Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7352BC3DA6F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 22:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243749AbjHXWA7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 18:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243794AbjHXWA1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 18:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3611BD4
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 15:00:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AA2E6245E
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 22:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE96C433C8;
        Thu, 24 Aug 2023 22:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692914424;
        bh=HRmAvIaO52xl068gX6ZpDVcnctDD8F8eYfIzR33cgGY=;
        h=Date:To:From:Subject:From;
        b=lqn9NM3P5stO9whd1gSVARuOOqsqbHjTxYn829Ys5UNDE0h1n42dKmmLP3+kGj57k
         d7hJ78JWJ7paMp+9RN5ISWKqMICjAZqEvCRwUD6XCzHshbwbbXA76TFMktEzj9E+B0
         rtDs+hXUXNRrQ+mje8rf0p+ppyMyKoqn4L6GJJ7E=
Date:   Thu, 24 Aug 2023 15:00:23 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, nphamcs@gmail.com,
        hannes@cmpxchg.org, andre.przywara@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-cachestat-catch-failing-fsync-test-on-tmpfs.patch removed from -mm tree
Message-Id: <20230824220024.5FE96C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cachestat: catch failing fsync test on tmpfs
has been removed from the -mm tree.  Its filename was
     selftests-cachestat-catch-failing-fsync-test-on-tmpfs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andre Przywara <andre.przywara@arm.com>
Subject: selftests: cachestat: catch failing fsync test on tmpfs
Date: Mon, 21 Aug 2023 17:05:34 +0100

The cachestat kselftest runs a test on a normal file, which is created
temporarily in the current directory.  Among the tests it runs there is a
call to fsync(), which is expected to clean all dirty pages used by the
file.

However the tmpfs filesystem implements fsync() as noop_fsync(), so the
call will not even attempt to clean anything when this test file happens
to live on a tmpfs instance.  This happens in an initramfs, or when the
current directory is in /dev/shm or sometimes /tmp.

To avoid this test failing wrongly, use statfs() to check which filesystem
the test file lives on.  If that is "tmpfs", we skip the fsync() test.

Since the fsync test is only one part of the "normal file" test, we now
execute this twice, skipping the fsync part on the first call.  This way
only the second test, including the fsync part, would be skipped.

Link: https://lkml.kernel.org/r/20230821160534.3414911-3-andre.przywara@arm.com
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cachestat/test_cachestat.c |   62 ++++++++---
 1 file changed, 47 insertions(+), 15 deletions(-)

--- a/tools/testing/selftests/cachestat/test_cachestat.c~selftests-cachestat-catch-failing-fsync-test-on-tmpfs
+++ a/tools/testing/selftests/cachestat/test_cachestat.c
@@ -4,10 +4,12 @@
 #include <stdio.h>
 #include <stdbool.h>
 #include <linux/kernel.h>
+#include <linux/magic.h>
 #include <linux/mman.h>
 #include <sys/mman.h>
 #include <sys/shm.h>
 #include <sys/syscall.h>
+#include <sys/vfs.h>
 #include <unistd.h>
 #include <string.h>
 #include <fcntl.h>
@@ -15,7 +17,7 @@
 
 #include "../kselftest.h"
 
-#define NR_TESTS	8
+#define NR_TESTS	9
 
 static const char * const dev_files[] = {
 	"/dev/zero", "/dev/null", "/dev/urandom",
@@ -93,19 +95,33 @@ out:
 }
 
 /*
+ * fsync() is implemented via noop_fsync() on tmpfs. This makes the fsync()
+ * test fail below, so we need to check for test file living on a tmpfs.
+ */
+static bool is_on_tmpfs(int fd)
+{
+	struct statfs statfs_buf;
+
+	if (fstatfs(fd, &statfs_buf))
+		return false;
+
+	return statfs_buf.f_type == TMPFS_MAGIC;
+}
+
+/*
  * Open/create the file at filename, (optionally) write random data to it
  * (exactly num_pages), then test the cachestat syscall on this file.
  *
  * If test_fsync == true, fsync the file, then check the number of dirty
  * pages.
  */
