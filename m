From: akpm@linux-foundation.org
Subject: [merged] memfd-test-test-hugetlbfs-sealing.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:33:38 -0800
Message-ID: <20180201193338.-LeOEt0KL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59938 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754623AbeBATdr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:33:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dh.herrmann@gmail.com, hughd@google.com, marcandre.lureau@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memfd-test: test hugetlbfs sealing
has been removed from the -mm tree.  Its filename was
     memfd-test-test-hugetlbfs-sealing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marc-André Lureau <marcandre.lureau@redhat.com>
Subject: memfd-test: test hugetlbfs sealing

Remove most of the special-casing of hugetlbfs now that sealing
is supported.

Link: http://lkml.kernel.org/r/20171107122800.25517-7-marcandre.lureau@redhat.com
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |  150 +------------------
 1 file changed, 15 insertions(+), 135 deletions(-)

diff -puN tools/testing/selftests/memfd/memfd_test.c~memfd-test-test-hugetlbfs-sealing tools/testing/selftests/memfd/memfd_test.c
--- a/tools/testing/selftests/memfd/memfd_test.c~memfd-test-test-hugetlbfs-sealing
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -513,6 +513,10 @@ static void mfd_assert_grow_write(int fd
 	static char *buf;
 	ssize_t l;
 
+	/* hugetlbfs does not support write */
+	if (hugetlbfs_test)
+		return;
+
 	buf = malloc(mfd_def_size * 8);
 	if (!buf) {
 		printf("malloc(%zu) failed: %m\n", mfd_def_size * 8);
@@ -533,6 +537,10 @@ static void mfd_fail_grow_write(int fd)
 	static char *buf;
 	ssize_t l;
 
+	/* hugetlbfs does not support write */
+	if (hugetlbfs_test)
+		return;
+
 	buf = malloc(mfd_def_size * 8);
 	if (!buf) {
 		printf("malloc(%zu) failed: %m\n", mfd_def_size * 8);
@@ -627,18 +635,13 @@ static void test_create(void)
 	fd = mfd_assert_new("", 0, MFD_CLOEXEC);
 	close(fd);
 
-	if (!hugetlbfs_test) {
-		/* verify MFD_ALLOW_SEALING is allowed */
-		fd = mfd_assert_new("", 0, MFD_ALLOW_SEALING);
-		close(fd);
-
-		/* verify MFD_ALLOW_SEALING | MFD_CLOEXEC is allowed */
-		fd = mfd_assert_new("", 0, MFD_ALLOW_SEALING | MFD_CLOEXEC);
-		close(fd);
-	} else {
-		/* sealing is not supported on hugetlbfs */
-		mfd_fail_new("", MFD_ALLOW_SEALING);
-	}
+	/* verify MFD_ALLOW_SEALING is allowed */
+	fd = mfd_assert_new("", 0, MFD_ALLOW_SEALING);
+	close(fd);
+
+	/* verify MFD_ALLOW_SEALING | MFD_CLOEXEC is allowed */
+	fd = mfd_assert_new("", 0, MFD_ALLOW_SEALING | MFD_CLOEXEC);
+	close(fd);
 }
 
 /*
@@ -649,10 +652,6 @@ static void test_basic(void)
 {
 	int fd;
 
-	/* hugetlbfs does not contain sealing support */
-	if (hugetlbfs_test)
-		return;
-
 	printf("%s BASIC\n", MEMFD_STR);
 
 	fd = mfd_assert_new("kern_memfd_basic",
@@ -698,28 +697,6 @@ static void test_basic(void)
 }
 
 /*
- * hugetlbfs doesn't support seals or write, so just verify grow and shrink
- * on a hugetlbfs file created via memfd_create.
- */
-static void test_hugetlbfs_grow_shrink(void)
-{
-	int fd;
-
-	printf("%s HUGETLBFS-GROW-SHRINK\n", MEMFD_STR);
-
-	fd = mfd_assert_new("kern_memfd_seal_write",
-			    mfd_def_size,
-			    MFD_CLOEXEC);
-
-	mfd_assert_read(fd);
-	mfd_assert_write(fd);
-	mfd_assert_shrink(fd);
-	mfd_assert_grow(fd);
-
-	close(fd);
-}
-
-/*
  * Test SEAL_WRITE
  * Test whether SEAL_WRITE actually prevents modifications.
  */
@@ -727,13 +704,6 @@ static void test_seal_write(void)
 {
 	int fd;
 
-	/*
-	 * hugetlbfs does not contain sealing or write support.  Just test
-	 * basic grow and shrink via test_hugetlbfs_grow_shrink.
-	 */
-	if (hugetlbfs_test)
-		return test_hugetlbfs_grow_shrink();
-
 	printf("%s SEAL-WRITE\n", MEMFD_STR);
 
 	fd = mfd_assert_new("kern_memfd_seal_write",
@@ -760,10 +730,6 @@ static void test_seal_shrink(void)
 {
 	int fd;
 
-	/* hugetlbfs does not contain sealing support */
-	if (hugetlbfs_test)
-		return;
-
 	printf("%s SEAL-SHRINK\n", MEMFD_STR);
 
 	fd = mfd_assert_new("kern_memfd_seal_shrink",
@@ -790,10 +756,6 @@ static void test_seal_grow(void)
 {
 	int fd;
 
-	/* hugetlbfs does not contain sealing support */
-	if (hugetlbfs_test)
-		return;
-
 	printf("%s SEAL-GROW\n", MEMFD_STR);
 
 	fd = mfd_assert_new("kern_memfd_seal_grow",
@@ -820,10 +782,6 @@ static void test_seal_resize(void)
 {
 	int fd;
 
-	/* hugetlbfs does not contain sealing support */
-	if (hugetlbfs_test)
-		return;
-
 	printf("%s SEAL-RESIZE\n", MEMFD_STR);
 
 	fd = mfd_assert_new("kern_memfd_seal_resize",
@@ -843,32 +801,6 @@ static void test_seal_resize(void)
 }
 
 /*
- * hugetlbfs does not support seals.  Basic test to dup the memfd created
- * fd and perform some basic operations on it.
- */
-static void hugetlbfs_dup(char *b_suffix)
-{
-	int fd, fd2;
-
-	printf("%s HUGETLBFS-DUP %s\n", MEMFD_STR, b_suffix);
-
-	fd = mfd_assert_new("kern_memfd_share_dup",
-			    mfd_def_size,
-			    MFD_CLOEXEC);
-
-	fd2 = mfd_assert_dup(fd);
-
-	mfd_assert_read(fd);
-	mfd_assert_write(fd);
-
-	mfd_assert_shrink(fd2);
-	mfd_assert_grow(fd2);
-
-	close(fd2);
-	close(fd);
-}
-
-/*
  * Test sharing via dup()
  * Test that seals are shared between dupped FDs and they're all equal.
  */
@@ -876,15 +808,6 @@ static void test_share_dup(char *banner,
 {
 	int fd, fd2;
 
-	/*
-	 * hugetlbfs does not contain sealing support.  Perform some
-	 * basic testing on dup'ed fd instead via hugetlbfs_dup.
-	 */
-	if (hugetlbfs_test) {
-		hugetlbfs_dup(b_suffix);
-		return;
-	}
-
 	printf("%s %s %s\n", MEMFD_STR, banner, b_suffix);
 
 	fd = mfd_assert_new("kern_memfd_share_dup",
@@ -927,10 +850,6 @@ static void test_share_mmap(char *banner
 	int fd;
 	void *p;
 
-	/* hugetlbfs does not contain sealing support */
-	if (hugetlbfs_test)
-		return;
-
 	printf("%s %s %s\n", MEMFD_STR,  banner, b_suffix);
 
 	fd = mfd_assert_new("kern_memfd_share_mmap",
@@ -956,32 +875,6 @@ static void test_share_mmap(char *banner
 }
 
 /*
- * Basic test to make sure we can open the hugetlbfs fd via /proc and
- * perform some simple operations on it.
- */
-static void hugetlbfs_proc_open(char *b_suffix)
-{
-	int fd, fd2;
-
-	printf("%s HUGETLBFS-PROC-OPEN %s\n", MEMFD_STR, b_suffix);
-
-	fd = mfd_assert_new("kern_memfd_share_open",
-			    mfd_def_size,
-			    MFD_CLOEXEC);
-
-	fd2 = mfd_assert_open(fd, O_RDWR, 0);
-
-	mfd_assert_read(fd);
-	mfd_assert_write(fd);
-
-	mfd_assert_shrink(fd2);
-	mfd_assert_grow(fd2);
-
-	close(fd2);
-	close(fd);
-}
-
-/*
  * Test sealing with open(/proc/self/fd/%d)
  * Via /proc we can get access to a separate file-context for the same memfd.
  * This is *not* like dup(), but like a real separate open(). Make sure the
@@ -991,15 +884,6 @@ static void test_share_open(char *banner
 {
 	int fd, fd2;
 
-	/*
-	 * hugetlbfs does not contain sealing support.  So test basic
-	 * functionality of using /proc fd via hugetlbfs_proc_open
-	 */
-	if (hugetlbfs_test) {
-		hugetlbfs_proc_open(b_suffix);
-		return;
-	}
-
 	printf("%s %s %s\n", MEMFD_STR, banner, b_suffix);
 
 	fd = mfd_assert_new("kern_memfd_share_open",
@@ -1043,10 +927,6 @@ static void test_share_fork(char *banner
 	int fd;
 	pid_t pid;
 
-	/* hugetlbfs does not contain sealing support */
-	if (hugetlbfs_test)
-		return;
