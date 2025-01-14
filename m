Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D1624335F
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837102; cv=none; b=q+4+1Jr+Gf4vIwT411GTadLZJoa+iKqoRseKyB/i8NdjaN/NmT01+YnKgP/6bOPnd/o77fQlPB4vEqUw5gP5amQkf/fGPM5Xv4jSGIXQjBUfrmaEs9RQF1xAPSes6SFjcUvKZ1e2+oYUmZjuYhwzcgHbdNX08kb9NhP9yNqe95U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837102; c=relaxed/simple;
	bh=3YbuISteV1iHJAatvR9TvgsoDfXQAHHxGxjbIxMq2JY=;
	h=Date:To:From:Subject:Message-Id; b=IIr3lKqZ/VDafI2V+ssZyGkN0Red1webH/bMv6EagN3eR9xCf7A+cup4FfWSSl7CnNMXphq9cVNlp0DFwZA6JwJGPNtrMPVP7PJA9kLopjnyudeNcI6YloJPzc9ONCK/4bQH4A6ka5DArAIqI0v5/k5w6OLH4MhhEpnXTXbrOjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GWRZZbQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GWRZZbQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7A8C4CEDD;
	Tue, 14 Jan 2025 06:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837101;
	bh=3YbuISteV1iHJAatvR9TvgsoDfXQAHHxGxjbIxMq2JY=;
	h=Date:To:From:Subject:From;
	b=GWRZZbQHmzXct9mAnh2uj5NeTLvgIrYfdLFiqUOW8ioZb3LyRXhma6f4/vqiZ/7Te
	 G4qDlhQY0OXWAtjQlZPqiMsyC43cz9tEudOhCKagDjKFJc61dHWc1LuCHksEb6738n
	 o17nlsrKlUxNJ/+QrxC73u/vOP26h9R4a1OiTeFs=
Date: Mon, 13 Jan 2025 22:45:01 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-cond_resched-in-writeback-loop.patch removed from -mm tree
Message-Id: <20250114064501.DC7A8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: cond_resched() in writeback loop
has been removed from the -mm tree.  Its filename was
     zram-cond_resched-in-writeback-loop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


