Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EB723A98E
	for <mm-commits@vger.kernel.org>; Fri, 17 Oct 2025 21:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760735440; cv=none; b=Zn9BrBh6Baz8DhQxJpCjzKEXJrnzMOpdt5g221t9J+C63ye4/kdyIEJ99YrOQJIhCOZRnShxuO7tgmFZ49lJ3WyArAAweZSymolClBWAFYjRVads4w8UmDy2GmDUioYGCqm86eyreBdGAqloDObuTrcLOyjcdZudiwrLuWeh8lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760735440; c=relaxed/simple;
	bh=mx49M3X17dtjD7LymMNRCZrwqBjO/RKjTAHuhXTYCzY=;
	h=Date:To:From:Subject:Message-Id; b=pIqSEwofNABX1kPrVyHRmhBjNGMSjNwc18e7j5GnMEtFUuAQ5vEb5ye+KHwaAeJLTNGFpcpbgdsfjm7v3KYWuyFslzBXmFBtEDVZ7HwOcKNAufAdimRQdM+yitafTvqO1lMdbsXrtUCBD3zNFA3GZkjMjZbcfZMWsf4zyJ/Vlgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l0xruBNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l0xruBNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FB7C4CEE7;
	Fri, 17 Oct 2025 21:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760735440;
	bh=mx49M3X17dtjD7LymMNRCZrwqBjO/RKjTAHuhXTYCzY=;
	h=Date:To:From:Subject:From;
	b=l0xruBNeyaC2+7G5po7dPbR/oDXpebGS6V31Ze4AIWWay9gZrWf6dawSSvcIwQdoO
	 lHNt57VqAYqQsXK9qd2kR+fG1Qj02iqWjEcRTK/7jFav18mKzKO59GJeBQa4PuWVo3
	 v9hLyawSvyDMCPQp2Z7j6o398TYhL3Bglc919mB8=
Date: Fri, 17 Oct 2025 14:10:39 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,david@redhat.com,craftfever@airmail.cc,chengming.zhou@linux.dev,pedrodemargomes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item.patch removed from -mm tree
Message-Id: <20251017211040.55FB7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
has been removed from the -mm tree.  Its filename was
     ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: ksm: use range-walk function to jump over holes in scan_get_next_rmap_item
Date: Wed, 15 Oct 2025 22:22:36 -0300

Currently, scan_get_next_rmap_item() walks every page address in a VMA to
locate mergeable pages.  This becomes highly inefficient when scanning
large virtual memory areas that contain mostly unmapped regions.

This patch replaces the per-address lookup with a range walk using
walk_page_range().  The range walker allows KSM to skip over entire
unmapped holes in a VMA, avoiding unnecessary lookups.  This problem was
previously discussed in [1].

