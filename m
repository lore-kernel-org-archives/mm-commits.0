Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F93D368D7B
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 22:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780007205; cv=none; b=fnsq4KneFIlx2c+qrSohxXBEdzHuYPE3jG5iztbbgMHd5tt+SegiB/pF7c3LAh9WEhwENoH660lBh7dU8fee/yhRmTRmbG8Jd/xoIsRJKcgVSmH4wPKj4c45zx0ZbQ9CCXjg8b6fgbo4/QjvsI/J/myYsI1wOKOuLFKixPCLGZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780007205; c=relaxed/simple;
	bh=0guI/qOwXr+V11W70b6RPzpFK92Rla7EQn9u9GzBpJI=;
	h=Date:To:From:Subject:Message-Id; b=mOvnvtQXu/19/2OEdKx7sbzt3H3NugU3N2a0v60jdwfkhCAZ/4gEzWYFidauT/pGPF2QF/s0BO54+JPih3RsnB5Q72y8l0jzHh8FRix5sHOXDAHXYXXBqlNGIePI8zWbR9+rT8aofHgmKiqUYizGxNZVW1SBxFxhsbNoP/lC/rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=swTXhFi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="swTXhFi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195BB1F000E9;
	Thu, 28 May 2026 22:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780007204;
	bh=cRZza1+ZYjMIEBamkMp3ZND6NWq+WrdueG3Uvbgpois=;
	h=Date:To:From:Subject;
	b=swTXhFi/HQshXZoaLx4UiPYaZ7YSYPm5fQ5StIvQvSrlAcSt3mDR4Itfs6jV1cTaz
	 RPOt+2ueXZgRAlGF/zJKKxnG86eCZLoUCDCM4bZ0xQ7kNKgfrOmU5+/ghdD+hy0Bkv
	 000YVpToJf6fGtbTnFYH7H4gItYY3UnLgkykhhS0=
Date: Thu, 28 May 2026 15:26:43 -0700
To: mm-commits@vger.kernel.org,xieyisheng1@huawei.com,senozhatsky@chromium.org,minchan@kernel.org,hch@lst.de,axboe@kernel.dk,shenxiaogll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-drop-unused-bio-parameter-from-write-helpers.patch added to mm-new branch
Message-Id: <20260528222644.195BB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: drop unused bio parameter from write helpers
has been added to the -mm mm-new branch.  Its filename is
     zram-drop-unused-bio-parameter-from-write-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-drop-unused-bio-parameter-from-write-helpers.patch

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
From: Cunlong Li <shenxiaogll@gmail.com>
Subject: zram: drop unused bio parameter from write helpers
Date: Thu, 28 May 2026 10:48:45 +0800

After "zram: fix use-after-free in zram_bvec_write_partial()",
zram_bvec_write_partial() always passes NULL to zram_read_page() and no
longer needs the parent bio.  Mirror the read side
(zram_bvec_read_partial() has not taken a bio since commit 4e3c87b9421d
("zram: fix synchronous reads")) and drop the parameter from
zram_bvec_write_partial() and zram_bvec_write().

No functional change.

Link: https://lore.kernel.org/20260528-zram-v3-2-cab86eef8764@gmail.com
Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-drop-unused-bio-parameter-from-write-helpers
+++ a/drivers/block/zram/zram_drv.c
@@ -2334,7 +2334,7 @@ static int zram_write_page(struct zram *
  * This is a partial IO. Read the full page before writing the changes.
  */
 static int zram_bvec_write_partial(struct zram *zram, struct bio_vec *bvec,
-				   u32 index, int offset, struct bio *bio)
+				   u32 index, int offset)
 {
 	struct page *page = alloc_page(GFP_NOIO);
 	int ret;
@@ -2352,10 +2352,10 @@ static int zram_bvec_write_partial(struc
 }
 
 static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
-			   u32 index, int offset, struct bio *bio)
+			   u32 index, int offset)
 {
 	if (is_partial_io(bvec))
-		return zram_bvec_write_partial(zram, bvec, index, offset, bio);
+		return zram_bvec_write_partial(zram, bvec, index, offset);
 	return zram_write_page(zram, bvec->bv_page, index);
 }
 
@@ -2752,7 +2752,7 @@ static void zram_bio_write(struct zram *
 
 		bv.bv_len = min_t(u32, bv.bv_len, PAGE_SIZE - offset);
 
-		if (zram_bvec_write(zram, &bv, index, offset, bio) < 0) {
+		if (zram_bvec_write(zram, &bv, index, offset) < 0) {
 			atomic64_inc(&zram->stats.failed_writes);
 			bio->bi_status = BLK_STS_IOERR;
 			break;
_

Patches currently in -mm which might be from shenxiaogll@gmail.com are

zram-fix-use-after-free-in-zram_bvec_write_partial.patch
zram-drop-unused-bio-parameter-from-write-helpers.patch

