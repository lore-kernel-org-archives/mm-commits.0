Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9BB35FF4A
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 18:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763489573; cv=none; b=qKHM795+sKWlPw8IgPWZ+P4e6+YWhLmuR9ryfmLU2dBQewstP085bz0uGLeH0OJhtoMcyUIPDAlHJ+LsfsdVF6Umzo34dwkvXRCTFLswcvPj2g8Cpky+eg31JqN0+O55M9VaAyaKvy6DMyliis3FNetkEBL115NLM9CQX7eN9d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763489573; c=relaxed/simple;
	bh=EZwc9Q4FDRc8iIaILtWaJtOO6sPPQUQNopKPU9Jhwq8=;
	h=Date:To:From:Subject:Message-Id; b=dIu5xoQMzHot9ylioc+xrMzDRxr2TO2ETRvA/kbaDIO2QXg8rcoHXVGXL1Cung2QYIa0stVlW4tpZJFgx1T4sLbIAUGwor0ph2FCEZ96Jhw8eY8jM8D3MNyggMjh55sh/KHHCjQ0shJQctHljNk1RkXU5eUqhsA64AD+Kujn1H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FWqnS2qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FWqnS2qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF14C19423;
	Tue, 18 Nov 2025 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763489572;
	bh=EZwc9Q4FDRc8iIaILtWaJtOO6sPPQUQNopKPU9Jhwq8=;
	h=Date:To:From:Subject:From;
	b=FWqnS2qy98nWv9xV5ik1s38qU+sUq02sJcOZjyudrCW9YvK9z28w4yJ5d6X+IzYym
	 CsXkAK26VftS1UO1AAtHmwfm/avyBQSxfkK2J4qmx6XnpbU9i2q8fRossRkNs+ZIwP
	 jqbWjI8fvlN4coz1pb606h29u8EQ54IsSq4nD4uM=
Date: Tue, 18 Nov 2025 10:12:50 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-read-slot-block-idx-under-slot-lock.patch added to mm-unstable branch
Message-Id: <20251118181252.6BF14C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: read slot block idx under slot lock
has been added to the -mm mm-unstable branch.  Its filename is
     zram-read-slot-block-idx-under-slot-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-read-slot-block-idx-under-slot-lock.patch

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
Subject: zram: read slot block idx under slot lock
Date: Tue, 18 Nov 2025 16:30:00 +0900

Read slot's block id under slot-lock.  We release the slot-lock for bdev
read so, technically, slot still can get freed in the meantime, but at
least we will read bdev block (page) that holds previous know slot data,
not from slot->handle bdev block, which can be anything at that point.

Link: https://lkml.kernel.org/r/20251118073000.1928107-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-read-slot-block-idx-under-slot-lock
+++ a/drivers/block/zram/zram_drv.c
@@ -1980,14 +1980,14 @@ static int zram_read_page(struct zram *z
 		ret = zram_read_from_zspool(zram, page, index);
 		zram_slot_unlock(zram, index);
 	} else {
+		unsigned long blk_idx = zram_get_handle(zram, index);
+
 		/*
 		 * The slot should be unlocked before reading from the backing
 		 * device.
 		 */
 		zram_slot_unlock(zram, index);
-
-		ret = read_from_bdev(zram, page, zram_get_handle(zram, index),
-				     parent);
+		ret = read_from_bdev(zram, page, blk_idx, parent);
 	}
 
 	/* Should NEVER happen. Return bio error if it does. */
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-add-writeback-batch-size-device-attr.patch
zram-take-write-lock-in-wb-limit-store-handlers.patch
zram-drop-wb_limit_lock.patch
zram-rework-bdev-block-allocation.patch
zram-read-slot-block-idx-under-slot-lock.patch

