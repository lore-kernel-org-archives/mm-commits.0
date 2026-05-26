Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FB7395AC3
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 20:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779825710; cv=none; b=tOylkN2GbaL4kJgfrBRM4JXYBNcGAcDT1IiQJPTS0pyuu6ZsmPd2Pbms8+HLGM5beEA4iDRIaHvAfATRufxDkVhRUJisIXvOdsfljbeUjDJ0eRSoGvh2LMjMgM922PqKypYt5nXblXjN4I9EgHChOPDW4PBM0m3YbyyCHasC8J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779825710; c=relaxed/simple;
	bh=GATdQKl/g1kkwgJAD9eE+AmYwEb1o8xqs8zDbFyS1Sw=;
	h=Date:To:From:Subject:Message-Id; b=Fvjx1QNi0nSrPPe8bkQH7oelj6936Ll2piWNrM0fC5vBgQwv2FDQKt8EsfgRUYv08k6taq4anlOOIKI5U+kp7KtkEvzA4+Xm17ARg0DamAJL0Uojq+tcPtZZezy16oMIz45HdCQCT7oaOrsnzyet2q33clp486ChUIiDIcx5hQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=od2ob4iZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="od2ob4iZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5C41F000E9;
	Tue, 26 May 2026 20:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779825708;
	bh=8OOymiD/4Bk9T9PZCX2p6gAaZEHSgLC8Nn3//XsKUKk=;
	h=Date:To:From:Subject;
	b=od2ob4iZTWg5JH9BTRyvRyNQ0etbXHZ4GXfQ0vSw/0c7s+bGwv7Qdo8CDvrXo+r2y
	 HYrtZucUqQS4VFGj2KneU+mYT/ZC6JUqHJsHavP322yJWGOsZcvKJPm6B1oBmCMXHx
	 7ucQCRiVVaLrNs7VBbOD6Sg4SKvfQtZChfjgTPWw=
Date: Tue, 26 May 2026 13:01:47 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zram-do-not-leak-blk-idx-at-the-end-of-writeback.patch removed from -mm tree
Message-Id: <20260526200148.1A5C41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not leak blk idx at the end of writeback
has been removed from the -mm tree.  Its filename was
     zram-do-not-leak-blk-idx-at-the-end-of-writeback.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not leak blk idx at the end of writeback
Date: Mon, 25 May 2026 13:46:01 +0900

Patch series "zram: writeback fixes".

Brian reported several issues with zram's writeback implementation.
This small series addresses those issues.


This patch (of 2):

In certain cases zram_writeback_slots() loop can terminate with blk_idx
being valid (in particular when we race with modification of last slot)
but zram_writeback_slots() forgets to release the reserved block id, which
leads to this block becoming unavailable for future writeback.  Release
valid blk_idx before returning from zram_writeback_slots().

Link: https://lore.kernel.org/20260525044639.1888561-1-senozhatsky@chromium.org
Link: https://lore.kernel.org/20260525044639.1888561-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-leak-blk-idx-at-the-end-of-writeback
+++ a/drivers/block/zram/zram_drv.c
@@ -1127,6 +1127,9 @@ next:
 	if (req)
 		release_wb_req(req);
 
+	if (blk_idx != INVALID_BDEV_BLOCK)
+		zram_release_bdev_block(zram, blk_idx);
+
 	while (atomic_read(&wb_ctl->num_inflight) > 0) {
 		wait_event(wb_ctl->done_wait, !list_empty(&wb_ctl->done_reqs));
 		err = zram_complete_done_reqs(zram, wb_ctl);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-clear-trailing-bytes-of-compressed-writeback-pages.patch

