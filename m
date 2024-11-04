Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA8A4C6C
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730694958; cv=none; b=jUCg7ReYm59MKNn33RgWXFkkQy+nyAsyvYbZnfcNaxXS+g0ixfB9n1mBDITENOK3IrV6wOP8ihqC7A9cJ5Nsb9QcQFTSTJAGgBj0y/xK3MKiHT3X0KoqPSXFkqoLwVFYWY9wGGmreZVq87qdCLDm+E8wmv8agLAkWeeRJidaBjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730694958; c=relaxed/simple;
	bh=fLcbCPJ6uzb7GKFbn8R6gVuKmbBR0MonwHzsuRq7yKY=;
	h=Date:To:From:Subject:Message-Id; b=DihKV8Qfwb/tGxk4yMAM9I8auez3VQMzAgObIs+ez78joefnc0gJaDW9NM8PXO7cv7JN3Nvs4zdJ4yKUjrAUX6TV9/B5MabnImAQyJrz2v0GkYHG8HyOWS96pn+5ue3zIbxmc45WHNc8z2Mfi1w5fVRpUHS5omlaixg7w5Av+HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PlNe/5jT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PlNe/5jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C1AC4CECE;
	Mon,  4 Nov 2024 04:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730694958;
	bh=fLcbCPJ6uzb7GKFbn8R6gVuKmbBR0MonwHzsuRq7yKY=;
	h=Date:To:From:Subject:From;
	b=PlNe/5jTk/d0GzXqq1fHCxDS5k+v90X6XUIUzYFQ+qXfmOXUAFR9/V7z4UZa46DbJ
	 1DbDWDF/lOTnsJXPy8MwWCu/bDEO0JuuHIBK7JL1ima+kw/oszZNu4flwvfG4sXYK2
	 Q2JjX9vPjXMIuJCKHPuS27fU6wi4qlIS/1DGRs9c=
Date: Sun, 03 Nov 2024 20:35:57 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,dan.carpenter@linaro.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zram-rework-recompress-target-selection-strategy-fix.patch removed from -mm tree
Message-Id: <20241104043557.F2C1AC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not skip the first bucket
has been removed from the -mm tree.  Its filename was
     zram-rework-recompress-target-selection-strategy-fix.patch

This patch was dropped because it was folded into zram-rework-recompress-target-selection-strategy.patch

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not skip the first bucket
Date: Tue, 1 Oct 2024 17:55:56 +0900

A small fixup.

Link: https://lkml.kernel.org/r/20241001085634.1948384-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-rework-recompress-target-selection-strategy-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -264,7 +264,7 @@ static struct zram_pp_slot *select_pp_sl
 	s32 idx = NUM_PP_BUCKETS - 1;
 
 	/* The higher the bucket id the more optimal slot post-processing is */
-	while (idx > 0) {
+	while (idx >= 0) {
 		pps = list_first_entry_or_null(&ctl->pp_buckets[idx],
 					       struct zram_pp_slot,
 					       entry);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-introduce-zram_pp_slot-flag.patch
zram-permit-only-one-post-processing-operation-at-a-time.patch
zram-rework-recompress-target-selection-strategy.patch
zram-rework-writeback-target-selection-strategy.patch
zram-do-not-mark-idle-slots-that-cannot-be-idle.patch
zram-reshuffle-zram_free_page-flags-operations.patch
zram-remove-under_wb-and-simplify-writeback.patch
zram-do-not-open-code-comp-priority-0.patch
zram-clear-idle-flag-after-recompression.patch
zram-clear-idle-flag-in-mark_idle.patch

