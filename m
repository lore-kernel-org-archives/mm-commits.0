Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7469C427A10
	for <mm-commits@vger.kernel.org>; Wed, 14 Oct 2026 21:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792012618; cv=none; b=KfaUqjLwXaHbTvZmv6nYP+37XVHcWL7X2VS0sdGY1uHlzgQWsONbvuFKvmJs/WYKLRevePEJPRF3qahJaH1jpvGBiW+tU3xlHs67PzeMF3+RoWQQRiGKEFjjVN+WfXXzkkDB3mAbvR+dwW0cuwKq4zl71b2pUln+m1x55Q0DluI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792012618; c=relaxed/simple;
	bh=vdkX8G4zBcnvy8Hg5l+viLrWF+ChbRTLv4SYdrnnl10=;
	h=Date:To:From:Subject:Message-Id; b=AiizxROo1Wqd443HnUMR+TrIkk8P+s2bAsqF++Sn1a0+Vn6WunR3+RcEEjVf/mZIA3Eq0QHLhZjvYlWz3DouLC3hAqOEe8jt+9A3XiecESCwoAWEmy721KzAMa0h/z6f6O5pxvYcX0H2unp6+p/s1lmrsIsnVpXUJRdW5roJD64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KiGCPj7f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KiGCPj7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2947F1F000C4;
	Wed, 14 Oct 2026 21:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792012617;
	bh=Q0ZpQ0BddJ6lFkwatWKnblCyEpfnkEuYkW36PJriHps=;
	h=Date:To:From:Subject;
	b=KiGCPj7fRcemOVAqmV05gx3W8OZAkg47HyL6i3/I2xXa3rp6VpQFtENuhuXbhFwXi
	 /uVoPnT+10+kA83wle0Ft0ZwevY3naYVKWZmw0SJoPBSnVxOmw+bWwyqXXEZx6pMMY
	 qZB56luM3QYeEK12i/37VJ3IkC0qvB8+b5J68g9M=
Date: Wed, 14 Oct 2026 14:16:56 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-collapse-call-collapse_file-from-collapse_single_pmd.patch added to mm-unstable branch
Message-Id: <20261014211657.2947F1F000C4@smtp.kernel.org>
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
Date: Wed, 14 Oct 2026 18:11:41 +0100

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

Link: https://lore.kernel.org/20261014171145.3292736-9-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
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
@@ -2767,13 +2767,9 @@ static enum scan_result collapse_scan_fi
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
@@ -2804,8 +2800,16 @@ static enum scan_result collapse_single_
 
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
@@ -2817,6 +2821,7 @@ retry:
 		triggered_wb = true;
 		goto retry;
 	}
+put:
 	fput(file);
 
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
_

Patches currently in -mm which might be from kas@kernel.org are

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

