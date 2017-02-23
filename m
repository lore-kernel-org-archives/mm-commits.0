From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:14:43 -0800
Message-ID: <58af50c3.4nKOI7FGRYJxMd8Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40016 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751305AbdBWVOt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: add userfaultfd hook for shared memory faults
has been removed from the -mm tree.  Its filename was
     userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: shmem: add userfaultfd hook for shared memory faults

When processing a page fault in shared memory area for not present page,
check the VMA determine if faults are to be handled by userfaultfd.  If
so, delegate the page fault to handle_userfault.

Link: http://lkml.kernel.org/r/20161216144821.5183-33-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN mm/shmem.c~userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults mm/shmem.c
--- a/mm/shmem.c~userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults
+++ a/mm/shmem.c
@@ -72,6 +72,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
 #include <uapi/linux/memfd.h>
+#include <linux/userfaultfd_k.h>
 #include <linux/rmap.h>
 
 #include <linux/uaccess.h>
@@ -118,13 +119,14 @@ static int shmem_replace_page(struct pag
 				struct shmem_inode_info *info, pgoff_t index);
 static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 		struct page **pagep, enum sgp_type sgp,
-		gfp_t gfp, struct mm_struct *fault_mm, int *fault_type);
+		gfp_t gfp, struct vm_area_struct *vma,
+		struct vm_fault *vmf, int *fault_type);
 
 int shmem_getpage(struct inode *inode, pgoff_t index,
 		struct page **pagep, enum sgp_type sgp)
 {
 	return shmem_getpage_gfp(inode, index, pagep, sgp,
-		mapping_gfp_mask(inode->i_mapping), NULL, NULL);
+		mapping_gfp_mask(inode->i_mapping), NULL, NULL, NULL);
 }
 
 static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
@@ -1578,7 +1580,7 @@ static int shmem_replace_page(struct pag
  */
 static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	struct page **pagep, enum sgp_type sgp, gfp_t gfp,
-	struct mm_struct *fault_mm, int *fault_type)
+	struct vm_area_struct *vma, struct vm_fault *vmf, int *fault_type)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -1632,7 +1634,7 @@ repeat:
 	 * bring it back from swap or allocate.
 	 */
 	sbinfo = SHMEM_SB(inode->i_sb);
-	charge_mm = fault_mm ? : current->mm;
+	charge_mm = vma ? vma->vm_mm : current->mm;
 
 	if (swap.val) {
 		/* Look it up and read it in.. */
@@ -1642,7 +1644,8 @@ repeat:
 			if (fault_type) {
 				*fault_type |= VM_FAULT_MAJOR;
 				count_vm_event(PGMAJFAULT);
-				mem_cgroup_count_vm_event(fault_mm, PGMAJFAULT);
+				mem_cgroup_count_vm_event(charge_mm,
+							  PGMAJFAULT);
 			}
 			/* Here we actually start the io */
 			page = shmem_swapin(swap, gfp, info, index);
@@ -1711,6 +1714,11 @@ repeat:
 		swap_free(swap);
 
 	} else {
+		if (vma && userfaultfd_missing(vma)) {
+			*fault_type = handle_userfault(vmf, VM_UFFD_MISSING);
+			return 0;
+		}
+
 		/* shmem_symlink() */
 		if (mapping->a_ops != &shmem_aops)
 			goto alloc_nohuge;
@@ -1973,7 +1981,7 @@ static int shmem_fault(struct vm_area_st
 		sgp = SGP_NOHUGE;
 
 	error = shmem_getpage_gfp(inode, vmf->pgoff, &vmf->page, sgp,
-				  gfp, vma->vm_mm, &ret);
+				  gfp, vma, vmf, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
 	return ret;
@@ -4254,7 +4262,7 @@ struct page *shmem_read_mapping_page_gfp
 
 	BUG_ON(mapping->a_ops != &shmem_aops);
 	error = shmem_getpage_gfp(inode, index, &page, SGP_CACHE,
-				  gfp, NULL, NULL);
+				  gfp, NULL, NULL, NULL);
 	if (error)
 		page = ERR_PTR(error);
 	else
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

