Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF702BE7DD
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966031; cv=none; b=UXQuWxwTxdayoSjhmKPdIJOvONAlie7m5fgNjG2WXqzKyv8R9l+aLM2OPzf+fBD3/VKBQm4ZmVJUKZSTLl9R67JClLMdLmtNDZ3XKZuJLG2bH1DxYtxfC+HZ5uzIE3YVpnVSvQ7RuVZwjrOeIKKMhjIdEzznqzd9w579r1d4LAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966031; c=relaxed/simple;
	bh=MRc/13wX0mlIrt7sEYowc082Wx6crr3m0gGSnKfG1io=;
	h=Date:To:From:Subject:Message-Id; b=nDV4kYPWQE3h429KHlSj7uAsXYu+RAXk39TgSkbO3pxHLE8tV+cMv4lEIC46gP9rpEby0JGUkevsi5Td3v5FuUL8ArLjEkV1NYgdcYDSRlHoVcYu+85JJTaGX9llx1Xp4bdZ8UgrpCdQXuqueZO8X++zaxpfJ2lcGMGV2lQVC7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pyrl1MVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pyrl1MVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7665C16AAE;
	Wed, 21 Jan 2026 03:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966030;
	bh=MRc/13wX0mlIrt7sEYowc082Wx6crr3m0gGSnKfG1io=;
	h=Date:To:From:Subject:From;
	b=Pyrl1MVMuzv/pLPjOKRK6ZvU1Q4glb3gKQkrZGP/0s1nSnIFhF7jXHqBl264/9qA2
	 NnvDCDPTRimDDf3wSDTiZK7t9CqtSADZ6SbjheWNSnuyzr+v+WUJ0zAg4Fkto4Iaa6
	 NERtH4yzmdiwMsCuk2zAVt3jywTQJonvlKXY6mhw=
Date: Tue, 20 Jan 2026 19:27:10 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-use-u32-for-entry-ac_time-tracking.patch removed from -mm tree
Message-Id: <20260121032710.B7665C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: use u32 for entry ac_time tracking
has been removed from the -mm tree.  Its filename was
     zram-use-u32-for-entry-ac_time-tracking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: use u32 for entry ac_time tracking
Date: Mon, 15 Dec 2025 14:47:11 +0900

We can reduce sizeof(zram_table_entry) on 64-bit systems by converting
flags and ac_time to u32.  Entry flags fit into u32, and for ac_time u32
gives us over a century of entry lifespan (approx 136 years) which is
plenty (zram uses system boot time (seconds)).

In struct zram_table_entry we use bytes aliasing, because bit-wait API
(for slot lock) requires a whole unsigned long word.

Link: https://lkml.kernel.org/r/d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: David Stevens <stevensd@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   60 ++++++++++++++++----------------
 drivers/block/zram/zram_drv.h |    9 +++-
 2 files changed, 37 insertions(+), 32 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-u32-for-entry-ac_time-tracking
+++ a/drivers/block/zram/zram_drv.c
@@ -81,7 +81,7 @@ static void zram_slot_lock_init(struct z
  */
 static __must_check bool zram_slot_trylock(struct zram *zram, u32 index)
 {
-	unsigned long *lock = &zram->table[index].flags;
+	unsigned long *lock = &zram->table[index].__lock;
 
 	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK, lock)) {
 		mutex_acquire(slot_dep_map(zram, index), 0, 1, _RET_IP_);
@@ -94,7 +94,7 @@ static __must_check bool zram_slot_trylo
 
 static void zram_slot_lock(struct zram *zram, u32 index)
 {
-	unsigned long *lock = &zram->table[index].flags;
+	unsigned long *lock = &zram->table[index].__lock;
 
 	mutex_acquire(slot_dep_map(zram, index), 0, 0, _RET_IP_);
 	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
@@ -103,7 +103,7 @@ static void zram_slot_lock(struct zram *
 
 static void zram_slot_unlock(struct zram *zram, u32 index)
 {
-	unsigned long *lock = &zram->table[index].flags;
+	unsigned long *lock = &zram->table[index].__lock;
 
 	mutex_release(slot_dep_map(zram, index), _RET_IP_);
 	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK, lock);
@@ -130,34 +130,33 @@ static void zram_set_handle(struct zram
 }
 
 static bool zram_test_flag(struct zram *zram, u32 index,
-			enum zram_pageflags flag)
+			   enum zram_pageflags flag)
 {
-	return zram->table[index].flags & BIT(flag);
+	return zram->table[index].attr.flags & BIT(flag);
 }
 
 static void zram_set_flag(struct zram *zram, u32 index,
-			enum zram_pageflags flag)
+			  enum zram_pageflags flag)
 {
-	zram->table[index].flags |= BIT(flag);
+	zram->table[index].attr.flags |= BIT(flag);
 }
 
 static void zram_clear_flag(struct zram *zram, u32 index,
-			enum zram_pageflags flag)
+			    enum zram_pageflags flag)
 {
-	zram->table[index].flags &= ~BIT(flag);
+	zram->table[index].attr.flags &= ~BIT(flag);
 }
 
 static size_t zram_get_obj_size(struct zram *zram, u32 index)
 {
-	return zram->table[index].flags & (BIT(ZRAM_FLAG_SHIFT) - 1);
+	return zram->table[index].attr.flags & (BIT(ZRAM_FLAG_SHIFT) - 1);
 }
 
