Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBCA24332A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837094; cv=none; b=foVdYQfrDT95YMfqbSV1KwcZNh5/tMmRk4BXdfz6HUkQi7DehT7AZVUoAtr5TrWU6Xe1ne9E87zV6QUf4YkjJ8D645yvJGoIMJa5mbhQjc99FmEIxTadkYvqMZCAKy/dS9QgMtLZ6PCAjn44QJCGf+ZudxoghoZibjosiD2mOqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837094; c=relaxed/simple;
	bh=/GZLIqJEwZB0+I1Hb1lnr8y0H2TQ6g5iNmFs0hvSDIk=;
	h=Date:To:From:Subject:Message-Id; b=Tuh7tUHxrVqxIZBqiCXjlSwXkw/hDxXk/A2c8e2Ot5IjtSgo54fbXwY3CM8LwxwSqhEWSbBZIWO6k0LF78rWaKQk9x/mMOWdXFM+nSeWZKY7zld56EDzcnhzgNhqk2S0GmXOWjJQwU3gwvX3gnYrkIqzi5QtKy9zZuxJR07y2bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oN0nH02e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oN0nH02e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46468C4CEDD;
	Tue, 14 Jan 2025 06:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837094;
	bh=/GZLIqJEwZB0+I1Hb1lnr8y0H2TQ6g5iNmFs0hvSDIk=;
	h=Date:To:From:Subject:From;
	b=oN0nH02e9E5zx6POuvoctEr4sJfiLKnymWG+e3cD2sRMufJVR2sDBLauNw20aRTy4
	 hB2ZxgUU8T2EbF9PR1DTgw0rWiRllf3f5jdRtCRvPw2ayYjAsFq1opRKREv8M6iZSe
	 BqSHMcpUY9Due/MV/TtvEjqmFmFN7w7HbeAqbtps=
Date: Mon, 13 Jan 2025 22:44:53 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-free-slot-memory-early-during-write.patch removed from -mm tree
Message-Id: <20250114064454.46468C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: free slot memory early during write
has been removed from the -mm tree.  Its filename was
     zram-free-slot-memory-early-during-write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1649,6 +1649,11 @@ static int zram_write_page(struct zram *
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
@@ -1737,13 +1742,7 @@ compress_again:
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


