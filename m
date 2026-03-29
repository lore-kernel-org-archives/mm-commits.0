Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6891B255E43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744914; cv=none; b=iJw3DCuDrvwknqgjOFZQ/dAA+v/F54a6TGfYVLL2EacG7NRWljDF8MlUKGSds64IUpP9zyURKRA+UTGyNdEoOH4/u7dQhOE4cZkpmXmvQVHG2W0+O5lQrNC8koHpCkGDScZH/2F0Fr6P2AWlSfomhgr1mofXQQUSs2uF2H1NMW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744914; c=relaxed/simple;
	bh=RjEEYvAqqWjZ3T76dJBZzeEQBrhH1uvWPqFqs8WzvqQ=;
	h=Date:To:From:Subject:Message-Id; b=f07ZG2g0LwBKZAqoaXLBrsSy52Ys5WSKMZwkQl6K8EDYK7FuhrRc/lywt2dPhdbsYZuBdcTCmU//sDFiTzEpH+K03UNyGkkfG8S6p5k1FzlMSyN/nb3rfbgUyHlfYRRZYjDaOO0fKoUd3mjnuwzkfBgMYHc5v6Du2o+jX70zmlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bmP4IoL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bmP4IoL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D6AC4CEF7;
	Sun, 29 Mar 2026 00:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744914;
	bh=RjEEYvAqqWjZ3T76dJBZzeEQBrhH1uvWPqFqs8WzvqQ=;
	h=Date:To:From:Subject:From;
	b=bmP4IoL/c9aqJyNaShE8mig8iphkG47LsWUD5OOaxdwfLzSGCmUYAXRjqul4UMdMk
	 l5s2JizLfW9rsdfoJyrRtV9xgPbAafVBAcmq1OwLrDi2/60If5QvS4lJRptemqQuVX
	 fy6NPwlS1bF594OtW2vOTXBVluYPkb1V0bu5ntA0=
Date: Sat, 28 Mar 2026 17:41:53 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-propagate-read_from_bdev_async-errors.patch removed from -mm tree
Message-Id: <20260329004154.41D6AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: propagate read_from_bdev_async() errors
has been removed from the -mm tree.  Its filename was
     zram-propagate-read_from_bdev_async-errors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: propagate read_from_bdev_async() errors
Date: Mon, 16 Mar 2026 10:53:32 +0900

When read_from_bdev_async() fails to chain bio, for instance fails to
allocate request or bio, we need to propagate the error condition so that
upper layer is aware of it.  zram already does that by setting
BLK_STS_IOERR ->bi_status, but only for sync reads.  Change async read
path to return its error status so that async errors are also handled.

Link: https://lkml.kernel.org/r/20260316015354.114465-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Brian Geffon <bgeffon@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-propagate-read_from_bdev_async-errors
+++ a/drivers/block/zram/zram_drv.c
@@ -1429,21 +1429,21 @@ static void zram_async_read_endio(struct
 	queue_work(system_highpri_wq, &req->work);
 }
 
-static void read_from_bdev_async(struct zram *zram, struct page *page,
-				 u32 index, unsigned long blk_idx,
-				 struct bio *parent)
+static int read_from_bdev_async(struct zram *zram, struct page *page,
+				u32 index, unsigned long blk_idx,
+				struct bio *parent)
 {
 	struct zram_rb_req *req;
 	struct bio *bio;
 
 	req = kmalloc_obj(*req, GFP_NOIO);
 	if (!req)
-		return;
+		return -ENOMEM;
 
 	bio = bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
 	if (!bio) {
 		kfree(req);
-		return;
+		return -ENOMEM;
 	}
 
 	req->zram = zram;
@@ -1459,6 +1459,8 @@ static void read_from_bdev_async(struct
 	__bio_add_page(bio, page, PAGE_SIZE, 0);
 	bio_inc_remaining(parent);
 	submit_bio(bio);
+
+	return 0;
 }
 
 static void zram_sync_read(struct work_struct *w)
@@ -1507,8 +1509,7 @@ static int read_from_bdev(struct zram *z
 			return -EIO;
 		return read_from_bdev_sync(zram, page, index, blk_idx);
 	}
-	read_from_bdev_async(zram, page, index, blk_idx, parent);
-	return 0;
+	return read_from_bdev_async(zram, page, index, blk_idx, parent);
 }
 #else
 static inline void reset_bdev(struct zram *zram) {};
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


