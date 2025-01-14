Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1901F23D3FC
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837097; cv=none; b=gjs3RgbtuixY3BbcROj1jyGRHFpKxdhCb12SvjRmFQLXADpUvg4Y1TZVWV7JfLbdfLIW0zJKfn2EGhQef2AwXlI+0IRG/+FTr7yP4uHZQFIOTbyQ2X3/r4PyU2Q2PjSBYgyoERrhzX8qhl8dkanbtrvCKihm8Luy3jdnCydVPM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837097; c=relaxed/simple;
	bh=OkbHIT4ZzxWXAZXRbjP8E9OLDoXcMpysKIa3owfUwSU=;
	h=Date:To:From:Subject:Message-Id; b=I8KzJjyM4ZA61o9SOaetFqxp8/7yxRzP2p5F4LC9J0d1Egm8rx8zkut3hwJ0tjhjWhXtXjD3eigAFUFmLoBONvh5f8BuGxJ2N33DpmkttpSUjvqhnkJvBzDz2QTrW9JjeOSIVwS/Q+Wjc85ssWUDQ3vgLj+tp43jsOFSqFb3Fjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zneZFjki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zneZFjki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A7FC4CEDD;
	Tue, 14 Jan 2025 06:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837096;
	bh=OkbHIT4ZzxWXAZXRbjP8E9OLDoXcMpysKIa3owfUwSU=;
	h=Date:To:From:Subject:From;
	b=zneZFjkie1VHMOSS6Hy2wM8e1AtIZZvuz6LiZw5rUhrUv5pcZUiOhkq32G3gi59dc
	 BmkYqIm+SVZMcdqhZPSI5fa9emz6Xx3QcE6yH9Y5RWvYT0HasvzpcbDSRDxr4TWFOA
	 id/MgIVkfMDA1X5jV4IBuk9eqnHBYgg9Jk2VU1PY=
Date: Mon, 13 Jan 2025 22:44:56 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-factor-out-zram_same-write.patch removed from -mm tree
Message-Id: <20250114064456.D8A7FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: factor out ZRAM_SAME write
has been removed from the -mm tree.  Its filename was
     zram-factor-out-zram_same-write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: factor out ZRAM_SAME write
Date: Wed, 18 Dec 2024 15:34:20 +0900

Handling of ZRAM_SAME now uses a goto to the final stages of
zram_write_page() plus it introduces a branch and flags variable, which is
not making the code any simpler.  In reality, we can handle ZRAM_SAME
immediately when we detect such pages and remove a goto and a branch.

Factor out ZRAM_SAME handling into a separate routine to simplify
zram_write_page().

Link: https://lkml.kernel.org/r/20241218063513.297475-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   37 ++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 16 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-factor-out-zram_same-write
+++ a/drivers/block/zram/zram_drv.c
@@ -1625,6 +1625,20 @@ static int zram_bvec_read(struct zram *z
 	return zram_read_page(zram, bvec->bv_page, index, bio);
 }
 
+static int write_same_filled_page(struct zram *zram, unsigned long fill,
+				  u32 index)
+{
+	zram_slot_lock(zram, index);
+	zram_set_flag(zram, index, ZRAM_SAME);
+	zram_set_handle(zram, index, fill);
+	zram_slot_unlock(zram, index);
+
+	atomic64_inc(&zram->stats.same_pages);
+	atomic64_inc(&zram->stats.pages_stored);
+
+	return 0;
+}
+
 static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 {
 	int ret = 0;
@@ -1634,7 +1648,7 @@ static int zram_write_page(struct zram *
 	void *src, *dst, *mem;
 	struct zcomp_strm *zstrm;
 	unsigned long element = 0;
-	enum zram_pageflags flags = 0;
+	bool same_filled;
 
 	/* First, free memory allocated to this slot (if any) */
 	zram_slot_lock(zram, index);
@@ -1642,14 +1656,10 @@ static int zram_write_page(struct zram *
 	zram_slot_unlock(zram, index);
 
 	mem = kmap_local_page(page);
-	if (page_same_filled(mem, &element)) {
-		kunmap_local(mem);
-		/* Free memory associated with this sector now. */
-		flags = ZRAM_SAME;
-		atomic64_inc(&zram->stats.same_pages);
-		goto out;
-	}
+	same_filled = page_same_filled(mem, &element);
 	kunmap_local(mem);
+	if (same_filled)
+		return write_same_filled_page(zram, element, index);
 
 compress_again:
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
@@ -1728,7 +1738,7 @@ compress_again:
 	zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 	zs_unmap_object(zram->mem_pool, handle);
 	atomic64_add(comp_len, &zram->stats.compr_data_size);
-out:
+
 	zram_slot_lock(zram, index);
 	if (comp_len == PAGE_SIZE) {
 		zram_set_flag(zram, index, ZRAM_HUGE);
@@ -1736,13 +1746,8 @@ out:
 		atomic64_inc(&zram->stats.huge_pages_since);
 	}
 
-	if (flags) {
-		zram_set_flag(zram, index, flags);
-		zram_set_handle(zram, index, element);
-	}  else {
-		zram_set_handle(zram, index, handle);
-		zram_set_obj_size(zram, index, comp_len);
-	}
+	zram_set_handle(zram, index, handle);
+	zram_set_obj_size(zram, index, comp_len);
 	zram_slot_unlock(zram, index);
 
 	/* Update stats */
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


