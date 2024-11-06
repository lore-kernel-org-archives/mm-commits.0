Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F533185B5B
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854793; cv=none; b=ix9qm3PxdB4AvQDnhAHceeOzuVxWm/u3iROqjVUG/UyrkjUeRRP0S68Ykzh4tyh9trdM/5pVr87H2UZpC5nFU3TicyWdD2phlJhcHKEY8YitOENjVYojtPJTtK4eT2ZOzNS1wCLM/fR0iMyCtbzmEb0UwW5HQMMO1QbO277/qy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854793; c=relaxed/simple;
	bh=JA16OsvbZK61b8iov+N+GzzABIoQTE8Ja11ePrqakxY=;
	h=Date:To:From:Subject:Message-Id; b=R4IgllprqNa8mhCF7N0RPFO8h2kM5ZdDd81JUaw1RZMUofeeDEgyFfWEEawTFnskN/WbOeYWTu9CO+aW7vUtglQYMAr5iHKrIFoUOC9STWfr2lNMQzDV721kUO/ZGn1xfrqgP61hTxQGrVGY3ODUs2XuIH+0sEHtFmvNHePAunQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CZH1wEXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CZH1wEXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E5FC4CECF;
	Wed,  6 Nov 2024 00:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854793;
	bh=JA16OsvbZK61b8iov+N+GzzABIoQTE8Ja11ePrqakxY=;
	h=Date:To:From:Subject:From;
	b=CZH1wEXtfX2pHqCXrsNYDsuLyTO3sXRGaW2c15gRh8qfoEJKVMqVQYrCQ9i+CMI+6
	 /VlN4i/Vz2R+RhcaMcAa3g8KmMFTOi7QumBQshDzgwracPmB8diPgYDdVMHdtpXGjq
	 JLL4gYAJadPZrWL7Pn6SuprNI/0caXFT6yZobnAw=
Date: Tue, 05 Nov 2024 16:59:52 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unused-hugepage-for-vma_alloc_folio.patch removed from -mm tree
Message-Id: <20241106005953.46E5FC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unused hugepage for vma_alloc_folio()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-hugepage-for-vma_alloc_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove unused hugepage for vma_alloc_folio()
Date: Thu, 10 Oct 2024 14:15:56 +0800

The hugepage parameter was deprecated since commit ddc1a5cbc05d
("mempolicy: alloc_pages_mpol() for NUMA policy without vma"), for
PMD-sized THP, it still tries only preferred node if possible in
vma_alloc_folio() by checking the order of the folio allocation.

Link: https://lkml.kernel.org/r/20241010061556.1846751-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/page.h   |    2 +-
 arch/arm64/mm/fault.c           |    2 +-
 arch/m68k/include/asm/page_no.h |    2 +-
 arch/s390/include/asm/page.h    |    2 +-
 arch/x86/include/asm/page.h     |    2 +-
 include/linux/gfp.h             |    6 +++---
 include/linux/highmem.h         |    2 +-
 mm/huge_memory.c                |    2 +-
 mm/ksm.c                        |    2 +-
 mm/memory.c                     |   10 ++++------
 mm/mempolicy.c                  |    3 +--
 mm/userfaultfd.c                |    2 +-
 12 files changed, 17 insertions(+), 20 deletions(-)

--- a/arch/alpha/include/asm/page.h~mm-remove-unused-hugepage-for-vma_alloc_folio
+++ a/arch/alpha/include/asm/page.h
@@ -18,7 +18,7 @@ extern void clear_page(void *page);
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr, false)
+	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
 
 extern void copy_page(void * _to, void * _from);
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
--- a/arch/arm64/mm/fault.c~mm-remove-unused-hugepage-for-vma_alloc_folio
+++ a/arch/arm64/mm/fault.c
@@ -983,7 +983,7 @@ struct folio *vma_alloc_zeroed_movable_f
 	if (vma->vm_flags & VM_MTE)
 		flags |= __GFP_ZEROTAGS;
 
-	return vma_alloc_folio(flags, 0, vma, vaddr, false);
+	return vma_alloc_folio(flags, 0, vma, vaddr);
 }
 
 void tag_clear_highpage(struct page *page)
--- a/arch/m68k/include/asm/page_no.h~mm-remove-unused-hugepage-for-vma_alloc_folio
+++ a/arch/m68k/include/asm/page_no.h
@@ -14,7 +14,7 @@ extern unsigned long memory_end;
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr, false)
+	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
 
 #define __pa(vaddr)		((unsigned long)(vaddr))
 #define __va(paddr)		((void *)((unsigned long)(paddr)))
