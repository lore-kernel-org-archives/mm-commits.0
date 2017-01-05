From: akpm@linux-foundation.org
Subject: +
 userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:54:26 -0800
Message-ID: <586d9942.RPLWS25OIBR1qnbE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36242 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937497AbdAEAy1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: add userfaultfd hook for shared memory faults
has been added to the -mm tree.  Its filename is
     userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1571,7 +1573,7 @@ static int shmem_replace_page(struct pag
  */
 static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	struct page **pagep, enum sgp_type sgp, gfp_t gfp,
-	struct mm_struct *fault_mm, int *fault_type)
+	struct vm_area_struct *vma, struct vm_fault *vmf, int *fault_type)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -1625,7 +1627,7 @@ repeat:
 	 * bring it back from swap or allocate.
 	 */
 	sbinfo = SHMEM_SB(inode->i_sb);
-	charge_mm = fault_mm ? : current->mm;
+	charge_mm = vma ? vma->vm_mm : current->mm;
 
 	if (swap.val) {
 		/* Look it up and read it in.. */
@@ -1635,7 +1637,8 @@ repeat:
 			if (fault_type) {
 				*fault_type |= VM_FAULT_MAJOR;
 				count_vm_event(PGMAJFAULT);
-				mem_cgroup_count_vm_event(fault_mm, PGMAJFAULT);
+				mem_cgroup_count_vm_event(charge_mm,
+							  PGMAJFAULT);
 			}
 			/* Here we actually start the io */
 			page = shmem_swapin(swap, gfp, info, index);
@@ -1704,6 +1707,11 @@ repeat:
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
@@ -1966,7 +1974,7 @@ static int shmem_fault(struct vm_area_st
 		sgp = SGP_NOHUGE;
 
 	error = shmem_getpage_gfp(inode, vmf->pgoff, &vmf->page, sgp,
-				  gfp, vma->vm_mm, &ret);
+				  gfp, vma, vmf, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
 	return ret;
@@ -4247,7 +4255,7 @@ struct page *shmem_read_mapping_page_gfp
 
 	BUG_ON(mapping->a_ops != &shmem_aops);
 	error = shmem_getpage_gfp(inode, index, &page, SGP_CACHE,
-				  gfp, NULL, NULL);
+				  gfp, NULL, NULL, NULL);
 	if (error)
 		page = ERR_PTR(error);
 	else
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-dup_userfaultfd-use-mm_count-instead-of-mm_users.patch
userfaultfd-introduce-vma_can_userfault.patch
userfaultfd-shmem-add-shmem_mcopy_atomic_pte-for-userfaultfd-support.patch
userfaultfd-shmem-introduce-vma_is_shmem.patch
userfaultfd-shmem-use-shmem_mcopy_atomic_pte-for-shared-memory.patch
userfaultfd-shmem-add-userfaultfd-hook-for-shared-memory-faults.patch
userfaultfd-shmem-allow-registration-of-shared-memory-ranges.patch
userfaultfd-shmem-add-userfaultfd_shmem-test.patch
userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open.patch
userfaultfd-non-cooperative-selftest-add-ufd-parameter-to-copy_page.patch
userfaultfd-non-cooperative-selftest-add-test-for-fork-madvdontneed-and-remap-events.patch

