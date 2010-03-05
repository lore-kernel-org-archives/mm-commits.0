From: akpm@linux-foundation.org
Subject: [folded] mm-fix-mbind-vma-merge-problem-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:17:37 -0800
Message-ID: <201003052117.o25LHbwm028123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083Ab0CEVSP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:18:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, aarcange@redhat.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, nickpiggin@yah


The patch titled
     mm-fix-mbind-vma-merge-problem-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-mbind-vma-merge-problem-fix.patch

This patch was dropped because it was folded into mm-fix-mbind-vma-merge-problem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-fix-mbind-vma-merge-problem-fix
From: Minchan Kim <minchan.kim@gmail.com>

mm-fix-mbind-vma-merge-problem.patch added vma_merge in mbind to merge
mergeable vmas.  But it passed wrong offset of vm_file.

This patch fixes it.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/mempolicy.c~mm-fix-mbind-vma-merge-problem-fix mm/mempolicy.c
--- a/mm/mempolicy.c~mm-fix-mbind-vma-merge-problem-fix
+++ a/mm/mempolicy.c
@@ -570,6 +570,7 @@ static int mbind_range(struct mm_struct 
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
+	pgoff_t pgoff;
 	unsigned long vmstart;
 	unsigned long vmend;
 
@@ -582,9 +583,9 @@ static int mbind_range(struct mm_struct 
 		vmstart = max(start, vma->vm_start);
 		vmend   = min(end, vma->vm_end);
 
+		pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
-				  vma->anon_vma, vma->vm_file, vma->vm_pgoff,
-				  new_pol);
+				  vma->anon_vma, vma->vm_file, pgoff, new_pol);
 		if (prev) {
 			vma = prev;
 			next = vma->vm_next;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

mm-clean-up-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-count-swap-usage.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-get_scan_ratio-cleanup.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-fix-mbind-vma-merge-problem.patch
mm-fix-mbind-vma-merge-problem-fix.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups.patch
rmap-remove-obsolete-check-from-__page_check_anon_rmap.patch
rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page.patch
vmscan-factor-out-page-reference-checks.patch
vmscan-factor-out-page-reference-checks-fix.patch
vmscan-drop-page_mapping_inuse.patch
vmscan-detect-mapped-file-pages-used-only-once.patch