-bool test_cachestat(const char *filename, bool write_random, bool create,
-		bool test_fsync, unsigned long num_pages, int open_flags,
-		mode_t open_mode)
+static int test_cachestat(const char *filename, bool write_random, bool create,
+			  bool test_fsync, unsigned long num_pages,
+			  int open_flags, mode_t open_mode)
 {
 	size_t PS = sysconf(_SC_PAGESIZE);
 	int filesize = num_pages * PS;
-	bool ret = true;
+	int ret = KSFT_PASS;
 	long syscall_ret;
 	struct cachestat cs;
 	struct cachestat_range cs_range = { 0, filesize };
@@ -114,7 +130,7 @@ bool test_cachestat(const char *filename
 
 	if (fd == -1) {
 		ksft_print_msg("Unable to create/open file.\n");
-		ret = false;
+		ret = KSFT_FAIL;
 		goto out;
 	} else {
 		ksft_print_msg("Create/open %s\n", filename);
@@ -123,7 +139,7 @@ bool test_cachestat(const char *filename
 	if (write_random) {
 		if (!write_exactly(fd, filesize)) {
 			ksft_print_msg("Unable to access urandom.\n");
-			ret = false;
+			ret = KSFT_FAIL;
 			goto out1;
 		}
 	}
@@ -134,7 +150,7 @@ bool test_cachestat(const char *filename
 
 	if (syscall_ret) {
 		ksft_print_msg("Cachestat returned non-zero.\n");
-		ret = false;
+		ret = KSFT_FAIL;
 		goto out1;
 
 	} else {
@@ -144,15 +160,17 @@ bool test_cachestat(const char *filename
 			if (cs.nr_cache + cs.nr_evicted != num_pages) {
 				ksft_print_msg(
 					"Total number of cached and evicted pages is off.\n");
-				ret = false;
+				ret = KSFT_FAIL;
 			}
 		}
 	}
 
 	if (test_fsync) {
-		if (fsync(fd)) {
+		if (is_on_tmpfs(fd)) {
+			ret = KSFT_SKIP;
+		} else if (fsync(fd)) {
 			ksft_print_msg("fsync fails.\n");
-			ret = false;
+			ret = KSFT_FAIL;
 		} else {
 			syscall_ret = syscall(cachestat_nr, fd, &cs_range, &cs, 0);
 
@@ -163,13 +181,13 @@ bool test_cachestat(const char *filename
 				print_cachestat(&cs);
 
 				if (cs.nr_dirty) {
-					ret = false;
+					ret = KSFT_FAIL;
 					ksft_print_msg(
 						"Number of dirty should be zero after fsync.\n");
 				}
 			} else {
 				ksft_print_msg("Cachestat (after fsync) returned non-zero.\n");
-				ret = false;
+				ret = KSFT_FAIL;
 				goto out1;
 			}
 		}
@@ -260,7 +278,7 @@ int main(void)
 		const char *dev_filename = dev_files[i];
 
 		if (test_cachestat(dev_filename, false, false, false,
-			4, O_RDONLY, 0400))
+			4, O_RDONLY, 0400) == KSFT_PASS)
 			ksft_test_result_pass("cachestat works with %s\n", dev_filename);
 		else {
 			ksft_test_result_fail("cachestat fails with %s\n", dev_filename);
@@ -269,13 +287,27 @@ int main(void)
 	}
 
 	if (test_cachestat("tmpfilecachestat", true, true,
-		true, 4, O_CREAT | O_RDWR, 0400 | 0600))
+		false, 4, O_CREAT | O_RDWR, 0600) == KSFT_PASS)
 		ksft_test_result_pass("cachestat works with a normal file\n");
 	else {
 		ksft_test_result_fail("cachestat fails with normal file\n");
 		ret = 1;
 	}
 
+	switch (test_cachestat("tmpfilecachestat", true, true,
+		true, 4, O_CREAT | O_RDWR, 0600)) {
+	case KSFT_FAIL:
+		ksft_test_result_fail("cachestat fsync fails with normal file\n");
+		ret = KSFT_FAIL;
+		break;
+	case KSFT_PASS:
+		ksft_test_result_pass("cachestat fsync works with a normal file\n");
+		break;
+	case KSFT_SKIP:
+		ksft_test_result_skip("tmpfilecachestat is on tmpfs\n");
+		break;
+	}
+
 	if (test_cachestat_shmem())
 		ksft_test_result_pass("cachestat works with a shmem file\n");
 	else {
_

Patches currently in -mm which might be from andre.przywara@arm.com are


