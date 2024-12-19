Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11587171D2
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 00:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734569873; cv=none; b=SFetul7CCAvmYXG2x8XvyCumaLnLSU5aLRbMcgniVj9ZO6ZYKs1I15av7aQqG4TYpn7XvIm566UwzsSVordSdaWfoRJ2Q672i1V6eIsuw2ckNZstEqWBkq+/ybmwm7LpqiLZcxvUOjwUTDKT845p0VoL1KNC7s2wvBKlF9jlslI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734569873; c=relaxed/simple;
	bh=PT6re08LY2M9EBzas0WZHzfdSldO1mXpt8soJUXOdPI=;
	h=Date:To:From:Subject:Message-Id; b=oy63bwyQ0VgrOUrpXSNOsVJf9+1NCwNWVdd2xJvZz2ZSBMAyIKMxAp6CTGNqMN2MsfADekeUDANlq+ZvGSI4xtxQL5cVWNTN2x3FsHxj0j/leV5foywyeydLud3zxLwSuytMSQ02BYQmhh8LXHlIMpQrZWLIIrI2Yf4zgkj4s9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CO7Qopw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CO7Qopw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971F4C4CECD;
	Thu, 19 Dec 2024 00:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734569872;
	bh=PT6re08LY2M9EBzas0WZHzfdSldO1mXpt8soJUXOdPI=;
	h=Date:To:From:Subject:From;
	b=CO7Qopw/yxbsFfWWgPgS6xlQzfHy3MwF2XI/hDn7kUZQ+RShFwXM1LlHuiRFRn5xD
	 uO34evJqbgZGsHCgbmXRIeb+DhLPt61PykmMwCgPUFwQS3nt+nXBCQpjjH9UZi0kau
	 l1tc2w+joY11NEwgNrLkstCTF/Sw2W7WCrRuejIg=
Date: Wed, 18 Dec 2024 16:57:52 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-factor-out-zram_same-write.patch added to mm-unstable branch
Message-Id: <20241219005752.971F4C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: factor out ZRAM_SAME write
has been added to the -mm mm-unstable branch.  Its filename is
     zram-factor-out-zram_same-write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-factor-out-zram_same-write.patch

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
@@ -1624,6 +1624,20 @@ static int zram_bvec_read(struct zram *z
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
@@ -1633,7 +1647,7 @@ static int zram_write_page(struct zram *
 	void *src, *dst, *mem;
 	struct zcomp_strm *zstrm;
 	unsigned long element = 0;
-	enum zram_pageflags flags = 0;
+	bool same_filled;
 
 	/* First, free memory allocated to this slot (if any) */
 	zram_slot_lock(zram, index);
@@ -1641,14 +1655,10 @@ static int zram_write_page(struct zram *
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
@@ -1727,7 +1737,7 @@ compress_again:
 	zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 	zs_unmap_object(zram->mem_pool, handle);
 	atomic64_add(comp_len, &zram->stats.compr_data_size);
-out:
+
 	zram_slot_lock(zram, index);
 	if (comp_len == PAGE_SIZE) {
 		zram_set_flag(zram, index, ZRAM_HUGE);
@@ -1735,13 +1745,8 @@ out:
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

zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch
zram-use-zram_read_from_zspool-in-writeback.patch
zram-cond_resched-in-writeback-loop.patch

