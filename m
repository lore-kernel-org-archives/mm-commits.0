Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B063C21
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hE+oLJyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC63C433C8;
	Mon, 11 Dec 2023 00:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256071;
	bh=5zovkt85AfTE8v8Y6+gv37l3vvRsfqdseL3CsA5ImgU=;
	h=Date:To:From:Subject:From;
	b=hE+oLJyRpEtpSTYA/w07dobEYOPn3zDlXhoa6Wr0O2iezr3mNq6gsY3Uy3Nlx6r6F
	 qrTHeZ5dA/BtAr7ro1nD5T7hfkb9+YUK9IsYHwKkFlS5u/dzqqflwqaK9mM2ZfUTGu
	 UAzXLuuauvmkAmwYopCVwENI718NOijj24nFVhZQ=
Date: Sun, 10 Dec 2023 16:54:31 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,dmaluka@chromium.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-split-memory-tracking-and-ac-time-tracking.patch removed from -mm tree
Message-Id: <20231211005431.8BC63C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: split memory-tracking and ac-time tracking
has been removed from the -mm tree.  Its filename was
     zram-split-memory-tracking-and-ac-time-tracking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: split memory-tracking and ac-time tracking
Date: Wed, 15 Nov 2023 11:42:12 +0900

ZRAM_MEMORY_TRACKING enables two features:
- per-entry ac-time tracking
- debugfs interface

The latter one is the reason why memory-tracking depends on DEBUG_FS,
while the former one is used far beyond debugging these days.  Namely
ac-time is used for fine grained writeback of idle entries (pages).

Move ac-time tracking under its own config option so that it can be
enabled (along with writeback) on systems without DEBUG_FS.

[senozhatsky@chromium.org: ifdef fixup, per Dmytro]
  Link: https://lkml.kernel.org/r/20231117013543.540280-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20231115024223.4133148-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Dmytro Maluka <dmaluka@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    2 -
 drivers/block/zram/Kconfig                  |   11 ++++++-
 drivers/block/zram/zram_drv.c               |   27 ++++++++----------
 drivers/block/zram/zram_drv.h               |    2 -
 4 files changed, 25 insertions(+), 17 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-split-memory-tracking-and-ac-time-tracking
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -328,7 +328,7 @@ as idle::
 From now on, any pages on zram are idle pages. The idle mark
 will be removed until someone requests access of the block.
 IOW, unless there is access request, those pages are still idle pages.
-Additionally, when CONFIG_ZRAM_MEMORY_TRACKING is enabled pages can be
+Additionally, when CONFIG_ZRAM_TRACK_ENTRY_ACTIME is enabled pages can be
 marked as idle based on how long (in seconds) it's been since they were
 last accessed::
 
--- a/drivers/block/zram/Kconfig~zram-split-memory-tracking-and-ac-time-tracking
+++ a/drivers/block/zram/Kconfig
@@ -69,9 +69,18 @@ config ZRAM_WRITEBACK
 
 	 See Documentation/admin-guide/blockdev/zram.rst for more information.
 
+config ZRAM_TRACK_ENTRY_ACTIME
+	bool "Track access time of zram entries"
+	depends on ZRAM
+	help
+	  With this feature zram tracks access time of every stored
+	  entry (page), which can be used for a more fine grained IDLE
+	  pages writeback.
+
 config ZRAM_MEMORY_TRACKING
 	bool "Track zRam block status"
 	depends on ZRAM && DEBUG_FS
+	select ZRAM_TRACK_ENTRY_ACTIME
 	help
 	  With this feature, admin can track the state of allocated blocks
 	  of zRAM. Admin could see the information via
@@ -86,4 +95,4 @@ config ZRAM_MULTI_COMP
 	  This will enable multi-compression streams, so that ZRAM can
 	  re-compress pages using a potentially slower but more effective
 	  compression algorithm. Note, that IDLE page recompression
-	  requires ZRAM_MEMORY_TRACKING.
+	  requires ZRAM_TRACK_ENTRY_ACTIME.
--- a/drivers/block/zram/zram_drv.c~zram-split-memory-tracking-and-ac-time-tracking
+++ a/drivers/block/zram/zram_drv.c
@@ -174,6 +174,14 @@ static inline u32 zram_get_priority(stru
 	return prio & ZRAM_COMP_PRIORITY_MASK;
 }
 
+static void zram_accessed(struct zram *zram, u32 index)
+{
+	zram_clear_flag(zram, index, ZRAM_IDLE);
+#ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
+	zram->table[index].ac_time = ktime_get_boottime();
+#endif
+}
+
 static inline void update_used_max(struct zram *zram,
 					const unsigned long pages)
 {
@@ -293,8 +301,9 @@ static void mark_idle(struct zram *zram,
 		zram_slot_lock(zram, index);
 		if (zram_allocated(zram, index) &&
 				!zram_test_flag(zram, index, ZRAM_UNDER_WB)) {
-#ifdef CONFIG_ZRAM_MEMORY_TRACKING
-			is_idle = !cutoff || ktime_after(cutoff, zram->table[index].ac_time);
+#ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
+			is_idle = !cutoff || ktime_after(cutoff,
+							 zram->table[index].ac_time);
 #endif
 			if (is_idle)
 				zram_set_flag(zram, index, ZRAM_IDLE);
@@ -317,7 +326,7 @@ static ssize_t idle_store(struct device
 		 */
 		u64 age_sec;
 
-		if (IS_ENABLED(CONFIG_ZRAM_MEMORY_TRACKING) && !kstrtoull(buf, 0, &age_sec))
+		if (IS_ENABLED(CONFIG_ZRAM_TRACK_ENTRY_ACTIME) && !kstrtoull(buf, 0, &age_sec))
 			cutoff_time = ktime_sub(ktime_get_boottime(),
 					ns_to_ktime(age_sec * NSEC_PER_SEC));
 		else
@@ -841,12 +850,6 @@ static void zram_debugfs_destroy(void)
 	debugfs_remove_recursive(zram_debugfs_root);
 }
 
-static void zram_accessed(struct zram *zram, u32 index)
-{
-	zram_clear_flag(zram, index, ZRAM_IDLE);
-	zram->table[index].ac_time = ktime_get_boottime();
-}
-
 static ssize_t read_block_state(struct file *file, char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -930,10 +933,6 @@ static void zram_debugfs_unregister(stru
 #else
 static void zram_debugfs_create(void) {};
 static void zram_debugfs_destroy(void) {};
-static void zram_accessed(struct zram *zram, u32 index)
-{
-	zram_clear_flag(zram, index, ZRAM_IDLE);
-};
 static void zram_debugfs_register(struct zram *zram) {};
 static void zram_debugfs_unregister(struct zram *zram) {};
 #endif
@@ -1254,7 +1253,7 @@ static void zram_free_page(struct zram *
 {
 	unsigned long handle;
 
-#ifdef CONFIG_ZRAM_MEMORY_TRACKING
+#ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 	zram->table[index].ac_time = 0;
 #endif
 	if (zram_test_flag(zram, index, ZRAM_IDLE))
--- a/drivers/block/zram/zram_drv.h~zram-split-memory-tracking-and-ac-time-tracking
+++ a/drivers/block/zram/zram_drv.h
@@ -69,7 +69,7 @@ struct zram_table_entry {
 		unsigned long element;
 	};
 	unsigned long flags;
-#ifdef CONFIG_ZRAM_MEMORY_TRACKING
+#ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 	ktime_t ac_time;
 #endif
 };
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

checkpatch-do-not-require-an-empty-line-before-error-injection.patch

