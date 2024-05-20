Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4283FEC
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716164618; cv=none; b=gS02F0wgVxblx/zc36bPr6/OmhMBfa4TMOkV2fYYon9aruBWYiJDO+t3WHBBcmItKajr0LSjWVLGRqLmeL62y1oQe2T3nr0ENoTu7W6vfDaBBZxISidlw7fbEL3Dqiw1QoGRzHBtnmeAk1/eJgrv3f7bITOtJ9C8W2T9JXDNbLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716164618; c=relaxed/simple;
	bh=Diox3WRnx/VmguFkDsndbzgqHN74FbwA2zucTZ1DNnA=;
	h=Date:To:From:Subject:Message-Id; b=CBpqFDw79P6NZLQ0xOZwldLbSkncaMLvgFZbpLqUML7yFhSidwV87d68ckbeUlBOpsk+DUkk3S8lz6+qE0WK9394XhYrtdTlALtjIVGaDSo3mbunS/Fdff7t1AQbsiqnc+1kHpj07y3GpP4qy8jEZqqWqlYPq+lEg6+Z/kTH9e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vvj+zqDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vvj+zqDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9D2C32781;
	Mon, 20 May 2024 00:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716164618;
	bh=Diox3WRnx/VmguFkDsndbzgqHN74FbwA2zucTZ1DNnA=;
	h=Date:To:From:Subject:From;
	b=vvj+zqDVqgsuEOlanZ4uIogBaie9qF85dXmTRGZC/sLY/qdnsOiwwFx7/QfjzeCBE
	 WYqDFX85GD+IADWvTfC6xZliZyjIKokthuddWQJuOI+jdbG+eGaIMdVuwtTRd+FGdA
	 I2n/f9Cg3/FtV+Ed+3yD9hOV1674dyTK3TUOhBzk=
Date: Sun, 19 May 2024 17:23:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-factor-out-wb_dirty_exceeded-to-remove-repeated-code.patch added to mm-unstable branch
Message-Id: <20240520002337.EA9D2C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: factor out wb_dirty_exceeded to remove repeated code
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-factor-out-wb_dirty_exceeded-to-remove-repeated-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-factor-out-wb_dirty_exceeded-to-remove-repeated-code.patch

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
Subject: writeback: factor out wb_dirty_exceeded to remove repeated code
Date: Tue, 14 May 2024 20:52:53 +0800

Factor out wb_dirty_exceeded to remove repeated code

Link: https://lkml.kernel.org/r/20240514125254.142203-8-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
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

writeback-factor-out-wb_bg_dirty_limits-to-remove-repeated-code.patch
writeback-add-general-function-domain_dirty_avail-to-calculate-dirty-and-avail-of-domain.patch
writeback-factor-out-domain_over_bg_thresh-to-remove-repeated-code.patch
writeback-factor-out-code-of-freerun-to-remove-repeated-code.patch
writeback-factor-out-wb_dirty_freerun-to-remove-more-repeated-freerun-code.patch
writeback-factor-out-balance_domain_limits-to-remove-repeated-code.patch
writeback-factor-out-wb_dirty_exceeded-to-remove-repeated-code.patch
writeback-factor-out-balance_wb_limits-to-remove-repeated-code.patch

