Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFEA374170;
	Tue, 25 Aug 2026 01:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622915; cv=none; b=p7ptL9eX8Mvze5S3pGc/g2p7Turg+iK6ljbdHi/wCehDL8nBOqzVtDWz2iXJNPVlHqeB0l/zTfeR8lWiFrggy9YKXvIMx0qBRgbVZrkUIf3f2ddWIwsUSAeWaq0Kj94DctJmS2mhbWaXJApvdjLGmyXZDnjJzlEdYOfvjxgLvdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622915; c=relaxed/simple;
	bh=kPAGCdy+OAdyCtSQIMl4fEdlUgAvlv8YTucvotB0a94=;
	h=Date:To:From:Subject:Message-Id; b=NLEXtK+cM4srCwPxueCoEHKWIzk5AIPYUE3X2YuU4Rx6Ef8DG8BVLZtc8ECdRE2oT3ufGI/qUdujaMoC97nfzCuGWJsfKWdaam9VZNOA4qhE5JewIi4d7uEB9HmEuSMXcQj9VD1OpIdf81ucrEYabZAqfnR2FjkM4TPzeedM4IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iY6yHToL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iY6yHToL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E493D1F00A3A;
	Tue, 25 Aug 2026 01:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622913;
	bh=Fhqu5bMi5nUdgeC/dyLkj6K25le8wL4hDEAn42hU+uY=;
	h=Date:To:From:Subject;
	b=iY6yHToLVv6nAMyp5t9UrSZOcebl9CPBDqTz9Yc8Xk8aUFPNUkPM11zVg4zrFMSYk
	 WpMf/QbAQY5EYWGe8vecjA8zRj0iItgkKOxbqOYryc6Owp2+p/3a36WjTpMYSKbzMt
	 AExlbHhQ/lJTYBVTSSE+sDchjVEGE/60XXgFgSqQ=
Date: Mon, 24 Aug 2026 18:55:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-fix-slot-lock-bit-position-on-big-endian-64-bit.patch removed from -mm tree
Message-Id: <20260825015512.E493D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fix slot lock bit position on big-endian 64-bit
has been removed from the -mm tree.  Its filename was
     zram-fix-slot-lock-bit-position-on-big-endian-64-bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Carlier <devnexen@gmail.com>
Subject: zram: fix slot lock bit position on big-endian 64-bit
Date: Mon, 10 Aug 2026 21:22:37 +0100

The slot lock is a bit operation on the whole __lock word, which flags and
ac_time alias as two u32s.  On little-endian the lock bit lands in the
position ZRAM_ENTRY_LOCK reserves in flags, so the aliasing works out.  On
64-bit big-endian it lands in ac_time instead: with
ZRAM_TRACK_ENTRY_ACTIME enabled, storing the access time from
mark_slot_accessed() or slot_free() wipes out the held lock bit, letting
another CPU take the same slot lock; an access time value with that bit
set makes the slot look locked forever.

Shift the lock bit into the flags half of the word on big-endian 64-bit.

Link: https://lore.kernel.org/20260810202241.2436603-1-devnexen@gmail.com
Fixes: 2e8ff2f51dde ("zram: use u32 for entry ac_time tracking")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 drivers/block/zram/zram_drv.h |   14 ++++++++++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-slot-lock-bit-position-on-big-endian-64-bit
+++ a/drivers/block/zram/zram_drv.c
@@ -74,7 +74,7 @@ static __must_check bool slot_trylock(st
 {
 	unsigned long *lock = &zram->table[index].__lock;
 
-	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK, lock)) {
+	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK_BIT, lock)) {
 		mutex_acquire(&zram->table_lock_map, 0, 1, _RET_IP_);
 		lock_acquired(&zram->table_lock_map, _RET_IP_);
 		return true;
@@ -88,7 +88,7 @@ static void slot_lock(struct zram *zram,
 	unsigned long *lock = &zram->table[index].__lock;
 
 	mutex_acquire(&zram->table_lock_map, 0, 0, _RET_IP_);
-	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
+	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK_BIT, TASK_UNINTERRUPTIBLE);
 	lock_acquired(&zram->table_lock_map, _RET_IP_);
 }
 
@@ -97,7 +97,7 @@ static void slot_unlock(struct zram *zra
 	unsigned long *lock = &zram->table[index].__lock;
 
 	mutex_release(&zram->table_lock_map, _RET_IP_);
-	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK, lock);
+	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK_BIT, lock);
 }
 
 static inline bool init_done(struct zram *zram)
--- a/drivers/block/zram/zram_drv.h~zram-fix-slot-lock-bit-position-on-big-endian-64-bit
+++ a/drivers/block/zram/zram_drv.h
@@ -15,6 +15,7 @@
 #ifndef _ZRAM_DRV_H_
 #define _ZRAM_DRV_H_
 
+#include <asm/byteorder.h>
 #include <linux/rwsem.h>
 #include <linux/zsmalloc.h>
 
@@ -58,6 +59,19 @@ enum zram_pageflags {
 };
 
 /*
+ * The slot lock is a bit-wait lock on the whole __lock word, while
+ * flags and ac_time alias that word as two u32s.  The lock bit must
+ * land in the slot that ZRAM_ENTRY_LOCK reserves in attr.flags; on
+ * 64-bit big-endian the flags word maps to the upper half of __lock,
+ * so the bit position has to be shifted up.
+ */
+#if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
+#define ZRAM_ENTRY_LOCK_BIT  (ZRAM_ENTRY_LOCK + 32)
+#else
+#define ZRAM_ENTRY_LOCK_BIT  ZRAM_ENTRY_LOCK
+#endif
+
+/*
  * Allocated for each disk page.  We use bit-lock (ZRAM_ENTRY_LOCK bit
  * of flags) to save memory.  There can be plenty of entries and standard
  * locking primitives (e.g. mutex) will significantly increase sizeof()
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

