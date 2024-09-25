Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3682013698E
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 00:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727225598; cv=none; b=IIj6no1m9DHx0LRE8vlUwQyoaxUIaf34NsUPxvqiyyVE6K1AAC8mnaKhrRqCC8AJWe88+VG2t3Q6uBK6HOrc7UFMR/mBsin8183AxMqo9hANJx7h4L3nRlfMeVdc3t62VIHLYuS3gi2wlCEIqV4nqjWisY18k/nqEpFj9QE1LCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727225598; c=relaxed/simple;
	bh=Fpj3r2YxKJK/xPcXFVB8K/OztT8m9Wm8mKUOfn/u6wM=;
	h=Date:To:From:Subject:Message-Id; b=QX5XXaEqs3FuxLYhviMMSS+42N7w/KIw+FYcot3JF8UoB1a4skFUmUcv3HEPXxnmhRWrywyaRQnj8p7hMmcRGHiJu5E+SE1vOzRgROvL3n/YnEJBp/dcSYLI8PK3s1YJvLvx+mxH0TSWwkRlmll+loEIh6BGlYRGvlOJb8eXLyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eocYPNI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eocYPNI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D01C4CEC4;
	Wed, 25 Sep 2024 00:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727225597;
	bh=Fpj3r2YxKJK/xPcXFVB8K/OztT8m9Wm8mKUOfn/u6wM=;
	h=Date:To:From:Subject:From;
	b=eocYPNI7SLuiTfXyNxo9VZaYxN0Il3SWLTnY1PXjKD5syE71gHacu1YrTrcDYPswi
	 s+SQ6Q3RGIeiz8Prwg8bvU5FzcB7ozHariS/A5hJWByMebzM7TPyISfEAmLcLpwGnJ
	 Hp2l7iX+VGKO3hVcSHGDWYfrzT3ZauM9uSGJIqVE=
Date: Tue, 24 Sep 2024 17:53:17 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-rework-writeback-target-selection-strategy.patch added to mm-unstable branch
Message-Id: <20240925005317.B7D01C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: rework writeback target selection strategy
has been added to the -mm mm-unstable branch.  Its filename is
     zram-rework-writeback-target-selection-strategy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-rework-writeback-target-selection-strategy.patch

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
Subject: zram: rework writeback target selection strategy
Date: Tue, 17 Sep 2024 11:09:09 +0900

Writeback suffers from the same problem as recompression did before -
target slot selection for writeback is just a simple iteration over
zram->table entries (stored pages) which selects suboptimal targets for
writeback.  This is especially problematic for writeback, because we
uncompress objects before writeback so each of them takes 4K out of
limited writeback storage.  For example, when we take a 48 bytes slot and
store it as a 4K object to writeback device we only save 48 bytes of
memory (release from zsmalloc pool).  We naturally want to pick the
largest objects for writeback, because then each writeback will release
the largest amount of memory.

This patch applies the same solution and strategy as for recompression
target selection: pp control (post-process) with 16 buckets of candidate
pp slots.  Slots are assigned to pp buckets based on sizes - the larger
the slot the higher the group index.  This gives us sorted by size lists
of candidate slots (in linear time), so that among post-processing
candidate slots we always select the largest ones first and maximize the
memory saving.

TEST
====

