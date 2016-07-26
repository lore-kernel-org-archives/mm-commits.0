From: akpm@linux-foundation.org
Subject: [patch 111/126] shmem, thp: respect MADV_{NO,}HUGEPAGE for file
 mappings
Date: Tue, 26 Jul 2016 15:26:21 -0700
Message-ID: <5797e38d.BnmyY/xiAkGGEL3w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758683AbcGZW0W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:26:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: shmem, thp: respect MADV_{NO,}HUGEPAGE for file mappings

Let's wire up existing madvise() hugepage hints for file mappings.

MADV_HUGEPAGE advise shmem to allocate huge page on page fault in the
VMA. It only has effect if the filesystem is mounted with huge=advise or
huge=within_size.

MADV_NOHUGEPAGE prevents hugepage from being allocated on page fault in
the VMA. It doesn't prevent a huge page from being allocated by other
means, i.e. page fault into different mapping or write(2) into file.

Link: http://lkml.kernel.org/r/1466021202-61880-31-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   19 +++++--------------
 mm/shmem.c       |   20 +++++++++++++++++---
 2 files changed, 22 insertions(+), 17 deletions(-)

diff -puN mm/huge_memory.c~shmem-thp-respect-madv_nohugepage-for-file-mappings mm/huge_memory.c
--- a/mm/huge_memory.c~shmem-thp-respect-madv_nohugepage-for-file-mappings
+++ a/mm/huge_memory.c
@@ -1830,7 +1830,7 @@ spinlock_t *__pmd_trans_huge_lock(pmd_t
 	return NULL;
 }
 
-#define VM_NO_THP (VM_SPECIAL | VM_HUGETLB | VM_SHARED | VM_MAYSHARE)
+#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB | VM_SHARED | VM_MAYSHARE)
 
 int hugepage_madvise(struct vm_area_struct *vma,
 		     unsigned long *vm_flags, int advice)
@@ -1846,11 +1846,6 @@ int hugepage_madvise(struct vm_area_stru
 		if (mm_has_pgste(vma->vm_mm))
 			return 0;
 #endif
-		/*
-		 * Be somewhat over-protective like KSM for now!
-		 */
-		if (*vm_flags & VM_NO_THP)
-			return -EINVAL;
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
 		/*
@@ -1858,15 +1853,11 @@ int hugepage_madvise(struct vm_area_stru
 		 * register it here without waiting a page fault that
 		 * may not happen any time soon.
 		 */
-		if (unlikely(khugepaged_enter_vma_merge(vma, *vm_flags)))
+		if (!(*vm_flags & VM_NO_KHUGEPAGED) &&
+				khugepaged_enter_vma_merge(vma, *vm_flags))
 			return -ENOMEM;
 		break;
 	case MADV_NOHUGEPAGE:
-		/*
-		 * Be somewhat over-protective like KSM for now!
-		 */
-		if (*vm_flags & VM_NO_THP)
-			return -EINVAL;
 		*vm_flags &= ~VM_HUGEPAGE;
 		*vm_flags |= VM_NOHUGEPAGE;
 		/*
@@ -1974,7 +1965,7 @@ int khugepaged_enter_vma_merge(struct vm
 		 * page fault if needed.
 		 */
 		return 0;
-	if (vma->vm_ops || (vm_flags & VM_NO_THP))
+	if (vma->vm_ops || (vm_flags & VM_NO_KHUGEPAGED))
 		/* khugepaged not yet working on file or special mappings */
 		return 0;
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
@@ -2366,7 +2357,7 @@ static bool hugepage_vma_check(struct vm
 		return false;
 	if (is_vma_temporary_stack(vma))
 		return false;
-	return !(vma->vm_flags & VM_NO_THP);
+	return !(vma->vm_flags & VM_NO_KHUGEPAGED);
 }
 
 /*
diff -puN mm/shmem.c~shmem-thp-respect-madv_nohugepage-for-file-mappings mm/shmem.c
--- a/mm/shmem.c~shmem-thp-respect-madv_nohugepage-for-file-mappings
+++ a/mm/shmem.c
@@ -101,6 +101,8 @@ struct shmem_falloc {
 enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
 	SGP_CACHE,	/* don't exceed i_size, may allocate page */
+	SGP_NOHUGE,	/* like SGP_CACHE, but no huge pages */
+	SGP_HUGE,	/* like SGP_CACHE, huge pages preferred */
 	SGP_WRITE,	/* may exceed i_size, may allocate !Uptodate page */
 	SGP_FALLOC,	/* like SGP_WRITE, but make existing page Uptodate */
 };
@@ -1409,6 +1411,7 @@ static int shmem_getpage_gfp(struct inod
 	struct mem_cgroup *memcg;
 	struct page *page;
 	swp_entry_t swap;
+	enum sgp_type sgp_huge = sgp;
 	pgoff_t hindex = index;
 	int error;
 	int once = 0;
@@ -1416,6 +1419,8 @@ static int shmem_getpage_gfp(struct inod
 
 	if (index > (MAX_LFS_FILESIZE >> PAGE_SHIFT))
 		return -EFBIG;
+	if (sgp == SGP_NOHUGE || sgp == SGP_HUGE)
+		sgp = SGP_CACHE;
 repeat:
 	swap.val = 0;
 	page = find_lock_entry(mapping, index);
@@ -1534,7 +1539,7 @@ repeat:
 		/* shmem_symlink() */
 		if (mapping->a_ops != &shmem_aops)
 			goto alloc_nohuge;
-		if (shmem_huge == SHMEM_HUGE_DENY)
+		if (shmem_huge == SHMEM_HUGE_DENY || sgp_huge == SGP_NOHUGE)
 			goto alloc_nohuge;
 		if (shmem_huge == SHMEM_HUGE_FORCE)
 			goto alloc_huge;
@@ -1551,7 +1556,9 @@ repeat:
 				goto alloc_huge;
 			/* fallthrough */
 		case SHMEM_HUGE_ADVISE:
-			/* TODO: wire up fadvise()/madvise() */
+			if (sgp_huge == SGP_HUGE)
+				goto alloc_huge;
+			/* TODO: implement fadvise() hints */
 			goto alloc_nohuge;
 		}
 
@@ -1680,6 +1687,7 @@ static int shmem_fault(struct vm_area_st
 {
 	struct inode *inode = file_inode(vma->vm_file);
 	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
+	enum sgp_type sgp;
 	int error;
 	int ret = VM_FAULT_LOCKED;
 
@@ -1741,7 +1749,13 @@ static int shmem_fault(struct vm_area_st
 		spin_unlock(&inode->i_lock);
 	}
 
-	error = shmem_getpage_gfp(inode, vmf->pgoff, &vmf->page, SGP_CACHE,
+	sgp = SGP_CACHE;
+	if (vma->vm_flags & VM_HUGEPAGE)
+		sgp = SGP_HUGE;
+	else if (vma->vm_flags & VM_NOHUGEPAGE)
+		sgp = SGP_NOHUGE;
+
+	error = shmem_getpage_gfp(inode, vmf->pgoff, &vmf->page, sgp,
 				  gfp, vma->vm_mm, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
_
