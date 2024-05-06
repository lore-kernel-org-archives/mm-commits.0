Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3523022089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957119; cv=none; b=KDDniv8nmjypzfhkUcZWTUREJMK/ZLILlQHUtT9Y7rv4CBaf/rMPaOeKzBal1nTetj5tHeB6NXZBuvIqqGtpPSSJPaPPanxFlMtiYN/M2ouDSv5lY6VahZOBrfiSNfHHu11T+gI2GXS5f/qKbdKennbxFCsjhJyqeXQCi/bWk9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957119; c=relaxed/simple;
	bh=tSB0fi6TS9rJBGv1KKKxJQ0n8t3g28XKQ8uyDS7v6Yg=;
	h=Date:To:From:Subject:Message-Id; b=QeHhW1fy9UvOlV2gmZttgb8VNIBw2ptuR2McPUTrmz06gPVf0OEIqFT0LkYxAF2OgGdKCOoe0lddA/goCk+BDIgeb1jBGC7TKpA+tZqC6gigj+/K98ZWqHnbbNIOg44FyQKuBdU6k1emNDHh1EP9i/zB9A0XHz8MULNPK0lUVb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WjKBoYx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WjKBoYx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C81C113CC;
	Mon,  6 May 2024 00:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957119;
	bh=tSB0fi6TS9rJBGv1KKKxJQ0n8t3g28XKQ8uyDS7v6Yg=;
	h=Date:To:From:Subject:From;
	b=WjKBoYx7VkYpFiOV4unifbxkbQQp1imrlOlGx3Jfxiu7F7jX7mjdbIgD4q0Jtfzi7
	 C0lnisPhWZxsSG2P/EuIcVkooY9lQOeLvmAJr/SGiMTWdt4EKdNVzjCtLd8zsqYlEj
	 NzWZrso+rDUSzAC0+Mt+UnuTONx3U2eBUGm9PZrc=
Date: Sun, 05 May 2024 17:58:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,mszeredi@redhat.com,jack@suse.cz,hcochran@kernelspring.com,axboe@kernel.dk,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-enable-__wb_calc_thresh-to-calculate-dirty-background-threshold.patch removed from -mm tree
Message-Id: <20240506005839.09C81C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: enable __wb_calc_thresh to calculate dirty background threshold
has been removed from the -mm tree.  Its filename was
     mm-enable-__wb_calc_thresh-to-calculate-dirty-background-threshold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Howard Cochran <hcochran@kernelspring.com>
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


