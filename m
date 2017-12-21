From: akpm@linux-foundation.org
Subject: +
 memfd-test-add-memfd-hugetlb-prefix-when-testing-hugetlbfs.patch added to
 -mm tree
Date: Wed, 20 Dec 2017 16:25:23 -0800
Message-ID: <5a3aff73.RxeSoZ9Zo8zAOSpi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38530 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756493AbdLUAZZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Dec 2017 19:25:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcandre.lureau@redhat.com, aarcange@redhat.com, dh.herrmann@gmail.com, hughd@google.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memfd-test: add 'memfd-hugetlb:' prefix when testing hugetlbfs
has been added to the -mm tree.  Its filename is
     memfd-test-add-memfd-hugetlb-prefix-when-testing-hugetlbfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memfd-test-add-memfd-hugetlb-prefix-when-testing-hugetlbfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memfd-test-add-memfd-hugetlb-prefix-when-testing-hugetlbfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marc-André Lureau <marcandre.lureau@redhat.com>
Subject: memfd-test: add 'memfd-hugetlb:' prefix when testing hugetlbfs

Link: http://lkml.kernel.org/r/20171107122800.25517-8-marcandre.lureau@redhat.com
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |   26 +++++++++++--------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN tools/testing/selftests/memfd/memfd_test.c~memfd-test-add-memfd-hugetlb-prefix-when-testing-hugetlbfs tools/testing/selftests/memfd/memfd_test.c
--- a/tools/testing/selftests/memfd/memfd_test.c~memfd-test-add-memfd-hugetlb-prefix-when-testing-hugetlbfs
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -20,6 +20,7 @@
 #include <unistd.h>
 
 #define MEMFD_STR	"memfd:"
+#define MEMFD_HUGE_STR	"memfd-hugetlb:"
 #define SHARED_FT_STR	"(shared file-table)"
 
 #define MFD_DEF_SIZE 8192
@@ -30,6 +31,7 @@
  */
 static int hugetlbfs_test;
 static size_t mfd_def_size = MFD_DEF_SIZE;
+static const char *memfd_str = MEMFD_STR;
 
 /*
  * Copied from mlock2-tests.c
@@ -606,7 +608,7 @@ static void test_create(void)
 	char buf[2048];
 	int fd;
 
-	printf("%s CREATE\n", MEMFD_STR);
+	printf("%s CREATE\n", memfd_str);
 
 	/* test NULL name */
 	mfd_fail_new(NULL, 0);
@@ -652,7 +654,7 @@ static void test_basic(void)
 {
 	int fd;
 
-	printf("%s BASIC\n", MEMFD_STR);
+	printf("%s BASIC\n", memfd_str);
 
 	fd = mfd_assert_new("kern_memfd_basic",
 			    mfd_def_size,
@@ -704,7 +706,7 @@ static void test_seal_write(void)
 {
 	int fd;
 
-	printf("%s SEAL-WRITE\n", MEMFD_STR);
+	printf("%s SEAL-WRITE\n", memfd_str);
 
 	fd = mfd_assert_new("kern_memfd_seal_write",
 			    mfd_def_size,
@@ -730,7 +732,7 @@ static void test_seal_shrink(void)
 {
 	int fd;
 
-	printf("%s SEAL-SHRINK\n", MEMFD_STR);
+	printf("%s SEAL-SHRINK\n", memfd_str);
 
 	fd = mfd_assert_new("kern_memfd_seal_shrink",
 			    mfd_def_size,
@@ -756,7 +758,7 @@ static void test_seal_grow(void)
 {
 	int fd;
 
-	printf("%s SEAL-GROW\n", MEMFD_STR);
+	printf("%s SEAL-GROW\n", memfd_str);
 
 	fd = mfd_assert_new("kern_memfd_seal_grow",
 			    mfd_def_size,
@@ -782,7 +784,7 @@ static void test_seal_resize(void)
 {
 	int fd;
 
-	printf("%s SEAL-RESIZE\n", MEMFD_STR);
+	printf("%s SEAL-RESIZE\n", memfd_str);
 
 	fd = mfd_assert_new("kern_memfd_seal_resize",
 			    mfd_def_size,
@@ -808,7 +810,7 @@ static void test_share_dup(char *banner,
 {
 	int fd, fd2;
 
-	printf("%s %s %s\n", MEMFD_STR, banner, b_suffix);
+	printf("%s %s %s\n", memfd_str, banner, b_suffix);
 
 	fd = mfd_assert_new("kern_memfd_share_dup",
 			    mfd_def_size,
@@ -850,7 +852,7 @@ static void test_share_mmap(char *banner
 	int fd;
 	void *p;
 
-	printf("%s %s %s\n", MEMFD_STR,  banner, b_suffix);
+	printf("%s %s %s\n", memfd_str,  banner, b_suffix);
 
 	fd = mfd_assert_new("kern_memfd_share_mmap",
 			    mfd_def_size,
@@ -884,7 +886,7 @@ static void test_share_open(char *banner
 {
 	int fd, fd2;
 
-	printf("%s %s %s\n", MEMFD_STR, banner, b_suffix);
+	printf("%s %s %s\n", memfd_str, banner, b_suffix);
 
 	fd = mfd_assert_new("kern_memfd_share_open",
 			    mfd_def_size,
@@ -927,7 +929,7 @@ static void test_share_fork(char *banner
 	int fd;
 	pid_t pid;
 
-	printf("%s %s %s\n", MEMFD_STR, banner, b_suffix);
+	printf("%s %s %s\n", memfd_str, banner, b_suffix);
 
 	fd = mfd_assert_new("kern_memfd_share_fork",
 			    mfd_def_size,
@@ -963,7 +965,11 @@ int main(int argc, char **argv)
 			}
 
 			hugetlbfs_test = 1;
+			memfd_str = MEMFD_HUGE_STR;
 			mfd_def_size = hpage_size * 2;
+		} else {
+			printf("Unknown option: %s\n", argv[1]);
+			abort();
 		}
 	}
 
_

Patches currently in -mm which might be from marcandre.lureau@redhat.com are

shmem-unexport-shmem_add_seals-shmem_get_seals.patch
shmem-rename-functions-that-are-memfd-related.patch
hugetlb-expose-hugetlbfs_inode_info-in-header.patch
hugetlb-implement-memfd-sealing.patch
shmem-add-sealing-support-to-hugetlb-backed-memfd.patch
memfd-test-test-hugetlbfs-sealing.patch
memfd-test-add-memfd-hugetlb-prefix-when-testing-hugetlbfs.patch
memfd-test-move-common-code-to-a-shared-unit.patch
memfd-test-run-fuse-test-on-hugetlb-backend-memory.patch
mm-page_owner-align-with-pageblock_nr_pages.patch

