Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552003438B5
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 21:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779744706; cv=none; b=F2lgbVStkqn40fdCvLeX/J2kBx3Qpxn+pVnkDm8Mm3J1MkpF5MDHrm7QU8f13ct9NS+po8f/i6jDWVxEVwPwbn0hA6N74SFnCr+lLct4oRecqAjQuFR7ubQ2szy/TmCo+5p6qRE/wHeIepj2PT/x14tTgPLrGWmvkp4+v89+RC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779744706; c=relaxed/simple;
	bh=3iXpzOYc721wjuby94jNnz6dcEqniSzXnV6LpiKAU5E=;
	h=Date:To:From:Subject:Message-Id; b=QL1yiiTjycAFlz3rhYo4+9RMeCLFUCuERVR7G2y8f6DJy6IUBRHSOSNIaoK4IWLNfoLRdXM9deFOVNSNFfRF5giIUSUesjbpjiaSMp+UXn6dEc2I2vnFOINVX2Q6QoWu5lGrv+Qe0m0E4X0IR5AlN0gKQKaF3tTVNqX+djOpjQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P/bMQzZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P/bMQzZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B461F000E9;
	Mon, 25 May 2026 21:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779744705;
	bh=D9gjLaYaMW1Hy8hw51AMnDBwXId6mm5KxEMEi0yHfl8=;
	h=Date:To:From:Subject;
	b=P/bMQzZ9nNMtcggt5k8oL46fd1kEco7J9p8oComftz6P062Sc2AlPnNVbdddSaAHp
	 rhf1ZeG3d30VUBVWiBRebelrIKAjcR30UKU4AYTDIQWGqLYb9ZGeie6DyzuY8gH70C
	 6vbAQQL1pmoGUvOakG51/QXRLgYit9w7Tnrzr5V0=
Date: Mon, 25 May 2026 14:31:44 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-leak-blk-idx-at-the-end-of-writeback.patch added to mm-new branch
Message-Id: <20260525213144.E3B461F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not leak blk idx at the end of writeback
has been added to the -mm mm-new branch.  Its filename is
     zram-do-not-leak-blk-idx-at-the-end-of-writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-leak-blk-idx-at-the-end-of-writeback.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

zram-do-not-leak-blk-idx-at-the-end-of-writeback.patch
zram-clear-trailing-bytes-of-compressed-writeback-pages.patch

