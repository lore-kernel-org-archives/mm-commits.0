Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB988BEC
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337168; cv=none; b=QULRohklHXv3SEZvof8WYjlbbsNLm4I/yzZKjv7eIuv8fz1oNBGVfqRFx5fScs2DTxsCrbNbxOGh0zUJvdCF3xR46Z1j1PPLJas8enRJCVUqfH17Sz4mmWpII7M2lHl4EEEwuD5lcFNRlWAMSqH5lQdRxJiVLiPJidXlW1PYUQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337168; c=relaxed/simple;
	bh=C67hxo25sQUb4V+kIDZvU0xB+AL4DZ+8lJv4MUzcWbc=;
	h=Date:To:From:Subject:Message-Id; b=tFFKqW7qf7EUDqX3O7GME24gdiaEe1PRzUEtGio9zCozNFYKvINbGqw5bNlSE3muNWEmy6tp9ZxN6+nMs2mg4pZiVYFIQP+hyipIygvbZFn46EAL+JgpXjFq7qDFQ8NgIZSdAQvUj2J1oYYn+MJLBTip4rctrPYLf9iD1O7QsV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M236kzyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M236kzyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8FCC4CED6;
	Mon, 20 Jan 2025 01:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337168;
	bh=C67hxo25sQUb4V+kIDZvU0xB+AL4DZ+8lJv4MUzcWbc=;
	h=Date:To:From:Subject:From;
	b=M236kzyW4gQewDOC4UFNbbRAufOruPQzetZa+IBinj5+8z/wvxqWdm6N7b7jWTw+Z
	 e2QaCorhUJHwzrMB4pDd+3c00a6zeHHGmaSeFE6KcCf7ZjuJSEg5qItzIif4oI6f4/
	 VYm8jlPd7gp+fIBS8sjawP7WZcoKX/6CNDZvAGiY=
Date: Sun, 19 Jan 2025 17:39:27 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,linux@roeck-us.net,jack@suse.cz,jimzhao.ai@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page-writeback-consolidate-wb_thresh-bumping-logic-into-__wb_calc_thresh.patch removed from -mm tree
Message-Id: <20250120013928.7A8FCC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page-writeback: consolidate wb_thresh bumping logic into __wb_calc_thresh
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-consolidate-wb_thresh-bumping-logic-into-__wb_calc_thresh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jim Zhao <jimzhao.ai@gmail.com>
Subject: mm/page-writeback: consolidate wb_thresh bumping logic into __wb_calc_thresh
Date: Thu, 21 Nov 2024 18:05:39 +0800

Address the feedback from 39ac99852fca ("mm/page-writeback: raise
wb_thresh to prevent write blocking with strictlimit)".  The wb_thresh
bumping logic is scattered across wb_position_ratio, __wb_calc_thresh, and
wb_update_dirty_ratelimit.  For consistency, consolidate all wb_thresh
bumping logic into __wb_calc_thresh.

Link: https://lkml.kernel.org/r/20241121100539.605818-1-jimzhao.ai@gmail.com
Signed-off-by: Jim Zhao <jimzhao.ai@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   53 ++++++++++++------------------------------
 1 file changed, 16 insertions(+), 37 deletions(-)

