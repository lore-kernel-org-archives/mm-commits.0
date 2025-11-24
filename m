Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D56337115
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025850; cv=none; b=jJzfgRAi+1+kE9gN6KUwLBvvHcYBYvFuCoJPu+6I1bM0F6S5bGGMBw+hZcDoWOmkSCcuhPN0UkRQ5PavXbSy90tu1E1kOL6zIMs5Nr3QEDKV2Qwee1RCiMtDMJDJAppfpsjihmOQ18xjJrZldiAvLJk3tZesuaSWaGgRHkRGxOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025850; c=relaxed/simple;
	bh=kUVpRJBH9sThd3yL95IYs3J/q5ehIX5Divjsu+q4Dps=;
	h=Date:To:From:Subject:Message-Id; b=urH21su1QVWYgTga1F00XQmHVzcBzYqSjyQ9VGcwt/GcO4QufEpkfS6m7MFYt1BiYmYBLWbizu4wCj3rEZ7apC6LCyrF12CH3sPx3qtzzuJXN683i8O0jScFLpkUm2ROhFpUoqUtJ7qiBO8wNgU24O4c4OAEvgKWjd4o44QHZxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zgnizLx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zgnizLx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5F2C4CEF1;
	Mon, 24 Nov 2025 23:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025848;
	bh=kUVpRJBH9sThd3yL95IYs3J/q5ehIX5Divjsu+q4Dps=;
	h=Date:To:From:Subject:From;
	b=zgnizLx5Ys8GXwA46CPpbC8ugR3qbaT8Shsc0h4rP+G6c+GSys3K4UhimEcB2TYqX
	 Lr+dVkGEK4vjjuEpoLii5dKCEfa2/fLt4tnryPlVQk7xCTWMiUwa/XmpYiaeAjL0va
	 pc3TBciQre8k2nkSNV4jyIuqQKUwRTYVkCqkpXFk=
Date: Mon, 24 Nov 2025 15:10:47 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-read-slot-block-idx-under-slot-lock.patch removed from -mm tree
Message-Id: <20251124231048.7D5F2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: read slot block idx under slot lock
has been removed from the -mm tree.  Its filename was
     zram-read-slot-block-idx-under-slot-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: read slot block idx under slot lock
Date: Sat, 22 Nov 2025 16:40:29 +0900

Read slot's block id under slot-lock.  We release the slot-lock for bdev
read so, technically, slot still can get freed in the meantime, but at
least we will read bdev block (page) that holds previous know slot data,
not from slot->handle bdev block, which can be anything at that point.

Link: https://lkml.kernel.org/r/20251122074029.3948921-7-senozhatsky@chromium.org
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
@@ -1995,14 +1995,14 @@ static int zram_read_page(struct zram *z
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