[1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/

Link: https://lkml.kernel.org/r/20251016012236.4189-1-pedrodemargomes@gmail.com
Link: https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/ [1]
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Reported-by: craftfever <craftfever@airmail.cc>
Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |  185 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 135 insertions(+), 50 deletions(-)

--- a/mm/ksm.c~ksm-use-range-walk-function-to-jump-over-holes-in-scan_get_next_rmap_item
+++ a/mm/ksm.c
@@ -2455,14 +2455,119 @@ static bool should_skip_rmap_item(struct
 	return true;
 }
 
+struct ksm_walk_private {
+	struct page *page;
+	struct folio *folio;
+	struct vm_area_struct *vma;
+	unsigned long address;
+};
+
+static int ksm_walk_test(unsigned long addr, unsigned long next, struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+	struct ksm_walk_private *private;
+
+	if (!(vma->vm_flags & VM_MERGEABLE))
+		return 1;
+
+	private = (struct ksm_walk_private *) walk->private;
+	private->address = vma->vm_end;
+
+	if (!vma->anon_vma)
+		return 1;
+
+	return 0;
+}
+
+static int ksm_pmd_entry(pmd_t *pmd, unsigned long addr,
+			    unsigned long end, struct mm_walk *walk)
+{
+	struct mm_struct *mm = walk->mm;
+	struct vm_area_struct *vma = walk->vma;
+	struct ksm_walk_private *private = (struct ksm_walk_private *) walk->private;
+	struct folio *folio;
+	pte_t *start_pte, *pte, ptent;
+	pmd_t pmde;
+	struct page *page;
+	spinlock_t *ptl;
+	int ret = 0;
+
+	if (ksm_test_exit(mm))
+		return 1;
+
+	ptl = pmd_lock(mm, pmd);
+	pmde = pmdp_get(pmd);
+
+	if (!pmd_present(pmde))
+		goto pmd_out;
+
+	if (!pmd_trans_huge(pmde))
+		goto pte_table;
+
+	page = vm_normal_page_pmd(vma, addr, pmde);
+
+	if (!page)
+		goto pmd_out;
+
+	folio = page_folio(page);
+	if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+		goto pmd_out;
+
+	ret = 1;
+	folio_get(folio);
+	private->page = page + ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
+	private->folio = folio;
+	private->vma = vma;
+	private->address = addr;
+pmd_out:
+	spin_unlock(ptl);
+	return ret;
+
+pte_table:
+	spin_unlock(ptl);
+
+	start_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!start_pte)
+		return 0;
+
+	for (; addr < end; pte++, addr += PAGE_SIZE) {
+		ptent = ptep_get(pte);
+		page = vm_normal_page(vma, addr, ptent);
+
+		if (!page)
+			continue;
+
+		folio = page_folio(page);
+		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+			continue;
+
+		ret = 1;
+		folio_get(folio);
+		private->page = page;
+		private->folio = folio;
+		private->vma = vma;
+		private->address = addr;
+		break;
+	}
+	pte_unmap_unlock(start_pte, ptl);
+
+	cond_resched();
+	return ret;
+}
+
+struct mm_walk_ops walk_ops = {
+	.pmd_entry = ksm_pmd_entry,
+	.test_walk = ksm_walk_test,
+	.walk_lock = PGWALK_RDLOCK,
+};
+
 static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 {
 	struct mm_struct *mm;
 	struct ksm_mm_slot *mm_slot;
 	struct mm_slot *slot;
-	struct vm_area_struct *vma;
 	struct ksm_rmap_item *rmap_item;
-	struct vma_iterator vmi;
+	struct ksm_walk_private walk_private;
 	int nid;
 
 	if (list_empty(&ksm_mm_head.slot.mm_node))
@@ -2527,64 +2632,44 @@ next_mm:
 
 	slot = &mm_slot->slot;
 	mm = slot->mm;
-	vma_iter_init(&vmi, mm, ksm_scan.address);
 
 	mmap_read_lock(mm);
 	if (ksm_test_exit(mm))
 		goto no_vmas;
 
-	for_each_vma(vmi, vma) {
-		if (!(vma->vm_flags & VM_MERGEABLE))
-			continue;
-		if (ksm_scan.address < vma->vm_start)
-			ksm_scan.address = vma->vm_start;
-		if (!vma->anon_vma)
-			ksm_scan.address = vma->vm_end;
-
-		while (ksm_scan.address < vma->vm_end) {
-			struct page *tmp_page = NULL;
-			struct folio_walk fw;
-			struct folio *folio;
+	while (true) {
+		struct folio *folio;
 
-			if (ksm_test_exit(mm))
-				break;
+		walk_private.page = NULL;
+		walk_private.folio = NULL;
+		walk_private.address = ksm_scan.address;
+
+		walk_page_range(mm, ksm_scan.address, -1, &walk_ops, (void *) &walk_private);
+		ksm_scan.address = walk_private.address;
+		if (!walk_private.page)
+			break;
+
+		folio = walk_private.folio;
+		flush_anon_page(walk_private.vma, walk_private.page, ksm_scan.address);
+		flush_dcache_page(walk_private.page);
+		rmap_item = get_next_rmap_item(mm_slot,
+			ksm_scan.rmap_list, ksm_scan.address);
+		if (rmap_item) {
+			ksm_scan.rmap_list =
+					&rmap_item->rmap_list;
 
-			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
-			if (folio) {
-				if (!folio_is_zone_device(folio) &&
-				     folio_test_anon(folio)) {
-					folio_get(folio);
-					tmp_page = fw.page;
-				}
-				folio_walk_end(&fw, vma);
+			ksm_scan.address += PAGE_SIZE;
+			if (should_skip_rmap_item(folio, rmap_item)) {
+				folio_put(folio);
+				continue;
 			}
 
-			if (tmp_page) {
-				flush_anon_page(vma, tmp_page, ksm_scan.address);
-				flush_dcache_page(tmp_page);
-				rmap_item = get_next_rmap_item(mm_slot,
-					ksm_scan.rmap_list, ksm_scan.address);
-				if (rmap_item) {
-					ksm_scan.rmap_list =
-							&rmap_item->rmap_list;
-
-					if (should_skip_rmap_item(folio, rmap_item)) {
-						folio_put(folio);
-						goto next_page;
-					}
-
-					ksm_scan.address += PAGE_SIZE;
-					*page = tmp_page;
-				} else {
-					folio_put(folio);
-				}
-				mmap_read_unlock(mm);
-				return rmap_item;
-			}
-next_page:
-			ksm_scan.address += PAGE_SIZE;
-			cond_resched();
+			*page = walk_private.page;
+		} else {
+			folio_put(folio);
 		}
+		mmap_read_unlock(mm);
+		return rmap_item;
 	}
 
 	if (ksm_test_exit(mm)) {
_

Patches currently in -mm which might be from pedrodemargomes@gmail.com are


