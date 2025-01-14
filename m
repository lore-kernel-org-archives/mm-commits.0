Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD23D23D3E0
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837095; cv=none; b=lDi1dG0jRNONx+kdLQOINr4DRL+rTkI2tJfOvNXOJ/6mtvZ3oc3LBxe0++Xe/cIvKGjMwyHxwkJ5HB8jtLH5uTKjHoU0Vj0VfOOExR9txUhJHR34e33nQocDpV6UnJL4WtqfMayGXw+FW7JxwQDsJzW12DlRxPnmVoSD7VS3yAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837095; c=relaxed/simple;
	bh=8jrdSKOcEH0N5pVxyY+PjpbnAlbb81nstkoCNFXNKnU=;
	h=Date:To:From:Subject:Message-Id; b=CXLIwAuYoYNatLbp6q12kNdktYniFjUDkF5MZEEIo2Z6rLGvTzGOAwvYU+WeV/gAIWRQHyiZQQtRxp3GDLorE4/Cp9NUkyJBJORnKxtkXxTq6t7Hzu0kcA8ud6TleUWN0WWMc72hEJ81GWMyF8/BvDkAE+d7CZLuCzw1dFnRqoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e0tj9LQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e0tj9LQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91772C4CEDD;
	Tue, 14 Jan 2025 06:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837095;
	bh=8jrdSKOcEH0N5pVxyY+PjpbnAlbb81nstkoCNFXNKnU=;
	h=Date:To:From:Subject:From;
	b=e0tj9LQJfoVghYF1aIjPskn84uOe204fJBcnuw0eO4btftMAumPQSNfxD8YJw4F6P
	 NJDI0csshG6Wxn40ceJdqfSSwvnwEzb0PQ0SqWIg1Zcpa6O+Qvm7szsv5M+jcWKbOY
	 OnWVJbRLSCB6Aoj0x+0BSrOJf/6klPzZps4hwcjU=
Date: Mon, 13 Jan 2025 22:44:55 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-remove-entry-element-member.patch removed from -mm tree
Message-Id: <20250114064455.91772C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: remove entry element member
has been removed from the -mm tree.  Its filename was
     zram-remove-entry-element-member.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1505,7 +1494,7 @@ static void zram_free_page(struct zram *
 
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
-		free_block_bdev(zram, zram_get_element(zram, index));
+		free_block_bdev(zram, zram_get_handle(zram, index));
 		goto out;
 	}
 
@@ -1549,12 +1538,10 @@ static int zram_read_from_zspool(struct
 
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
@@ -1600,7 +1587,7 @@ static int zram_read_page(struct zram *z
 		 */
 		zram_slot_unlock(zram, index);
 
-		ret = read_from_bdev(zram, page, zram_get_element(zram, index),
+		ret = read_from_bdev(zram, page, zram_get_handle(zram, index),
 				     parent);
 	}
 
@@ -1751,7 +1738,7 @@ out:
 
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


