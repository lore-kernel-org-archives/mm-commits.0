From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-non-cooperative-selftest-add-ufd-parameter-to-copy_page.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:15:10 -0800
Message-ID: <58af50de.fkZJi/pWl09Jeke0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40116 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdBWVPL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:15:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: selftest: add ufd parameter to copy_page
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-selftest-add-ufd-parameter-to-copy_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: non-cooperative: selftest: add ufd parameter to copy_page

With future addition of event tests, copy_page will be called with
different userfault file descriptors

Link: http://lkml.kernel.org/r/20161216144821.5183-40-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-non-cooperative-selftest-add-ufd-parameter-to-copy_page tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-non-cooperative-selftest-add-ufd-parameter-to-copy_page
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -317,7 +317,7 @@ static void *locking_thread(void *arg)
 	return NULL;
 }
 
-static int copy_page(unsigned long offset)
+static int copy_page(int ufd, unsigned long offset)
 {
 	struct uffdio_copy uffdio_copy;
 
@@ -329,7 +329,7 @@ static int copy_page(unsigned long offse
 	uffdio_copy.len = page_size;
 	uffdio_copy.mode = 0;
 	uffdio_copy.copy = 0;
-	if (ioctl(uffd, UFFDIO_COPY, &uffdio_copy)) {
+	if (ioctl(ufd, UFFDIO_COPY, &uffdio_copy)) {
 		/* real retval in ufdio_copy.copy */
 		if (uffdio_copy.copy != -EEXIST)
 			fprintf(stderr, "UFFDIO_COPY error %Ld\n",
@@ -386,7 +386,7 @@ static void *uffd_poll_thread(void *arg)
 		offset = (char *)(unsigned long)msg.arg.pagefault.address -
 			 area_dst;
 		offset &= ~(page_size-1);
-		if (copy_page(offset))
+		if (copy_page(uffd, offset))
 			userfaults++;
 	}
 	return (void *)userfaults;
@@ -424,7 +424,7 @@ static void *uffd_read_thread(void *arg)
 		offset = (char *)(unsigned long)msg.arg.pagefault.address -
 			 area_dst;
 		offset &= ~(page_size-1);
-		if (copy_page(offset))
+		if (copy_page(uffd, offset))
 			(*this_cpu_userfaults)++;
 	}
 	return (void *)NULL;
@@ -438,7 +438,7 @@ static void *background_thread(void *arg
 	for (page_nr = cpu * nr_pages_per_cpu;
 	     page_nr < (cpu+1) * nr_pages_per_cpu;
 	     page_nr++)
-		copy_page(page_nr * page_size);
+		copy_page(uffd, page_nr * page_size);
 
 	return NULL;
 }
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

