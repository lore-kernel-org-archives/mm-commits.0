Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1007C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjASBOa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjASBNv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:13:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFDC53571
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:13:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0CFDB81F6C
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827B9C433D2;
        Thu, 19 Jan 2023 01:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090820;
        bh=EwnkEj/a8hHNSRIU+dUjtgTqUHL0ToDqXd4R7/61VSM=;
        h=Date:To:From:Subject:From;
        b=yLN30n7CTsbD99GiGhOkc2GToGmC4ZQz9wSb/+t63DGUCTmeJM+qDijEzXPKiEeNS
         n8366cikUcEBII3ISSCvIe0sBA1igzQHtIZs5e/R2MaRKvEhFgQTibSwSpEPxx1LOM
         x3B5lC0m8dZjBtg3/NldIzW4Vg6p6GWaN02YMLQk=
Date:   Wed, 18 Jan 2023 17:13:40 -0800
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        lkp@intel.com, keescook@chromium.org, jorgelo@chromium.org,
        jannh@google.com, hughd@google.com, dverkamp@chromium.org,
        dmitry.torokhov@gmail.com, dh.herrmann@gmail.com,
        jeffxu@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memfd-add-tests-for-mfd_noexec_seal-mfd_exec.patch removed from -mm tree
Message-Id: <20230119011340.827B9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/memfd: add tests for MFD_NOEXEC_SEAL MFD_EXEC
has been removed from the -mm tree.  Its filename was
     selftests-memfd-add-tests-for-mfd_noexec_seal-mfd_exec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Xu <jeffxu@google.com>
Subject: selftests/memfd: add tests for MFD_NOEXEC_SEAL MFD_EXEC
Date: Thu, 15 Dec 2022 00:12:05 +0000

Tests to verify MFD_NOEXEC, MFD_EXEC and vm.memfd_noexec sysctl.

Link: https://lkml.kernel.org/r/20221215001205.51969-6-jeffxu@google.com
Signed-off-by: Jeff Xu <jeffxu@google.com>
Co-developed-by: Daniel Verkamp <dverkamp@chromium.org>
Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: kernel test robot <lkp@intel.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/fuse_test.c  |    1 
 tools/testing/selftests/memfd/memfd_test.c |  228 ++++++++++++++++++-
 2 files changed, 224 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/memfd/fuse_test.c~selftests-memfd-add-tests-for-mfd_noexec_seal-mfd_exec
+++ a/tools/testing/selftests/memfd/fuse_test.c
@@ -22,6 +22,7 @@
 #include <linux/falloc.h>
 #include <fcntl.h>
 #include <linux/memfd.h>
+#include <linux/types.h>
 #include <sched.h>
 #include <stdio.h>
 #include <stdlib.h>
--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-add-tests-for-mfd_noexec_seal-mfd_exec
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -30,6 +30,14 @@
 
 #define F_SEAL_EXEC	0x0020
 
+#define F_WX_SEALS (F_SEAL_SHRINK | \
+		    F_SEAL_GROW | \
+		    F_SEAL_WRITE | \
+		    F_SEAL_FUTURE_WRITE | \
+		    F_SEAL_EXEC)
+
+#define MFD_NOEXEC_SEAL	0x0008U
+
 /*
  * Default is not to test hugetlbfs
  */
@@ -80,6 +88,37 @@ static int mfd_assert_new(const char *na
 	return fd;
 }
 
