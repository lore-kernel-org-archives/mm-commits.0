Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD0F468E
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716164614; cv=none; b=u6IoxqN8H5x2tU88mq2bfVAxkv1lvTfA+807WVkHBjBCX9+zsOaeDvAFmx1+35uLwkyrqyImCNni5BkGrJQfqfAAt6vPc5pZ5pXsjxL+LJPmQ9mm4Kg+RXSwFzY2TPmFeGKWFkpeW4MzAgfkdJVgqospdWVBRiwnSWeyJ0Syv0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716164614; c=relaxed/simple;
	bh=RrO3vReclu2xAbTj7l0O5N0617RiD0Fv7AW4OvSBvHY=;
	h=Date:To:From:Subject:Message-Id; b=Qa9ogP/0nFYSG2ZB2nreDCRTs3L7zSUNPI/YQ77xEnZ4A7VciH3La0xdWRtx62sh44Y+T6OZNcpvICOZgw205YLQa8g8538RR8hbMuafM4abnacaleLVVwMuCVGTbMn9puLc/yRWgBb5n5Kw5dire34covhOPujEDibrpqGu6aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=de0TwAYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="de0TwAYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE59C32781;
	Mon, 20 May 2024 00:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716164614;
	bh=RrO3vReclu2xAbTj7l0O5N0617RiD0Fv7AW4OvSBvHY=;
	h=Date:To:From:Subject:From;
	b=de0TwAYXdrMOydlrOtpX5fpovujuA5Vv1jzWnkAnpkgm1fWOyQPA1cRXB8JytgWH+
	 P37b37jiKGbrDI2bwdG65uaz1090X/sZNQ+zkIdYgCTl/eeYZW0rJokD8SrkwvoLoo
	 TFE6EDhRcGxmvsp3L5rYTAc0UxI2m459wz9kO1Dw=
Date: Sun, 19 May 2024 17:23:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-factor-out-wb_dirty_freerun-to-remove-more-repeated-freerun-code.patch added to mm-unstable branch
Message-Id: <20240520002334.5EE59C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: factor out wb_dirty_freerun to remove more repeated freerun code
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-factor-out-wb_dirty_freerun-to-remove-more-repeated-freerun-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-factor-out-wb_dirty_freerun-to-remove-more-repeated-freerun-code.patch

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
Subject: writeback: factor out wb_dirty_freerun to remove more repeated freerun code
Date: Tue, 14 May 2024 20:52:51 +0800

Factor out wb_dirty_freerun to remove more repeated freerun code.

Link: https://lkml.kernel.org/r/20240514125254.142203-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   53 +++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

--- a/mm/page-writeback.c~writeback-factor-out-wb_dirty_freerun-to-remove-more-repeated-freerun-code
+++ a/mm/page-writeback.c
@@ -1746,6 +1746,27 @@ static void domain_dirty_freerun(struct
 	dtc->freerun = dirty <= dirty_freerun_ceiling(thresh, bg_thresh);
 }
 
+static void wb_dirty_freerun(struct dirty_throttle_control *dtc,
+			     bool strictlimit)
+{
+	dtc->freerun = false;
+
+	/* was already handled in domain_dirty_freerun */
+	if (strictlimit)
+		return;
+
+	wb_dirty_limits(dtc);
+	/*
+	 * LOCAL_THROTTLE tasks must not be throttled when below the per-wb
+	 * freerun ceiling.
+	 */
+	if (!(current->flags & PF_LOCAL_THROTTLE))
+		return;
+
+	dtc->freerun = dtc->wb_dirty <
+		       dirty_freerun_ceiling(dtc->wb_thresh, dtc->wb_bg_thresh);
+}
+
 /*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
@@ -1838,19 +1859,9 @@ free_running:
 		 * Calculate global domain's pos_ratio and select the
 		 * global dtc by default.
 		 */
-		if (!strictlimit) {
-			wb_dirty_limits(gdtc);
-
-			if ((current->flags & PF_LOCAL_THROTTLE) &&
-			    gdtc->wb_dirty <
-			    dirty_freerun_ceiling(gdtc->wb_thresh,
-						  gdtc->wb_bg_thresh))
-				/*
-				 * LOCAL_THROTTLE tasks must not be throttled
-				 * when below the per-wb freerun ceiling.
-				 */
-				goto free_running;
-		}
+		wb_dirty_freerun(gdtc, strictlimit);
+		if (gdtc->freerun)
+			goto free_running;
 
 		dirty_exceeded = (gdtc->wb_dirty > gdtc->wb_thresh) &&
 			((gdtc->dirty > gdtc->thresh) || strictlimit);
@@ -1865,20 +1876,10 @@ free_running:
 			 * both global and memcg domains.  Choose the one
 			 * w/ lower pos_ratio.
 			 */
-			if (!strictlimit) {
-				wb_dirty_limits(mdtc);
+			wb_dirty_freerun(mdtc, strictlimit);
+			if (mdtc->freerun)
+				goto free_running;
 
-				if ((current->flags & PF_LOCAL_THROTTLE) &&
-				    mdtc->wb_dirty <
-				    dirty_freerun_ceiling(mdtc->wb_thresh,
-							  mdtc->wb_bg_thresh))
-					/*
-					 * LOCAL_THROTTLE tasks must not be
-					 * throttled when below the per-wb
-					 * freerun ceiling.
-					 */
-					goto free_running;
-			}
 			dirty_exceeded |= (mdtc->wb_dirty > mdtc->wb_thresh) &&
 				((mdtc->dirty > mdtc->thresh) || strictlimit);
 
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

