Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205033C4B94
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439218; cv=none; b=QXP5BPVzFiUDCrV2kGKZ/Prev+Glr84IIQSPpsOK4efis3YHpObtX25Yyv21+1+PqfDBGZ5Z+3qEBQJN4BdZESIKSNCqHxNZ+zT1PNeI8Cfhu6bFCnntN5kgdGFwbIw/v5fa2PXb3Us6a4r2P6zdSW/wx2yDIdIXaKci2alcxZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439218; c=relaxed/simple;
	bh=EpJa72pAypjL+Iso4b/eaONszaXrLIFgioJkgMbhv+w=;
	h=Date:To:From:Subject:Message-Id; b=ng12GWZKHM84hZAcWhJrEDV0UxHuAeewAkfaQZ30C+eCiDvEcuft1W72YQPWWjYQYv5+SpYDJav0XOJrdDneHnSbtpTxVSEcllXYRGuiyCn4YfkSZf7UthD8GpUsSYZ6mOfxex5bZsfk/DYISScUfy6Odlo/O247kC/abzxejtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MldwVdjP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MldwVdjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F0B1F00898;
	Tue,  2 Jun 2026 22:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439216;
	bh=MoNy4Mw0YmLhLQFuiznMVY8v2j9F7QnKlAJIguPArwo=;
	h=Date:To:From:Subject;
	b=MldwVdjPCu3q/A+lTZuuTfde5ZXIRuAECRZn7ITHJ7bryCNzKTOhYx1qwjNam7IZa
	 8CLWz15Kk3toUH6bXu0sEjle/blakTdN7JZh5SWEkY125NwwXLljm1ePlZeqJHLSi0
	 FnYZDyZ66ztPgfrRwP+P8wjSbLuIWvJC0UcMIlm8=
Date: Tue, 02 Jun 2026 15:26:55 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-do-not-leak-blk-idx-at-the-end-of-writeback.patch removed from -mm tree
Message-Id: <20260602222655.E7F0B1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not leak blk idx at the end of writeback
has been removed from the -mm tree.  Its filename was
     zram-do-not-leak-blk-idx-at-the-end-of-writeback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not leak blk idx at the end of writeback
Date: Tue, 26 May 2026 11:27:16 +0900

zram_writeback_slots() loop can terminate with valid reserved backing
device blk_idx.  The problem is that cleanup code doesn't release that
reserved blk_idx before zram_writeback_slots() returns, which leads to
blk_idx leak (it becomes permanently busy and can not be used for actual
writeback.) This does not lead to any system instabilities, it only means
that we can writeback less pages.  The scenario is hard to hit in practice
as it requires writeabck to race with modification (slot-free or
overwrite) of the final post-processing slot.

Release reserved but unused blk_idx before returning from
zram_writeback_slots().

Link: https://lore.kernel.org/20260526022754.2377730-2-senozhatsky@chromium.org
Fixes: f405066a1f0db ("zram: introduce writeback bio batching")
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


