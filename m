Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271534FC339;
	Thu, 15 Oct 2026 23:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792107753; cv=none; b=XBSxfuUjAPkKRxgB63VYtzCHh8oCgq9bbPgBy8LLOQp0TX1KNNyDMvLzfbgCnDQ5jLLX+XkRBMCv4lgzAC33NLLNoEedUDFqF3YUuztTncryl3M0CYDL1x2sd4PV+LCHqIUxuQ0rk9A2VAw8VKIDlZRB52z/ERKAuf6O43ujFoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792107753; c=relaxed/simple;
	bh=z2DZ0kqH0HHcr4hHqckIrYJVyQ/HYGq/cK+jJeD38PI=;
	h=Date:To:From:Subject:Message-Id; b=PCtE+Ocyr5tA1Wx/Ol8qnEaV3GHK2Ds5jjjclveRYrDSFvvmQJ+ShzVCF3zIA5vqFdKL7LNh51RrXgq4omfC2HSgnl1H4WKi3RnLzMqBEMQIfnH8FNEXB8AKMXFpl/kASeEEjfDF5zPg2lfAufRbJsKP/sSoKf6xo/pMVfoszaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WDnMo9dg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WDnMo9dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74991F000C4;
	Thu, 15 Oct 2026 23:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792107751;
	bh=NLTwNcxfXoAhGZEtZl18RT2cd0JAxAjMH1SuYujOvhE=;
	h=Date:To:From:Subject;
	b=WDnMo9dgTToFlh4Qic/BQ95xc/Xw83W3TqADU7bl7uWFmuFVKkR0lI2WKhsDMEbbb
	 Lx1wiC5AwYFdDuAjyZd5aztzUCumZIp7L6A70K6f5+KnC6VWyGP9shra9UD79QUIaY
	 FxG/VKV2uYPdeFCk7rtYEA8RDhhVn/IbSOa8qvJ8=
Date: Thu, 15 Oct 2026 16:42:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,mhocko@suse.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order-fix.patch added to mm-unstable branch
Message-Id: <20261015234231.A74991F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Re: mm: page_alloc: make defrag_mode retries follow the promoted order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order-fix.patch

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
From: Kiryl Shutsemau <kas@kernel.org>
Subject: Re: mm: page_alloc: make defrag_mode retries follow the promoted order
Date: Thu, 15 Oct 2026 13:50:55 +0100

s/order_nofrag_promoted/order_defrag_promoted/, per hannes

Link: https://lore.kernel.org/atDL-nSFP2KVU7cI@thinkstation
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order-fix
+++ a/mm/page_alloc.c
@@ -4117,7 +4117,7 @@ out:
 	return page;
 }
 
-static inline bool order_nofrag_promoted(unsigned int order,
+static inline bool order_defrag_promoted(unsigned int order,
 					 const struct alloc_context *ac)
 {
 	return ac->reclaim_compact_order != order;
@@ -4250,7 +4250,7 @@ should_compact_retry(gfp_t gfp_mask, str
 	 * Promoted requests fall back instead.
 	 */
 	if (compact_result == COMPACT_SKIPPED) {
-		if (!order_nofrag_promoted(order, ac))
+		if (!order_defrag_promoted(order, ac))
 			ret = compaction_zonelist_suitable(ac, order,
 							   alloc_flags, gfp_mask);
 		goto out;
@@ -4632,7 +4632,7 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	 * for compaction without freeing anything.
 	 */
 	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER &&
-	    !order_nofrag_promoted(order, ac))
+	    !order_defrag_promoted(order, ac))
 		*no_progress_loops = 0;
 	else
 		(*no_progress_loops)++;
@@ -5029,7 +5029,7 @@ retry:
 	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
 		alloc_flags &= ~ALLOC_NOFRAGMENT;
 		/* Retries went into making blocks, start the fallback afresh */
-		if (order_nofrag_promoted(order, ac)) {
+		if (order_defrag_promoted(order, ac)) {
 			no_progress_loops = 0;
 			compaction_retries = 0;
 		}
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order-fix.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch

