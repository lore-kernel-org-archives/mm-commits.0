Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD732F8E90
	for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 03:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785035413; cv=none; b=UclIxmN8CnkjdTS1DsQVj1N2OgJxujZBbFvAdjQ3t1kggq9AI7EUBKIf1r3ZNDUKMZVFNCFMAZxEW8s+URZciC7RdDcl6LhbwOHJjmB0OvUySazNAboVjrYCEFZQ+USoyr7y3umzJNyqRFPIaJ5RF+Ha3wEp/4XIBlGlbWyeqSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785035413; c=relaxed/simple;
	bh=OGmhEzr6HVg+bDRiiIH76SoGy/U0saP4YCYyNjqzS88=;
	h=Date:To:From:Subject:Message-Id; b=l6KOvDx4aw5Ncl6vnxzy9zbthuL34R4rGeqDNk4TJVI9kmoEUNb8jeKZP6Cuj46eonzNhkDgt8n+3sRO57MrIcN6T79o4yV2r6Jr/SEavB5kZYHC8QqsDz6laIxVu0YUH4yfFXsAR6olUXUPXXRxzUNUn9JUFH3Td2fOGflnkQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vS0u1n3j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vS0u1n3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCB41F000E9;
	Sun, 26 Jul 2026 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785035410;
	bh=84/Abhfu6lLq07k35lZMHDGMxsZgtiT7KmxGvolMVDY=;
	h=Date:To:From:Subject;
	b=vS0u1n3juaWRsIsbdVyghmL8XznLsPU75xombP8UHw1ZamoLRG8eKlntrLSoMD6tL
	 2G3anQdWngaJduNQUKq1lOI4/ukrEHriZWNdWROxo6cXYPf0UZ73dFl0PF+vuNOjPb
	 LzsnDojA2+GXjQx1idDREJj9Ky8tiFzqjXerSReo=
Date: Sat, 25 Jul 2026 20:10:10 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-move-lockmap-to-be-per-zram-instead-per-table.patch added to mm-new branch
Message-Id: <20260726031010.8BCB41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: move lockmap to be per-zram instead per table
has been added to the -mm mm-new branch.  Its filename is
     zram-move-lockmap-to-be-per-zram-instead-per-table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-move-lockmap-to-be-per-zram-instead-per-table.patch

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

zram-move-lockmap-to-be-per-zram-instead-per-table.patch
zram-use-a-custom-key-for-each-zram-object.patch

