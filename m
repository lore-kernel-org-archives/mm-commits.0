Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439B530C168
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334305; cv=none; b=oBdO/FnT2AqN6EGZkZl1WhgKLIIiN1lExD5qd5iyCt3bddpVWwnBHDL9KT0dk+nURQD2usuovYJeRT0pvm7VkO2Zac+JgQ8RE7u4fiegKoUigSSbQhKOnokOy4OdfT7A9J9LLKHRXjsswaSiTe2kKMFPelLhNkwf/rh4eS4yTO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334305; c=relaxed/simple;
	bh=bY8HHw4s2s679gnsOxyYwntiniBVGo3UyNZ5o93TtEc=;
	h=Date:To:From:Subject:Message-Id; b=jd7L8gmrSCQBaLnNOfHZxD7KMT5WYONKgHIYYpQCzgQOwN0ys554mTTPJMhq02Sz+rEYqKc0j35Ic4EJxfzE71+ytfxf7dCRd7C8SVt9NjhYF1thMvA1w+vn3Jcb7YkAM1noRU48KDM+HHeyDyQPdvj5+gSfeBaSEF3E3Q2zbh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RtyKodmd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RtyKodmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A94F1F0089D;
	Wed,  7 Oct 2026 00:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334304;
	bh=SkgfXKK3APHNF3DzgjT6SVnn1No1sUTWYLnzxioFxPQ=;
	h=Date:To:From:Subject;
	b=RtyKodmdrqqAFXJmjU51W+TrUA6whye7be29Fy27gztAIPILhu7wQZdL4OrmaV4Be
	 5GVlIwNRaH8TGe0KUEt0s697GEt6HVU4Bcqb0acIo47Sas2Jq/P/GBO3+5yIXRUMzt
	 icc/X+4VXZzhFETOhn5aE0kJysuucF1EqHRYO59M=
Date: Tue, 06 Oct 2026 17:51:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch removed from -mm tree
Message-Id: <20261007005144.1A94F1F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: dequeue the deferred split after the split freeze
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/huge_memory: dequeue the deferred split after the split freeze
Date: Mon, 31 Aug 2026 10:15:14 +0100

__folio_freeze_and_split_unmapped() takes the deferred split list_lru lock
across the freeze.  It is only there to stop deferred_split_scan() from
touching the folio under split.

With deferred_split_isolate() fixed, the workaround can be dropped.

Unqueue the folio after folio_ref_freeze(), the way
__folio_migrate_mapping() does: folio_unqueue_deferred_split() needs a
zero refcount and a memcg still set, and both hold there.

If the split is called from deferred_split_scan(), the unqueue is a no-op
-- the folio is already removed from the list.  But PG_partially_mapped is
still set, so it has to be cleared here or
MTHP_STAT_NR_ANON_PARTIALLY_MAPPED never comes back down.

Link: https://lore.kernel.org/20260831091514.1879786-3-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: Claude-Code:claude-opus-5
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>
---

 mm/huge_memory.c |   46 +++++++++++++--------------------------------
 1 file changed, 14 insertions(+), 32 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze
+++ a/mm/huge_memory.c
@@ -3979,41 +3979,27 @@ static int __folio_freeze_and_split_unma
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
-	struct list_lru_one *lru;
-	bool dequeue_deferred;
 	int ret = 0;
 
 	VM_WARN_ON_ONCE(!mapping && end);
-	/*
-	 * If this folio can be on the deferred split queue, lock out
-	 * the shrinker before freezing the ref. If the shrinker sees
-	 * a 0-ref folio, it assumes it beat folio_put() to the list
-	 * lock and must clean up the LRU state - the same dequeue we
-	 * will do below as part of the split.
-	 */
-	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
-	if (dequeue_deferred) {
-		struct mem_cgroup *memcg;
-
-		rcu_read_lock();
-		memcg = folio_memcg(folio);
-		lru = list_lru_lock(&deferred_split_lru,
-				    folio_nid(folio), &memcg);
-	}
+
 	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
 
-		if (dequeue_deferred) {
-			__list_lru_del(&deferred_split_lru, lru,
-				       &folio->_deferred_list, folio_nid(folio));
-			if (folio_test_partially_mapped(folio)) {
-				folio_clear_partially_mapped(folio);
-				mod_mthp_stat(old_order,
-					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-			}
-			list_lru_unlock(lru);
-			rcu_read_unlock();
+		/* Take off the deferred split queue while frozen and memcg set */
+		folio_unqueue_deferred_split(folio);
+
+		/*
+		 * deferred_split_scan() takes the folio off the queue before it
+		 * splits it, so the unqueue above finds an empty list and
+		 * leaves PG_partially_mapped set.
+		 * Clear it here: the flag does not survive the split.
+		 */
+		if (folio_test_partially_mapped(folio)) {
+			folio_clear_partially_mapped(folio);
+			mod_mthp_stat(old_order,
+				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		}
 
 		if (mapping) {
@@ -4115,10 +4101,6 @@ static int __folio_freeze_and_split_unma
 		if (ci)
 			swap_cluster_unlock(ci);
 	} else {
-		if (dequeue_deferred) {
-			list_lru_unlock(lru);
-			rcu_read_unlock();
-		}
 		return -EAGAIN;
 	}
 
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-huge_memory-add-folio_reset_partially_mapped.patch
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

