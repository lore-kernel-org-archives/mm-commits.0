Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D533128A3
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334304; cv=none; b=aewmEAyHvtHtIJSCC3sjjkBu2K0isUfSQDy7+33f9g25f2MtHe0BoS3eX7XZ9KPeCY82dNEDNKoEUQvtw3u3Ovbt4B3sVtH9ldnNbzXsf3DXt9iIx0AERLWKp6nAAJRnt657q94g+wejXEnK3mLlaX6ELHAimcxAZ9+5jStvn1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334304; c=relaxed/simple;
	bh=swH3Z2/Ea/fFj31fmCx/Df2R35+XNnUXlgsmqrivv7Y=;
	h=Date:To:From:Subject:Message-Id; b=ofRMqQ9wEcu+dMBu7SyHV6mRRKkkWqPtRh0eLw8n47hbZ50KlQ8Vop0QJCkFFfU5P+FkEmxpU86xiS0snPDhsN4pRmlqTMY3ueD4MFXuj91ie8l6cn0gCqJqEmhnSs+kQ7KX9tE9ccOwV9OVRmDG+0m8a0BZq/f5PXgpIdly03k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MaRn4SWH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MaRn4SWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090A91F0089B;
	Wed,  7 Oct 2026 00:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334303;
	bh=WTwy15RnHS8sNwD0WZY9Oud9PVwoVnlgUpMARsJgHUk=;
	h=Date:To:From:Subject;
	b=MaRn4SWHaISMD1sfHgDFxrlnBXMknGQdq/xvgvwiPJa8hS31YUzMAcsfgm1MesqrB
	 tWTrjsbvpDcHzgjRXPPAI+Y1TV6rYrgHxW2QxCjBQ0Zvubs7+ftXVeLRPKGccYCzE/
	 I73hiIALfn/yYwA9+l7JmQltDc1q7v0QPmf5/Vtw=
Date: Tue, 06 Oct 2026 17:51:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch removed from -mm tree
Message-Id: <20261007005143.090A91F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: do not touch frozen folios in deferred_split_isolate()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/huge_memory: do not touch frozen folios in deferred_split_isolate()
Date: Mon, 31 Aug 2026 10:15:13 +0100

Patch series "Fix deferred_split_isolate() and drop the split workaround",
v2.

deferred_split_isolate() probes each queued folio with folio_try_get(). 
folio_try_get() failure is treated as a lost race with folio_put().

It leads to wrong results when !folio_try_get() was not caused by
folio_put(): for a frozen folio, PG_partially_mapped gets wrongfully
cleared and the folio dropped from the queue.

It came up in the review of my collapse RFC series:

  https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/

The bug is inert in upstream code:

  - __folio_split() works around it;
  - __folio_migrate_mapping() freezes a folio it is about to replace;
  - reclaim freezes only what try_to_unmap() already unmapped.

No cc:stable needed.  But my collapse rework steps on it, so it is worth
fixing.

The branch the first patch removes also hid an inert, pre-existing bug in
the zone device path:

  https://lore.kernel.org/all/20260827163838.1813081-1-usama.arif@linux.dev/

The first patch fixes deferred_split_isolate().

The second patch removes the workaround for this deferred_split_isolate()
behaviour from __folio_freeze_and_split_unmapped().

Tested in a VM: split_huge_page_test, folio_split_race_test and cow pass.

Also ran a test that leaves 16 partially mapped THPs on the deferred split
queue and drives thp-deferred_split through debugfs, checking
nr_anon_partially_mapped.


This patch (of 2):

deferred_split_isolate() probes each queued folio with folio_try_get(). 
folio_try_get() failure is treated as a lost race with folio_put(): clear
PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take the
folio off the queue.

The folio_put() race is the most common case for !folio_try_get(), but it
is not the only option.  Another scenario is folio_ref_freeze().

A zero refcount in such cases does not mean the folio is going away.  It
means "don't touch me" and current deferred_split_isolate() doesn't
respect it.  It can lead to unqueueing folios from the deferred list for
no reason:

    CPU 0                            CPU 1
    ---------------------------      ------------------------------
    freeze a mapped folio            deferred_split_scan()
      folio_ref_freeze()               folio_try_get() fails
                                       folio_clear_partially_mapped()
                                       NR_ANON_PARTIALLY_MAPPED--
                                       folio off the queue
    give up, put it back
      folio_ref_unfreeze()

The folio is still partially mapped, but it is no longer a split
candidate.  Nothing queues it again until part of it is unmapped once
more.

Skip the folio instead: whoever freezes the folio, owns it and owner is
responsible for its fate.  It also covers the folio_put() case:
__folio_put() unqueues the folio via folio_unqueue_deferred_split().

Nothing is lost by skipping.  Everything that frees a queued folio
unqueues it first, and folio_unqueue_deferred_split() clears
PG_partially_mapped and brings MTHP_STAT_NR_ANON_PARTIALLY_MAPPED down on
the way:

    __folio_put(), folios_put_refs()   mm/folio.c
    __folio_migrate_mapping()          mm/migrate.c
    shrink_folio_list()                mm/vmscan.c

__folio_freeze_and_split_unmapped() does the same by hand, under the
list_lru lock it holds across the freeze.  A freeze that ends in
folio_ref_unfreeze() leaves a folio that is still partially mapped and
still belongs on the queue.

Link: https://lore.kernel.org/20260831091514.1879786-1-kirill@shutemov.name
Link: https://lore.kernel.org/20260831091514.1879786-2-kirill@shutemov.name
Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Lance Yang <lance.yang@linux.dev>
Closes: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: Claude-Code:claude-opus-5
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
---

 mm/huge_memory.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate
+++ a/mm/huge_memory.c
@@ -4638,22 +4638,11 @@ static enum lru_status deferred_split_is
 	struct folio *folio = container_of(item, struct folio, _deferred_list);
 	struct list_head *freeable = cb_arg;
 
-	if (folio_try_get(folio)) {
-		list_lru_isolate_move(lru, item, freeable);
-		return LRU_REMOVED;
-	}
+	/* Lost race to folio_put() or the folio is under folio_ref_freeze() */
+	if (!folio_try_get(folio))
+		return LRU_SKIP;
 
-	/*
-	 * We lost race with folio_put(). Read folio state before the
-	 * isolate: folio_unqueue_deferred_split() checks list_empty()
-	 * locklessly, so once removed the folio can be freed any time.
-	 */
-	if (folio_test_partially_mapped(folio)) {
-		folio_clear_partially_mapped(folio);
-		mod_mthp_stat(folio_order(folio),
-			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-	}
-	list_lru_isolate(lru, item);
+	list_lru_isolate_move(lru, item, freeable);
 	return LRU_REMOVED;
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

