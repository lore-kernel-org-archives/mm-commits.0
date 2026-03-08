Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97AF38E110
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 18:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772996156; cv=none; b=Di24x0dF3Z2/rI045mj6Bub1yiS6HhGh9WN52tX4hVXL5fhx89R6O+webYtQajuL2AP5r92Tm9fr8BZskPekzyu6GS/MZGLtDUMv88FRoMXFMOj7TT/7/y/QLFzzDApyEpPwko35fUcM48GfPpu1HCAcdKQD/yHoanAClAw5nbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772996156; c=relaxed/simple;
	bh=+9Y7b6zhq2jGi1IU89LDj9pmx8iWCevZsH2mjOgsr3E=;
	h=Date:To:From:Subject:Message-Id; b=mty8hmAEUx9eankTbR+eYCRyuEvnA/X8UiAxEAHx8hB2K82PIwa+1xPAy7yZ4Q6bFYeJFMrpb5nQ4PmGRS2Oxx6fRwrmEckBPu0vm0SPlkRd4fUns6g4yndlXICxyWS74rUIO6k4Efbm/EL1gO4seMAYY1Z47Vr27usmyIP0IfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AB2vFDIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AB2vFDIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FBAC116C6;
	Sun,  8 Mar 2026 18:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772996156;
	bh=+9Y7b6zhq2jGi1IU89LDj9pmx8iWCevZsH2mjOgsr3E=;
	h=Date:To:From:Subject:From;
	b=AB2vFDIq7pTKFsbhXpoZdFfBwutSgEOuH+Jym5NgjUOxYllKovdK6Uroxc+rBZ5Xr
	 pLA60sBYig0LxnmLAprSnf20mZwY4NjKOdg5wJTzJ7uPPNuTlVqk+4e/Sa+dUke4/W
	 DNIRKI/KixCtfnpbyFMzRbVyF5RvesIIzJ6qZTNU=
Date: Sun, 08 Mar 2026 11:55:55 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] zram-use-gfp_kernel-for-post-processing-slot-allocation.patch removed from -mm tree
Message-Id: <20260308185556.61FBAC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: use GFP_KERNEL for post-processing slot allocation
has been removed from the -mm tree.  Its filename was
     zram-use-gfp_kernel-for-post-processing-slot-allocation.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: use GFP_KERNEL for post-processing slot allocation
Date: Thu, 5 Mar 2026 11:16:03 +0900

Post-processing slot allocation used to be performed under slot bit-lock,
so gfp was restricted, then we switched to a sleepable slot lock but gpf
still remained restricted.  Drop that restriction and use GFP_KERNEL
instead.

Link: https://lkml.kernel.org/r/20260305021619.617481-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-gfp_kernel-for-post-processing-slot-allocation
+++ a/drivers/block/zram/zram_drv.c
@@ -297,7 +297,7 @@ static bool place_pp_slot(struct zram *z
 	struct zram_pp_slot *pps;
 	u32 bid;
 
-	pps = kmalloc_obj(*pps, GFP_NOIO | __GFP_NOWARN);
+	pps = kmalloc_obj(*pps, GFP_KERNEL | __GFP_NOWARN);
 	if (!pps)
 		return false;
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-recompression-priority-param-should-override-algo.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch

