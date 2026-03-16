Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1849176FB1
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 01:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773626245; cv=none; b=ZAgbDJ62OGLlRHaRjpOFXq7EB5lQYBpXLC1zKBnflBRv62y2tABqkm1+hg3ehezIgREdEFjs+kfxJXM0Wi6WtQxw1/+2kxweb+a2VJ072AYTHt83iTokhs9ewDqUIHx77g9day/7a/To15BuChT5aW4pKab7Lsa83nrwnbkMwKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773626245; c=relaxed/simple;
	bh=ERMiD+g0JcdEYBSKnIjJLxQWH175GlKgc56V+23eBjQ=;
	h=Date:To:From:Subject:Message-Id; b=QA7dGAUVY5+YmhmcYzdlzv1/WVGz7JpPWgn/1qH4yVM1aGIKCU9slOZsyXADNj8qUvOzz0UrYKJUvZUfP0+IUBoiSMKSlo9aB+tqD0TZ9UYZ0xxqphZy8gssWFpkeGJ44NCRC1nQw6t1whx121gkSdlovs8fSpj5rq7yoL9nf/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Goz+Lozq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Goz+Lozq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E767C4CEF7;
	Mon, 16 Mar 2026 01:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773626244;
	bh=ERMiD+g0JcdEYBSKnIjJLxQWH175GlKgc56V+23eBjQ=;
	h=Date:To:From:Subject:From;
	b=Goz+LozqRpY4EWJlxocQf6l3ZxzKB4Bpa56v493yk9XR9yD7yTjMOCv+bAqQ9+gjL
	 cy1MMKEpKl8mWD3GkVLiJFLtRyGbyffnPPKl22fCfP4ylJnMLdXGi+tygbKxVZp8Kx
	 mLE/TQKkb9s5O85Xjmv8Bl2aKoG2mbQrV+HpQSAs=
Date: Sun, 15 Mar 2026 18:57:23 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-propagate-read_from_bdev_async-errors.patch added to mm-new branch
Message-Id: <20260316015724.6E767C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: propagate read_from_bdev_async() errors
has been added to the -mm mm-new branch.  Its filename is
     zram-propagate-read_from_bdev_async-errors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-propagate-read_from_bdev_async-errors.patch

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
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-propagate-read_from_bdev_async-errors
+++ a/drivers/block/zram/zram_drv.c
@@ -1445,21 +1445,21 @@ static void zram_async_read_endio(struct
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
@@ -1475,6 +1475,8 @@ static void read_from_bdev_async(struct
 	__bio_add_page(bio, page, PAGE_SIZE, 0);
 	bio_inc_remaining(parent);
 	submit_bio(bio);
+
+	return 0;
 }
 
 static void zram_sync_read(struct work_struct *w)
@@ -1523,8 +1525,7 @@ static int read_from_bdev(struct zram *z
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

zram-do-not-permit-params-change-after-init.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch
zram-unify-and-harden-algo-priority-params-handling.patch
zram-propagate-read_from_bdev_async-errors.patch