--- a/arch/s390/include/asm/page.h~mm-remove-unused-hugepage-for-vma_alloc_folio
+++ a/arch/s390/include/asm/page.h
@@ -74,7 +74,7 @@ static inline void copy_page(void *to, v
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr, false)
+	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
 
 /*
  * These are used to make use of C type-checking..
--- a/arch/x86/include/asm/page.h~mm-remove-unused-hugepage-for-vma_alloc_folio
+++ a/arch/x86/include/asm/page.h
@@ -35,7 +35,7 @@ static inline void copy_user_page(void *
 }
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr, false)
+	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
 
 #ifndef __pa
 #define __pa(x)		__phys_addr((unsigned long)(x))
--- a/include/linux/gfp.h~mm-remove-unused-hugepage-for-vma_alloc_folio
+++ a/include/linux/gfp.h
@@ -306,7 +306,7 @@ struct folio *folio_alloc_noprof(gfp_t g
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *mpol, pgoff_t ilx, int nid);
 struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr, bool hugepage);
+		unsigned long addr);
 #else
 static inline struct page *alloc_pages_noprof(gfp_t gfp_mask, unsigned int order)
 {
@@ -326,7 +326,7 @@ static inline struct folio *folio_alloc_
 {
 	return folio_alloc_noprof(gfp, order);
 }
-#define vma_alloc_folio_noprof(gfp, order, vma, addr, hugepage)		\
+#define vma_alloc_folio_noprof(gfp, order, vma, addr)		\
 	folio_alloc_noprof(gfp, order)
 #endif
 
@@ -341,7 +341,7 @@ static inline struct folio *folio_alloc_
 static inline struct page *alloc_page_vma_noprof(gfp_t gfp,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct folio *folio = vma_alloc_folio_noprof(gfp, 0, vma, addr, false);
+	struct folio *folio = vma_alloc_folio_noprof(gfp, 0, vma, addr);
 
 	return &folio->page;
 }
--- a/include/linux/highmem.h~mm-remove-unused-hugepage-for-vma_alloc_folio
+++ a/include/linux/highmem.h
@@ -226,7 +226,7 @@ struct folio *vma_alloc_zeroed_movable_f
 {
 	struct folio *folio;
 
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr, false);
+	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
 	if (folio)
 		clear_user_highpage(&folio->page, vaddr);
 
--- a/mm/huge_memory.c~mm-remove-unused-hugepage-for-vma_alloc_folio
+++ a/mm/huge_memory.c
@@ -1146,7 +1146,7 @@ static struct folio *vma_alloc_anon_foli
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
-	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK, true);
+	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
 
 	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
--- a/mm/ksm.c~mm-remove-unused-hugepage-for-vma_alloc_folio
+++ a/mm/ksm.c
@@ -2971,7 +2971,7 @@ struct folio *ksm_might_need_to_copy(str
 	if (!folio_test_uptodate(folio))
 		return folio;		/* let do_swap_page report the error */
 
-	new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr, false);
+	new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr);
 	if (new_folio &&
 	    mem_cgroup_charge(new_folio, vma->vm_mm, GFP_KERNEL)) {
 		folio_put(new_folio);
--- a/mm/memory.c~mm-remove-unused-hugepage-for-vma_alloc_folio
+++ a/mm/memory.c
@@ -1059,8 +1059,7 @@ static inline struct folio *folio_preall
 	if (need_zero)
 		new_folio = vma_alloc_zeroed_movable_folio(vma, addr);
 	else
-		new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
-					    addr, false);
+		new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr);
 
 	if (!new_folio)
 		return NULL;
@@ -4017,8 +4016,7 @@ static struct folio *__alloc_swap_folio(
 	struct folio *folio;
 	swp_entry_t entry;
 
-	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma,
-				vmf->address, false);
+	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vmf->address);
 	if (!folio)
 		return NULL;
 
@@ -4174,7 +4172,7 @@ static struct folio *alloc_swap_folio(st
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr, true);
+		folio = vma_alloc_folio(gfp, order, vma, addr);
 		if (folio) {
 			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
 							    gfp, entry))
@@ -4713,7 +4711,7 @@ static struct folio *alloc_anon_folio(st
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr, true);
+		folio = vma_alloc_folio(gfp, order, vma, addr);
 		if (folio) {
 			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
 				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
--- a/mm/mempolicy.c~mm-remove-unused-hugepage-for-vma_alloc_folio
+++ a/mm/mempolicy.c
@@ -2290,7 +2290,6 @@ struct folio *folio_alloc_mpol_noprof(gf
  * @order: Order of the folio.
  * @vma: Pointer to VMA.
  * @addr: Virtual address of the allocation.  Must be inside @vma.
- * @hugepage: Unused (was: For hugepages try only preferred node if possible).
  *
  * Allocate a folio for a specific address in @vma, using the appropriate
  * NUMA policy.  The caller must hold the mmap_lock of the mm_struct of the
@@ -2301,7 +2300,7 @@ struct folio *folio_alloc_mpol_noprof(gf
  * Return: The folio on success or NULL if allocation fails.
  */
 struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr, bool hugepage)
+		unsigned long addr)
 {
 	struct mempolicy *pol;
 	pgoff_t ilx;
--- a/mm/userfaultfd.c~mm-remove-unused-hugepage-for-vma_alloc_folio
+++ a/mm/userfaultfd.c
@@ -251,7 +251,7 @@ static int mfill_atomic_pte_copy(pmd_t *
 	if (!*foliop) {
 		ret = -ENOMEM;
 		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
-					dst_addr, false);
+					dst_addr);
 		if (!folio)
 			goto out;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-use-aligned-address-in-clear_gigantic_page.patch
mm-use-aligned-address-in-copy_user_gigantic_page.patch

