Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649F748E0DD
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897233; cv=none; b=dvjCy2jPofRr49RotAQHFwdUW8i/H8X8fYW/cwtFDd3Rz6zkTJYQlPnRB+YQ6ElpIXU/7Nd8AxaGtELyCz70kvAINAo0Tv1BPSPgTkhKEaYeqqOLkE7bFdHFgOH36AvLCgO5eFA6+NVDYHI8uGkZYpFlBFiQjRP/We0qZtTaNRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897233; c=relaxed/simple;
	bh=ACAnLkKz6qLzMrYPN/xqA3nHwXKd5sWKsrf7KbERiWU=;
	h=Date:To:From:Subject:Message-Id; b=KpqTFkk4tsqz8dVHdBuE1ox4prYcVwEjAyo1ieTGi6i8hHgFbxuhSSSeGIeltoiBIH9nOnjCkYYU20IsG++/shQcSO4Kqy42n2HZMAz6Y66cgA1cHtI7ecijXJgMCzlLfm1iKW8fmTt9JfQO+WA/wJuY/sXjiaxn1S3ByjxMvBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ftHFaeSa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ftHFaeSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BA61F00A3A;
	Tue,  8 Sep 2026 19:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788897232;
	bh=nlTVVpUE1Yn0bBsjpuP11mWxMCcDf0poYZe1QeY2q3E=;
	h=Date:To:From:Subject;
	b=ftHFaeSa9OKJhyTWslpz5PuckOxHFsMtp1kmcR9SAu1e/2EWHNCODwHY18EOP2+k4
	 B7UV9cI8FcYAdH2q0woUEyUTy27m5ZCcW5UO91QXFoKHZDIju20L77YcgCXen9KbUe
	 6sCafRBDkUCd9RaMeEFYqKNcEEYEBmk0DdLc5XZg=
Date: Tue, 08 Sep 2026 12:53:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ljs@kernel.org,david@kernel.org,baolin.wang@linux.alibaba.com,balbirs@nvidia.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-folio_reset_partially_mapped.patch added to mm-new branch
Message-Id: <20260908195351.D6BA61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: add folio_reset_partially_mapped()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-add-folio_reset_partially_mapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-folio_reset_partially_mapped.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-folio_reset_partially_mapped
+++ a/mm/huge_memory.c
@@ -3977,6 +3977,25 @@ static unsigned int folio_cache_ref_coun
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
@@ -3985,7 +4004,6 @@ static int __folio_freeze_and_split_unma
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
-	int old_order = folio_order(folio);
 	int ret = 0;
 
 	VM_WARN_ON_ONCE(!mapping && end);
@@ -4003,11 +4021,7 @@ static int __folio_freeze_and_split_unma
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
@@ -4521,11 +4535,7 @@ bool __folio_unqueue_deferred_split(stru
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

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
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
mm-huge_memory-add-folio_reset_partially_mapped.patch

