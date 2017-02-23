From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:15:07 -0800
Message-ID: <58af50db.4qZwGZ+iaodswG12%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40102 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdBWVPI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:15:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: selftest: introduce userfaultfd_open
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: non-cooperative: selftest: introduce userfaultfd_open

userfaultfd_open will be needed by the non cooperative selftest.

Link: http://lkml.kernel.org/r/20161216144821.5183-39-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   41 ++++++++++++---------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -81,7 +81,7 @@ static int huge_fd;
 static char *huge_fd_off0;
 #endif
 static unsigned long long *count_verify;
-static int uffd, finished, *pipefd;
+static int uffd, uffd_flags, finished, *pipefd;
 static char *area_src, *area_dst;
 static char *zeropage;
 pthread_attr_t attr;
@@ -512,23 +512,9 @@ static int stress(unsigned long *userfau
 	return 0;
 }
 
-static int userfaultfd_stress(void)
+static int userfaultfd_open(void)
 {
-	void *area;
-	char *tmp_area;
-	unsigned long nr;
-	struct uffdio_register uffdio_register;
 	struct uffdio_api uffdio_api;
-	unsigned long cpu;
-	int uffd_flags, err;
-	unsigned long userfaults[nr_cpus];
-
-	allocate_area((void **)&area_src);
-	if (!area_src)
-		return 1;
-	allocate_area((void **)&area_dst);
-	if (!area_dst)
-		return 1;
 
 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
 	if (uffd < 0) {
@@ -549,6 +535,29 @@ static int userfaultfd_stress(void)
 		return 1;
 	}
 
+	return 0;
+}
+
+static int userfaultfd_stress(void)
+{
+	void *area;
+	char *tmp_area;
+	unsigned long nr;
+	struct uffdio_register uffdio_register;
+	unsigned long cpu;
+	int err;
+	unsigned long userfaults[nr_cpus];
+
+	allocate_area((void **)&area_src);
+	if (!area_src)
+		return 1;
+	allocate_area((void **)&area_dst);
+	if (!area_dst)
+		return 1;
+
+	if (userfaultfd_open() < 0)
+		return 1;
+
 	count_verify = malloc(nr_pages * sizeof(unsigned long long));
 	if (!count_verify) {
 		perror("count_verify");
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

