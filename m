Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794023632;
	b=VvT9ql6t20nLuP1l89PlVUvgAWm2HumL2hPuXW0uuJkz8Jdgl98iGxzEamT0iHuaV3/2
	 mxQ5lZRjZPji4AC2Z9gswmJFKz0fLhL6IsMDHoiF0U3KuKZbs7x+xAJSo3LD/LRg8K/ZO
	 dGDof6vr+xRcZNoPONyVla/9wMIUg0TH5/W4fWNmyksqOWfXPuraNeciIKRXLDsbGc94t
	 e7sn7a6B/KPuokSW6OARbCu0fteUOY7LL+3fna+2TfPumXtIw3aBic2YMEP48X22JlBd3
	 zIaTJF1GDIkWyZtj+ekg5IO6k/TubPyj1rDLXHEaOPMIIBXi6eeFCG2ZknmMxnHJvUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794023632;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=EiQvWzftrHSbX2N1NPNO30E03Rd0E63iQCFzzWY/83E=;
	b=bZxHFbS3kyWkGw63JllaEbWsIV1K6mjszgxNHPlQPP37QF0dwsM4qlduDS5EhMDbh8n3
	 SwhcDvrIU4wN2dKufUMfcsLXc9Ydoriwsz8nvbmZqVfUXI6PTGqH9Eaft9Eiz2t/+G7nV
	 m9q1rhYPTi+h1IthvQ92N5ICJCyXYAFWJE60WZ/nuKlWrCoGHfZSbfx46mSjoyk6ypnLq
	 yaD5Laaz12b8oBC6G421mw8zz6Wj+MebP3yffR4KIzvnvLkwyz/XdAL5K+cdMh+09gKFn
	 OH6EtsAwKzGhkgYxVwGWZkwoHkYmsqTtHWT++CwqHfP631tjlYOQVSNinBEpGDAz0oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ktinXpN2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9074D606A336
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 03:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ktinXpN2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1D71F008A2;
	Sat,  7 Nov 2026 03:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023632;
	bh=EiQvWzftrHSbX2N1NPNO30E03Rd0E63iQCFzzWY/83E=;
	h=Date:To:From:Subject;
	b=ktinXpN2xAzb5Ta9YhWxqTIq8VARqcjCKmzSsXKu5V/7snClI3ll8FSscV3Rznu1t
	 QONKUhwyzQRi4DD0Xk3vnPzKMrlfs6AxsUZE6D8aBcLl5PXA9I3+GESJ0Buks3QTHg
	 hIIMqaF4mG6dCivL+rVi2GJo9voNdCDdb4+w4U1Y=
Date: Fri, 06 Nov 2026 19:53:51 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch added to mm-unstable branch
Message-Id: <20261107035352.5A1D71F008A2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: hugetlb_vmemmap: make vmemmap optimization folio-oriented
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm: hugetlb_vmemmap: make vmemmap optimization folio-oriented
Date: Sat, 07 Nov 2026 10:27:53 +0800

Vmemmap optimization operates on one folio at a time, but the current
interface exposes a raw address range and requires the HugeTLB caller to
prepare part of the operation.  This splits the common mechanism across
layers and obscures its natural unit of work.

Make the folio the unit of vmemmap optimization and move the common
mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
eligibility and state in the caller while making the remapping code
applicable to any eligible folio.

No functional change intended.

Link: https://lore.kernel.org/20261107022756.77731-11-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Yili Zhang <zhangyili01@baidu.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
---

 mm/hugetlb_vmemmap.c |   68 +++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 35 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-make-vmemmap-optimization-folio-oriented
+++ a/mm/hugetlb_vmemmap.c
@@ -233,6 +233,11 @@ static struct page *vmemmap_dup_page_fro
 	return dst;
 }
 
+static inline unsigned long folio_vmemmap_size(const struct folio *folio)
+{
+	return folio_nr_pages(folio) * sizeof(struct page);
+}
+
 static inline struct page *folio_vmemmap_shared_tail_page(const struct folio *folio)
 {
 	return vmemmap_shared_tail_page(folio_order(folio), folio_zone(folio));
@@ -302,28 +307,42 @@ static int vmemmap_remap_split(unsigned
 }
 
 /**
- * vmemmap_remap_free - remap a vmemmap range and collect old backing pages
- * @start:	start address of the vmemmap virtual address range that we want
- *		to remap.
- * @end:	end address of the vmemmap virtual address range that we want to
- *		remap.
- * @vmemmap_pages: input/output list whose first entry supplies the new backing
- *		page for @start; replaced backing pages are added to the list for
- *		the caller to free.
- * @flags:	modifications to vmemmap_remap_walk flags
+ * vmemmap_optimize_folio - optimize the vmemmap backing of a folio
+ * @folio:	folio whose vmemmap pages should be optimized.
+ * @vmemmap_pages: list holding replacement pages for the remap and displaced
+ *		backing pages for the caller to free.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Remap @folio's vmemmap so optimizable entries point at the shared tail page
+ * while non-optimizable entries are copied into replacement pages. Caller is
+ * responsible for freeing the pages left on the @vmemmap_pages list, even on
+ * failure.
  *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_free(unsigned long start, unsigned long end,
+static int vmemmap_optimize_folio(const struct folio *folio,
 		struct list_head *vmemmap_pages, unsigned long flags)
 {
-	int ret;
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN;
+	int ret, nid = folio_nid(folio);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_optimize_pte,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
 	};
 
+	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
+
+	if (!vmemmap_optimizable_order(folio_order(folio)))
+		return -EOPNOTSUPP;
+
+	ret = alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES,
+				      nid, gfp_mask);
+	if (ret)
+		return ret;
+
 	ret = vmemmap_remap_range(start, end, &walk);
 	if (!ret || !walk.nr_walked)
 		return ret;
@@ -490,17 +509,12 @@ static int __hugetlb_vmemmap_optimize_fo
 					    struct list_head *vmemmap_pages,
 					    unsigned long flags)
 {
-	unsigned long vmemmap_start, vmemmap_end;
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN;
-	int nid, ret = 0;
+	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
 
 	if (!vmemmap_should_optimize_folio(h, folio))
-		return ret;
-
-	nid = folio_nid(folio);
+		return 0;
 
 	/*
 	 * Very Subtle
@@ -514,23 +528,7 @@ static int __hugetlb_vmemmap_optimize_fo
 	 * the TLB and clear the flag below.
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
-
-	ret = alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES,
-				      nid, gfp_mask);
-	if (ret)
-		goto out;
-
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	/*
-	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end).
-	 * Add pages previously mapping the range to vmemmap_pages list so that
-	 * they can be freed by the caller.
-	 */
-	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
-				 vmemmap_pages, flags);
-out:
+	ret = vmemmap_optimize_folio(folio, vmemmap_pages, flags);
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
mm-hugetlb_vmemmap-remove-hugetlb-specific-vmemmap-optimization-macros.patch
mm-hugetlb_vmemmap-unify-vmemmap_splitremap_no_tlb_flush.patch
mm-hugetlb_vmemmap-simplify-vmemmap-head-page-handling.patch
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

