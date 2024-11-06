Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E567D14386D
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854710; cv=none; b=BxaNN9N4GP3skQye9BNc9t0otyJnHfzDiJaF88ZYNfbxiK8WOPrrOv0LvjxTLgqZXOojX8/hotT5a8Znsq3DJA2yBpF2Nm5brMQxh9iChowWgQ64/h3gRhzTUuIYS/Ys98bnkq56bCxD3z7v0V8nrxS908OUssradagTjBPW0JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854710; c=relaxed/simple;
	bh=pVi27875Ph4qPff2rpFZzN1RGdk8DSuArZW9YIEqF7Q=;
	h=Date:To:From:Subject:Message-Id; b=lylgui6HF2zYnxgtOM/YetOdqrwwXJ2uBckO/dNixlJTgw93KBvLxFhhkVlkxDq51ii3O4XSTdfJa3JqYj0D32Jmqkx23hzsZR/GQ6a04c2twqPoaMuUUjvYtt3qRzocw5wrKRkUvGRFyXO7KXSdEZHWUiyivt8r0Kw38wmKWc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MHtbZOF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MHtbZOF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79812C4CED1;
	Wed,  6 Nov 2024 00:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854709;
	bh=pVi27875Ph4qPff2rpFZzN1RGdk8DSuArZW9YIEqF7Q=;
	h=Date:To:From:Subject:From;
	b=MHtbZOF0RvEZLTOu9VNpMKCPgDdmzbjC8hQ8wvUTY8AUaQsGpY0Uaxo8rl+KBYYVX
	 pxhI+fejS5nYrNcnR+CvewPmyvLroY45aCsC5u90qXPI1A7YyIlzHI48TnTtx2kRYx
	 4YiST64i1r55hozQZLH81EmIVJfsEcaDjtbaQakU=
Date: Tue, 05 Nov 2024 16:58:28 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-reshuffle-zram_free_page-flags-operations.patch removed from -mm tree
Message-Id: <20241106005829.79812C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: reshuffle zram_free_page() flags operations
has been removed from the -mm tree.  Its filename was
     zram-reshuffle-zram_free_page-flags-operations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: reshuffle zram_free_page() flags operations
Date: Tue, 17 Sep 2024 11:09:11 +0900

Drop some redundant zram_test_flag() calls and re-order zram_clear_flag()
calls.  Plus two small trivial coding style fixes.  No functional changes.

Link: https://lkml.kernel.org/r/20240917021020.883356-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-reshuffle-zram_free_page-flags-operations
+++ a/drivers/block/zram/zram_drv.c
@@ -1499,20 +1499,17 @@ static void zram_free_page(struct zram *
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 	zram->table[index].ac_time = 0;
 #endif
-	if (zram_test_flag(zram, index, ZRAM_IDLE))
-		zram_clear_flag(zram, index, ZRAM_IDLE);
+
+	zram_clear_flag(zram, index, ZRAM_IDLE);
+	zram_clear_flag(zram, index, ZRAM_INCOMPRESSIBLE);
+	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
+	zram_set_priority(zram, index, 0);
 
 	if (zram_test_flag(zram, index, ZRAM_HUGE)) {
 		zram_clear_flag(zram, index, ZRAM_HUGE);
 		atomic64_dec(&zram->stats.huge_pages);
 	}
 
-	if (zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
-		zram_clear_flag(zram, index, ZRAM_INCOMPRESSIBLE);
-
-	zram_set_priority(zram, index, 0);
-	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
-
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
 		free_block_bdev(zram, zram_get_element(zram, index));
@@ -1536,13 +1533,12 @@ static void zram_free_page(struct zram *
 	zs_free(zram->mem_pool, handle);
 
 	atomic64_sub(zram_get_obj_size(zram, index),
-			&zram->stats.compr_data_size);
+		     &zram->stats.compr_data_size);
 out:
 	atomic64_dec(&zram->stats.pages_stored);
 	zram_set_handle(zram, index, 0);
 	zram_set_obj_size(zram, index, 0);
-	WARN_ON_ONCE(zram->table[index].flags &
-		~(1UL << ZRAM_UNDER_WB));
+	WARN_ON_ONCE(zram->table[index].flags & ~(1UL << ZRAM_UNDER_WB));
 }
 
 /*
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-clear-idle-flag-after-recompression.patch
zram-clear-idle-flag-in-mark_idle.patch

