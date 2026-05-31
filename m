Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A6D267B05
	for <mm-commits@vger.kernel.org>; Sun, 31 May 2026 19:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780255916; cv=none; b=UwCJNNQBeWIE0qWGu2ahAky8w1gPCMHn0udjXZ3LSdvvfXgYnQf5ud1HMwt0Equ5YbmerqsBbxTa9Z47MdeJ3Iigpo/kRxQ1NDpG3JN8SZMiKxEMKVMhoo+xpDS5Y5zKYaFo3UgJUEKTfFv4y1bOdR/zpAxf8XZdPn8qS4R8vZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780255916; c=relaxed/simple;
	bh=0VNicil1Iz8/oEy4bx2+iBQ09BK7TEhDCFHS2FJXSOg=;
	h=Date:To:From:Subject:Message-Id; b=KwGE6Rdd9QpYKO5qclkAYd69gl2TSyX+/PWKq5tGJP8ubt3GfMV8z3aMzZKgiu4vBh1zd0pgCtKqRZREZ5iCadGZVFRoG5lGrLlYc6OQ58qipcw1lPqzFQ5Bhx4g2pg7qZH3Wp9MNjxXk7D5iLT2IP3iv4t6m1ZaKl8+SJwwfWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BL/Bv3Bj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BL/Bv3Bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0298B1F00893;
	Sun, 31 May 2026 19:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780255915;
	bh=+0YGPwrnzHNQXIGk5UZI47MgmMmcDA5JcxU8PXx1QSM=;
	h=Date:To:From:Subject;
	b=BL/Bv3Bj+o/urWPN/MHpMhz6tCmQe4WYitFKambf4L+k+4I2pULPuL5T2xcHdIfve
	 iZAEofHARHny95lL+DqG11LOmqHMdd/feGhulOywlCxYUjudH8TQlFjLJ4gTj3DijT
	 8GzZNPEQ6lH1n5pyB4uZqqALS2GnV0v//yaVNQbs=
Date: Sun, 31 May 2026 12:31:54 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,kasong@tencent.com,hch@lst.de,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axboe@kernel.dk,wujianyue000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-partial-i-o-config-check.patch added to mm-new branch
Message-Id: <20260531193155.0298B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix partial I/O config check
has been added to the -mm mm-new branch.  Its filename is
     zram-fix-partial-i-o-config-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-partial-i-o-config-check.patch

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
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: zram: fix partial I/O config check
Date: Sun, 31 May 2026 20:35:16 +0800

IS_ENABLED() expects a CONFIG_* symbol.  Use the real Kconfig symbol so
this warning reflects whether synchronous partial I/O is built in.

Link: https://lore.kernel.org/20260531-zram-fix-partial-io-config-check-on-akpm-v1-1-eb085d98faea@gmail.com
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kairui Song <kasong@tencent.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-partial-i-o-config-check
+++ a/drivers/block/zram/zram_drv.c
@@ -1510,7 +1510,7 @@ static int read_from_bdev(struct zram *z
 {
 	atomic64_inc(&zram->stats.bd_reads);
 	if (!parent) {
-		if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
+		if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_ZRAM_PARTIAL_IO)))
 			return -EIO;
 		return read_from_bdev_sync(zram, page, index, blk_idx);
 	}
_

Patches currently in -mm which might be from wujianyue000@gmail.com are

zram-fix-partial-i-o-config-check.patch

