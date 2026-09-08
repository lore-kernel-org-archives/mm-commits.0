Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51487563FA5
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897036; cv=none; b=qzqDlpz8e/f84Tj1q6thl8CC2LAfBBA5HoJrcDyM649xr5ISTTMJR0OW+oK4BeyBorBHvHVvqiOL9zqUoS/1Z6DuizJg05ktObea1HsKKMKsYmXAHFuPppxymirFafFO1scHHMC2IMUavEvif1sq/MlKJvxcuR8+pnH/sqCcBoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897036; c=relaxed/simple;
	bh=wRjY3XeeDdBl0Bd7u/fDD2gkar+Mv0N3BeveeyjEOzw=;
	h=Date:To:From:Subject:Message-Id; b=EDATkufLvYCznYhtJLFBR8XIO1qSBu79CdzMv/azCa/2aATDy/uvnRc6pPSVDwDCWooecv6laEngQ/5IgDbBepRvT2Njm5pkMwxP9d+Ni52dqM6W8s3kViMZJvRZT2aOUaawLNc44iXmrWygtzPL4aO6fOBLksvMueZfz0KMYlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bg/7c1+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bg/7c1+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E7B1F00A3D;
	Tue,  8 Sep 2026 19:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788897032;
	bh=MMlE+GXcMxB1/8B/4MAQwltGjWku5rWTjvhw9zhDT1w=;
	h=Date:To:From:Subject;
	b=bg/7c1+wKjdre/MDmg8ki9p2snPRwOjtI+IPho4XyivaGwEFPoLMw3AtpgDpYf6t4
	 LT0VwSapxxdNOQMQcewddybzZW4i4UVi6iepgAh6DiNiurdxH6Piov6w5bTbpcEJ42
	 ZGGluKgnhusWYfKtfTmMyIT/o2S0war8P/L9w2KE=
Date: Tue, 08 Sep 2026 12:50:32 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch added to mm-new branch
Message-Id: <20260908195032.95E7B1F00A3D@smtp.kernel.org>
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
Date: Tue, 8 Sep 2026 13:50:58 +0100

collapse_order_mixed_sources() faults its region as order-2 folios and
collapses them to the -c target.  Order 2 is below the contpte size on
every arm64 page size, so nothing in this suite collapses a contpte-mapped
source on purpose.

Let -s name the source order alongside -c.  The case then faults at that
order, keeping order 2 when -s is absent, and the source order has to be a
supported mTHP order below the target.  The other mTHP cases are
unaffected: mthp_push_target_order() enables only the target order.

"-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
larger mTHP.

Assisted-by: LLM
Link: https://lore.kernel.org/20260908125105.1510704-13-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1357,11 +1357,13 @@ static void collapse_order_max_ptes_none
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
@@ -1369,7 +1371,7 @@ static void collapse_order_mixed_sources
 	mthp_push_target_order();
 
 	settings = *thp_current_settings();
-	settings.hugepages[MIN_MTHP_ORDER].enabled = THP_ALWAYS;
+	settings.hugepages[source_order].enabled = THP_ALWAYS;
 	thp_push_settings(&settings);
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
@@ -1379,10 +1381,9 @@ static void collapse_order_mixed_sources
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
@@ -1392,7 +1393,8 @@ static void collapse_order_mixed_sources
 
 	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
 		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
-	ksft_print_msg("Collapse region backed by smaller large folios...");
+	ksft_print_msg("Collapse region backed by order-%d sources...",
+		       source_order);
 	if (!khugepaged_full_pass(MTHP_PASS_TIMEOUT_S))
 		fail("Timeout");
 	else if (all_windows_at_order(p, hpage_pmd_size))
@@ -1423,6 +1425,7 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    -s, if set, is the source order for the mixed-source case.\n");
 	exit(1);
 }
 
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

