Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36223B960C
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068158; cv=none; b=JfQwvzWrccX2/wXbuSMFeCfHED2ZeKL5Lq3Cv48YYnkbtIsUA7i2AAk2lL2QxkqVnIzem3/OcFegVM+GnLwZMuaoK8T4/fwtSWPpwRGzdrpUDwlhfpa/2jL/A9CdrP/3UI2LQSeV+zRaDS8jVPZdw0rw6c5LZrbzvqzAu/Ka7Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068158; c=relaxed/simple;
	bh=4dK4Jd56VGl2SNBlg1EPqymG0G+jQCfcOwQqXOvFh04=;
	h=Date:To:From:Subject:Message-Id; b=cGzIYsMRn8PETFsf35zbnXczS2Em14YIz3dL6OTeHdh3DyGpwVoLcQ9nJFGSwck3DAXga1hACF9lPfxuj+bhC2/r0tRdsw3dx/pSQqXWJPQL11ZRDi0HBU9p4tZHfE5DrjtCenJAtsUextSMxpYVavoO6wcukqt3OlOcqXZa3so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W8IPBeQi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W8IPBeQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD1C1F000E9;
	Fri,  7 Aug 2026 02:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068156;
	bh=u+Xp0wzvZF5bdmj4i/7fOI/J6zyzF29ka+zO14pSel4=;
	h=Date:To:From:Subject;
	b=W8IPBeQiaKCE/PMrqwZJ7wV2rcXU4fi9f3juu3b6AuEyyc5BqMHPzzW2D9i+VE6Ak
	 R1jMISr2FTVkgUFuSxpbyqyW0iNm5WiO8umzpm+KpsZhFygTGFw+wR17oHLHJdtmCy
	 O1ABV3Xb/9p6aykmOmWK3YwiX2sK0yN1/q4ajaks=
Date: Thu, 06 Aug 2026 19:02:36 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-move-lockmap-to-be-per-zram-instead-per-table.patch removed from -mm tree
Message-Id: <20260807020236.9AD1C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: move lockmap to be per-zram instead per table
has been removed from the -mm tree.  Its filename was
     zram-move-lockmap-to-be-per-zram-instead-per-table.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: zram: move lockmap to be per-zram instead per table
Date: Tue, 14 Jul 2026 16:12:59 +0200

Patch series "zram: lockmap tweaks".


This patch (of 2):

The zram object contains an array zram_table_entry.  Each one has a `lock'
variable and each has a matching struct lockdep_map.  This mimics a struct
mutex.

It uses always the same key for all lockdep_map instances.  This makes it
look like the same lock to lockdep.  Therefore it could be reduced to have
one lockdep_map per struct zram.

Use only one struct lockdep_map per struct zram.

Link: https://lore.kernel.org/20260714141300.3945672-1-bigeasy@linutronix.de
Link: https://lore.kernel.org/20260714141300.3945672-2-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   21 +++++++++------------
 drivers/block/zram/zram_drv.h |    2 +-
 2 files changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-move-lockmap-to-be-per-zram-instead-per-table
+++ a/drivers/block/zram/zram_drv.c
@@ -57,14 +57,12 @@ static size_t huge_class_size;
 static const struct block_device_operations zram_devops;
 
 static void slot_free(struct zram *zram, u32 index);
-#define slot_dep_map(zram, index) (&(zram)->table[(index)].dep_map)
 
-static void slot_lock_init(struct zram *zram, u32 index)
+static void slot_lock_init(struct zram *zram)
 {
 	static struct lock_class_key __key;
 
-	lockdep_init_map(slot_dep_map(zram, index), "zram->table[index].lock",
-			 &__key, 0);
+	lockdep_init_map(&zram->table_lock_map, "zram->table[index].lock", &__key, 0);
 }
 
 /*
@@ -84,8 +82,8 @@ static __must_check bool slot_trylock(st
 	unsigned long *lock = &zram->table[index].__lock;
 
 	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK, lock)) {
-		mutex_acquire(slot_dep_map(zram, index), 0, 1, _RET_IP_);
-		lock_acquired(slot_dep_map(zram, index), _RET_IP_);
+		mutex_acquire(&zram->table_lock_map, 0, 1, _RET_IP_);
+		lock_acquired(&zram->table_lock_map, _RET_IP_);
 		return true;
 	}
 
@@ -96,16 +94,16 @@ static void slot_lock(struct zram *zram,
 {
 	unsigned long *lock = &zram->table[index].__lock;
 
-	mutex_acquire(slot_dep_map(zram, index), 0, 0, _RET_IP_);
+	mutex_acquire(&zram->table_lock_map, 0, 0, _RET_IP_);
 	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
-	lock_acquired(slot_dep_map(zram, index), _RET_IP_);
+	lock_acquired(&zram->table_lock_map, _RET_IP_);
 }
 
 static void slot_unlock(struct zram *zram, u32 index)
 {
 	unsigned long *lock = &zram->table[index].__lock;
 
-	mutex_release(slot_dep_map(zram, index), _RET_IP_);
+	mutex_release(&zram->table_lock_map, _RET_IP_);
 	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK, lock);
 }
 
@@ -1984,7 +1982,7 @@ static void zram_meta_free(struct zram *
 
 static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 {
-	size_t num_pages, index;
+	size_t num_pages;
 
 	num_pages = disksize >> PAGE_SHIFT;
 	zram->table = vzalloc(array_size(num_pages, sizeof(*zram->table)));
@@ -2001,8 +1999,7 @@ static bool zram_meta_alloc(struct zram
 	if (!huge_class_size)
 		huge_class_size = zs_huge_class_size(zram->mem_pool);
 
-	for (index = 0; index < num_pages; index++)
-		slot_lock_init(zram, index);
+	slot_lock_init(zram);
 
 	return true;
 }
--- a/drivers/block/zram/zram_drv.h~zram-move-lockmap-to-be-per-zram-instead-per-table
+++ a/drivers/block/zram/zram_drv.h
@@ -74,7 +74,6 @@ struct zram_table_entry {
 #endif
 		} attr;
 	};
-	struct lockdep_map dep_map;
 };
 
 struct zram_stats {
@@ -107,6 +106,7 @@ struct zram_stats {
 
 struct zram {
 	struct zram_table_entry *table;
+	struct lockdep_map table_lock_map;
 	struct zs_pool *mem_pool;
 	struct zcomp *comps[ZRAM_MAX_COMPS];
 	struct zcomp_params params[ZRAM_MAX_COMPS];
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


