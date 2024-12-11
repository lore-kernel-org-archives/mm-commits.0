Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012603D97A
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733878513; cv=none; b=WKbHW2bcIIWH6hrjlfFIrmY8haVsVKo60G28FQVrofvwXOksd4lHuTTWdJJIsu7molE5TquBQFpebte+QPD1iQqYvLTaYg/19CU0yTGHBCjHgRceA+DBPsN2IgjSlKOVhTcS1PmFiTgpTzGCXel41YehllpRLPmrAO0J/GI0dbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733878513; c=relaxed/simple;
	bh=OfYXB3T+v6FLyFrF0jdYQfxa5CdD/sHkJCtcBAOQiU8=;
	h=Date:To:From:Subject:Message-Id; b=uGjJqFGLsRGc/jWdzEWgkq3NyX/gqrzD0/uogJp3czI9pjS7dUz3JNfJu56NBKpzYopp4Vp6jG3gNtotFCdmhjR8h2sp36Ue5IdSsOKJQESCPWgZLL2U3n8KtTm6j3ZpcEFKuTBz5eZu9AbKtZ7HHBCLXs8yVBh6p0j9aTlumPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uWJuC9M/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uWJuC9M/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7083CC4CED6;
	Wed, 11 Dec 2024 00:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733878512;
	bh=OfYXB3T+v6FLyFrF0jdYQfxa5CdD/sHkJCtcBAOQiU8=;
	h=Date:To:From:Subject:From;
	b=uWJuC9M/xTaFcCcpuChSi7dl6HEC5rKGfmoTfGzThTGnV9sy2mcukcHKqP/F1F6MF
	 hN8gESXdbGAt8rm1oTtm28h4n5kUs2BV3pm5M0L6eQnbN+ggFO9wY/CBaM1+Zm/kp4
	 /8l3WJk2GsVjLGKpY5XbOCCBPMoE3pHLJT9KJ314=
Date: Tue, 10 Dec 2024 16:55:11 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-free-slot-memory-early-during-write.patch added to mm-unstable branch
Message-Id: <20241211005512.7083CC4CED6@smtp.kernel.org>
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
Date: Tue, 10 Dec 2024 19:53:56 +0900

In the current implementation entry's previously allocated memory is
released in the very last moment, when we already have allocated a new
memory for new data.  This, basically, temporarily increases memory usage
for no good reason.  For example, consider the case when both old (stale)
and new entry data are incompressible so such entry will temporarily use
two physical pages - one for stale (old) data and one for new data.  We
can release old memory as soon as we get a write request for entry.

Link: https://lkml.kernel.org/r/20241210105420.1888790-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-free-slot-memory-early-during-write
+++ a/drivers/block/zram/zram_drv.c
@@ -1651,6 +1651,11 @@ static int zram_write_page(struct zram *
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
@@ -1746,13 +1751,7 @@ compress_again:
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

zram-panic-when-use-ext4-over-zram-fix.patch
zram-cond_resched-in-writeback-loop.patch
zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch

