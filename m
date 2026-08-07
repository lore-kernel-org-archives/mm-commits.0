Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC7E3BED38
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068159; cv=none; b=hS3mr9aC09BYm9cx1DBjgJzU/7zhKkmfzlHVqFACQx+0NeSRT0pTR+cQNvhIMWiSiufdkP8E6LKBfyto1baZ+liUw4iIQ5q3Uxkd+PPJ3FjQxlot3KFTRKrwe+Fr9CuqM7rifSs3ZkHHKUI3wZQt09AcemECRsN/aOTclcftzoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068159; c=relaxed/simple;
	bh=3p71XzdWJYWqKsoqtVlvqdJGci7MbHLCwGBfp8RufWc=;
	h=Date:To:From:Subject:Message-Id; b=QHqII4OY50DwjCudsqk3csVaQj1j6Y+kWOzcg1rKV5fayCr4W3orbbhH0vWbQkPmJNFESN7A/f0HTFtYR8Zvaz4oPxk5WWuMOKTlfSvTICRuNJhcJZ/VIrkLMm0/w4bgq+oI1HG96Aeia/a83xfFz7S+jlALclWaKSuuS9ItDSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=acDmghYH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="acDmghYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C541F00A3A;
	Fri,  7 Aug 2026 02:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068157;
	bh=/MtcSlN0/PQwmSxRukGfqhOLDLBLI5W+ad/YEDMHUyQ=;
	h=Date:To:From:Subject;
	b=acDmghYHq8Tri+Dz9R/S0nJ9pGD8R3vc1HYyb8My4nsUeeaAWP6ZM9C/At3vcDs2g
	 0xVV79oM/iQt/C6ykXn5kWNod1sixYrCjm+BMBPdtRHVMNb74Nw95g1XGFiPZzTT9Q
	 rXczN8LP4AmT950uimrY+h3zQ6slLXVLr2H0fU34=
Date: Thu, 06 Aug 2026 19:02:37 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-use-a-custom-key-for-each-zram-object.patch removed from -mm tree
Message-Id: <20260807020237.B9C541F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: use a custom key for each zram object
has been removed from the -mm tree.  Its filename was
     zram-use-a-custom-key-for-each-zram-object.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: zram: use a custom key for each zram object
Date: Tue, 14 Jul 2026 16:13:00 +0200

Each struct zram uses the same key for its struct lockdep_map which is
used for locking analysis.

According to Sergey the lock chains might be different if zram1 is used
for and zram2 is for ext4.  This might lead to false dead lock reports if
it mixes a zram1 chain with a zram2.  This can be avoided if each lockmap
gets its own unique key.c

Use a dynamic lock_class_key for the table_lock_map.

Link: https://lore.kernel.org/20260714141300.3945672-3-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 +++--------
 drivers/block/zram/zram_drv.h |    1 +
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-a-custom-key-for-each-zram-object
+++ a/drivers/block/zram/zram_drv.c
@@ -58,13 +58,6 @@ static const struct block_device_operati
 
 static void slot_free(struct zram *zram, u32 index);
 
-static void slot_lock_init(struct zram *zram)
-{
-	static struct lock_class_key __key;
-
-	lockdep_init_map(&zram->table_lock_map, "zram->table[index].lock", &__key, 0);
-}
-
 /*
  * entry locking rules:
  *
@@ -1978,6 +1971,7 @@ static void zram_meta_free(struct zram *
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
 	zram->table = NULL;
+	lockdep_unregister_key(&zram->table_lock_key);
 }
 
 static bool zram_meta_alloc(struct zram *zram, u64 disksize)
@@ -1999,7 +1993,8 @@ static bool zram_meta_alloc(struct zram
 	if (!huge_class_size)
 		huge_class_size = zs_huge_class_size(zram->mem_pool);
 
-	slot_lock_init(zram);
+	lockdep_register_key(&zram->table_lock_key);
+	lockdep_init_map(&zram->table_lock_map, "zram->table[index].lock", &zram->table_lock_key, 0);
 
 	return true;
 }
--- a/drivers/block/zram/zram_drv.h~zram-use-a-custom-key-for-each-zram-object
+++ a/drivers/block/zram/zram_drv.h
@@ -107,6 +107,7 @@ struct zram_stats {
 struct zram {
 	struct zram_table_entry *table;
 	struct lockdep_map table_lock_map;
+	struct lock_class_key table_lock_key;
 	struct zs_pool *mem_pool;
 	struct zcomp *comps[ZRAM_MAX_COMPS];
 	struct zcomp_params params[ZRAM_MAX_COMPS];
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


