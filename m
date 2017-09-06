From: akpm@linux-foundation.org
Subject: [patch 080/119] userfaultfd: shmem: add
 shmem_mfill_zeropage_pte for userfaultfd support
Date: Wed, 06 Sep 2017 16:23:02 -0700
Message-ID: <20170906232302.coG-08eSl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50468 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdIFXXE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:23:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, xemul@virtuozzo.com

From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: shmem: add shmem_mfill_zeropage_pte for userfaultfd support

shmem_mfill_zeropage_pte is the low level routine that implements the
userfaultfd UFFDIO_ZEROPAGE command.  Since for shmem mappings zero pages
are always allocated and accounted, the new method is a slight extension
of the existing shmem_mcopy_atomic_pte.

Link: http://lkml.kernel.org/r/1497939652-16528-4-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    6 +++
 mm/shmem.c               |   62 ++++++++++++++++++++++++++-----------
 2 files changed, 51 insertions(+), 17 deletions(-)

diff -puN include/linux/shmem_fs.h~userfaultfd-shmem-add-shmem_mfill_zeropage_pte-for-userfaultfd-support include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~userfaultfd-shmem-add-shmem_mfill_zeropage_pte-for-userfaultfd-support
+++ a/include/linux/shmem_fs.h
@@ -137,9 +137,15 @@ extern int shmem_mcopy_atomic_pte(struct
 				  unsigned long dst_addr,
 				  unsigned long src_addr,
 				  struct page **pagep);
+extern int shmem_mfill_zeropage_pte(struct mm_struct *dst_mm,
+				    pmd_t *dst_pmd,
+				    struct vm_area_struct *dst_vma,
+				    unsigned long dst_addr);
 #else
 #define shmem_mcopy_atomic_pte(dst_mm, dst_pte, dst_vma, dst_addr, \
 			       src_addr, pagep)        ({ BUG(); 0; })
+#define shmem_mfill_zeropage_pte(dst_mm, dst_pmd, dst_vma, \
+				 dst_addr)      ({ BUG(); 0; })
 #endif
 
 #endif
diff -puN mm/shmem.c~userfaultfd-shmem-add-shmem_mfill_zeropage_pte-for-userfaultfd-support mm/shmem.c
--- a/mm/shmem.c~userfaultfd-shmem-add-shmem_mfill_zeropage_pte-for-userfaultfd-support
+++ a/mm/shmem.c
@@ -2207,12 +2207,13 @@ bool shmem_mapping(struct address_space
 	return mapping->a_ops == &shmem_aops;
 }
 
-int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm,
-			   pmd_t *dst_pmd,
-			   struct vm_area_struct *dst_vma,
-			   unsigned long dst_addr,
-			   unsigned long src_addr,
-			   struct page **pagep)
+static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
+				  pmd_t *dst_pmd,
+				  struct vm_area_struct *dst_vma,
+				  unsigned long dst_addr,
+				  unsigned long src_addr,
+				  bool zeropage,
+				  struct page **pagep)
 {
 	struct inode *inode = file_inode(dst_vma->vm_file);
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -2235,17 +2236,22 @@ int shmem_mcopy_atomic_pte(struct mm_str
 		if (!page)
 			goto out_unacct_blocks;
 
-		page_kaddr = kmap_atomic(page);
-		ret = copy_from_user(page_kaddr, (const void __user *)src_addr,
-				     PAGE_SIZE);
-		kunmap_atomic(page_kaddr);
-
-		/* fallback to copy_from_user outside mmap_sem */
-		if (unlikely(ret)) {
-			*pagep = page;
-			shmem_inode_unacct_blocks(inode, 1);
-			/* don't free the page */
-			return -EFAULT;
+		if (!zeropage) {	/* mcopy_atomic */
+			page_kaddr = kmap_atomic(page);
+			ret = copy_from_user(page_kaddr,
+					     (const void __user *)src_addr,
+					     PAGE_SIZE);
+			kunmap_atomic(page_kaddr);
+
+			/* fallback to copy_from_user outside mmap_sem */
+			if (unlikely(ret)) {
+				*pagep = page;
+				shmem_inode_unacct_blocks(inode, 1);
+				/* don't free the page */
+				return -EFAULT;
+			}
+		} else {		/* mfill_zeropage_atomic */
+			clear_highpage(page);
 		}
 	} else {
 		page = *pagep;
@@ -2311,6 +2317,28 @@ out_unacct_blocks:
 	goto out;
 }
 
+int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm,
+			   pmd_t *dst_pmd,
+			   struct vm_area_struct *dst_vma,
+			   unsigned long dst_addr,
+			   unsigned long src_addr,
+			   struct page **pagep)
+{
+	return shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma,
+				      dst_addr, src_addr, false, pagep);
+}
+
+int shmem_mfill_zeropage_pte(struct mm_struct *dst_mm,
+			     pmd_t *dst_pmd,
+			     struct vm_area_struct *dst_vma,
+			     unsigned long dst_addr)
+{
+	struct page *page = NULL;
+
+	return shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma,
+				      dst_addr, 0, true, &page);
+}
+
 #ifdef CONFIG_TMPFS
 static const struct inode_operations shmem_symlink_inode_operations;
 static const struct inode_operations shmem_short_symlink_operations;
_
