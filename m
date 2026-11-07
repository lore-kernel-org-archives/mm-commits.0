Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023388;
	b=Olv45a43E9q/BuPUsQGHnEIOJviIokVFoBmjJ5U6y6o4gylkaG1PL1LnE2w5G167QM5k
	 cc0y+Tly9uj2/xQN+2/HbUM3HauPo+XLPL1mZhQRbqvnlXtoxat+Ft1GG4ujH2igVX82y
	 R/gS7R5QVnAnsDKPdzurjb9n51yhvx8FP9C+J8MbbMcSy9mPJWCXedqbY5wF1DoC0XPTe
	 gpeoWR1Wah4RlFbdSCjuOZerPqjQCItW6TVTGGE1gKkgpN2LRQ9Er5sQcZuZUtPBnXK2i
	 PYN0IWxeE83qyrh2ttnDjBJcPVnC19pyP1G52Pcw9WWTTAX1hMYtwVwh13vLJGDk6Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023388;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KKuyeJF3OiZQKR2rDnKUvUqNlk/aiL4qorEzbhiHavY=;
	b=CPQVCb9FKP7lxaZCTrJjPQp9rYt0e6EIgHKZUJ39VGoMKa2wjbTHtqTDP0z92GhriRfj
	 Xy3tsrDnWdIfX2UiotkWBByLWl7RNvaCmjg9NOaVWD2KBDUSuX0tsNo9+g0VJcAXz/qmU
	 CYMsvycjhvdhmcMizSpRNUpT5DwVrhi3hVnj2v8tJ4CSzcoHcV6rXJTElNdA6aRw5ghy/
	 RagqVrTT1xESm9+g1/F8Nowd+jyEoz7XDhG+S2nzwLdBgreNes2mU0j6nlfjLJp1TUkVy
	 eYoeUlmKmgliB+NsOJDHjUjfi0TaQJTjo7Xb1eVee4pJtCE6gj4OFNvx3NiaOiJRDPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vlLBAMTR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A14606A32E
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vlLBAMTR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD531F0089F;
	Sat,  7 Nov 2026 03:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023388;
	bh=KKuyeJF3OiZQKR2rDnKUvUqNlk/aiL4qorEzbhiHavY=;
	h=Date:To:From:Subject;
	b=vlLBAMTR4qGGkGYmBl+naQkj9JtIpH9L+s1UvOClK018OUceDEBpPQapdq09EmWyS
	 a7aTRN2T7jYru2vYLhdd3RGRJbN77P4QVicB+NrJWtl7rzT9on6iS50XLGqI1Y5IuH
	 2on4aMAGMVdjj04Lz4yeN9aKsmEW1x5iuSNga0S8=
Date: Fri, 06 Nov 2026 19:49:47 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch removed from -mm tree
Message-Id: <20261107034948.0BD531F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: simplify vmemmap head page handling
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: simplify vmemmap head page handling
Date: Wed, 04 Nov 2026 10:35:01 +0800

The new head page is already tracked on the vmemmap page list before
remapping starts.  Passing it separately gives the remap walker two ways
to refer to the same page and unnecessarily complicates its interface.

Use the page list as the single handoff mechanism for the head page,
removing the redundant state from the walker.

No functional change intended.

Link: https://lore.kernel.org/20261104023510.260766-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20261103224659.2865b9ff27d09994949edd78@linux-foundation.org
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 mm/hugetlb_vmemmap.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling
+++ a/mm/hugetlb_vmemmap.c
@@ -25,10 +25,9 @@
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @nr_walked:		the number of walked pte.
- * @vmemmap_head:	the page to be installed as first in the vmemmap range
  * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
- * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
- *			or is mapped from.
+ * @vmemmap_pages:	list supplying replacement pages for the remap and
+ *			receiving displaced backing pages for the caller to free.
  * @flags:		used to modify behavior in vmemmap page table walking
  *			operations.
  */
