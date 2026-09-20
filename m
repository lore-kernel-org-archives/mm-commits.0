Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C603FA5EF
	for <mm-commits@vger.kernel.org>; Sun, 20 Sep 2026 23:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789948528; cv=none; b=K/pbhOnz72kMBlYzDFGq/TQeFid6PXAGdL9sbNygnsZlmUVRfH1b++sYVZGVUqs+I/maHBfbIDvNwHTzhTQFaEIBFhOBRUY5YuBeoc89ew3jojXxHDOHZyULTmvT4Jn2nxEXxAChc2ZHCEatF0XIg5WjQXHKif4pNM2OM1zDXLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789948528; c=relaxed/simple;
	bh=XFSX4Y3VKmuM3/xqWzXfEqSjwnCdS/AhRvFGiiXcX2I=;
	h=Date:To:From:Subject:Message-Id; b=qPrt09ghcwa99QaRVDu+pmmlCQm0kTBNjmIRTyp1uZj6ywD1wygvfrci9QNAZXsqnc2OqstMfuuYvBvJ3puvI5c83CxFDsfvwpDDA+HniK4l58oWteZP9Ib4HCv03OTqVqKswi1YUJlesf2TTqa51zSqFi7hVpq9JHmr9FUzSqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GtfYJNUf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GtfYJNUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D895A1F000FF;
	Sun, 20 Sep 2026 23:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789948527;
	bh=Yl3TH0hI5v0GW72RYoZq4V4MBGcm8iR23OLxMwJrfqo=;
	h=Date:To:From:Subject;
	b=GtfYJNUfNabXYXy4EA2BgQ1Glxp9Mv/v/K4+zuiVgngs1e+FefY92970am4qGo5Dy
	 sXVW280XMZoQFB3+UumGBbwALTrHFMU8QtjkdIhLOmzJ5L4CZplxZr3pK2toWVsFlb
	 bT5+ZAS01AlfnjVVJTglZmzXpnaMGl9/G7FEHkh0=
Date: Sun, 20 Sep 2026 16:55:26 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch added to mm-new branch
Message-Id: <20260920235526.D895A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: parameterize the mixed-source collapse case by source order
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch

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
Subject: selftests/mm: parameterize the mixed-source collapse case by source order
Date: Sat, 19 Sep 2026 01:24:42 +0100

collapse_order_mixed_sources() faults its region as order-2 folios and
collapses them to the -c target.  Order 2 is below the contpte size on
every arm64 page size, so nothing in this suite collapses a contpte-mapped
source on purpose.

Let -s name the source order alongside -c.  The case then faults at that
order, keeping order 2 when -s is absent, and the source order has to be a
supported mTHP order below the target.  The other mTHP cases are
unaffected: mthp_push_target_order() enables only the target order.

A -c at or below -s is refused before any case runs: the sources would
already be the size being asked for.  Without the check the generic cases
fail on that one by one instead of saying why.

"-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
larger mTHP.

Assisted-by: LLM
Link: https://lore.kernel.org/20260919002451.496763-13-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@meta.com
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/khugepaged.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1354,11 +1354,13 @@ static void collapse_order_max_ptes_none
 static void collapse_order_mixed_sources(struct collapse_context *c,
 					 struct mem_ops *ops)
 {
+	int source_order = anon_order ? anon_order : MIN_MTHP_ORDER;
 	struct thp_settings settings;
 	void *p;
 
-	if (collapse_order <= MIN_MTHP_ORDER) {
-		ksft_test_result_skip("%s: no source order below target\n",
+	if (source_order >= collapse_order ||
+	    !(thp_supported_orders() & (1UL << source_order))) {
+		ksft_test_result_skip("%s: no supported source order below target\n",
 				      __func__);
 		return;
 	}
@@ -1366,7 +1368,7 @@ static void collapse_order_mixed_sources
 	mthp_push_target_order();
 
 	settings = *thp_current_settings();
-	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
+	settings.hugepages[source_order].enabled = THP_ALWAYS;
 	thp_push_settings(&settings);
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
@@ -1376,10 +1378,9 @@ static void collapse_order_mixed_sources
 	 * The allocator can fall back to smaller folios under fragmentation;
 	 * having nothing to collapse from is not a failure.
 	 */
-	if (!is_range_backed_by_order(p, hpage_pmd_size, MIN_MTHP_ORDER,
+	if (!is_range_backed_by_order(p, hpage_pmd_size, source_order,
 				      pagemap_fd, kpageflags_fd)) {
-		ksft_print_msg("No order-%d sources to collapse...",
-			       MIN_MTHP_ORDER);
+		ksft_print_msg("No order-%d sources to collapse...", source_order);
 		skip("Skip");
 		ops->cleanup_area(p, hpage_pmd_size);
 		thp_pop_settings();
@@ -1389,7 +1390,8 @@ static void collapse_order_mixed_sources
 
 	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
 		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
-	ksft_print_msg("Collapse region backed by smaller large folios...");
+	ksft_print_msg("Collapse region backed by order-%d sources...",
+		       source_order);
 	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
 		fail("Timeout");
 	else if (all_windows_at_order(p, hpage_pmd_size))
@@ -1420,6 +1422,7 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    -s, if set, is the source order for the mixed-source case.\n");
 	exit(1);
 }
 
@@ -1575,6 +1578,9 @@ int main(int argc, char **argv)
 	    !(thp_supported_orders() & (1UL << collapse_order)))
 		ksft_exit_skip("Order %d is not a supported anon THP order\n",
 			       collapse_order);
+	if (mthp_khugepaged_context && collapse_order <= anon_order)
+		ksft_exit_skip("-c %d needs a source order below it, -s says %d\n",
+			       collapse_order, anon_order);
 
 	if (mthp_khugepaged_context) {
 		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
mm-huge_memory-add-folio_reset_partially_mapped.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
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

