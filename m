From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-shmem-introduce-vma_is_shmem.patch removed
 from -mm tree
Date: Thu, 23 Feb 2017 13:14:34 -0800
Message-ID: <58af50ba.0kNQvAwYO7OYiCZ+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40014 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbdBWVOt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: introduce vma_is_shmem
has been removed from the -mm tree.  Its filename was
     userfaultfd-shmem-introduce-vma_is_shmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: shmem: introduce vma_is_shmem

Currently userfault relies on vma_is_anonymous and vma_is_hugetlb to
ensure compatibility of a VMA with userfault.  Introduction of
vma_is_shmem allows detection if tmpfs backed VMAs, so that they may be
used with userfaultfd.  Current implementation presumes usage of
vma_is_shmem only by slow path routines in userfaultfd, therefore the
vma_is_shmem is not made inline to leave the few remaining free bits in
vm_flags.

Link: http://lkml.kernel.org/r/20161216144821.5183-30-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 ++++++++++
 mm/shmem.c         |    5 +++++
 2 files changed, 15 insertions(+)

diff -puN include/linux/mm.h~userfaultfd-shmem-introduce-vma_is_shmem include/linux/mm.h
--- a/include/linux/mm.h~userfaultfd-shmem-introduce-vma_is_shmem
+++ a/include/linux/mm.h
@@ -1383,6 +1383,16 @@ static inline bool vma_is_anonymous(stru
 	return !vma->vm_ops;
 }
 
+#ifdef CONFIG_SHMEM
+/*
+ * The vma_is_shmem is not inline because it is used only by slow
+ * paths in userfault.
+ */
+bool vma_is_shmem(struct vm_area_struct *vma);
+#else
+static inline bool vma_is_shmem(struct vm_area_struct *vma) { return false; }
+#endif
+
 static inline int stack_guard_page_start(struct vm_area_struct *vma,
 					     unsigned long addr)
 {
diff -puN mm/shmem.c~userfaultfd-shmem-introduce-vma_is_shmem mm/shmem.c
--- a/mm/shmem.c~userfaultfd-shmem-introduce-vma_is_shmem
+++ a/mm/shmem.c
@@ -191,6 +191,11 @@ static const struct inode_operations shm
 static const struct vm_operations_struct shmem_vm_ops;
 static struct file_system_type shmem_fs_type;
 
+bool vma_is_shmem(struct vm_area_struct *vma)
+{
+	return vma->vm_ops == &shmem_vm_ops;
+}
+
 static LIST_HEAD(shmem_swaplist);
 static DEFINE_MUTEX(shmem_swaplist_mutex);
 
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

