From: akpm@linux-foundation.org
Subject: + userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch added to -mm tree
Date: Wed, 02 Aug 2017 14:29:38 -0700
Message-ID: <59824442.KnSyXWMuoCBOK3Nm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41376 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750725AbdHBV3j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 17:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.perevalov@samsung.com, dgilbert@redhat.com, maxime.coquelin@redhat.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftest: exercise UFFDIO_COPY/ZEROPAGE -EEXIST
has been added to the -mm tree.  Its filename is
     userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: selftest: exercise UFFDIO_COPY/ZEROPAGE -EEXIST

This will retry the UFFDIO_COPY/ZEROPAGE to verify it returns -EEXIST at
the first invocation and then later every 10 seconds.

In the filebacked MAP_SHARED case this also verifies the -EEXIST triggered
in the filesystem pagecache insertion, if the offset in the file was not a
hole.

shmem MAP_SHARED tries to index the newly allocated pagecache in the radix
tree before checking the pagetable so it doesn't need any assistance to
exercise that case.

hugetlbfs checks the pmd to be not none before trying to index the
hugetlbfs page in the radix tree, so it requires to run UFFDIO_COPY into
an alias mapping (the alternative would be to use MADV_DONTNEED to only
zap the pagetables, but that doesn't work on hugetlbfs).

Link: http://lkml.kernel.org/r/20170802165145.22628-3-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
Cc: Maxime Coquelin <maxime.coquelin@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |  145 +++++++++++++++++++--
 1 file changed, 138 insertions(+), 7 deletions(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -67,6 +67,7 @@
 #include <pthread.h>
 #include <linux/userfaultfd.h>
 #include <setjmp.h>
+#include <stdbool.h>
 
 #ifdef __NR_userfaultfd
 
@@ -83,11 +84,17 @@ static int bounces;
 #define TEST_SHMEM	3
 static int test_type;
 
+/* exercise the test_uffdio_*_eexist every ALARM_INTERVAL_SECS */
+#define ALARM_INTERVAL_SECS 10
+static volatile bool test_uffdio_copy_eexist = true;
+static volatile bool test_uffdio_zeropage_eexist = true;
+
+static bool map_shared;
 static int huge_fd;
 static char *huge_fd_off0;
 static unsigned long long *count_verify;
 static int uffd, uffd_flags, finished, *pipefd;
-static char *area_src, *area_dst;
+static char *area_src, *area_src_alias, *area_dst, *area_dst_alias;
 static char *zeropage;
 pthread_attr_t attr;
 
@@ -126,6 +133,9 @@ static void anon_allocate_area(void **al
 	}
 }
 
+static void noop_alias_mapping(__u64 *start, size_t len, unsigned long offset)
+{
+}
 
 /* HugeTLB memory */
 static int hugetlb_release_pages(char *rel_area)
@@ -146,17 +156,51 @@ static int hugetlb_release_pages(char *r
 
 static void hugetlb_allocate_area(void **alloc_area)
 {
+	void *area_alias = NULL;
+	char **alloc_area_alias;
 	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
-				MAP_PRIVATE | MAP_HUGETLB, huge_fd,
-				*alloc_area == area_src ? 0 :
-				nr_pages * page_size);
+			   (map_shared ? MAP_SHARED : MAP_PRIVATE) |
+			   MAP_HUGETLB,
+			   huge_fd, *alloc_area == area_src ? 0 :
+			   nr_pages * page_size);
 	if (*alloc_area == MAP_FAILED) {
 		fprintf(stderr, "mmap of hugetlbfs file failed\n");
 		*alloc_area = NULL;
 	}
 
-	if (*alloc_area == area_src)
+	if (map_shared) {
+		area_alias = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
+				  MAP_SHARED | MAP_HUGETLB,
+				  huge_fd, *alloc_area == area_src ? 0 :
+				  nr_pages * page_size);
+		if (area_alias == MAP_FAILED) {
+			if (munmap(*alloc_area, nr_pages * page_size) < 0)
+				perror("hugetlb munmap"), exit(1);
+			*alloc_area = NULL;
+			return;
+		}
+	}
+	if (*alloc_area == area_src) {
 		huge_fd_off0 = *alloc_area;
+		alloc_area_alias = &area_src_alias;
+	} else {
+		alloc_area_alias = &area_dst_alias;
+	}
+	if (area_alias)
+		*alloc_area_alias = area_alias;
+}
+
+static void hugetlb_alias_mapping(__u64 *start, size_t len, unsigned long offset)
+{
+	if (!map_shared)
+		return;
+	/*
+	 * We can't zap just the pagetable with hugetlbfs because
+	 * MADV_DONTEED won't work. So exercise -EEXIST on a alias
+	 * mapping where the pagetables are not established initially,
+	 * this way we'll exercise the -EEXEC at the fs level.
+	 */
+	*start = (unsigned long) area_dst_alias + offset;
 }
 
 /* Shared memory */
