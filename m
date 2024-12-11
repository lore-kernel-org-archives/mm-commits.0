Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EEE42A95
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733878515; cv=none; b=aC6uBcgOCkNjfrVzXklQON5ynaUAVifp6qUlBePq6odgXzLFKD6P+D64zNM/PQMfOldjQaj/Gw4lw/qVIc1U7DIP4itpaUBTlCPHVk6WKq3svSwMbRtaWhKcuKZ4qmqEUiM50skteW9UK3TBjgdsh3CjzJIZVchGJtfknmp1FqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733878515; c=relaxed/simple;
	bh=aqpvoip5ciqBwHvzYwQEDhfJmzYbMcSnXipZvnVi5GA=;
	h=Date:To:From:Subject:Message-Id; b=X7YK6efSTRNifAAusCYupMr2JcRbCfvJxaUj68rkpwDcXVbN4ODMY2xLQlXT3m/WVEs9HUv1xlkOUMxBzkRwGtl1W2/tSDkkR9ASI/T0Il/TELswVSQCfZBffe1h5ZIhGAaDnGh0R85WlAqbtgnqVyxzDNFHWikLP90wmIUItlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OarrBNLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OarrBNLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647E0C4CED6;
	Wed, 11 Dec 2024 00:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733878514;
	bh=aqpvoip5ciqBwHvzYwQEDhfJmzYbMcSnXipZvnVi5GA=;
	h=Date:To:From:Subject:From;
	b=OarrBNLOAv1+kbov+duuO2ThlkQjvzSXcwK8GfkgthikGx7pAqZOpX26xGsC0Nb/c
	 rvJutGZRbneYVCYF+mzjmnQUi81xuKItGMtC92PlyKeTyB20CX0sozsH3U9fS/ZYxY
	 HNDY0pxs2qWAmlNTM+uVvjDZxV8799I2R8VtUAyg=
Date: Tue, 10 Dec 2024 16:55:13 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-entry-element-member.patch added to mm-unstable branch
Message-Id: <20241211005514.647E0C4CED6@smtp.kernel.org>
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
Date: Tue, 10 Dec 2024 19:53:57 +0900

Element is in the same anon union as handle and hence holds the same
value, which makes code below sort of confusing

    handle = zram_get_handle()
    if (!handle)
	element = zram_get_element()

Element doesn't really simplify the code, let's just remove it.  We
already re-purpose handle to store the block id a written back page.

Link: https://lkml.kernel.org/r/20241210105420.1888790-4-senozhatsky@chromium.org
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
@@ -1506,7 +1495,7 @@ static void zram_free_page(struct zram *
 
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
-		free_block_bdev(zram, zram_get_element(zram, index));
+		free_block_bdev(zram, zram_get_handle(zram, index));
 		goto out;
 	}
 
@@ -1550,12 +1539,10 @@ static int zram_read_from_zspool(struct
 
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
@@ -1601,7 +1588,7 @@ static int zram_read_page(struct zram *z
 		 */
 		zram_slot_unlock(zram, index);
 
-		ret = read_from_bdev(zram, page, zram_get_element(zram, index),
+		ret = read_from_bdev(zram, page, zram_get_handle(zram, index),
 				     parent);
 	}
 
@@ -1760,7 +1747,7 @@ out:
 
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

zram-panic-when-use-ext4-over-zram-fix.patch
zram-cond_resched-in-writeback-loop.patch
zram-free-slot-memory-early-during-write.patch
zram-remove-entry-element-member.patch
zram-factor-out-zram_same-write.patch
zram-factor-out-zram_huge-write.patch
zram-factor-out-different-page-types-read.patch

