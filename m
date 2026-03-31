Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DC22BE05F
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917819; cv=none; b=fZtS5UhpeXo4P8NfjiT2vs3H3Je2YYTwjg2RxgM+h30AvkLSwKtkGUeriyAxtvIHpp2dBR71/Wzy2ezJGcscThtN1vyvd/RIhrHlhkzEAstiykxrCl3DuDW2Ce5hZmHGOXvvVKwY9sp/yWXsAeoNvueiZ4WBbfvwJYHuw+7K5h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917819; c=relaxed/simple;
	bh=oJjCtrslzKP5jXA/iPuAgnCF9UO9PPoPWfFlTUcMyEU=;
	h=Date:To:From:Subject:Message-Id; b=Ml31kapmoY2HwxssCIRw84CpISHWxYJlKnFiIVpHctuLp8rj7hzPrgvHeQfHB7eHJtE1JDaaOnw/2RVSopISw9BT4NldTcWLE5xeL/odnqDVUBS56qp112lE8KYOJSLBbnVDdUqo10xS9UvtOqYzKqn67TuuNF8gziQ0e4s4LzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0BNKNDkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0BNKNDkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE85C4CEF7;
	Tue, 31 Mar 2026 00:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917819;
	bh=oJjCtrslzKP5jXA/iPuAgnCF9UO9PPoPWfFlTUcMyEU=;
	h=Date:To:From:Subject:From;
	b=0BNKNDkIHnba8NU+Jc5hCSMizZ3PhwcPP22FsxKvejyR1ciBz9CKRTZqU94FY1fCz
	 64VPb2QCLMAROTqPIXi22x/wM9uhpPqQQlGQyqr51e24MgHaY8+KRnP1f47a+PbX31
	 Qk+juD8X4+ujgDEa+SMRJRYkxxtQdbj3bdyV2ZGI=
Date: Mon, 30 Mar 2026 17:43:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-simplify-vma_is_specal_huge.patch removed from -mm tree
Message-Id: <20260331004339.6AE85C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: simplify vma_is_specal_huge()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-simplify-vma_is_specal_huge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge_memory: simplify vma_is_specal_huge()
Date: Fri, 20 Mar 2026 18:07:18 +0000

Patch series "mm/huge_memory: refactor zap_huge_pmd()", v3.

zap_huge_pmd() is overly complicated, clean it up and also add an assert
in the case that we encounter a buggy PMD entry that doesn't match
expectations.

This is motivated by a bug discovered [0] where the PMD entry was none of:

* A non-DAX, PFN or mixed map.
* The huge zero folio
* A present PMD entry
* A softleaf entry

In zap_huge_pmd(), but due to the bug we manged to reach this code.

It is useful to explicitly call this out rather than have an arbitrary
NULL pointer dereference happen, which also improves understanding of
what's going on.

The series goes further to make use of vm_normal_folio_pmd() rather than
implementing custom logic for retrieving the folio, and extends softleaf
functionality to provide and use an equivalent softleaf function.


This patch (of 13):

This function is confused - it overloads the term 'special' yet again,
checks for DAX but in many cases the code explicitly excludes DAX before
invoking the predicate.

It also unnecessarily checks for vma->vm_file - this has to be present for
a driver to have set VMA_MIXEDMAP_BIT or VMA_PFNMAP_BIT.

In fact, a far simpler form of this is to reverse the DAX predicate and
return false if DAX is set.

This makes sense from the point of view of 'special' as in
vm_normal_page(), as DAX actually does potentially have retrievable
folios.

Also there's no need to have this in mm.h so move it to huge_memory.c.

No functional change intended.

Link: https://lkml.kernel.org/r/cover.1774029655.git.ljs@kernel.org
Link: https://lkml.kernel.org/r/d2b65883dc4895f197c4b4a69fbf27a063463412.1774029655.git.ljs@kernel.org
Link: https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/ [0]
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++--
 include/linux/mm.h      |   16 ----------------
 mm/huge_memory.c        |   30 +++++++++++++++++++++++-------
 3 files changed, 25 insertions(+), 25 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-simplify-vma_is_specal_huge
+++ a/include/linux/huge_mm.h
@@ -83,7 +83,7 @@ extern struct kobj_attribute thpsize_shm
  * file is never split and the MAX_PAGECACHE_ORDER limit does not apply to
  * it.  Same to PFNMAPs where there's neither page* nor pagecache.
  */
-#define THP_ORDERS_ALL_SPECIAL		\
+#define THP_ORDERS_ALL_SPECIAL_DAX	\
 	(BIT(PMD_ORDER) | BIT(PUD_ORDER))
 #define THP_ORDERS_ALL_FILE_DEFAULT	\
 	((BIT(MAX_PAGECACHE_ORDER + 1) - 1) & ~BIT(0))
@@ -92,7 +92,7 @@ extern struct kobj_attribute thpsize_shm
  * Mask of all large folio orders supported for THP.
  */
 #define THP_ORDERS_ALL	\
-	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FILE_DEFAULT)
+	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL_DAX | THP_ORDERS_ALL_FILE_DEFAULT)
 
 enum tva_type {
 	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
--- a/include/linux/mm.h~mm-huge_memory-simplify-vma_is_specal_huge
+++ a/include/linux/mm.h
@@ -5068,22 +5068,6 @@ long copy_folio_from_user(struct folio *
 			   const void __user *usr_src,
 			   bool allow_pagefault);
 
-/**
- * vma_is_special_huge - Are transhuge page-table entries considered special?
- * @vma: Pointer to the struct vm_area_struct to consider
- *
- * Whether transhuge page-table entries are considered "special" following
- * the definition in vm_normal_page().
- *
- * Return: true if transhuge page-table entries should be considered special,
- * false otherwise.
- */
-static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
-{
-	return vma_is_dax(vma) || (vma->vm_file &&
-				   (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)));
-}
-
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if MAX_NUMNODES > 1
--- a/mm/huge_memory.c~mm-huge_memory-simplify-vma_is_specal_huge
+++ a/mm/huge_memory.c
@@ -100,6 +100,14 @@ static inline bool file_thp_enabled(stru
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
+/* If returns true, we are unable to access the VMA's folios. */
+static bool vma_is_special_huge(const struct vm_area_struct *vma)
+{
+	if (vma_is_dax(vma))
+		return false;
+	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
 					 enum tva_type type,
@@ -113,8 +121,8 @@ unsigned long __thp_vma_allowable_orders
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
 		supported_orders = THP_ORDERS_ALL_ANON;
-	else if (vma_is_special_huge(vma))
-		supported_orders = THP_ORDERS_ALL_SPECIAL;
+	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
+		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
@@ -2415,7 +2423,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 						tlb->fullmm);
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
+	if (vma_is_special_huge(vma)) {
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
@@ -2917,7 +2925,7 @@ int zap_huge_pud(struct mmu_gather *tlb,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
+	if (vma_is_special_huge(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -3068,7 +3076,7 @@ static void __split_huge_pmd_locked(stru
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
+		if (vma_is_special_huge(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4629,8 +4637,16 @@ next:
 
 static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
 {
-	return vma_is_special_huge(vma) || (vma->vm_flags & VM_IO) ||
-		    is_vm_hugetlb_page(vma);
+	if (vma_is_dax(vma))
+		return true;
+	if (vma_is_special_huge(vma))
+		return true;
+	if (vma_test(vma, VMA_IO_BIT))
+		return true;
+	if (is_vm_hugetlb_page(vma))
+		return true;
+
+	return false;
 }
 
 static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