@@ -186,6 +230,7 @@ struct uffd_test_ops {
 	unsigned long expected_ioctls;
 	void (*allocate_area)(void **alloc_area);
 	int (*release_pages)(char *rel_area);
+	void (*alias_mapping)(__u64 *start, size_t len, unsigned long offset);
 };
 
 #define ANON_EXPECTED_IOCTLS		((1 << _UFFDIO_WAKE) | \
@@ -196,18 +241,21 @@ static struct uffd_test_ops anon_uffd_te
 	.expected_ioctls = ANON_EXPECTED_IOCTLS,
 	.allocate_area	= anon_allocate_area,
 	.release_pages	= anon_release_pages,
+	.alias_mapping = noop_alias_mapping,
 };
 
 static struct uffd_test_ops shmem_uffd_test_ops = {
 	.expected_ioctls = ANON_EXPECTED_IOCTLS,
 	.allocate_area	= shmem_allocate_area,
 	.release_pages	= shmem_release_pages,
+	.alias_mapping = noop_alias_mapping,
 };
 
 static struct uffd_test_ops hugetlb_uffd_test_ops = {
 	.expected_ioctls = UFFD_API_RANGE_IOCTLS_BASIC,
 	.allocate_area	= hugetlb_allocate_area,
 	.release_pages	= hugetlb_release_pages,
+	.alias_mapping = hugetlb_alias_mapping,
 };
 
 static struct uffd_test_ops *uffd_test_ops;
@@ -332,6 +380,23 @@ static void *locking_thread(void *arg)
 	return NULL;
 }
 
+static void retry_copy_page(int ufd, struct uffdio_copy *uffdio_copy,
+			    unsigned long offset)
+{
+	uffd_test_ops->alias_mapping(&uffdio_copy->dst,
+				     uffdio_copy->len,
+				     offset);
+	if (ioctl(ufd, UFFDIO_COPY, uffdio_copy)) {
+		/* real retval in ufdio_copy.copy */
+		if (uffdio_copy->copy != -EEXIST)
+			fprintf(stderr, "UFFDIO_COPY retry error %Ld\n",
+				uffdio_copy->copy), exit(1);
+	} else {
+		fprintf(stderr,	"UFFDIO_COPY retry unexpected %Ld\n",
+			uffdio_copy->copy), exit(1);
+	}
+}
+
 static int copy_page(int ufd, unsigned long offset)
 {
 	struct uffdio_copy uffdio_copy;
@@ -352,8 +417,13 @@ static int copy_page(int ufd, unsigned l
 	} else if (uffdio_copy.copy != page_size) {
 		fprintf(stderr, "UFFDIO_COPY unexpected copy %Ld\n",
 			uffdio_copy.copy), exit(1);
-	} else
+	} else {
+		if (test_uffdio_copy_eexist) {
+			test_uffdio_copy_eexist = false;
+			retry_copy_page(ufd, &uffdio_copy, offset);
+		}
 		return 1;
+	}
 	return 0;
 }
 
@@ -692,6 +762,23 @@ static int faulting_process(int signal_t
 	return 0;
 }
 
