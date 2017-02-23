From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-introduce-vma_can_userfault.patch removed
 from -mm tree
Date: Thu, 23 Feb 2017 13:14:28 -0800
Message-ID: <58af50b4.Fahw6+Zv3qMoVns9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40012 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751293AbdBWVOt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: introduce vma_can_userfault
has been removed from the -mm tree.  Its filename was
     userfaultfd-introduce-vma_can_userfault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: introduce vma_can_userfault

Check whether a VMA can be used with userfault in more compact way

Link: http://lkml.kernel.org/r/20161216144821.5183-28-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-introduce-vma_can_userfault fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-introduce-vma_can_userfault
+++ a/fs/userfaultfd.c
@@ -1096,6 +1096,11 @@ static __always_inline int validate_rang
 	return 0;
 }
 
+static inline bool vma_can_userfault(struct vm_area_struct *vma)
+{
+	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma);
+}
+
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 				unsigned long arg)
 {
@@ -1185,7 +1190,7 @@ static int userfaultfd_register(struct u
 
 		/* check not compatible vmas */
 		ret = -EINVAL;
-		if (!vma_is_anonymous(cur) && !is_vm_hugetlb_page(cur))
+		if (!vma_can_userfault(cur))
 			goto out_unlock;
 		/*
 		 * If this vma contains ending address, and huge pages
@@ -1229,7 +1234,7 @@ static int userfaultfd_register(struct u
 	do {
 		cond_resched();
 
-		BUG_ON(!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma));
+		BUG_ON(!vma_can_userfault(vma));
 		BUG_ON(vma->vm_userfaultfd_ctx.ctx &&
 		       vma->vm_userfaultfd_ctx.ctx != ctx);
 
@@ -1367,7 +1372,7 @@ static int userfaultfd_unregister(struct
 		 * provides for more strict behavior to notice
 		 * unregistration errors.
 		 */
-		if (!vma_is_anonymous(cur) && !is_vm_hugetlb_page(cur))
+		if (!vma_can_userfault(cur))
 			goto out_unlock;
 
 		found = true;
@@ -1381,7 +1386,7 @@ static int userfaultfd_unregister(struct
 	do {
 		cond_resched();
 
-		BUG_ON(!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma));
+		BUG_ON(!vma_can_userfault(vma));
 
 		/*
 		 * Nothing to do: this vma is already registered into this
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

