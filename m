Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9341614BF87
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 17:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714065917; cv=none; b=ufbiPSa1K3W68wzq0A4aDdey4yCMsRIJI+py9n2rbh59N1fcrG7girBVEpF4UIpQQYMg4NV24iqNHfoM3Hl5U2GKUCdue4FtyVimK8Uh2/jcabHIG3T2UiEJ3U6Ks0CdCyYYXUHFnMigXAG6XafNsTl4N8jzFSomHlIIiiAxOLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714065917; c=relaxed/simple;
	bh=P2WuHhEmSgeNa9IlcUjjPPjBpLUw7cSRhWYdR967/zo=;
	h=Date:To:From:Subject:Message-Id; b=WAFANxzrCw5YSuKE80ZZJdtM9l/neEPjNhByjP+Hwwtb27qBrBsTa0QEe8RT78tP91DRiLGEujyJMdWLkabsbIczbt0Akh4cHG0SYVKPdZ18gQsKccaO8QnaUapl8H0Qvx3J4XbbN/fbISsqa+/t+QddtBktbYX7m0sM/TajCNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C/TERWuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C/TERWuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05816C113CC;
	Thu, 25 Apr 2024 17:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714065917;
	bh=P2WuHhEmSgeNa9IlcUjjPPjBpLUw7cSRhWYdR967/zo=;
	h=Date:To:From:Subject:From;
	b=C/TERWuYPvKNlLr2pi6bWX+HmXHbI3eZFna4daRoWmbi8x3Wo/3dhPK/lGvGqPh8x
	 HryR+nIM7BuUmGkeZL7vQilrroxCKHYGZ+s18Fe5kyjc2SelvQDOjVChD4nbf9F+d/
	 3gg0eJB7/bSQbVWD8vpooHidn+7aolHUEIx8Pruw=
Date: Thu, 25 Apr 2024 10:25:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,mszeredi@redhat.com,jack@suse.cz,hcochran@kernelspring.com,axboe@kernel.dk,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enable-__wb_calc_thresh-to-calculate-dirty-background-threshold.patch added to mm-unstable branch
Message-Id: <20240425172517.05816C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: enable __wb_calc_thresh to calculate dirty background threshold
has been added to the -mm mm-unstable branch.  Its filename is
     mm-enable-__wb_calc_thresh-to-calculate-dirty-background-threshold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-enable-__wb_calc_thresh-to-calculate-dirty-background-threshold.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: enable __wb_calc_thresh to calculate dirty background threshold
Date: Thu, 25 Apr 2024 21:17:21 +0800

Patch series "Fix and cleanups to page-writeback", v2.

This series contains some random cleanups and a fix to correct calculation
of wb's bg_thresh in cgroup domain.  More details can be found respective
patches.


This patch (of 4):

Originally, __wb_calc_thresh always calculate wb's share of dirty
throttling threshold.  By getting thresh of wb_domain from caller,
__wb_calc_thresh could be used for both dirty throttling and dirty
background threshold.

This is a preparation to correct threshold calculation of wb in cgroup.

Link: https://lkml.kernel.org/r/20240425131724.36778-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20240425131724.36778-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Howard Cochran <hcochran@kernelspring.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- a/mm/page-writeback.c~mm-enable-__wb_calc_thresh-to-calculate-dirty-background-threshold
+++ a/mm/page-writeback.c
@@ -838,13 +838,15 @@ static void mdtc_calc_avail(struct dirty
 }
 
 /**
- * __wb_calc_thresh - @wb's share of dirty throttling threshold
+ * __wb_calc_thresh - @wb's share of dirty threshold
  * @dtc: dirty_throttle_context of interest
+ * @thresh: dirty throttling or dirty background threshold of wb_domain in @dtc
  *
- * Note that balance_dirty_pages() will only seriously take it as a hard limit
- * when sleeping max_pause per page is not enough to keep the dirty pages under
- * control. For example, when the device is completely stalled due to some error
- * conditions, or when there are 1000 dd tasks writing to a slow 10MB/s USB key.
+ * Note that balance_dirty_pages() will only seriously take dirty throttling
+ * threshold as a hard limit when sleeping max_pause per page is not enough
+ * to keep the dirty pages under control. For example, when the device is
+ * completely stalled due to some error conditions, or when there are 1000
+ * dd tasks writing to a slow 10MB/s USB key.
  * In the other normal situations, it acts more gently by throttling the tasks
  * more (rather than completely block them) when the wb dirty pages go high.
  *
@@ -855,19 +857,20 @@ static void mdtc_calc_avail(struct dirty
  * The wb's share of dirty limit will be adapting to its throughput and
  * bounded by the bdi->min_ratio and/or bdi->max_ratio parameters, if set.
  *
- * Return: @wb's dirty limit in pages. The term "dirty" in the context of
- * dirty balancing includes all PG_dirty and PG_writeback pages.
+ * Return: @wb's dirty limit in pages. For dirty throttling limit, the term
+ * "dirty" in the context of dirty balancing includes all PG_dirty and
+ * PG_writeback pages.
  */
-static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc)
+static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
+				      unsigned long thresh)
 {
 	struct wb_domain *dom = dtc_dom(dtc);
-	unsigned long thresh = dtc->thresh;
 	u64 wb_thresh;
 	unsigned long numerator, denominator;
 	unsigned long wb_min_ratio, wb_max_ratio;
 
 	/*
-	 * Calculate this BDI's share of the thresh ratio.
+	 * Calculate this wb's share of the thresh ratio.
 	 */
 	fprop_fraction_percpu(&dom->completions, dtc->wb_completions,
 			      &numerator, &denominator);
@@ -887,9 +890,9 @@ static unsigned long __wb_calc_thresh(st
 
 unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh)
 {
-	struct dirty_throttle_control gdtc = { GDTC_INIT(wb),
-					       .thresh = thresh };
-	return __wb_calc_thresh(&gdtc);
+	struct dirty_throttle_control gdtc = { GDTC_INIT(wb) };
+
+	return __wb_calc_thresh(&gdtc, thresh);
 }
 
 unsigned long cgwb_calc_thresh(struct bdi_writeback *wb)
@@ -908,7 +911,7 @@ unsigned long cgwb_calc_thresh(struct bd
 	mdtc_calc_avail(&mdtc, filepages, headroom);
 	domain_dirty_limits(&mdtc);
 
-	return __wb_calc_thresh(&mdtc);
+	return __wb_calc_thresh(&mdtc, mdtc.thresh);
 }
 
 /*
@@ -1655,7 +1658,7 @@ static inline void wb_dirty_limits(struc
 	 *   wb_position_ratio() will let the dirtier task progress
 	 *   at some rate <= (write_bw / 2) for bringing down wb_dirty.
 	 */
-	dtc->wb_thresh = __wb_calc_thresh(dtc);
+	dtc->wb_thresh = __wb_calc_thresh(dtc, dtc->thresh);
 	dtc->wb_bg_thresh = dtc->thresh ?
 		div64_u64(dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

writeback-collect-stats-of-all-wb-of-bdi-in-bdi_debug_stats_show.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch
writeback-add-wb_monitorpy-script-to-monitor-writeback-info-on-bdi.patch
writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch
mm-enable-__wb_calc_thresh-to-calculate-dirty-background-threshold.patch
mm-correct-calculation-of-wbs-bg_thresh-in-cgroup-domain.patch
mm-call-__wb_calc_thresh-instead-of-wb_calc_thresh-in-wb_over_bg_thresh.patch
mm-remove-stale-comment-__folio_mark_dirty.patch

