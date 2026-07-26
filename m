Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6618C19E839
	for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 03:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785035414; cv=none; b=FfBMCdvYyabo6rRNC0znkFwU6zJkY0MgmtaiUKcPa62i+H+AKmptxs2X2ojB62XO6fWW+KWGBmpNgHrPa3j8DMHkeM2d5NpJKXsJQs1guI7QYV5BXz4rE+N8Ve3GfV+7jY1Wm/IWDNwk99Yjj9Uq6oYstrWxErXV/p3YRLEaFfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785035414; c=relaxed/simple;
	bh=ThX6g1hjcPi5nKWMwZoTefOFHFSvpduvPLsuDHUpSvk=;
	h=Date:To:From:Subject:Message-Id; b=LLlxaBDM/3v4kIy5hjDbJqqYVl4Vi40o33VJMaiLY2KNd/Q0ziFrWX/FLwaY7sgxZNQ8UAIvk9oX6kqxVyf7MiLhmRKPb7/NAw6vHJQ7qyq3VGNVqQWf14ZcQPynLKyoTz3A8HNOMZiPJfKkkQNaega1tqQSEbsj/J5B/CeSoos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CmTuzR5B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CmTuzR5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FF21F00A3A;
	Sun, 26 Jul 2026 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785035413;
	bh=C9zTQ3/CqtY70/OiCSCB5H8vrudWcYUcHrclHaD90j0=;
	h=Date:To:From:Subject;
	b=CmTuzR5BAYeZniTIg8h1TimyAjtgBcfo/OG/vuT9ok94wkD+8OwPDkRs1+quqTHZv
	 LDOm49rk4muLq1zzBJFKkSD/a2gmH6fJHxx5XlWKymXPVNJb/jXgbe7Yj893QbdNSZ
	 xvHbqg5E9XGN7ermRhQ0Wkwql8pophh5F8vP5uhA=
Date: Sat, 25 Jul 2026 20:10:12 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-use-a-custom-key-for-each-zram-object.patch added to mm-new branch
Message-Id: <20260726031013.05FF21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: use a custom key for each zram object
has been added to the -mm mm-new branch.  Its filename is
     zram-use-a-custom-key-for-each-zram-object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-use-a-custom-key-for-each-zram-object.patch

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

zram-move-lockmap-to-be-per-zram-instead-per-table.patch
zram-use-a-custom-key-for-each-zram-object.patch

