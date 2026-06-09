Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726532F3C13
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968151; cv=none; b=BF/AO9i0LmnS4AGtZ/fmnQq8fjS1JpoE+uwIR629dMfQnpSt41+KTk1CCX3fBRQ1XgxjkRCPOYmkDVZ/cMajWsfH9JNKrbvNUkuMclzwCsb1IHQu7C2TZttByLdDnk0YizFF8jgPRGq7CO+rTqMD8SDNx6SzwZHHRX/HmEm4jnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968151; c=relaxed/simple;
	bh=nCn138tjzw7v219JB2DW6ei7YozTaQKBeaPOke8h2pE=;
	h=Date:To:From:Subject:Message-Id; b=ZFe+3aUidf6Z55OkKPiFPaURnOz5Bo809PYBKo4yOG/F6fHghPSdIuESsKOjZlASIGs4DmWzYUrYId8Bz7TID5Azlm3oV61/RqyEmLdVAeJGZkGP1/njv2RIylIKXxPSeAGK+JdtLgEhijT233092AN8gwqCPkP+e6t7eeHFyo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TBfMwobV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TBfMwobV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456111F00893;
	Tue,  9 Jun 2026 01:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968150;
	bh=OFKH1V2LChCb41xE3qRjJFyXK+T/F6lz7qCGu/jm7LM=;
	h=Date:To:From:Subject;
	b=TBfMwobV8HIdMJDxjHwGHyd9puC+KrdJg+LbOatdMUYpSlCGKuRam7WCX481cIx5g
	 i7e7/VhyJCa0n3B/E/vxl0J5XCIf4ReNe0q0TSZ3xVtwpPXRYVfhL9RiD8PfSPVWYm
	 /hJZO5Td6lLk42TLhEumXJqmIsl5suCkaLHVPny0=
Date: Mon, 08 Jun 2026 18:22:29 -0700
To: mm-commits@vger.kernel.org,xieyisheng1@huawei.com,senozhatsky@chromium.org,minchan@kernel.org,hch@lst.de,axboe@kernel.dk,shenxiaogll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-drop-unused-bio-parameter-from-write-helpers.patch removed from -mm tree
Message-Id: <20260609012230.456111F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: drop unused bio parameter from write helpers
has been removed from the -mm tree.  Its filename was
     zram-drop-unused-bio-parameter-from-write-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


