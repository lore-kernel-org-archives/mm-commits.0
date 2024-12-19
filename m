Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3105171D2
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 00:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734569870; cv=none; b=NGLdMgOPf7Po8NMqQjLexwY0cEWOqIYJNmxv2HN1kMfHw8jbnVKza7Z1nk1df/9RfY596zYlNqAboZItBUfS8wnnfBO0l5j9/9C0SwJWRd4ckAOvPdwUd0iD+0up2QBiIwCi4SUY/PclcsCu7+B6J3xw3hfU2bsINUbSi6empUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734569870; c=relaxed/simple;
	bh=Jt53Vhzg893OaL39J+Xne7NMQYuTYw5ucS5mdFcysqw=;
	h=Date:To:From:Subject:Message-Id; b=X/5YO7DLE3ACv2rbjz+ZTM7OfxZqsNCbhLPx63opa6j+rFh4HN6LhIArzYoRWje4rVev9lXa77YsGgNSg/N9sTzD6H6jc6snC1o+yTLmfZFsGY9vwd/XRZJksABp/kVLrMNCXSXRvsBdNgDODws9+KPu77i8Jhch21z9T/XtGjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdTiZmuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdTiZmuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F6BC4CECD;
	Thu, 19 Dec 2024 00:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734569870;
	bh=Jt53Vhzg893OaL39J+Xne7NMQYuTYw5ucS5mdFcysqw=;
	h=Date:To:From:Subject:From;
	b=gdTiZmuEmcRKv8ahfqDcMDXZYL0lnvXWuLqfjf5ISjM1LcH9P6cNq+ag5A/Uox3kS
	 fMKvmRZ2GHRcDyvP7YYuqNtv6YPPGfYeWBRQKd9T9+oaUKFp/OEZEfDlPs8F1KHFvo
	 pox8DGSp6t7n0dADu85VEoGUYUbrthvkUiCjPYpc=
Date: Wed, 18 Dec 2024 16:57:49 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-entry-element-member.patch added to mm-unstable branch
Message-Id: <20241219005750.49F6BC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: remove entry element member
has been added to the -mm mm-unstable branch.  Its filename is
     zram-remove-entry-element-member.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-entry-element-member.patch

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
Subject: zram: remove entry element member
Date: Wed, 18 Dec 2024 15:34:19 +0900

Element is in the same anon union as handle and hence holds the same
value, which makes code below sort of confusing

    handle = zram_get_handle()
    if (!handle)
	element = zram_get_element()

Element doesn't really simplify the code, let's just remove it.  We
already re-purpose handle to store the block id a written back page.

Link: https://lkml.kernel.org/r/20241218063513.297475-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   23 +++++------------------
 drivers/block/zram/zram_drv.h |    5 +----
 2 files changed, 6 insertions(+), 22 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-entry-element-member
+++ a/drivers/block/zram/zram_drv.c
@@ -112,17 +112,6 @@ static void zram_clear_flag(struct zram
 	zram->table[index].flags &= ~BIT(flag);
 }
 
-static inline void zram_set_element(struct zram *zram, u32 index,
-			unsigned long element)
-{
-	zram->table[index].element = element;
-}
-
-static unsigned long zram_get_element(struct zram *zram, u32 index)
-{
-	return zram->table[index].element;
-}
-
 static size_t zram_get_obj_size(struct zram *zram, u32 index)
 {
 	return zram->table[index].flags & (BIT(ZRAM_FLAG_SHIFT) - 1);
@@ -879,7 +868,7 @@ static ssize_t writeback_store(struct de
 
 		zram_free_page(zram, index);
 		zram_set_flag(zram, index, ZRAM_WB);
-		zram_set_element(zram, index, blk_idx);
+		zram_set_handle(zram, index, blk_idx);
 		blk_idx = 0;
 		atomic64_inc(&zram->stats.pages_stored);
 		spin_lock(&zram->wb_limit_lock);
@@ -1504,7 +1493,7 @@ static void zram_free_page(struct zram *
 
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
-		free_block_bdev(zram, zram_get_element(zram, index));
+		free_block_bdev(zram, zram_get_handle(zram, index));
 		goto out;
 	}
 
@@ -1548,12 +1537,10 @@ static int zram_read_from_zspool(struct
 
 	handle = zram_get_handle(zram, index);
 	if (!handle || zram_test_flag(zram, index, ZRAM_SAME)) {
-		unsigned long value;
 		void *mem;
 
-		value = handle ? zram_get_element(zram, index) : 0;
 		mem = kmap_local_page(page);
-		zram_fill_page(mem, PAGE_SIZE, value);
+		zram_fill_page(mem, PAGE_SIZE, handle);
 		kunmap_local(mem);
 		return 0;
 	}
@@ -1599,7 +1586,7 @@ static int zram_read_page(struct zram *z
 		 */
 		zram_slot_unlock(zram, index);
 
-		ret = read_from_bdev(zram, page, zram_get_element(zram, index),
+		ret = read_from_bdev(zram, page, zram_get_handle(zram, index),
 				     parent);
 	}
 
@@ -1750,7 +1737,7 @@ out:
 
 	if (flags) {
 		zram_set_flag(zram, index, flags);
-		zram_set_element(zram, index, element);
+		zram_set_handle(zram, index, element);
 	}  else {
 		zram_set_handle(zram, index, handle);
 		zram_set_obj_size(zram, index, comp_len);
--- a/drivers/block/zram/zram_drv.h~zram-remove-entry-element-member
+++ a/drivers/block/zram/zram_drv.h
@@ -62,10 +62,7 @@ enum zram_pageflags {
 
 /* Allocated for each disk page */
 struct zram_table_entry {
-	union {
-		unsigned long handle;
-		unsigned long element;
-	};
+	unsigned long handle;
 	unsigned int flags;
 	spinlock_t lock;
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch
zram-use-zram_read_from_zspool-in-writeback.patch
zram-cond_resched-in-writeback-loop.patch

