Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EA7C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiI0Cz6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiI0CzR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:55:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7710E275EA
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57644615B5
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32AFC433B5;
        Tue, 27 Sep 2022 02:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664247009;
        bh=Bo0Kym92Jbpb8xEadCx1iNkXnHm4lPlt8LxKYt85azo=;
        h=Date:To:From:Subject:From;
        b=g8a4fhhSIzEnbopl1bXGITjbfeVlqd72uXKb0jOjbbvR6MVFICNHEmIkNq8MIuFZ0
         gBLiBxgM9b0u296vMrq8isrvBy1sF4kxKjUWh1tBZcwW+SuyO8UxDlpARnHLuDGEuP
         ProB+9TmP3+GGSQnipRRkMscV2qfVddTpj5zqEAA=
Date:   Mon, 26 Sep 2022 19:50:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        rostedt@goodmis.org, riel@surriel.com, peterz@infradead.org,
        mhocko@kernel.org, mgorman@techsingularity.net,
        liam.howlett@oracle.com, kirill@shutemov.name, hughd@google.com,
        matenajakub@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-refactor-of-vma_merge.patch removed from -mm tree
Message-Id: <20220927025009.B32AFC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: refactor of vma_merge()
has been removed from the -mm tree.  Its filename was
     mm-refactor-of-vma_merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jakub Matěna <matenajakub@gmail.com>
Subject: mm: refactor of vma_merge()
Date: Fri, 3 Jun 2022 16:57:18 +0200

Patch series "Refactor of vma_merge and new merge call", v4.

I am currently working on my master's thesis trying to increase number of
merges of VMAs currently failing because of page offset incompatibility
and difference in their anon_vmas.  The following refactor and added merge
call included in this series is just two smaller upgrades I created along
the way.


This patch (of 2):

Refactor vma_merge() to make it shorter and more understandable.  Main
change is the elimination of code duplicity in the case of merge next
check.  This is done by first doing checks and caching the results before
executing the merge itself.  The variable 'area' is divided into 'mid' and
'res' as previously it was used for two purposes, as the middle VMA
between prev and next and also as the result of the merge itself.  Exit
paths are also unified.

Link: https://lkml.kernel.org/r/20220603145719.1012094-1-matenajakub@gmail.com
Link: https://lkml.kernel.org/r/20220603145719.1012094-2-matenajakub@gmail.com
Signed-off-by: Jakub Matěna <matenajakub@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Rik van Riel <riel@surriel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   87 ++++++++++++++++++++++------------------------------
 1 file changed, 37 insertions(+), 50 deletions(-)

--- a/mm/mmap.c~mm-refactor-of-vma_merge
+++ a/mm/mmap.c
@@ -1005,8 +1005,10 @@ struct vm_area_struct *vma_merge(struct
 			struct anon_vma_name *anon_name)
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
-	struct vm_area_struct *area, *next;
-	int err;
+	struct vm_area_struct *mid, *next, *res;
+	int err = -1;
+	bool merge_prev = false;
+	bool merge_next = false;
 
 	/*
 	 * We later require that vma->vm_flags == vm_flags,
@@ -1016,75 +1018,60 @@ struct vm_area_struct *vma_merge(struct
 		return NULL;
 
 	next = find_vma(mm, prev ? prev->vm_end : 0);
-	area = next;
-	if (area && area->vm_end == end)		/* cases 6, 7, 8 */
+	mid = next;
+	if (next && next->vm_end == end)		/* cases 6, 7, 8 */
 		next = find_vma(mm, next->vm_end);
 
 	/* verify some invariant that must be enforced by the caller */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
-	VM_WARN_ON(area && end > area->vm_end);
+	VM_WARN_ON(mid && end > mid->vm_end);
 	VM_WARN_ON(addr >= end);
 
-	/*
-	 * Can it merge with the predecessor?
-	 */
+	/* Can we merge the predecessor? */
 	if (prev && prev->vm_end == addr &&
 			mpol_equal(vma_policy(prev), policy) &&
 			can_vma_merge_after(prev, vm_flags,
 					    anon_vma, file, pgoff,
 					    vm_userfaultfd_ctx, anon_name)) {
-		/*
-		 * OK, it can.  Can we now merge in the successor as well?
-		 */
-		if (next && end == next->vm_start &&
-				mpol_equal(policy, vma_policy(next)) &&
-				can_vma_merge_before(next, vm_flags,
-						     anon_vma, file,
-						     pgoff+pglen,
-						     vm_userfaultfd_ctx, anon_name) &&
-				is_mergeable_anon_vma(prev->anon_vma,
-						      next->anon_vma, NULL)) {
-							/* cases 1, 6 */
-			err = __vma_adjust(prev, prev->vm_start,
-					 next->vm_end, prev->vm_pgoff, NULL,
-					 prev);
-		} else					/* cases 2, 5, 7 */
-			err = __vma_adjust(prev, prev->vm_start,
-					 end, prev->vm_pgoff, NULL, prev);
-		if (err)
-			return NULL;
-		khugepaged_enter_vma(prev, vm_flags);
-		return prev;
+		merge_prev = true;
 	}
-
-	/*
-	 * Can this new request be merged in front of next?
-	 */
+	/* Can we merge the successor? */
 	if (next && end == next->vm_start &&
 			mpol_equal(policy, vma_policy(next)) &&
 			can_vma_merge_before(next, vm_flags,
 					     anon_vma, file, pgoff+pglen,
 					     vm_userfaultfd_ctx, anon_name)) {
+		merge_next = true;
+	}
+	/* Can we merge both the predecessor and the successor? */
+	if (merge_prev && merge_next &&
+			is_mergeable_anon_vma(prev->anon_vma,
+				next->anon_vma, NULL)) {	 /* cases 1, 6 */
+		err = __vma_adjust(prev, prev->vm_start,
+					next->vm_end, prev->vm_pgoff, NULL,
+					prev);
+		res = prev;
+	} else if (merge_prev) {			/* cases 2, 5, 7 */
+		err = __vma_adjust(prev, prev->vm_start,
+					end, prev->vm_pgoff, NULL, prev);
+		res = prev;
+	} else if (merge_next) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
 			err = __vma_adjust(prev, prev->vm_start,
-					 addr, prev->vm_pgoff, NULL, next);
-		else {					/* cases 3, 8 */
-			err = __vma_adjust(area, addr, next->vm_end,
-					 next->vm_pgoff - pglen, NULL, next);
-			/*
-			 * In case 3 area is already equal to next and
-			 * this is a noop, but in case 8 "area" has
-			 * been removed and next was expanded over it.
-			 */
-			area = next;
-		}
-		if (err)
-			return NULL;
-		khugepaged_enter_vma(area, vm_flags);
-		return area;
+					addr, prev->vm_pgoff, NULL, next);
+		else					/* cases 3, 8 */
+			err = __vma_adjust(mid, addr, next->vm_end,
+					next->vm_pgoff - pglen, NULL, next);
+		res = next;
 	}
 
-	return NULL;
+	/*
+	 * Cannot merge with predecessor or successor or error in __vma_adjust?
+	 */
+	if (err)
+		return NULL;
+	khugepaged_enter_vma(res, vm_flags);
+	return res;
 }
 
 /*
_

Patches currently in -mm which might be from matenajakub@gmail.com are