A very simple demonstration: zram is configured with a writeback device. 
A limited writeback (wb_limit 2500 pages) is performed then, with a log of
sizes of slots that were written back.  You can see that patched zram
selects slots for recompression in significantly different manner, which
leads to higher memory savings (see column #2 of mm_stat output).

BASE
----

*** initial state of zram device
/sys/block/zram0/mm_stat
1750327296 619765836 631902208        0 631902208        1        0    34278    34278

*** writeback idle wb_limit 2500
/sys/block/zram0/mm_stat
1750327296 617622333 631578624        0 631902208        1        0    34278    34278

Sizes of selected objects for writeback:
... 193 349 46 46 46 46 852 1002 543 162 107 49 34 34 34 ...

PATCHED
-------

*** initial state of zram device
/sys/block/zram0/mm_stat
1750319104 619760957 631992320        0 631992320        1        0    34278    34278

*** writeback idle wb_limit 2500
/sys/block/zram0/mm_stat
1750319104 612672056 626135040        0 631992320        1        0    34278    34278

Sizes of selected objects for writeback:
... 3667 3580 3581 3580 3581 3581 3581 3231 3211 3203 3231 3246 ...

Note, pp-slots are not strictly sorted, there is a PP_BUCKET_SIZE_RANGE
variation of sizes within particular bucket.

Link: https://lkml.kernel.org/r/20240917021020.883356-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   83 ++++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 19 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-rework-writeback-target-selection-strategy
+++ a/drivers/block/zram/zram_drv.c
@@ -184,7 +184,7 @@ static void zram_accessed(struct zram *z
 #endif
 }
 
-#ifdef CONFIG_ZRAM_MULTI_COMP
+#if defined CONFIG_ZRAM_WRITEBACK || defined CONFIG_ZRAM_MULTI_COMP
 struct zram_pp_slot {
 	unsigned long		index;
 	struct list_head	entry;
@@ -681,11 +681,57 @@ static void read_from_bdev_async(struct
 #define IDLE_WRITEBACK			(1<<1)
 #define INCOMPRESSIBLE_WRITEBACK	(1<<2)
 
+static int scan_slots_for_writeback(struct zram *zram, u32 mode,
+				    unsigned long nr_pages,
+				    unsigned long index,
+				    struct zram_pp_ctl *ctl)
+{
+	struct zram_pp_slot *pps = NULL;
+
+	for (; nr_pages != 0; index++, nr_pages--) {
+		if (!pps)
+			pps = kmalloc(sizeof(*pps), GFP_KERNEL);
+		if (!pps)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&pps->entry);
+
+		zram_slot_lock(zram, index);
+		if (!zram_allocated(zram, index))
+			goto next;
+
+		if (zram_test_flag(zram, index, ZRAM_WB) ||
+		    zram_test_flag(zram, index, ZRAM_SAME))
+			goto next;
+
+		if (mode & IDLE_WRITEBACK &&
+		    !zram_test_flag(zram, index, ZRAM_IDLE))
+			goto next;
+		if (mode & HUGE_WRITEBACK &&
+		    !zram_test_flag(zram, index, ZRAM_HUGE))
+			goto next;
+		if (mode & INCOMPRESSIBLE_WRITEBACK &&
+		    !zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
+			goto next;
+
+		pps->index = index;
+		place_pp_slot(zram, ctl, pps);
+		pps = NULL;
+next:
+		zram_slot_unlock(zram, index);
+	}
+
+	kfree(pps);
+	return 0;
+}
+
 static ssize_t writeback_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
+	struct zram_pp_ctl *ctl = NULL;
+	struct zram_pp_slot *pps;
 	unsigned long index = 0;
 	struct bio bio;
 	struct bio_vec bio_vec;
@@ -737,7 +783,15 @@ static ssize_t writeback_store(struct de
 		goto release_init_lock;
 	}
 
-	for (; nr_pages != 0; index++, nr_pages--) {
+	ctl = init_pp_ctl();
+	if (!ctl) {
+		ret = -ENOMEM;
+		goto release_init_lock;
+	}
+
+	scan_slots_for_writeback(zram, mode, nr_pages, index, ctl);
+
+	while ((pps = select_pp_slot(ctl))) {
 		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
 			spin_unlock(&zram->wb_limit_lock);
@@ -754,25 +808,10 @@ static ssize_t writeback_store(struct de
 			}
 		}
 
+		index = pps->index;
 		zram_slot_lock(zram, index);
-		if (!zram_allocated(zram, index))
+		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
-
-		if (zram_test_flag(zram, index, ZRAM_WB) ||
-				zram_test_flag(zram, index, ZRAM_SAME) ||
-				zram_test_flag(zram, index, ZRAM_UNDER_WB))
-			goto next;
-
-		if (mode & IDLE_WRITEBACK &&
-		    !zram_test_flag(zram, index, ZRAM_IDLE))
-			goto next;
-		if (mode & HUGE_WRITEBACK &&
-		    !zram_test_flag(zram, index, ZRAM_HUGE))
-			goto next;
-		if (mode & INCOMPRESSIBLE_WRITEBACK &&
-		    !zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
-			goto next;
-
 		/*
 		 * Clearing ZRAM_UNDER_WB is duty of caller.
 		 * IOW, zram_free_page never clear it.
@@ -786,6 +825,8 @@ static ssize_t writeback_store(struct de
 			zram_clear_flag(zram, index, ZRAM_UNDER_WB);
 			zram_clear_flag(zram, index, ZRAM_IDLE);
 			zram_slot_unlock(zram, index);
+
+			release_pp_slot(zram, pps);
 			continue;
 		}
 
@@ -804,6 +845,8 @@ static ssize_t writeback_store(struct de
 			zram_clear_flag(zram, index, ZRAM_UNDER_WB);
 			zram_clear_flag(zram, index, ZRAM_IDLE);
 			zram_slot_unlock(zram, index);
+
+			release_pp_slot(zram, pps);
 			/*
 			 * BIO errors are not fatal, we continue and simply
 			 * attempt to writeback the remaining objects (pages).
@@ -846,12 +889,14 @@ static ssize_t writeback_store(struct de
 		spin_unlock(&zram->wb_limit_lock);
 next:
 		zram_slot_unlock(zram, index);
+		release_pp_slot(zram, pps);
 	}
 
 	if (blk_idx)
 		free_block_bdev(zram, blk_idx);
 	__free_page(page);
 release_init_lock:
+	release_pp_ctl(zram, ctl);
 	atomic_set(&zram->pp_in_progress, 0);
 	up_read(&zram->init_lock);
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-introduce-zram_pp_slot-flag.patch
zram-permit-only-one-post-processing-operation-at-a-time.patch
zram-rework-recompress-target-selection-strategy.patch
zram-rework-writeback-target-selection-strategy.patch
zram-do-not-mark-idle-slots-that-cannot-be-idle.patch
zram-reshuffle-zram_free_page-flags-operations.patch
zram-remove-under_wb-and-simplify-writeback.patch

