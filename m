Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2F6C43334
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 17:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240823AbiFCRLl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 13:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiFCRLk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 13:11:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0134B842
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 10:11:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6866361A39
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 17:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B342AC385B8;
        Fri,  3 Jun 2022 17:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654276298;
        bh=7tIoh6FCF4V5pYCdQn8k6OiI3LqGGJoHeavM9H1mpDg=;
        h=Date:To:From:Subject:From;
        b=vfBmTlWM8AraPm+ctX/4wTyDt55YzwfFZD2G0N8mbuc/VL1emEKSHe5AF7bouJnt1
         Lye91b2UI2n0IXYKlcBjLxa23bZi8Iq8i4sdrpN3TAU1gRmh7D0bWyYLoZkAcqh8f4
         P7XMONAPJfiJNWH0c17hntrVtDc+WxsU7pUDm1hw=
Date:   Fri, 03 Jun 2022 10:11:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        rostedt@goodmis.org, riel@surriel.com, peterz@infradead.org,
        mhocko@kernel.org, mgorman@techsingularity.net,
        liam.howlett@oracle.com, kirill@shutemov.name, hughd@google.com,
        matenajakub@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-refactor-of-vma_merge.patch added to mm-unstable branch
Message-Id: <20220603171138.B342AC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH 1/2] mm: refactor of vma_merge()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-refactor-of-vma_merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-refactor-of-vma_merge.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jakub Matěna <matenajakub@gmail.com>
Subject: [PATCH 1/2] mm: refactor of vma_merge()
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
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -1074,8 +1074,10 @@ struct vm_area_struct *vma_merge(struct
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
@@ -1085,75 +1087,60 @@ struct vm_area_struct *vma_merge(struct
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

mm-refactor-of-vma_merge.patch
mm-add-merging-after-mremap-resize.patch

