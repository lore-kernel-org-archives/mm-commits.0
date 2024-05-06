Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA0836B01
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957122; cv=none; b=FHmJR5wK0L0PbQ61oJaCmsjbYTmjS/m5NajyCK0WQxRMDN/JmJjYbzu33g2oLljdOY2acQOSf91+6huWxyHQrHfdDhZV88RhWwRSlY/y8GxUR+6ePmkmdGF5ZhtA0oyrXLCZz4LEHAYagrcMzrC+/VHgTzrsP14s0rVLRVLEuuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957122; c=relaxed/simple;
	bh=DnxGMZLz96us1S7fX6l03yaM5Pu9QNO7fcfkSDKJDE8=;
	h=Date:To:From:Subject:Message-Id; b=OA3iN5AOlTVTSuypYl/48qNsZK1GA6esHMTiUFEU+aHyh3ygxTGmyP6CqLB+uj2JMUgHR6ESU+by7X3GTbdfrgKaWxM+UrfGkMnt1aLXSd1HE2bUCvNbNcfxnTRfn2uPxYreWRLhYRXuGbgzRQGNK8iGc019Px0oQSfoUKh81eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1sHiRcki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1sHiRcki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B11DC113CC;
	Mon,  6 May 2024 00:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957122;
	bh=DnxGMZLz96us1S7fX6l03yaM5Pu9QNO7fcfkSDKJDE8=;
	h=Date:To:From:Subject:From;
	b=1sHiRckiD423HZDLJM584yBNFVYDvDfTLg/cUgHkrikmWkMANOqPqxkrYIHb/Aywi
	 96H1fyx6IECtJsDutE1YYPaiAm1i8xffDX/3wf9iTWLZ2iHjEnTV1aIcGHmnsD5oPE
	 OwmZB4a2o1iKW+0Q/n33srOcD3V/Lz2zpzcdFAJo=
Date: Sun, 05 May 2024 17:58:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tj@kernel.org,mszeredi@redhat.com,jack@suse.cz,hcochran@kernelspring.com,axboe@kernel.dk,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-call-__wb_calc_thresh-instead-of-wb_calc_thresh-in-wb_over_bg_thresh.patch removed from -mm tree
Message-Id: <20240506005842.3B11DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: call __wb_calc_thresh instead of wb_calc_thresh in wb_over_bg_thresh
has been removed from the -mm tree.  Its filename was
     mm-call-__wb_calc_thresh-instead-of-wb_calc_thresh-in-wb_over_bg_thresh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: call __wb_calc_thresh instead of wb_calc_thresh in wb_over_bg_thresh
Date: Thu, 25 Apr 2024 21:17:23 +0800

Call __wb_calc_thresh to calculate wb bg_thresh of gdtc in
wb_over_bg_thresh to remove unnecessary wrap in wb_calc_thresh.

Link: https://lkml.kernel.org/r/20240425131724.36778-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Howard Cochran <hcochran@kernelspring.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-call-__wb_calc_thresh-instead-of-wb_calc_thresh-in-wb_over_bg_thresh
+++ a/mm/page-writeback.c
@@ -2117,7 +2117,7 @@ bool wb_over_bg_thresh(struct bdi_writeb
 	if (gdtc->dirty > gdtc->bg_thresh)
 		return true;
 
-	thresh = wb_calc_thresh(gdtc->wb, gdtc->bg_thresh);
+	thresh = __wb_calc_thresh(gdtc, gdtc->bg_thresh);
 	if (thresh < 2 * wb_stat_error())
 		reclaimable = wb_stat_sum(wb, WB_RECLAIMABLE);
 	else
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


