Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7028B7FBA2
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 18:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764441702; cv=none; b=EUajaiRs84P/jlHBFXta01Mdnjs4vaqhm/ttzqa5ozHwxIZVYogkhZ0te6QqTUmWzI71izFK13stdB+aXmu6ftb6+Jl/rQMbt2Y42qKp5lyq8juYzST07/LTlfCuMo6o7sQ6D/kHeDGqF25CMM93oE9yAKC/At5ISYuhyHLOLhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764441702; c=relaxed/simple;
	bh=5Ps1rinsQcMtnf29L6DsgmHNgA4cABQAjgySDvIpMr4=;
	h=Date:To:From:Subject:Message-Id; b=sOVYR7iimNxWodDoLAyg5c9ftESheSrHbrP3quoX43exdaFJ/bRdi/UShRpPPTYhObzmxzWuf3qlpRE9bN7v31mWZUgXDHgIjdpR1lMIc6Wjm0n/uPBMA8V/axdWjDIkMm6a+5aYp/wg7uVZzxt7963aVJ0Ya1052HoI75ttQPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xy0KdgoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xy0KdgoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084ECC4CEF7;
	Sat, 29 Nov 2025 18:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764441702;
	bh=5Ps1rinsQcMtnf29L6DsgmHNgA4cABQAjgySDvIpMr4=;
	h=Date:To:From:Subject:From;
	b=Xy0KdgoU0C42ZJrGes8qPf6l8rdturKgOgJVRIASu2NYh4/cG5K+gg1ZAcPSKirCC
	 E2mQHi/u1L5ylsOnAp2uhe6mhk9DtEp/bUWJEOB9lrT1EmNel7YWFDJaHK0Mh2kl2v
	 Zy4p3OzFHvQnucdgguJhIOD8+Xfg0NEKZG1BpMHA=
Date: Sat, 29 Nov 2025 10:41:41 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,chuguangqing@inspur.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-fix-a-spelling-mistake.patch removed from -mm tree
Message-Id: <20251129184142.084ECC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fix a spelling mistake
has been removed from the -mm tree.  Its filename was
     zram-fix-a-spelling-mistake.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chu Guangqing <chuguangqing@inspur.com>
Subject: zram: fix a spelling mistake
Date: Tue, 25 Nov 2025 10:05:22 +0800

The spelling of the word "relases" is incorrect; it should be "releases".

Link: https://lkml.kernel.org/r/20251125020522.1913-1-chuguangqing@inspur.com
Signed-off-by: Chu Guangqing <chuguangqing@inspur.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-a-spelling-mistake
+++ a/drivers/block/zram/zram_drv.c
@@ -1043,7 +1043,7 @@ static int zram_writeback_slots(struct z
 		index = pps->index;
 		zram_slot_lock(zram, index);
 		/*
-		 * scan_slots() sets ZRAM_PP_SLOT and relases slot lock, so
+		 * scan_slots() sets ZRAM_PP_SLOT and releases slot lock, so
 		 * slots can change in the meantime. If slots are accessed or
 		 * freed they lose ZRAM_PP_SLOT flag and hence we don't
 		 * post-process them.
_

Patches currently in -mm which might be from chuguangqing@inspur.com are


