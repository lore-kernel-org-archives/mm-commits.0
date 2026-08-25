Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A78349CC4
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622935; cv=none; b=PPnk8+HzATg0tKLEeOFBtvo8XEjBypuiaU70JWiF52A3MbJWXAHgW8yFep1uuevv3fMBhgzoTjtTa+tUWih61NVmZi5q6CaIVUdM3AZWxOSBYe0wNrgWL91u0M5VyBlFyftabv8KymjAOyvPv7JoQf/Suv5mOvdHcCVfSA2PnnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622935; c=relaxed/simple;
	bh=69oSuBQDvamvPSRda2yVXilMLG0+kHNbbYAVybxZ2zc=;
	h=Date:To:From:Subject:Message-Id; b=fbtXUcXn94RTqWSMQwPGgXNj44BMosO1fk4sHTtrmRmFhDdmxG/buDQiKZT+VkA8FYji88d9i+JwnQInDQMxzvF/fsL2m7Gs4yufIhj+rKTUtaZ3JKGKBqGfmC/DgezpilCn8l64JrRCwBQOjmta9DyIJJ5VHwBZf4gyC/2mQUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LQD/oyo0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LQD/oyo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A221F000E9;
	Tue, 25 Aug 2026 01:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622934;
	bh=Bow7HGSSge/AHGuLEvZdPAb3atMR1ApBqzAer08lSCY=;
	h=Date:To:From:Subject;
	b=LQD/oyo0EwgXrsD2dCr/3LZS64fXaxtv2BnMJwOmQYW5m45a8VBh6roQDEsUNVpnZ
	 hOfz2YhyGjTZ9S3l6TatSKGHaPRsMyXh4re8wKizQE0UVXtFoWd/DbOEBDw2IpVwSY
	 wSJQJ7G1wAwCH9HhtP6kCGukoKdFAp/UNTRpx3BE=
Date: Mon, 24 Aug 2026 18:55:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-fix-outdated-comments.patch removed from -mm tree
Message-Id: <20260825015534.41A221F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: fix outdated comments
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-outdated-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: mm/khugepaged: fix outdated comments
Date: Tue, 11 Aug 2026 06:48:36 -0600

Fix comment in collapse_scan_pmd() that still described the old
folio_mapcount() > folio_ref_count() check and a "512" false-positive
scenario.  The code now uses folio_expected_ref_count() !=
folio_ref_count() which doesn't suffer from the same limitation.

Fix comment in collapse_huge_page() that referenced ptep_clear_flush, when
the code actually uses pmdp_collapse_flush.

Fix comment in __collapse_huge_page_swapin() that referenced the old
function name khugepaged_scan_pmd, now collapse_scan_pmd.

Also clean up some simple typos and stale terminology (mmap_sem ->
mmap_lock, PG_lock -> folio lock, page -> folio, grammar).

We also clarify a comment regarding where the max_ptes_none check is
deferred to in mthp_collapse() from the original collapse_scan_pmd check.

Update all comments that references a function to include parentheses.

[nico.pache@linux.dev: fix outdated comments]
  Link: https://lore.kernel.org/1c96e2f3-802f-472b-81e6-4af17a721a3c@linux.dev
