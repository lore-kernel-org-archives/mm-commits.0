From: akpm@linux-foundation.org
Subject: [merged] mm-add-follow_pte_pmd.patch removed from -mm tree
Date: Wed, 11 Jan 2017 14:27:42 -0800
Message-ID: <5876b15e.rKpMM2uTwpH5R/eJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbdAKW2d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 17:28:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, dave.hansen@intel.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, mawilcox@microsoft.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add follow_pte_pmd()
has been removed from the -mm tree.  Its filename was
     mm-add-follow_pte_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: mm: add follow_pte_pmd()

Patch series "Write protect DAX PMDs in *sync path".

Currently dax_mapping_entry_mkclean() fails to clean and write protect the
pmd_t of a DAX PMD entry during an *sync operation.  This can result in
data loss, as detailed in patch 2.

This series is based on Dan's "libnvdimm-pending" branch, which is the
current home for Jan's "dax: Page invalidation fixes" series.  You can
find a working tree here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_pmd_clean


This patch (of 2):

Similar to follow_pte(), follow_pte_pmd() allows either a PTE leaf or a
huge page PMD leaf to be found and returned.

Link: http://lkml.kernel.org/r/1482272586-21177-2-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/memory.c        |   37 ++++++++++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-add-follow_pte_pmd include/linux/mm.h
--- a/include/linux/mm.h~mm-add-follow_pte_pmd
+++ a/include/linux/mm.h
@@ -1212,6 +1212,8 @@ void unmap_mapping_range(struct address_
 		loff_t const holebegin, loff_t const holelen, int even_cows);
 int follow_pte(struct mm_struct *mm, unsigned long address, pte_t **ptepp,
 	       spinlock_t **ptlp);
+int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
+			     pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	unsigned long *pfn);
 int follow_phys(struct vm_area_struct *vma, unsigned long address,
diff -puN mm/memory.c~mm-add-follow_pte_pmd mm/memory.c
--- a/mm/memory.c~mm-add-follow_pte_pmd
+++ a/mm/memory.c
@@ -3772,8 +3772,8 @@ int __pmd_alloc(struct mm_struct *mm, pu
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-static int __follow_pte(struct mm_struct *mm, unsigned long address,
-		pte_t **ptepp, spinlock_t **ptlp)
+static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
+		pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -3790,11 +3790,20 @@ static int __follow_pte(struct mm_struct
 
 	pmd = pmd_offset(pud, address);
 	VM_BUG_ON(pmd_trans_huge(*pmd));
-	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		goto out;
 
-	/* We cannot handle huge page PFN maps. Luckily they don't exist. */
-	if (pmd_huge(*pmd))
+	if (pmd_huge(*pmd)) {
+		if (!pmdpp)
+			goto out;
+
+		*ptlp = pmd_lock(mm, pmd);
+		if (pmd_huge(*pmd)) {
+			*pmdpp = pmd;
+			return 0;
+		}
+		spin_unlock(*ptlp);
+	}
+
+	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
 		goto out;
 
 	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
@@ -3817,9 +3826,23 @@ int follow_pte(struct mm_struct *mm, uns
 
 	/* (void) is needed to make gcc happy */
 	(void) __cond_lock(*ptlp,
-			   !(res = __follow_pte(mm, address, ptepp, ptlp)));
+			   !(res = __follow_pte_pmd(mm, address, ptepp, NULL,
+					   ptlp)));
+	return res;
+}
+
+int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
+			     pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
+{
+	int res;
+
+	/* (void) is needed to make gcc happy */
+	(void) __cond_lock(*ptlp,
+			   !(res = __follow_pte_pmd(mm, address, ptepp, pmdpp,
+					   ptlp)));
 	return res;
 }
+EXPORT_SYMBOL(follow_pte_pmd);
 
 /**
  * follow_pfn - look up PFN at a user virtual address
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-build-warnings-with-fs_dax-and-fs_iomap.patch
tracing-add-__print_flags_u64.patch
dax-add-tracepoint-infrastructure-pmd-tracing.patch
dax-update-maintainers-entries-for-fs-dax.patch
dax-add-tracepoints-to-dax_pmd_load_hole.patch
dax-add-tracepoints-to-dax_pmd_insert_mapping.patch

