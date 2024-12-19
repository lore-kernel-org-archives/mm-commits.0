Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB97171D2
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 00:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734569881; cv=none; b=kVXcbmNsjka5BRiqUjJLB+I3FYR3yJFVHT0MVGg7xE1e8w6Psu0QGjkSgQ79fEOGR+NG7j2TZzQW1yWLQNCXHX+BiTZp0PbASkS4q/pgOBkpAXPJh1NCRHkKAErCrgSy/DZ2C/dqr+2Cg463FCrTIj7/m9BDp5u5M1NggnhxGaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734569881; c=relaxed/simple;
	bh=OFbgET0hqrO1J+bWGHonLjpmmLivF6XWyWYeDtmLsVo=;
	h=Date:To:From:Subject:Message-Id; b=fAErnqZyE2j9e90A0XCETF3bE0+24zLbUeb06pZDMskJFNhf1u5UF9ZkSt8LbCmU9tz+7MhgRQUvtHBHRhm5DLLox3var7O5F/777vMnZNKg+rYoGyTCDymbPl49qnwBmHNrnoXVp/IT1ZjmC6gkBghojU9vi2GFRc20YDHb4gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hJ4drsUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hJ4drsUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDF1C4CECD;
	Thu, 19 Dec 2024 00:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734569880;
	bh=OFbgET0hqrO1J+bWGHonLjpmmLivF6XWyWYeDtmLsVo=;
	h=Date:To:From:Subject:From;
	b=hJ4drsUijkQNaqGBuTicLLoaB0AMKzHCQqCBwI9VS1grDPsYWOGeHsfnt4DK6m94M
	 2qSsJgLZhw5opSQNy2dIqzfsgTSkaPfQE6n0hvIuwac22ee17NwQwhQTy2U8oqcLV3
	 8v9l5U7/koLebSoYPfli8PTM9dVdUGZOrgu7IiNo=
Date: Wed, 18 Dec 2024 16:58:00 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-cond_resched-in-writeback-loop.patch added to mm-unstable branch
Message-Id: <20241219005800.9BDF1C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: cond_resched() in writeback loop
has been added to the -mm mm-unstable branch.  Its filename is
     zram-cond_resched-in-writeback-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-cond_resched-in-writeback-loop.patch

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
Subject: zram: cond_resched() in writeback loop
Date: Wed, 18 Dec 2024 15:34:24 +0900

zram writeback is a costly operation, because every target slot (unless
ZRAM_HUGE) is decompressed before it gets written to a backing device. 
The writeback to a backing device uses submit_bio_wait() which may look
like a rescheduling point.  However, if the backing device has
BD_HAS_SUBMIT_BIO bit set __submit_bio() calls directly
disk->fops->submit_bio(bio) on the backing device and so when
submit_bio_wait() calls blk_wait_io() the I/O is already done.  On such
systems we effective end up in a loop

    for_each (target slot) {
	decompress(slot)
	__submit_bio()
	    disk->fops->submit_bio(bio)
    }

Which on PREEMPT_NONE systems triggers watchdogs (since there are no
explicit rescheduling points).  Add cond_resched() to the zram writeback
loop.

Link: https://lkml.kernel.org/r/20241218063513.297475-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-cond_resched-in-writeback-loop
+++ a/drivers/block/zram/zram_drv.c
@@ -884,6 +884,8 @@ static ssize_t writeback_store(struct de
 next:
 		zram_slot_unlock(zram, index);
 		release_pp_slot(zram, pps);
+
+		cond_resched();
 	}
 
 	if (blk_idx)
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch
zram-use-zram_read_from_zspool-in-writeback.patch
zram-cond_resched-in-writeback-loop.patch