Link: https://lore.kernel.org/20260811-khugepaged_pte_refactor-v4-4-ddac39d61c4a@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Assisted-by: Cursor(claude-sonnet-4):4.6
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-outdated-comments
+++ a/mm/khugepaged.c
@@ -620,7 +620,7 @@ void __khugepaged_exit(struct mm_struct
 		/*
 		 * This is required to serialize against
 		 * collapse_test_exit() (which is guaranteed to run
-		 * under mmap sem read mode). Stop here (after we return all
+		 * under mmap_lock read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
 		 */
@@ -782,8 +782,8 @@ static enum scan_result __collapse_huge_
 
 		/*
 		 * We can do it before folio_isolate_lru because the
-		 * folio can't be freed from under us. NOTE: PG_lock
-		 * is needed to serialize against split_huge_page
+		 * folio can't be freed from under us. NOTE: folio lock
+		 * is needed to serialize against split_huge_page()
 		 * when invoked from the VM.
 		 */
 		if (!folio_trylock(folio)) {
@@ -809,7 +809,7 @@ static enum scan_result __collapse_huge_
 		}
 
 		/*
-		 * Isolate the page to avoid collapsing an hugepage
+		 * Isolate the folio to avoid collapsing a hugepage
 		 * currently in use by the VM.
 		 */
 		if (!folio_isolate_lru(folio)) {
@@ -921,7 +921,7 @@ static void __collapse_huge_page_copy_fa
 	 * Re-establish the PMD to point to the original page table
 	 * entry. Restoring PMD needs to be done prior to releasing
 	 * pages. Since pages are still isolated and locked here,
-	 * acquiring anon_vma_lock_write is unnecessary.
+	 * acquiring anon_vma_lock_write() is unnecessary.
 	 */
 	pmd_ptl = pmd_lock(vma->vm_mm, pmd);
 	pmd_populate(vma->vm_mm, pmd, pmd_pgtable(orig_pmd));
@@ -1095,9 +1095,9 @@ static enum scan_result hugepage_vma_rev
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
-	 * remapped to file after khugepaged reaquired the mmap_lock.
+	 * remapped to file after khugepaged reacquired the mmap_lock.
 	 *
-	 * thp_vma_allowable_orders may return true for qualified file
+	 * thp_vma_allowable_orders() may return true for qualified file
 	 * vmas.
 	 */
 	if (expect_anon && (!(*vmap)->anon_vma || !vma_is_anonymous(*vmap)))
@@ -1153,7 +1153,7 @@ static enum scan_result check_pmd_still_
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if khugepaged_scan_pmd believes it is worthwhile.
+ * Only done if collapse_scan_pmd() believes it is worthwhile.
  *
  * For mTHP orders the function bails on the first swap entry, because
  * faulting pages back in during collapse could re-populate PTEs that
@@ -1221,7 +1221,7 @@ static enum scan_result __collapse_huge_
 		pte = NULL;
 
 		/*
-		 * do_swap_page returns VM_FAULT_RETRY with released mmap_lock.
+		 * do_swap_page() returns VM_FAULT_RETRY with released mmap_lock.
 		 * Note we treat VM_FAULT_RETRY as VM_FAULT_ERROR here because
 		 * we do not retry here and swap entry will remain in pagetable
 		 * resulting in later failure.
@@ -1285,7 +1285,7 @@ static enum scan_result alloc_charge_fol
 }
 
 /*
- * collapse_huge_page expects the mmap_lock to be unlocked before entering and
+ * collapse_huge_page() expects the mmap_lock to be unlocked before entering and
  * will always return with the lock unlocked, to avoid holding the mmap_lock
  * while allocating a THP, as that could trigger direct reclaim/compaction.
  * Note that the VMA must be rechecked after grabbing the mmap_lock again.
@@ -1332,7 +1332,7 @@ static enum scan_result collapse_huge_pa
 
 	if (unmapped) {
 		/*
-		 * __collapse_huge_page_swapin will return with mmap_lock
+		 * __collapse_huge_page_swapin() will return with mmap_lock
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
@@ -1345,8 +1345,8 @@ static enum scan_result collapse_huge_pa
 	mmap_read_unlock(mm);
 	/*
 	 * Prevent all access to pagetables with the exception of
-	 * gup_fast later handled by the ptep_clear_flush and the VM
-	 * handled by the anon_vma lock + PG_lock.
+	 * gup_fast later handled by the pmdp_collapse_flush() and the VM
+	 * handled by the anon_vma lock + folio lock.
 	 *
 	 * UFFDIO_MOVE is prevented to race as well thanks to the
 	 * mmap_lock.
@@ -1403,9 +1403,9 @@ static enum scan_result collapse_huge_pa
 		spin_lock(pmd_ptl);
 		VM_WARN_ON_ONCE(!pmd_none(*pmd));
 		/*
-		 * We can only use set_pmd_at when establishing
+		 * We can only use set_pmd_at() when establishing
 		 * hugepmds and never for establishing regular pmds that
-		 * points to regular pagetables. Use pmd_populate for that
+		 * points to regular pagetables. Use pmd_populate() for that
 		 */
 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		spin_unlock(pmd_ptl);
@@ -1637,7 +1637,8 @@ static enum scan_result collapse_scan_pm
 
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
-	 * scan all pages to populate the bitmap for mTHP collapse.
+	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
+	 * is then checked again in mthp_collapse() for each attempted order.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
 		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
@@ -1758,12 +1759,9 @@ static enum scan_result collapse_scan_pm
 		/*
 		 * Check if the page has any GUP (or other external) pins.
 		 *
-		 * Here the check may be racy:
-		 * it may see folio_mapcount() > folio_ref_count().
-		 * But such case is ephemeral we could always retry collapse
-		 * later.  However it may report false positive if the page
-		 * has excessive GUP pins (i.e. 512).  Anyway the same check
-		 * will be done again later the risk seems low.
+		 * Here the check is racy, but such cases are ephemeral and
+		 * we can always retry collapse later. Anyway the same
+		 * check will be done again later, so the risk seems to be low.
 		 */
 		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
@@ -1784,7 +1782,7 @@ static enum scan_result collapse_scan_pm
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		/* collapse_huge_page expects the lock to be dropped before calling */
+		/* collapse_huge_page() expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
 		result = mthp_collapse(mm, start_addr, referenced,
 				       unmapped, cc, enabled_orders);
_

Patches currently in -mm which might be from nico.pache@linux.dev are


