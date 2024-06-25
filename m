Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C6713C9DE
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291545; cv=none; b=GkD9UrgopULn/iICEHBWbas77a+PSFTQb/R9fKCzaITtYHFa2RRSOP1dArxCr0TD6XK4cEu8Sn5Ul4/ZVr9SKQXraUY6HZiLVzf/a7g//9rfqBriFay9zetensirCC1annvSjP/ggYDGIl38W1goVvy0GTNDjNbpb0PWot8zFbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291545; c=relaxed/simple;
	bh=i3NAekGXIbnvD+/YAHp/7qp5fsn23SmDHMy9eOJTnAM=;
	h=Date:To:From:Subject:Message-Id; b=VD7p2cZTsG7V1yvU+YIEFD/VR3GoD2A4HwcjKRwCwu3uueb8a/D60GqCYVUjXmsGdxlNHi5qOxtBsDeQgXIXqTHU09AEVoSFpmpGbY32ZLryAiyGQI3FH68R4oJoIJ/T+MQ9CWAwI8HqvBJQtT2pkf6w2IH6wlbnSuEjOcpXejs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DonjxRR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DonjxRR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD07C32782;
	Tue, 25 Jun 2024 04:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291545;
	bh=i3NAekGXIbnvD+/YAHp/7qp5fsn23SmDHMy9eOJTnAM=;
	h=Date:To:From:Subject:From;
	b=DonjxRR9vVP4HijivbqgQJIF14iMgB7+EQtQmZkx7PSfBp+TtzEVT0VNGJ1ubeFrT
	 1y5ZtZfF3awBNe9hmD5Ddi11F3Wf9Hk1Ak7xjhBC9PhR5XgvMsJYjI5iNaH97olsdU
	 f6ngFK0M19/G6b0Kgj4XlLJO1vuGLBypJpv9M6kA=
Date: Mon, 24 Jun 2024 21:59:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-factor-out-wb_dirty_exceeded-to-remove-repeated-code.patch removed from -mm tree
Message-Id: <20240625045905.3DD07C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: factor out wb_dirty_exceeded to remove repeated code
has been removed from the -mm tree.  Its filename was
     writeback-factor-out-wb_dirty_exceeded-to-remove-repeated-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: writeback: factor out wb_dirty_exceeded to remove repeated code
Date: Tue, 14 May 2024 20:52:53 +0800

Factor out wb_dirty_exceeded to remove repeated code

Link: https://lkml.kernel.org/r/20240514125254.142203-8-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/page-writeback.c~writeback-factor-out-wb_dirty_exceeded-to-remove-repeated-code
+++ a/mm/page-writeback.c
@@ -140,6 +140,7 @@ struct dirty_throttle_control {
 
 	unsigned long		pos_ratio;
 	bool			freerun;
+	bool			dirty_exceeded;
 };
 
 /*
@@ -1775,6 +1776,13 @@ static void wb_dirty_freerun(struct dirt
 		       dirty_freerun_ceiling(dtc->wb_thresh, dtc->wb_bg_thresh);
 }
 
+static inline void wb_dirty_exceeded(struct dirty_throttle_control *dtc,
+				     bool strictlimit)
+{
+	dtc->dirty_exceeded = (dtc->wb_dirty > dtc->wb_thresh) &&
+		((dtc->dirty > dtc->thresh) || strictlimit);
+}
+
 /*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
@@ -1797,7 +1805,6 @@ static int balance_dirty_pages(struct bd
 	long max_pause;
 	long min_pause;
 	int nr_dirtied_pause;
-	bool dirty_exceeded = false;
 	unsigned long task_ratelimit;
 	unsigned long dirty_ratelimit;
 	struct backing_dev_info *bdi = wb->bdi;
@@ -1866,9 +1873,7 @@ free_running:
 		if (gdtc->freerun)
 			goto free_running;
 
-		dirty_exceeded = (gdtc->wb_dirty > gdtc->wb_thresh) &&
-			((gdtc->dirty > gdtc->thresh) || strictlimit);
-
+		wb_dirty_exceeded(gdtc, strictlimit);
 		wb_position_ratio(gdtc);
 		sdtc = gdtc;
 
@@ -1883,17 +1888,14 @@ free_running:
 			if (mdtc->freerun)
 				goto free_running;
 
-			dirty_exceeded |= (mdtc->wb_dirty > mdtc->wb_thresh) &&
-				((mdtc->dirty > mdtc->thresh) || strictlimit);
-
+			wb_dirty_exceeded(mdtc, strictlimit);
 			wb_position_ratio(mdtc);
 			if (mdtc->pos_ratio < gdtc->pos_ratio)
 				sdtc = mdtc;
 		}
 
-		if (dirty_exceeded != wb->dirty_exceeded)
-			wb->dirty_exceeded = dirty_exceeded;
-
+		wb->dirty_exceeded = gdtc->dirty_exceeded ||
+				     (mdtc && mdtc->dirty_exceeded);
 		if (time_is_before_jiffies(READ_ONCE(wb->bw_time_stamp) +
 					   BANDWIDTH_INTERVAL))
 			__wb_update_bandwidth(gdtc, mdtc, true);
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


