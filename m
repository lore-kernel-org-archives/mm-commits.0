Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541D72AE90
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 04:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733890869; cv=none; b=AbqR8QrWJpMb6FyhmYn1iS9xCUROaRkdrHvdNUF5k+bwWHARJUNjaUIH7n1Xk3Dj1KFK4dG9W6jRe83gSvc3wUgCNkjgG2kJ2t161XCO5BU6+rXRx6pMmmwPrYucieaXzzEVOS9W1M/ro5gKqko648PIiSZRiWh3A5gqISaC7ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733890869; c=relaxed/simple;
	bh=EvZfmStPSwpPLmp/gYIowLk5vqgHBubVxl+gnn8Q3kI=;
	h=Date:To:From:Subject:Message-Id; b=VzlnQDnA0AOPyA7/24RTapQBg5x/yFzF9SP6rNA6OgsMYui/ATkIIki5lLev+1ozmR+1d0sf0eIExRcHyUZRChAiIMaHh+V6sx0QujAzkpwPAbAn6LC980NMxDj/OVdbXlwhRmOoAJ/aUWknz4M/jiehONwsnzG+6zHKFdHO4M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pK2FbUIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pK2FbUIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEC6C4CED2;
	Wed, 11 Dec 2024 04:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733890869;
	bh=EvZfmStPSwpPLmp/gYIowLk5vqgHBubVxl+gnn8Q3kI=;
	h=Date:To:From:Subject:From;
	b=pK2FbUIkCDFNztqb/3rPgLCKzdOoCUSe5T5O6k5qIZTAlBrri2e8QF6axsWr1MwL+
	 nmT4fKiVzXhCxLwlIe+iyYHK6d/Vhv5voa7CX8VROcMTzo8mCWO2C9lUA8myDQZOEr
	 CfRf7Hp2jd+uWYs13BAE+HKbOCcgAMNw6N/nvnnw=
Date: Tue, 10 Dec 2024 20:21:08 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] zram-cond_resched-in-writeback-loop.patch removed from -mm tree
Message-Id: <20241211042108.ECEC6C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: cond_resched() in writeback loop
has been removed from the -mm tree.  Its filename was
     zram-cond_resched-in-writeback-loop.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: cond_resched() in writeback loop
Date: Tue, 10 Dec 2024 19:53:55 +0900

Patch series "zram: split page type read/write handling".

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


This patch (of 6):

Writeback loop can run for quite a while (depending on wb device
performance, compression algorithm and the number of entries we
writeback), so we need to do cond_resched() there, similarly to what we do
in recompress loop.

Link: https://lkml.kernel.org/r/20241210105420.1888790-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20241210105420.1888790-2-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-cond_resched-in-writeback-loop
+++ a/drivers/block/zram/zram_drv.c
@@ -889,6 +889,8 @@ static ssize_t writeback_store(struct de
 next:
 		zram_slot_unlock(zram, index);
 		release_pp_slot(zram, pps);
+
+		cond_resched();
 	}
 
 	if (blk_idx)
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-panic-when-use-ext4-over-zram-fix.patch
zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch

