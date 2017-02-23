From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-shmem-add-userfaultfd_shmem-test.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:14:52 -0800
Message-ID: <58af50cc.9GhfLqbNP9rnygG0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40036 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbdBWVOy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: add userfaultfd_shmem test
has been removed from the -mm tree.  Its filename was
     userfaultfd-shmem-add-userfaultfd_shmem-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: shmem: add userfaultfd_shmem test

The test verifies that anonymous shared mapping can be used with userfault
using the existing testing method.  The shared memory area is allocated
using mmap(..., MAP_SHARED | MAP_ANONYMOUS, ...) and released using
madvise(MADV_REMOVE)

Link: http://lkml.kernel.org/r/20161216144821.5183-35-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile      |    4 ++
 tools/testing/selftests/vm/run_vmtests   |   11 ++++++
 tools/testing/selftests/vm/userfaultfd.c |   37 +++++++++++++++++++--
 3 files changed, 50 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/vm/Makefile~userfaultfd-shmem-add-userfaultfd_shmem-test tools/testing/selftests/vm/Makefile
--- a/tools/testing/selftests/vm/Makefile~userfaultfd-shmem-add-userfaultfd_shmem-test
+++ a/tools/testing/selftests/vm/Makefile
@@ -11,6 +11,7 @@ BINARIES += thuge-gen
 BINARIES += transhuge-stress
 BINARIES += userfaultfd
 BINARIES += userfaultfd_hugetlb
+BINARIES += userfaultfd_shmem
 BINARIES += mlock-random-test
 
 all: $(BINARIES)
@@ -22,6 +23,9 @@ userfaultfd: userfaultfd.c ../../../../u
 userfaultfd_hugetlb: userfaultfd.c ../../../../usr/include/linux/kernel.h
 	$(CC) $(CFLAGS) -DHUGETLB_TEST -O2 -o $@ $< -lpthread
 
+userfaultfd_shmem: userfaultfd.c ../../../../usr/include/linux/kernel.h
+	$(CC) $(CFLAGS) -DSHMEM_TEST -O2 -o $@ $< -lpthread
+
 mlock-random-test: mlock-random-test.c
 	$(CC) $(CFLAGS) -o $@ $< -lcap
 
diff -puN tools/testing/selftests/vm/run_vmtests~userfaultfd-shmem-add-userfaultfd_shmem-test tools/testing/selftests/vm/run_vmtests
--- a/tools/testing/selftests/vm/run_vmtests~userfaultfd-shmem-add-userfaultfd_shmem-test
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -116,6 +116,17 @@ else
 fi
 rm -f $mnt/ufd_test_file
 
+echo "----------------------------"
+echo "running userfaultfd_shmem"
+echo "----------------------------"
+./userfaultfd_shmem 128 32
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=1
+else
+	echo "[PASS]"
+fi
+
 #cleanup
 umount $mnt
 rm -rf $mnt
diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-shmem-add-userfaultfd_shmem-test tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-shmem-add-userfaultfd_shmem-test
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -101,8 +101,9 @@ pthread_attr_t attr;
 				 ~(unsigned long)(sizeof(unsigned long long) \
 						  -  1)))
 
-#ifndef HUGETLB_TEST
+#if !defined(HUGETLB_TEST) && !defined(SHMEM_TEST)
 
+/* Anonymous memory */
 #define EXPECTED_IOCTLS		((1 << _UFFDIO_WAKE) | \
 				 (1 << _UFFDIO_COPY) | \
 				 (1 << _UFFDIO_ZEROPAGE))
@@ -127,10 +128,13 @@ static void allocate_area(void **alloc_a
 	}
 }
 
-#else /* HUGETLB_TEST */
+#else /* HUGETLB_TEST or SHMEM_TEST */
 
 #define EXPECTED_IOCTLS		UFFD_API_RANGE_IOCTLS_BASIC
 
+#ifdef HUGETLB_TEST
+
+/* HugeTLB memory */
 static int release_pages(char *rel_area)
 {
 	int ret = 0;
@@ -162,8 +166,37 @@ static void allocate_area(void **alloc_a
 		huge_fd_off0 = *alloc_area;
 }
 
+#elif defined(SHMEM_TEST)
+
+/* Shared memory */
+static int release_pages(char *rel_area)
+{
+	int ret = 0;
+
+	if (madvise(rel_area, nr_pages * page_size, MADV_REMOVE)) {
+		perror("madvise");
+		ret = 1;
+	}
+
+	return ret;
+}
+
+static void allocate_area(void **alloc_area)
+{
+	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
+			   MAP_ANONYMOUS | MAP_SHARED, -1, 0);
+	if (*alloc_area == MAP_FAILED) {
+		fprintf(stderr, "shared memory mmap failed\n");
+		*alloc_area = NULL;
+	}
+}
+
+#else /* SHMEM_TEST */
+#error "Undefined test type"
 #endif /* HUGETLB_TEST */
 
+#endif /* !defined(HUGETLB_TEST) && !defined(SHMEM_TEST) */
+
 static int my_bcmp(char *str1, char *str2, size_t n)
 {
 	unsigned long i;
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-rename-event_madvdontneed-to-event_remove.patch
userfaultfd-non-cooperative-add-madvise-event-for-madv_remove-request.patch
userfaultfd-non-cooperative-selftest-enable-remove-event-test-for-shmem.patch
mm-call-vm_munmap-in-munmap-syscall-instead-of-using-open-coded-version.patch
userfaultfd-non-cooperative-add-event-for-memory-unmaps.patch
userfaultfd-non-cooperative-add-event-for-exit-notification.patch
userfaultfd-non-cooperative-add-event-for-exit-notification-fix.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix.patch
userfaultfd_copy-return-enospc-in-case-mm-has-gone.patch
userfaultfd-documentation-update.patch