+static void retry_uffdio_zeropage(int ufd,
+				  struct uffdio_zeropage *uffdio_zeropage,
+				  unsigned long offset)
+{
+	uffd_test_ops->alias_mapping(&uffdio_zeropage->range.start,
+				     uffdio_zeropage->range.len,
+				     offset);
+	if (ioctl(ufd, UFFDIO_ZEROPAGE, uffdio_zeropage)) {
+		if (uffdio_zeropage->zeropage != -EEXIST)
+			fprintf(stderr, "UFFDIO_ZEROPAGE retry error %Ld\n",
+				uffdio_zeropage->zeropage), exit(1);
+	} else {
+		fprintf(stderr, "UFFDIO_ZEROPAGE retry unexpected %Ld\n",
+			uffdio_zeropage->zeropage), exit(1);
+	}
+}
+
 static int uffdio_zeropage(int ufd, unsigned long offset)
 {
 	struct uffdio_zeropage uffdio_zeropage;
@@ -727,6 +814,11 @@ static int uffdio_zeropage(int ufd, unsi
 			fprintf(stderr, "UFFDIO_ZEROPAGE unexpected %Ld\n",
 				uffdio_zeropage.zeropage), exit(1);
 		} else
+			if (test_uffdio_zeropage_eexist) {
+				test_uffdio_zeropage_eexist = false;
+				retry_uffdio_zeropage(ufd, &uffdio_zeropage,
+						      offset);
+			}
 			return 1;
 	} else {
 		fprintf(stderr,
@@ -999,6 +1091,15 @@ static int userfaultfd_stress(void)
 			return 1;
 		}
 
+		if (area_dst_alias) {
+			uffdio_register.range.start = (unsigned long)
+				area_dst_alias;
+			if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register)) {
+				fprintf(stderr, "register failure alias\n");
+				return 1;
+			}
+		}
+
 		/*
 		 * The madvise done previously isn't enough: some
 		 * uffd_thread could have read userfaults (one of
@@ -1032,9 +1133,17 @@ static int userfaultfd_stress(void)
 
 		/* unregister */
 		if (ioctl(uffd, UFFDIO_UNREGISTER, &uffdio_register.range)) {
-			fprintf(stderr, "register failure\n");
+			fprintf(stderr, "unregister failure\n");
 			return 1;
 		}
+		if (area_dst_alias) {
+			uffdio_register.range.start = (unsigned long) area_dst;
+			if (ioctl(uffd, UFFDIO_UNREGISTER,
+				  &uffdio_register.range)) {
+				fprintf(stderr, "unregister failure alias\n");
+				return 1;
+			}
+		}
 
 		/* verification */
 		if (bounces & BOUNCE_VERIFY) {
@@ -1056,6 +1165,10 @@ static int userfaultfd_stress(void)
 		area_src = area_dst;
 		area_dst = tmp_area;
 
+		tmp_area = area_src_alias;
+		area_src_alias = area_dst_alias;
+		area_dst_alias = tmp_area;
+
 		printf("userfaults:");
 		for (cpu = 0; cpu < nr_cpus; cpu++)
 			printf(" %lu", userfaults[cpu]);
@@ -1102,7 +1215,12 @@ static void set_test_type(const char *ty
 	} else if (!strcmp(type, "hugetlb")) {
 		test_type = TEST_HUGETLB;
 		uffd_test_ops = &hugetlb_uffd_test_ops;
+	} else if (!strcmp(type, "hugetlb_shared")) {
+		map_shared = true;
+		test_type = TEST_HUGETLB;
+		uffd_test_ops = &hugetlb_uffd_test_ops;
 	} else if (!strcmp(type, "shmem")) {
+		map_shared = true;
 		test_type = TEST_SHMEM;
 		uffd_test_ops = &shmem_uffd_test_ops;
 	} else {
@@ -1122,12 +1240,25 @@ static void set_test_type(const char *ty
 		fprintf(stderr, "Impossible to run this test\n"), exit(2);
 }
 
+static void sigalrm(int sig)
+{
+	if (sig != SIGALRM)
+		abort();
+	test_uffdio_copy_eexist = true;
+	test_uffdio_zeropage_eexist = true;
+	alarm(ALARM_INTERVAL_SECS);
+}
+
 int main(int argc, char **argv)
 {
 	if (argc < 4)
 		fprintf(stderr, "Usage: <test type> <MiB> <bounces> [hugetlbfs_file]\n"),
 				exit(1);
 
+	if (signal(SIGALRM, sigalrm) == SIG_ERR)
+		fprintf(stderr, "failed to arm SIGALRM"), exit(1);
+	alarm(ALARM_INTERVAL_SECS);
+
 	set_test_type(argv[1]);
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-hugetlbfs-remove-superfluous-page-unlock-in-vm_shared-case.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch
userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch
userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds.patch
userfaultfd-provide-pid-in-userfault-msg-add-feat-union.patch

