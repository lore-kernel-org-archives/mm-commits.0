Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567863B4EA9
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 20:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779825822; cv=none; b=ZwpboVaBrUcw59ok+7+eTSsSXgU8MvehH84Bdj3y2UKY5Uouys4bDcUy8HFAMDoxICdvb3MQot8i4VwprOCzXp8OJ6zXiVQaoUbid0bvdwL1+nFBUpCJhBHU0DvNyXV1ROme/BqvPi1U2KgwYdUyzrkEJXHi2n0DKiDTAa/cNCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779825822; c=relaxed/simple;
	bh=Sn6QZ+2150P1E2VYHVPIesu25K19DkrUhLIElVTd36w=;
	h=Date:To:From:Subject:Message-Id; b=PyAz8F4dj4qOocjNV2jFPxqa7xIywoCjGPKTLD9u96/H6iDiZCDdIp7hJnWw5bzb4U03AL3aYAc6MEKSz7henPmA6rrjoEzOn7uSQUXaCExcDrCR2FNEIy7RJ+EmAaq6QSJNu3WrsgEVp1xyld62r+yZgnZBg0OI4WlgNTss/1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L7W61U0C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L7W61U0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43861F000E9;
	Tue, 26 May 2026 20:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779825819;
	bh=wRcHeu0xuPbS3zx14weM0wcb9YlEhZ5jZH2O00F/lmg=;
	h=Date:To:From:Subject;
	b=L7W61U0CAZW/J6Oqijn5DG29UYx5bizem9kFlqhZafbt1kkMu9PUekpcsQ2Bb+2kD
	 o2X273qlV2ZbX7n0Yw8eCmMvKW0cXoQG/oC1cSOpt6bGzBAkRmhG1MO0pAtOjkV6ho
	 pzNC5PaE5S4UgyT4txn/d/i/hxXK2u9x++bcb4pA=
Date: Tue, 26 May 2026 13:03:39 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-leak-blk-idx-at-the-end-of-writeback.patch added to mm-new branch
Message-Id: <20260526200339.C43861F000E9@smtp.kernel.org>
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

zram-do-not-leak-blk-idx-at-the-end-of-writeback.patch
zram-clear-trailing-bytes-of-compressed-writeback-pages.patch

