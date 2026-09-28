Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03464F7CB0
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 22:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632906; cv=none; b=op1SiJK447kiCOies2ACh0VwK9bDNhCb4qfVJ3A8UN25iBs3onLCEHPBnOM3zaWmJvAv6FnlkO5bfs/2Wqc+7gJHiOMc4Uw23YQimySe5SZqhAbkbAMUhcEjDcCYkUEj/iHgz72Yo/M7a7t3ZjEdwgAYPM01m2H41MADcEu7EtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632906; c=relaxed/simple;
	bh=U4tFNIWiCPHeQjQTSL6xpkQW2/1GVq1Xx1y/fTBKkxU=;
	h=Date:To:From:Subject:Message-Id; b=SZo9ruRarDjGXVOx+rWtK4eSs+I5Mnbip6/3q4cttm4pM0/14O/PmcWTs/raRgimmtbT1rW5gntOi5t4UPp7NU4EY5/UPdYmNYG3/yO2tHdq374BFait94i5uvxTcQ20QtdSMY1FYDEFLbkD6Iq7esHlAwvni3ObV4w45rzx/2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qckxDtbO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qckxDtbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ABE1F000FF;
	Mon, 28 Sep 2026 22:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632904;
	bh=j4DDWQTjdEUBpCDjJFR9mEY+ugTOWtXEsfdwG7tmT6Q=;
	h=Date:To:From:Subject;
	b=qckxDtbOtOx4+E7uapplqf1uEUGYs58JqL+mgb0IOePfcj1d0pz8/AJunHJopG7KC
	 Wgle4wb9VKF9iBEcMk03lkpJ/Lqkp90BGn2MxVpz/pLpBWZuUpMMOYcyflIXm1/UaX
	 y2iC6PBsVRH4vz7iwYkVfPHns676+EoQDsy4DP8w=
Date: Mon, 28 Sep 2026 15:01:44 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-collapse-call-collapse_file-from-collapse_single_pmd.patch added to mm-unstable branch
Message-Id: <20260928220144.A4ABE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/collapse: call collapse_file() from collapse_single_pmd()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-collapse-call-collapse_file-from-collapse_single_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-collapse-call-collapse_file-from-collapse_single_pmd.patch

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/collapse: call collapse_file() from collapse_single_pmd()
Date: Mon, 28 Sep 2026 11:06:22 +0100

collapse_scan_file() reads the page cache to decide whether a table is
worth collapsing and, when it is, calls collapse_file() itself.  The
caller cannot get between the decision and the collapse.

Move the collapse_file() call up into collapse_single_pmd(), so the scan
stops at the decision.

Two things change with it.  The writeback retry re-runs collapse_file()
alone instead of rescanning first; collapse_file() repeats the scan's
checks under the page cache lock anyway.  And mm_khugepaged_scan_file
fires before the collapse, so for an accepted table its status reads
SCAN_SUCCEED; what the collapse made of the table is for
mm_khugepaged_collapse_file to report.

Preparation for splitting a collapse into a scan under mmap_lock and a
run without it.  The file scan has to stop where the anonymous one will.

Link: https://lore.kernel.org/20260928100630.21870-9-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
---

 mm/khugepaged.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~mm-collapse-call-collapse_file-from-collapse_single_pmd
+++ a/mm/khugepaged.c
@@ -2760,13 +2760,9 @@ static enum scan_result collapse_scan_fi
 	else
 		cc->progress += HPAGE_PMD_NR;
 
-	if (result == SCAN_SUCCEED) {
-		if (present < HPAGE_PMD_NR - max_ptes_none) {
-			result = SCAN_EXCEED_NONE_PTE;
-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-		} else {
-			result = collapse_file(mm, addr, file, start, cc);
-		}
+	if (result == SCAN_SUCCEED && present < HPAGE_PMD_NR - max_ptes_none) {
+		result = SCAN_EXCEED_NONE_PTE;
+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 	}
 
 	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
@@ -2797,8 +2793,16 @@ static enum scan_result collapse_single_
 
 	mmap_read_unlock(mm);
 	*lock_dropped = true;
-retry:
+
+	/*
+	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
+	 * the PMD folio, and only the PTE table is left to retract.
+	 */
 	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+	if (result != SCAN_SUCCEED)
+		goto put;
+retry:
+	result = collapse_file(mm, addr, file, pgoff, cc);
 
 	/* Dirty pages are worth a writeback and one more try, if asked for */
 	if (cc->policy.file_writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
@@ -2810,6 +2814,7 @@ retry:
 		triggered_wb = true;
 		goto retry;
 	}
+put:
 	fput(file);
 
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
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

