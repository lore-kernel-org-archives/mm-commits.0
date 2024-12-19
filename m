Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4A5171D2
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 00:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734569879; cv=none; b=LWMmJxeFJAfQ7yulYT30hIjWCzsNBohHzwOCrqCqG98ZCeyyRWC4oevB+5aYcQD/bTqQv4EqCIFbVH7OFJFgdwK+h5YUos6FC634bTRUe2FS/b8702RjBWvfT3UwSYS/XBwwoggPeMdiJL53vCCxBSZU0Uo1fUCN/OpyzaaGf6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734569879; c=relaxed/simple;
	bh=ANeDhRTdWg7aLn1RJBFr461JVDzlmsei17J5PD5ulFw=;
	h=Date:To:From:Subject:Message-Id; b=XtTAM92Ls4YOnHP7ejvokoOA6FySvVHi+WgKDiO6rOGzCoLmPyn8QBYzLEuCLD5OOXaAsQGpKlvh1Ga58KmDgZR+td6xoB6DXxb8CEPj0wEo6EOU31uAIRiNifojXh2RncmX7GLFvCUSxUIMn+y0o9olEqqJYzIkuOUaXA1xqLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yIHRe+pT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yIHRe+pT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF38C4CECD;
	Thu, 19 Dec 2024 00:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734569878;
	bh=ANeDhRTdWg7aLn1RJBFr461JVDzlmsei17J5PD5ulFw=;
	h=Date:To:From:Subject:From;
	b=yIHRe+pTW2p/kApSBsjU+hWYGX4YtstrErPdWHVgPt/+l+eaY2/DfYSRayZPv2qKL
	 PJpnVy2dcjq+BQzmpsAteUMuXjeLimZp1O0lcC1G1Xuy/4GlSfevOSMdtW01kh1zFq
	 c9hEvPJBMY5tjWxjg5IaX6xZ6uW2Zx2FfiEUAR30=
Date: Wed, 18 Dec 2024 16:57:58 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-use-zram_read_from_zspool-in-writeback.patch added to mm-unstable branch
Message-Id: <20241219005758.ADF38C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: use zram_read_from_zspool() in writeback
has been added to the -mm mm-unstable branch.  Its filename is
     zram-use-zram_read_from_zspool-in-writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-use-zram_read_from_zspool-in-writeback.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: use zram_read_from_zspool() in writeback
Date: Wed, 18 Dec 2024 15:34:23 +0900

We only can read pages from zspool in writeback, zram_read_page() is not
really right in that context not only because it's a more generic function
that handles ZRAM_WB pages, but also because it requires us to unlock slot
between slot flag check and actual page read.  Use zram_read_from_zspool()
instead and do slot flags check and page read under the same slot lock.

Link: https://lkml.kernel.org/r/20241218063513.297475-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-zram_read_from_zspool-in-writeback
+++ a/drivers/block/zram/zram_drv.c
@@ -55,8 +55,8 @@ static size_t huge_class_size;
 static const struct block_device_operations zram_devops;
 
 static void zram_free_page(struct zram *zram, size_t index);
-static int zram_read_page(struct zram *zram, struct page *page, u32 index,
-			  struct bio *parent);
+static int zram_read_from_zspool(struct zram *zram, struct page *page,
+				 u32 index);
 
 static int zram_slot_trylock(struct zram *zram, u32 index)
 {
@@ -831,13 +831,10 @@ static ssize_t writeback_store(struct de
 		 */
 		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
+		if (zram_read_from_zspool(zram, page, index))
+			goto next;
 		zram_slot_unlock(zram, index);
 
-		if (zram_read_page(zram, page, index, NULL)) {
-			release_pp_slot(zram, pps);
-			continue;
-		}
-
 		bio_init(&bio, zram->bdev, &bio_vec, 1,
 			 REQ_OP_WRITE | REQ_SYNC);
 		bio.bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch
zram-use-zram_read_from_zspool-in-writeback.patch
zram-cond_resched-in-writeback-loop.patch