-static void zram_set_obj_size(struct zram *zram,
-					u32 index, size_t size)
+static void zram_set_obj_size(struct zram *zram, u32 index, size_t size)
 {
-	unsigned long flags = zram->table[index].flags >> ZRAM_FLAG_SHIFT;
+	unsigned long flags = zram->table[index].attr.flags >> ZRAM_FLAG_SHIFT;
 
-	zram->table[index].flags = (flags << ZRAM_FLAG_SHIFT) | size;
+	zram->table[index].attr.flags = (flags << ZRAM_FLAG_SHIFT) | size;
 }
 
 static inline bool zram_allocated(struct zram *zram, u32 index)
@@ -208,14 +207,14 @@ static inline void zram_set_priority(str
 	 * Clear previous priority value first, in case if we recompress
 	 * further an already recompressed page
 	 */
-	zram->table[index].flags &= ~(ZRAM_COMP_PRIORITY_MASK <<
-				      ZRAM_COMP_PRIORITY_BIT1);
-	zram->table[index].flags |= (prio << ZRAM_COMP_PRIORITY_BIT1);
+	zram->table[index].attr.flags &= ~(ZRAM_COMP_PRIORITY_MASK <<
+					   ZRAM_COMP_PRIORITY_BIT1);
+	zram->table[index].attr.flags |= (prio << ZRAM_COMP_PRIORITY_BIT1);
 }
 
 static inline u32 zram_get_priority(struct zram *zram, u32 index)
 {
-	u32 prio = zram->table[index].flags >> ZRAM_COMP_PRIORITY_BIT1;
+	u32 prio = zram->table[index].attr.flags >> ZRAM_COMP_PRIORITY_BIT1;
 
 	return prio & ZRAM_COMP_PRIORITY_MASK;
 }
@@ -225,7 +224,7 @@ static void zram_accessed(struct zram *z
 	zram_clear_flag(zram, index, ZRAM_IDLE);
 	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
-	zram->table[index].ac_time = ktime_get_boottime();
+	zram->table[index].attr.ac_time = (u32)ktime_get_boottime_seconds();
 #endif
 }
 
@@ -447,7 +446,7 @@ static void mark_idle(struct zram *zram,
 
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 		is_idle = !cutoff ||
-			ktime_after(cutoff, zram->table[index].ac_time);
+			ktime_after(cutoff, zram->table[index].attr.ac_time);
 #endif
 		if (is_idle)
 			zram_set_flag(zram, index, ZRAM_IDLE);
@@ -461,18 +460,19 @@ static ssize_t idle_store(struct device
 			  const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	ktime_t cutoff_time = 0;
+	ktime_t cutoff = 0;
 
 	if (!sysfs_streq(buf, "all")) {
 		/*
 		 * If it did not parse as 'all' try to treat it as an integer
 		 * when we have memory tracking enabled.
 		 */
-		u64 age_sec;
+		u32 age_sec;
 
-		if (IS_ENABLED(CONFIG_ZRAM_TRACK_ENTRY_ACTIME) && !kstrtoull(buf, 0, &age_sec))
-			cutoff_time = ktime_sub(ktime_get_boottime(),
-					ns_to_ktime(age_sec * NSEC_PER_SEC));
+		if (IS_ENABLED(CONFIG_ZRAM_TRACK_ENTRY_ACTIME) &&
+		    !kstrtouint(buf, 0, &age_sec))
+			cutoff = ktime_sub((u32)ktime_get_boottime_seconds(),
+					   age_sec);
 		else
 			return -EINVAL;
 	}
@@ -482,10 +482,10 @@ static ssize_t idle_store(struct device
 		return -EINVAL;
 
 	/*
-	 * A cutoff_time of 0 marks everything as idle, this is the
+	 * A cutoff of 0 marks everything as idle, this is the
 	 * "all" behavior.
 	 */
-	mark_idle(zram, cutoff_time);
+	mark_idle(zram, cutoff);
 	return len;
 }
 
@@ -1588,7 +1588,7 @@ static ssize_t read_block_state(struct f
 		if (!zram_allocated(zram, index))
 			goto next;
 
-		ts = ktime_to_timespec64(zram->table[index].ac_time);
+		ts = ktime_to_timespec64(zram->table[index].attr.ac_time);
 		copied = snprintf(kbuf + written, count,
 			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
 			index, (s64)ts.tv_sec,
@@ -2013,7 +2013,7 @@ static void zram_slot_free(struct zram *
 	unsigned long handle;
 
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
-	zram->table[index].ac_time = 0;
+	zram->table[index].attr.ac_time = 0;
 #endif
 
 	zram_clear_flag(zram, index, ZRAM_IDLE);
@@ -3286,7 +3286,7 @@ static int __init zram_init(void)
 	struct zram_table_entry zram_te;
 	int ret;
 
-	BUILD_BUG_ON(__NR_ZRAM_PAGEFLAGS > sizeof(zram_te.flags) * 8);
+	BUILD_BUG_ON(__NR_ZRAM_PAGEFLAGS > sizeof(zram_te.attr.flags) * 8);
 
 	ret = cpuhp_setup_state_multi(CPUHP_ZCOMP_PREPARE, "block/zram:prepare",
 				      zcomp_cpu_up_prepare, zcomp_cpu_dead);
--- a/drivers/block/zram/zram_drv.h~zram-use-u32-for-entry-ac_time-tracking
+++ a/drivers/block/zram/zram_drv.h
@@ -65,10 +65,15 @@ enum zram_pageflags {
  */
 struct zram_table_entry {
 	unsigned long handle;
-	unsigned long flags;
+	union {
+		unsigned long __lock;
+		struct attr {
+			u32 flags;
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
-	ktime_t ac_time;
+			u32 ac_time;
 #endif
+		} attr;
+	};
 	struct lockdep_map dep_map;
 };
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zsmalloc-introduce-sg-list-based-object-read-api-fix.patch
zram-rename-init_lock-to-dev_lock.patch
zsmalloc-make-common-caches-global.patch

