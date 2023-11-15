Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4698EC2BB3F
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 22:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbjKOWlv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 17:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbjKOWlu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 17:41:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFC61A1
        for <mm-commits@vger.kernel.org>; Wed, 15 Nov 2023 14:41:46 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450B3C433C9;
        Wed, 15 Nov 2023 22:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700088106;
        bh=TqEhKsNIFV1mD14OzjrbYJceXOe6HlUyPindjSGQIlE=;
        h=Date:To:From:Subject:From;
        b=LymshScrbFlAK3h3ZC94mqX6WLitWOU2n24juV9z/FvKjxqHvV3XTgrHFlM71zOt3
         df676V28Cq+ZNpFhROMZwCPZ3MS1yF6IKzi9sGqDXZfuxtB2dU8NN60FfDxFzrDqVs
         4aPng9rjrU23pC/yn+F5Bi3m5xS34bMY6WpqOV1Q=
Date:   Wed, 15 Nov 2023 14:41:45 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-split-memory-tracking-and-ac-time-tracking.patch added to mm-unstable branch
Message-Id: <20231115224146.450B3C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: split memory-tracking and ac-time tracking
has been added to the -mm mm-unstable branch.  Its filename is
     zram-split-memory-tracking-and-ac-time-tracking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-split-memory-tracking-and-ac-time-tracking.patch

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
Subject: zram: split memory-tracking and ac-time tracking
Date: Wed, 15 Nov 2023 11:42:12 +0900

ZRAM_MEMORY_TRACKING enables two features:
- per-entry ac-time tracking
- debugfs interface

The latter one is the reason why memory-tracking depends on DEBUG_FS,
while the former one is used far beyond debugging these days.  Namely
ac-time is used for fine-grained writeback of idle entries (pages).

Move ac-time tracking under its own config option so that it can be
enabled (along with writeback) on systems without DEBUG_FS.

Link: https://lkml.kernel.org/r/20231115024223.4133148-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
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
+	  entry (page), which can be used for a more fine-grained IDLE
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
+#ifdef ZRAM_TRACK_ENTRY_ACTIME
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

zram-split-memory-tracking-and-ac-time-tracking.patch
zram-tweak-writeback-config-help.patch