@@ -37,7 +36,6 @@ struct vmemmap_remap_walk {
 					     struct vmemmap_remap_walk *walk);
 
 	unsigned long		nr_walked;
-	struct page		*vmemmap_head;
 	struct page		*vmemmap_tail;
 	struct list_head	*vmemmap_pages;
 
@@ -208,10 +206,13 @@ static void vmemmap_remap_pte(pte_t *pte
 	pte_t entry;
 
 	/* Remapping the head page requires r/w */
-	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
+	if (unlikely(walk->nr_walked == 0)) {
+		struct page *head;
+
 		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
 
-		list_del(&walk->vmemmap_head->lru);
+		head = list_first_entry(walk->vmemmap_pages, struct page, lru);
+		list_del(&head->lru);
 
 		/*
 		 * Makes sure that preceding stores to the page contents from
@@ -220,7 +221,7 @@ static void vmemmap_remap_pte(pte_t *pte
 		 */
 		smp_wmb();
 
-		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
+		entry = mk_pte(head, PAGE_KERNEL);
 	} else {
 		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
 
@@ -284,23 +285,20 @@ static int vmemmap_remap_split(unsigned
 }
 
 /**
- * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
- *			to use @vmemmap_head/tail, then free vmemmap which
- *			the range are mapped to.
+ * vmemmap_remap_free - remap a vmemmap range and collect old backing pages
  * @start:	start address of the vmemmap virtual address range that we want
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @vmemmap_head: the page to be installed as first in the vmemmap range
  * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
- * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
- *		responsibility to free pages.
+ * @vmemmap_pages: input/output list whose first entry supplies the new backing
+ *		page for @start; replaced backing pages are added to the list for
+ *		the caller to free.
  * @flags:	modifications to vmemmap_remap_walk flags
  *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      struct page *vmemmap_head,
 			      struct page *vmemmap_tail,
 			      struct list_head *vmemmap_pages,
 			      unsigned long flags)
@@ -308,7 +306,6 @@ static int vmemmap_remap_free(unsigned l
 	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_remap_pte,
-		.vmemmap_head	= vmemmap_head,
 		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
@@ -549,8 +546,7 @@ static int __hugetlb_vmemmap_optimize_fo
 	 * they can be freed by the caller.
 	 */
 	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
-				 vmemmap_head, vmemmap_tail,
-				 vmemmap_pages, flags);
+				 vmemmap_tail, vmemmap_pages, flags);
 out:
 	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch
mm-sparse-vmemmap-map-shared-vmemmap-tail-pages-as-read-only.patch
powerpc-mm-map-shared-vmemmap-tail-pages-as-read-only.patch
mm-hugetlb_vmemmap-remove-vmemmap_wrprotect_hvo.patch
mm-hugetlb_vmemmap-remove-hugetlb_vmemmap_optimize_bootmem_folios.patch
mm-generalize-kernel-pte-table-allocation.patch
mm-generalize-pmd-page-table-allocation.patch
mm-generalize-pud-page-table-allocation.patch
mm-remove-pagetable_dtor_free.patch
mm-remove-redundant-pagetable_dtor-calls.patch
mm-hugetlb_vmemmap-generalize-vmemmap-page-allocation.patch
mm-hugetlb_vmemmap-unify-writable-vmemmap-page-preparation.patch
mm-hugetlb_vmemmap-rename-vmemmap_remap_pte-to-vmemmap_optimize_pte.patch
mm-hugetlb_vmemmap-simplify-shared-tail-page-handling.patch
mm-hugetlb_vmemmap-move-alloc_vmemmap_page_list-next-to-its-free-helper.patch
mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch
mm-hugetlb_vmemmap-make-vmemmap-restoration-folio-oriented.patch
mm-hugetlb_vmemmap-unify-vmemmap-range-restoration.patch
mm-hugetlb_vmemmap-make-vmemmap-pte-conversion-folio-oriented.patch
mm-hugetlb-fix-validation-of-unsupported-hugetlb-orders.patch