+static void sysctl_assert_write(const char *val)
+{
+	int fd = open("/proc/sys/vm/memfd_noexec", O_WRONLY | O_CLOEXEC);
+
+	if (fd < 0) {
+		printf("open sysctl failed\n");
+		abort();
+	}
+
+	if (write(fd, val, strlen(val)) < 0) {
+		printf("write sysctl failed\n");
+		abort();
+	}
+}
+
+static void sysctl_fail_write(const char *val)
+{
+	int fd = open("/proc/sys/vm/memfd_noexec", O_WRONLY | O_CLOEXEC);
+
+	if (fd < 0) {
+		printf("open sysctl failed\n");
+		abort();
+	}
+
+	if (write(fd, val, strlen(val)) >= 0) {
+		printf("write sysctl %s succeeded, but failure expected\n",
+				val);
+		abort();
+	}
+}
+
 static int mfd_assert_reopen_fd(int fd_in)
 {
 	int fd;
@@ -758,6 +797,9 @@ static void test_create(void)
 	mfd_fail_new("", ~0);
 	mfd_fail_new("", 0x80000000U);
 
+	/* verify EXEC and NOEXEC_SEAL can't both be set */
+	mfd_fail_new("", MFD_EXEC | MFD_NOEXEC_SEAL);
+
 	/* verify MFD_CLOEXEC is allowed */
 	fd = mfd_assert_new("", 0, MFD_CLOEXEC);
 	close(fd);
@@ -969,20 +1011,21 @@ static void test_seal_resize(void)
 
 /*
  * Test SEAL_EXEC
- * Test that chmod() cannot change x bits after sealing
+ * Test fd is created with exec and allow sealing.
+ * chmod() cannot change x bits after sealing.
  */
-static void test_seal_exec(void)
+static void test_exec_seal(void)
 {
 	int fd;
 
 	printf("%s SEAL-EXEC\n", memfd_str);
 
+	printf("%s	Apply SEAL_EXEC\n", memfd_str);
 	fd = mfd_assert_new("kern_memfd_seal_exec",
 			    mfd_def_size,
-			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
+			    MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_EXEC);
 
 	mfd_assert_mode(fd, 0777);
-
 	mfd_assert_chmod(fd, 0644);
 
 	mfd_assert_has_seals(fd, 0);
@@ -996,11 +1039,182 @@ static void test_seal_exec(void)
 	mfd_fail_chmod(fd, 0700);
 	mfd_fail_chmod(fd, 0100);
 	mfd_assert_chmod(fd, 0666);
+	mfd_assert_write(fd);
+	close(fd);
+
+	printf("%s	Apply ALL_SEALS\n", memfd_str);
+	fd = mfd_assert_new("kern_memfd_seal_exec",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_EXEC);
+
+	mfd_assert_mode(fd, 0777);
+	mfd_assert_chmod(fd, 0700);
+
+	mfd_assert_has_seals(fd, 0);
+	mfd_assert_add_seals(fd, F_SEAL_EXEC);
+	mfd_assert_has_seals(fd, F_WX_SEALS);
 
+	mfd_fail_chmod(fd, 0711);
+	mfd_fail_chmod(fd, 0600);
+	mfd_fail_write(fd);
+	close(fd);
+}
+
+/*
+ * Test EXEC_NO_SEAL
+ * Test fd is created with exec and not allow sealing.
+ */
+static void test_exec_no_seal(void)
+{
+	int fd;
+
+	printf("%s EXEC_NO_SEAL\n", memfd_str);
+
+	/* Create with EXEC but without ALLOW_SEALING */
+	fd = mfd_assert_new("kern_memfd_exec_no_sealing",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_EXEC);
+	mfd_assert_mode(fd, 0777);
+	mfd_assert_has_seals(fd, F_SEAL_SEAL);
+	mfd_assert_chmod(fd, 0666);
 	close(fd);
 }
 
 /*
+ * Test memfd_create with MFD_NOEXEC flag
+ */
+static void test_noexec_seal(void)
+{
+	int fd;
+
+	printf("%s NOEXEC_SEAL\n", memfd_str);
+
+	/* Create with NOEXEC and ALLOW_SEALING */
+	fd = mfd_assert_new("kern_memfd_noexec",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_NOEXEC_SEAL);
+	mfd_assert_mode(fd, 0666);
+	mfd_assert_has_seals(fd, F_SEAL_EXEC);
+	mfd_fail_chmod(fd, 0777);
+	close(fd);
+
+	/* Create with NOEXEC but without ALLOW_SEALING */
+	fd = mfd_assert_new("kern_memfd_noexec",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_NOEXEC_SEAL);
+	mfd_assert_mode(fd, 0666);
+	mfd_assert_has_seals(fd, F_SEAL_EXEC);
+	mfd_fail_chmod(fd, 0777);
+	close(fd);
+}
+
+static void test_sysctl_child(void)
+{
+	int fd;
+
+	printf("%s sysctl 0\n", memfd_str);
+	sysctl_assert_write("0");
+	fd = mfd_assert_new("kern_memfd_sysctl_0",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
+
+	mfd_assert_mode(fd, 0777);
+	mfd_assert_has_seals(fd, 0);
+	mfd_assert_chmod(fd, 0644);
+	close(fd);
+
+	printf("%s sysctl 1\n", memfd_str);
+	sysctl_assert_write("1");
+	fd = mfd_assert_new("kern_memfd_sysctl_1",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
+
+	mfd_assert_mode(fd, 0666);
+	mfd_assert_has_seals(fd, F_SEAL_EXEC);
+	mfd_fail_chmod(fd, 0777);
+	sysctl_fail_write("0");
+	close(fd);
+
+	printf("%s sysctl 2\n", memfd_str);
+	sysctl_assert_write("2");
+	mfd_fail_new("kern_memfd_sysctl_2",
+		MFD_CLOEXEC | MFD_ALLOW_SEALING);
+	sysctl_fail_write("0");
+	sysctl_fail_write("1");
+}
+
+static int newpid_thread_fn(void *arg)
+{
+	test_sysctl_child();
+	return 0;
+}
+
+static void test_sysctl_child2(void)
+{
+	int fd;
+
+	sysctl_fail_write("0");
+	fd = mfd_assert_new("kern_memfd_sysctl_1",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
+
+	mfd_assert_mode(fd, 0666);
+	mfd_assert_has_seals(fd, F_SEAL_EXEC);
+	mfd_fail_chmod(fd, 0777);
+	close(fd);
+}
+
+static int newpid_thread_fn2(void *arg)
+{
+	test_sysctl_child2();
+	return 0;
+}
+static pid_t spawn_newpid_thread(unsigned int flags, int (*fn)(void *))
+{
+	uint8_t *stack;
+	pid_t pid;
+
+	stack = malloc(STACK_SIZE);
+	if (!stack) {
+		printf("malloc(STACK_SIZE) failed: %m\n");
+		abort();
+	}
+
+	pid = clone(fn,
+		    stack + STACK_SIZE,
+		    SIGCHLD | flags,
+		    NULL);
+	if (pid < 0) {
+		printf("clone() failed: %m\n");
+		abort();
+	}
+
+	return pid;
+}
+
+static void join_newpid_thread(pid_t pid)
+{
+	waitpid(pid, NULL, 0);
+}
+
+/*
+ * Test sysctl
+ * A very basic sealing test to see whether setting/retrieving seals works.
+ */
+static void test_sysctl(void)
+{
+	int pid = spawn_newpid_thread(CLONE_NEWPID, newpid_thread_fn);
+
+	join_newpid_thread(pid);
+
+	printf("%s child ns\n", memfd_str);
+	sysctl_assert_write("1");
+
+	pid = spawn_newpid_thread(CLONE_NEWPID, newpid_thread_fn2);
+	join_newpid_thread(pid);
+}
+
+/*
  * Test sharing via dup()
  * Test that seals are shared between dupped FDs and they're all equal.
  */
@@ -1173,13 +1387,15 @@ int main(int argc, char **argv)
 
 	test_create();
 	test_basic();
+	test_exec_seal();
+	test_exec_no_seal();
+	test_noexec_seal();
 
 	test_seal_write();
 	test_seal_future_write();
 	test_seal_shrink();
 	test_seal_grow();
 	test_seal_resize();
-	test_seal_exec();
 
 	test_share_dup("SHARE-DUP", "");
 	test_share_mmap("SHARE-MMAP", "");
@@ -1195,6 +1411,8 @@ int main(int argc, char **argv)
 	test_share_fork("SHARE-FORK", SHARED_FT_STR);
 	join_idle_thread(pid);
 
+	test_sysctl();
+
 	printf("memfd: DONE\n");
 
 	return 0;
_

Patches currently in -mm which might be from jeffxu@google.com are