--- a/mm/page-writeback.c~mm-page-writeback-consolidate-wb_thresh-bumping-logic-into-__wb_calc_thresh
+++ a/mm/page-writeback.c
@@ -942,26 +942,25 @@ static unsigned long __wb_calc_thresh(st
 	wb_min_max_ratio(wb, &wb_min_ratio, &wb_max_ratio);
 
 	wb_thresh += (thresh * wb_min_ratio) / (100 * BDI_RATIO_SCALE);
-	wb_max_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
-	if (wb_thresh > wb_max_thresh)
-		wb_thresh = wb_max_thresh;
 
 	/*
-	 * With strictlimit flag, the wb_thresh is treated as
-	 * a hard limit in balance_dirty_pages() and wb_position_ratio().
-	 * It's possible that wb_thresh is close to zero, not because
-	 * the device is slow, but because it has been inactive.
-	 * To prevent occasional writes from being blocked, we raise wb_thresh.
+	 * It's very possible that wb_thresh is close to 0 not because the
+	 * device is slow, but that it has remained inactive for long time.
+	 * Honour such devices a reasonable good (hopefully IO efficient)
+	 * threshold, so that the occasional writes won't be blocked and active
+	 * writes can rampup the threshold quickly.
 	 */
-	if (unlikely(wb->bdi->capabilities & BDI_CAP_STRICTLIMIT)) {
-		unsigned long limit = hard_dirty_limit(dom, dtc->thresh);
-		u64 wb_scale_thresh = 0;
-
-		if (limit > dtc->dirty)
-			wb_scale_thresh = (limit - dtc->dirty) / 100;
-		wb_thresh = max(wb_thresh, min(wb_scale_thresh, wb_max_thresh / 4));
+	if (thresh > dtc->dirty) {
+		if (unlikely(wb->bdi->capabilities & BDI_CAP_STRICTLIMIT))
+			wb_thresh = max(wb_thresh, (thresh - dtc->dirty) / 100);
+		else
+			wb_thresh = max(wb_thresh, (thresh - dtc->dirty) / 8);
 	}
 
+	wb_max_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
+	if (wb_thresh > wb_max_thresh)
+		wb_thresh = wb_max_thresh;
+
 	return wb_thresh;
 }
 
@@ -969,6 +968,7 @@ unsigned long wb_calc_thresh(struct bdi_
 {
 	struct dirty_throttle_control gdtc = { GDTC_INIT(wb) };
 
+	domain_dirty_avail(&gdtc, true);
 	return __wb_calc_thresh(&gdtc, thresh);
 }
 
@@ -1145,12 +1145,6 @@ static void wb_position_ratio(struct dir
 	if (unlikely(wb->bdi->capabilities & BDI_CAP_STRICTLIMIT)) {
 		long long wb_pos_ratio;
 
-		if (dtc->wb_dirty < 8) {
-			dtc->pos_ratio = min_t(long long, pos_ratio * 2,
-					   2 << RATELIMIT_CALC_SHIFT);
-			return;
-		}
-
 		if (dtc->wb_dirty >= wb_thresh)
 			return;
 
@@ -1222,14 +1216,6 @@ static void wb_position_ratio(struct dir
 	if (unlikely(wb_thresh > dtc->thresh))
 		wb_thresh = dtc->thresh;
 	/*
-	 * It's very possible that wb_thresh is close to 0 not because the
-	 * device is slow, but that it has remained inactive for long time.
-	 * Honour such devices a reasonable good (hopefully IO efficient)
-	 * threshold, so that the occasional writes won't be blocked and active
-	 * writes can rampup the threshold quickly.
-	 */
-	wb_thresh = max(wb_thresh, (limit - dtc->dirty) / 8);
-	/*
 	 * scale global setpoint to wb's:
 	 *	wb_setpoint = setpoint * wb_thresh / thresh
 	 */
@@ -1484,17 +1470,10 @@ static void wb_update_dirty_ratelimit(st
 	 * balanced_dirty_ratelimit = task_ratelimit * write_bw / dirty_rate).
 	 * Hence, to calculate "step" properly, we have to use wb_dirty as
 	 * "dirty" and wb_setpoint as "setpoint".
-	 *
-	 * We rampup dirty_ratelimit forcibly if wb_dirty is low because
-	 * it's possible that wb_thresh is close to zero due to inactivity
-	 * of backing device.
 	 */
 	if (unlikely(wb->bdi->capabilities & BDI_CAP_STRICTLIMIT)) {
 		dirty = dtc->wb_dirty;
-		if (dtc->wb_dirty < 8)
-			setpoint = dtc->wb_dirty + 1;
-		else
-			setpoint = (dtc->wb_thresh + dtc->wb_bg_thresh) / 2;
+		setpoint = (dtc->wb_thresh + dtc->wb_bg_thresh) / 2;
 	}
 
 	if (dirty < setpoint) {
_

Patches currently in -mm which might be from jimzhao.ai@gmail.com are


