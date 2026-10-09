Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72C940587A
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525453; cv=none; b=s4FGGDHrJVTJN2Z6P3Hun7GShi7SJIMtuyuM/Tx1Ygta0jHKlNwAkOTk9/cW0fqB6x6upXvrf17fqmGr0OVYDs7XNnWDC29DmId+0uuOI+dc1yOk9bIltLlOiJRW0x4pmYbGG9N2XgYrJZ1zY4Raqw7Q8wFFwqMrGtUzhza93p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525453; c=relaxed/simple;
	bh=8Lk0bbqBFkfRSYjvQbx/DoO66pi6QmMFW1P8hi14T5g=;
	h=Date:To:From:Subject:Message-Id; b=eJZDjKsSK8azTrFFGBaucULINArcy20UEpwYUbmwqiWk2M/z5FzaL/EBEFQ99GsdVgMZDEkUAR0Mt1fOZE4Em2/T3+7CgZVHIO9hT9USGuhn3BJeIsA+1gUsEjI6Sd6Zr8K6D5suBGeSxDiZjtwsrpo/EBKIqPzqAZA5kuEnQ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k6BPUz5b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k6BPUz5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0D41F00893;
	Fri,  9 Oct 2026 05:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525451;
	bh=effBMPkr2pkjd6FVZdG3S9RmZ8bYbCJgWOyclE1L0BI=;
	h=Date:To:From:Subject;
	b=k6BPUz5bFD/MWxFyh6J3yLQABLUwhIik4RcoFs9Vauc6UQxxChvvLAtfBGS/v4GQ0
	 04HVl9QRZWQUVIpl1fDi8s5nQJnDzbnHvspto2cNssrmsT52zk7txBoxRhetRtrUlT
	 l6bHFPKJP2z6jSToMmN8yq/xgocvGzYzQQNdWdGQ=
Date: Thu, 08 Oct 2026 22:57:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ljs@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,balbirs@nvidia.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-add-folio_reset_partially_mapped.patch removed from -mm tree
Message-Id: <20261009055731.AB0D41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: add folio_reset_partially_mapped()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-folio_reset_partially_mapped.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/huge_memory: add folio_reset_partially_mapped()
Date: Tue, 8 Sep 2026 14:28:21 +0100

__folio_unqueue_deferred_split() and __folio_freeze_and_split_unmapped()
both clear PG_partially_mapped and take the folio out of
MTHP_STAT_NR_ANON_PARTIALLY_MAPPED with the same five lines.

Move the block into folio_reset_partially_mapped() and call it from both
places.

The helper asserts what both callers rely on: the folio is frozen, so
deferred_split_folio() cannot set the flag again under it, and the folio
is already off the deferred split queue.  The list check sits behind the
flag test because order-1 folios have no _deferred_list.

folio_order() is safe to use at this point in the split process: it still
shows the pre-split order.

Link: https://lore.kernel.org/20260908132821.1517475-1-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Assisted-by: LLM
---

 mm/huge_memory.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-folio_reset_partially_mapped
+++ a/mm/huge_memory.c
@@ -3976,6 +3976,25 @@ static unsigned int folio_cache_ref_coun
 	return folio_nr_pages(folio);
 }
 
+static void folio_reset_partially_mapped(struct folio *folio)
+{
+	/* Folio must be frozen. */
+	VM_WARN_ON_FOLIO(folio_ref_count(folio), folio);
+
+	if (!folio_test_partially_mapped(folio))
+		return;
+
+	/*
+	 * Order-1 folios have no _deferred_list. The flag is only ever set
+	 * on folios that do, so the list can be checked after the flag.
+	 */
+	VM_WARN_ON_FOLIO(!list_empty(&folio->_deferred_list), folio);
+
+	folio_clear_partially_mapped(folio);
+	mod_mthp_stat(folio_order(folio),
+		      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+}
+
 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
 					     struct page *split_at, struct xa_state *xas,
 					     struct address_space *mapping, bool do_lru,
@@ -3984,7 +4003,6 @@ static int __folio_freeze_and_split_unma
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
-	int old_order = folio_order(folio);
 	int ret = 0;
 
 	VM_WARN_ON_ONCE(!mapping && end);
@@ -4002,11 +4020,7 @@ static int __folio_freeze_and_split_unma
 		 * leaves PG_partially_mapped set.
 		 * Clear it here: the flag does not survive the split.
 		 */
-		if (folio_test_partially_mapped(folio)) {
-			folio_clear_partially_mapped(folio);
-			mod_mthp_stat(old_order,
-				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-		}
+		folio_reset_partially_mapped(folio);
 
 		if (mapping) {
 			int nr = folio_nr_pages(folio);
@@ -4520,11 +4534,7 @@ bool __folio_unqueue_deferred_split(stru
 	memcg = folio_memcg(folio);
 	lru = list_lru_lock_irqsave(&deferred_split_lru, nid, &memcg, &flags);
 	if (__list_lru_del(&deferred_split_lru, lru, &folio->_deferred_list, nid)) {
-		if (folio_test_partially_mapped(folio)) {
-			folio_clear_partially_mapped(folio);
-			mod_mthp_stat(folio_order(folio),
-				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-		}
+		folio_reset_partially_mapped(folio);
 		unqueued = true;
 	}
 	list_lru_unlock_irqrestore(lru, &flags);
_

Patches currently in -mm which might be from kas@kernel.org are

selftests-mm-raise-the-khugepaged-test-case-cap.patch
selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch
selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch
selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch
selftests-mm-make-the-swap-cases-swapout-reliable.patch
selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch
selftests-mm-move-is_backed_by_folio-into-vm_util.patch
selftests-mm-add-folio-order-check-for-address-ranges.patch
selftests-mm-add-folio-order-detection-self-check.patch
selftests-mm-add-khugepaged-completion-barrier-helper.patch
selftests-mm-add-order-parameterized-khugepaged-collapse-cases.patch
selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch
selftests-mm-cover-a-shared-source-collapse-write-race.patch
selftests-mm-run-every-supported-collapse-order-by-default.patch
selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch
selftests-mm-add-khugepaged-race-harness.patch
selftests-mm-race-the-collapse-of-windows-with-holes.patch
selftests-mm-add-memory-pressure-threads-to-the-khugepaged-race-harness.patch
selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch
mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

