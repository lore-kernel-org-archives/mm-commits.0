Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1176171D2
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 00:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734569869; cv=none; b=UEf50jfkdusCKsGq9MZUTJ1Anjn7r375BrI2yE7qY+wfw4TWsPnDzNcFnjVx/m3SZTPcA9Pilelz5qSdr3i4KJlhqSeWTe0+0Y3fWBLRu8MEIlh2+QENo+QFMzM5VYq55Em71Llt248M+OkIVh+ARD/xUVEDSl21EfUMwvvlzvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734569869; c=relaxed/simple;
	bh=jayPTcFCy6J6z+TjG9kI+fsedUvtV2lNlfnNohq4L/g=;
	h=Date:To:From:Subject:Message-Id; b=m4xYjRmoN8KwAI6g9zBAmDmxgIDynI42uggWODOKRe30+gx+pNQtiSehvBWFpvnecWGDTb+slAZrk+va65MWie2VldYwS1rWz6teHoZhXQ6jqq408fNtfmxBIqBEe3WkNICbA66uQclQ8QEtIZSK4RO1h/0eSIUDSgz+O50fGk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VQORgAPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VQORgAPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581B3C4CECD;
	Thu, 19 Dec 2024 00:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734569868;
	bh=jayPTcFCy6J6z+TjG9kI+fsedUvtV2lNlfnNohq4L/g=;
	h=Date:To:From:Subject:From;
	b=VQORgAPCMY44aYBeXdnkc4OCDsnTFQXfrfQQF1nGOQ0O3Qk7oUM7dnUinmKFUqrFU
	 7ECRj5vQMKdMnBd9Wr5mOtgiRvNOnN/oNSHxPmHJpUSFD1npioMSRxzTSacYHVK+lX
	 tcTG+fInYQJdBDCRoi+4FFurnn4h3s+bFPvDkqPs=
Date: Wed, 18 Dec 2024 16:57:47 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-free-slot-memory-early-during-write.patch added to mm-unstable branch
Message-Id: <20241219005748.581B3C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: free slot memory early during write
has been added to the -mm mm-unstable branch.  Its filename is
     zram-free-slot-memory-early-during-write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-free-slot-memory-early-during-write.patch

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
Subject: zram: free slot memory early during write
Date: Wed, 18 Dec 2024 15:34:18 +0900

Patch series "zram: split page type read/write handling", v2.

This is a subset of [1] series which contains only fixes and improvements
(no new features, as ZRAM_HUGE split is still under consideration).

The motivation for factoring out is that zram_write_page() gets more and
more complex all the time, because it tries to handle too many scenarios:
ZRAM_SAME store, ZRAM_HUGE store, compress page store with zs_malloc
allocation slowpath and conditional recompression, etc.  Factor those out
and make things easier to handle.

Addition of cond_resched() is simply a fix, I can trigger watchdog from
zram writeback().  And early slot free is just a reasonable thing to do.

[1] https://lore.kernel.org/linux-kernel/20241119072057.3440039-1-senozhatsky@chromium.org


This patch (of 7):

In the current implementation entry's previously allocated memory is
released in the very last moment, when we already have allocated a new
memory for new data.  This, basically, temporarily increases memory usage
for no good reason.  For example, consider the case when both old (stale)
and new entry data are incompressible so such entry will temporarily use
two physical pages - one for stale (old) data and one for new data.  We
can release old memory as soon as we get a write request for entry.

Link: https://lkml.kernel.org/r/20241218063513.297475-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20241218063513.297475-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-free-slot-memory-early-during-write
+++ a/drivers/block/zram/zram_drv.c
@@ -1648,6 +1648,11 @@ static int zram_write_page(struct zram *
 	unsigned long element = 0;
 	enum zram_pageflags flags = 0;
 
+	/* First, free memory allocated to this slot (if any) */
+	zram_slot_lock(zram, index);
+	zram_free_page(zram, index);
+	zram_slot_unlock(zram, index);
+
 	mem = kmap_local_page(page);
 	if (page_same_filled(mem, &element)) {
 		kunmap_local(mem);
@@ -1736,13 +1741,7 @@ compress_again:
 	zs_unmap_object(zram->mem_pool, handle);
 	atomic64_add(comp_len, &zram->stats.compr_data_size);
 out:
-	/*
-	 * Free memory associated with this sector
-	 * before overwriting unused sectors.
-	 */
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
-
 	if (comp_len == PAGE_SIZE) {
 		zram_set_flag(zram, index, ZRAM_HUGE);
 		atomic64_inc(&zram->stats.huge_pages);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch
zram-use-zram_read_from_zspool-in-writeback.patch
zram-cond_resched-in-writeback-loop.patch

