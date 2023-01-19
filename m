Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C542C38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjASBON (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjASBNq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:13:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFE568403
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:13:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 562EEB81D77
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06906C433F1;
        Thu, 19 Jan 2023 01:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090816;
        bh=G9ZIRy2ag2SRFkgqr6ttT92AYEsSdeZaQYeJv66CoGc=;
        h=Date:To:From:Subject:From;
        b=H4NeVftGHf8KZEoPe9p1YQDsmi4cggD105k12EiDfeXcgcsm8lGOZoD2LapbOTLnP
         w4VisM8eQ1F/zFSqnoVOeWCzaLaNfwdNDRCXUBS/+V1aQJuq+14F+NoTjq+O/BYLMN
         PuUSMuJ0+EoRW4ThaJiEU8pJqpMUAh17dcnK59DU=
Date:   Wed, 18 Jan 2023 17:13:35 -0800
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        lkp@intel.com, keescook@chromium.org, jorgelo@chromium.org,
        jeffxu@google.com, jannh@google.com, hughd@google.com,
        dmitry.torokhov@gmail.com, dh.herrmann@gmail.com,
        dverkamp@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memfd-add-tests-for-f_seal_exec.patch removed from -mm tree
Message-Id: <20230119011336.06906C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/memfd: add tests for F_SEAL_EXEC
has been removed from the -mm tree.  Its filename was
     selftests-memfd-add-tests-for-f_seal_exec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Daniel Verkamp <dverkamp@chromium.org>
Subject: selftests/memfd: add tests for F_SEAL_EXEC
Date: Thu, 15 Dec 2022 00:12:02 +0000

Basic tests to ensure that user/group/other execute bits cannot be changed
after applying F_SEAL_EXEC to a memfd.

Link: https://lkml.kernel.org/r/20221215001205.51969-3-jeffxu@google.com
Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
Co-developed-by: Jeff Xu <jeffxu@google.com>
Signed-off-by: Jeff Xu <jeffxu@google.com>
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

 tools/testing/selftests/memfd/memfd_test.c |  123 ++++++++++++++++++-
 1 file changed, 122 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-add-tests-for-f_seal_exec
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -28,12 +28,38 @@
 #define MFD_DEF_SIZE 8192
 #define STACK_SIZE 65536
 
+#define F_SEAL_EXEC	0x0020
+
 /*
  * Default is not to test hugetlbfs
  */
 static size_t mfd_def_size = MFD_DEF_SIZE;
 static const char *memfd_str = MEMFD_STR;
 
+static ssize_t fd2name(int fd, char *buf, size_t bufsize)
+{
+	char buf1[PATH_MAX];
+	int size;
+	ssize_t nbytes;
+
+	size = snprintf(buf1, PATH_MAX, "/proc/self/fd/%d", fd);
+	if (size < 0) {
+		printf("snprintf(%d) failed on %m\n", fd);
+		abort();
+	}
+
+	/*
+	 * reserver one byte for string termination.
+	 */
+	nbytes = readlink(buf1, buf, bufsize-1);
+	if (nbytes == -1) {
+		printf("readlink(%s) failed %m\n", buf1);
+		abort();
+	}
+	buf[nbytes] = '\0';
+	return nbytes;
+}
+
 static int mfd_assert_new(const char *name, loff_t sz, unsigned int flags)
 {
 	int r, fd;
@@ -98,11 +124,14 @@ static unsigned int mfd_assert_get_seals
 
 static void mfd_assert_has_seals(int fd, unsigned int seals)
 {
+	char buf[PATH_MAX];
+	int nbytes;
 	unsigned int s;
+	fd2name(fd, buf, PATH_MAX);
 
 	s = mfd_assert_get_seals(fd);
 	if (s != seals) {
-		printf("%u != %u = GET_SEALS(%d)\n", seals, s, fd);
+		printf("%u != %u = GET_SEALS(%s)\n", seals, s, buf);
 		abort();
 	}
 }
@@ -594,6 +623,64 @@ static void mfd_fail_grow_write(int fd)
 	}
 }
 
+static void mfd_assert_mode(int fd, int mode)
+{
+	struct stat st;
+	char buf[PATH_MAX];
+	int nbytes;
+
+	fd2name(fd, buf, PATH_MAX);
+
+	if (fstat(fd, &st) < 0) {
+		printf("fstat(%s) failed: %m\n", buf);
+		abort();
+	}
+
+	if ((st.st_mode & 07777) != mode) {
+		printf("fstat(%s) wrong file mode 0%04o, but expected 0%04o\n",
+		       buf, (int)st.st_mode & 07777, mode);
+		abort();
+	}
+}
+
+static void mfd_assert_chmod(int fd, int mode)
+{
+	char buf[PATH_MAX];
+	int nbytes;
+
+	fd2name(fd, buf, PATH_MAX);
+
+	if (fchmod(fd, mode) < 0) {
+		printf("fchmod(%s, 0%04o) failed: %m\n", buf, mode);
+		abort();
+	}
+
+	mfd_assert_mode(fd, mode);
+}
+
+static void mfd_fail_chmod(int fd, int mode)
+{
+	struct stat st;
+	char buf[PATH_MAX];
+	int nbytes;
+
+	fd2name(fd, buf, PATH_MAX);
+
+	if (fstat(fd, &st) < 0) {
+		printf("fstat(%s) failed: %m\n", buf);
+		abort();
+	}
+
+	if (fchmod(fd, mode) == 0) {
+		printf("fchmod(%s, 0%04o) didn't fail as expected\n",
+		       buf, mode);
+		abort();
+	}
+
+	/* verify that file mode bits did not change */
+	mfd_assert_mode(fd, st.st_mode & 07777);
+}
+
 static int idle_thread_fn(void *arg)
 {
 	sigset_t set;
@@ -881,6 +968,39 @@ static void test_seal_resize(void)
 }
 
 /*
+ * Test SEAL_EXEC
+ * Test that chmod() cannot change x bits after sealing
+ */
+static void test_seal_exec(void)
+{
+	int fd;
+
+	printf("%s SEAL-EXEC\n", memfd_str);
+
+	fd = mfd_assert_new("kern_memfd_seal_exec",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
+
+	mfd_assert_mode(fd, 0777);
+
+	mfd_assert_chmod(fd, 0644);
+
+	mfd_assert_has_seals(fd, 0);
+	mfd_assert_add_seals(fd, F_SEAL_EXEC);
+	mfd_assert_has_seals(fd, F_SEAL_EXEC);
+
+	mfd_assert_chmod(fd, 0600);
+	mfd_fail_chmod(fd, 0777);
+	mfd_fail_chmod(fd, 0670);
+	mfd_fail_chmod(fd, 0605);
+	mfd_fail_chmod(fd, 0700);
+	mfd_fail_chmod(fd, 0100);
+	mfd_assert_chmod(fd, 0666);
+
+	close(fd);
+}
+
+/*
  * Test sharing via dup()
  * Test that seals are shared between dupped FDs and they're all equal.
  */
@@ -1059,6 +1179,7 @@ int main(int argc, char **argv)
 	test_seal_shrink();
 	test_seal_grow();
 	test_seal_resize();
+	test_seal_exec();
 
 	test_share_dup("SHARE-DUP", "");
 	test_share_mmap("SHARE-MMAP", "");
_

Patches currently in -mm which might be from dverkamp@chromium.org are


