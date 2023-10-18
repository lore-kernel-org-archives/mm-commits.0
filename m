Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AB8CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344834AbjJRVhj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235337AbjJRVgw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4AED77
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:36:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34D7C433C8;
        Wed, 18 Oct 2023 21:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664961;
        bh=u3XQAwUBF+JgmiYMOPKyp0XLNj8emh7b8RZfXw7Ete0=;
        h=Date:To:From:Subject:From;
        b=0wTCMDGrdbEHNRLDPa6rqZm63sHKMNcM7yH5duyQCUCOaVJ39yEEIUp1xagjjb2fS
         xKvJJrj5Ptfvr5zGFZOdUoVIU1OHjH2oYrPR/XEqkoiBlB6NCzt1sgxiOvkGHwIyZx
         /n45pG+Y7ztATsh4JacDet7YO0CYgz19mKoO+wVg=
Date:   Wed, 18 Oct 2023 14:36:00 -0700
To:     mm-commits@vger.kernel.org, vschneid@redhat.com,
        vincent.guittot@linaro.org, sclaibin@gmail.com,
        rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com,
        mingo@kernel.org, mgorman@suse.de, juri.lelli@redhat.com,
        dietmar.eggemann@arm.com, bsegall@google.com, bristot@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-remove-wait-bookmarks.patch removed from -mm tree
Message-Id: <20231018213601.B34D7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sched: remove wait bookmarks
has been removed from the -mm tree.  Its filename was
     sched-remove-wait-bookmarks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: sched: remove wait bookmarks
Date: Tue, 10 Oct 2023 04:58:29 +0100

There are no users of wait bookmarks left, so simplify the wait
code by removing them.

Link: https://lkml.kernel.org/r/20231010035829.544242-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Benjamin Segall <bsegall@google.com>
Cc: Bin Lai <sclaibin@gmail.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |    9 ++----
 kernel/sched/wait.c  |   60 ++++++-----------------------------------
 2 files changed, 13 insertions(+), 56 deletions(-)

--- a/include/linux/wait.h~sched-remove-wait-bookmarks
+++ a/include/linux/wait.h
@@ -19,10 +19,9 @@ int default_wake_function(struct wait_qu
 /* wait_queue_entry::flags */
 #define WQ_FLAG_EXCLUSIVE	0x01
 #define WQ_FLAG_WOKEN		0x02
-#define WQ_FLAG_BOOKMARK	0x04
-#define WQ_FLAG_CUSTOM		0x08
-#define WQ_FLAG_DONE		0x10
-#define WQ_FLAG_PRIORITY	0x20
+#define WQ_FLAG_CUSTOM		0x04
+#define WQ_FLAG_DONE		0x08
+#define WQ_FLAG_PRIORITY	0x10
 
 /*
  * A single wait-queue entry structure:
@@ -212,8 +211,6 @@ __remove_wait_queue(struct wait_queue_he
 int __wake_up(struct wait_queue_head *wq_head, unsigned int mode, int nr, void *key);
 void __wake_up_on_current_cpu(struct wait_queue_head *wq_head, unsigned int mode, void *key);
 void __wake_up_locked_key(struct wait_queue_head *wq_head, unsigned int mode, void *key);
-void __wake_up_locked_key_bookmark(struct wait_queue_head *wq_head,
-		unsigned int mode, void *key, wait_queue_entry_t *bookmark);
 void __wake_up_sync_key(struct wait_queue_head *wq_head, unsigned int mode, void *key);
 void __wake_up_locked_sync_key(struct wait_queue_head *wq_head, unsigned int mode, void *key);
 void __wake_up_locked(struct wait_queue_head *wq_head, unsigned int mode, int nr);
--- a/kernel/sched/wait.c~sched-remove-wait-bookmarks
+++ a/kernel/sched/wait.c
@@ -58,13 +58,6 @@ void remove_wait_queue(struct wait_queue
 EXPORT_SYMBOL(remove_wait_queue);
 
 /*
- * Scan threshold to break wait queue walk.
- * This allows a waker to take a break from holding the
- * wait queue lock during the wait queue walk.
- */
-#define WAITQUEUE_WALK_BREAK_CNT 64
-
-/*
  * The core wakeup function. Non-exclusive wakeups (nr_exclusive == 0) just
  * wake everything up. If it's an exclusive wakeup (nr_exclusive == small +ve
  * number) then we wake that number of exclusive tasks, and potentially all
@@ -78,21 +71,13 @@ EXPORT_SYMBOL(remove_wait_queue);
  * zero in this (rare) case, and we handle it by continuing to scan the queue.
  */
 static int __wake_up_common(struct wait_queue_head *wq_head, unsigned int mode,
-			int nr_exclusive, int wake_flags, void *key,
-			wait_queue_entry_t *bookmark)
+			int nr_exclusive, int wake_flags, void *key)
 {
 	wait_queue_entry_t *curr, *next;
-	int cnt = 0;
 
 	lockdep_assert_held(&wq_head->lock);
 
-	if (bookmark && (bookmark->flags & WQ_FLAG_BOOKMARK)) {
-		curr = list_next_entry(bookmark, entry);
-
-		list_del(&bookmark->entry);
-		bookmark->flags = 0;
-	} else
-		curr = list_first_entry(&wq_head->head, wait_queue_entry_t, entry);
+	curr = list_first_entry(&wq_head->head, wait_queue_entry_t, entry);
 
 	if (&curr->entry == &wq_head->head)
 		return nr_exclusive;
@@ -101,21 +86,11 @@ static int __wake_up_common(struct wait_
 		unsigned flags = curr->flags;
 		int ret;
 
-		if (flags & WQ_FLAG_BOOKMARK)
-			continue;
-
 		ret = curr->func(curr, mode, wake_flags, key);
 		if (ret < 0)
 			break;
 		if (ret && (flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
 			break;
-
-		if (bookmark && (++cnt > WAITQUEUE_WALK_BREAK_CNT) &&
-				(&next->entry != &wq_head->head)) {
-			bookmark->flags = WQ_FLAG_BOOKMARK;
-			list_add_tail(&bookmark->entry, &next->entry);
-			break;
-		}
 	}
 
 	return nr_exclusive;
@@ -125,20 +100,12 @@ static int __wake_up_common_lock(struct
 			int nr_exclusive, int wake_flags, void *key)
 {
 	unsigned long flags;
-	wait_queue_entry_t bookmark;
-	int remaining = nr_exclusive;
+	int remaining;
 
-	bookmark.flags = 0;
-	bookmark.private = NULL;
-	bookmark.func = NULL;
-	INIT_LIST_HEAD(&bookmark.entry);
-
-	do {
-		spin_lock_irqsave(&wq_head->lock, flags);
-		remaining = __wake_up_common(wq_head, mode, remaining,
-						wake_flags, key, &bookmark);
-		spin_unlock_irqrestore(&wq_head->lock, flags);
-	} while (bookmark.flags & WQ_FLAG_BOOKMARK);
+	spin_lock_irqsave(&wq_head->lock, flags);
+	remaining = __wake_up_common(wq_head, mode, nr_exclusive, wake_flags,
+			key);
+	spin_unlock_irqrestore(&wq_head->lock, flags);
 
 	return nr_exclusive - remaining;
 }
@@ -171,23 +138,16 @@ void __wake_up_on_current_cpu(struct wai
  */
 void __wake_up_locked(struct wait_queue_head *wq_head, unsigned int mode, int nr)
 {
-	__wake_up_common(wq_head, mode, nr, 0, NULL, NULL);
+	__wake_up_common(wq_head, mode, nr, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(__wake_up_locked);
 
 void __wake_up_locked_key(struct wait_queue_head *wq_head, unsigned int mode, void *key)
 {
-	__wake_up_common(wq_head, mode, 1, 0, key, NULL);
+	__wake_up_common(wq_head, mode, 1, 0, key);
 }
 EXPORT_SYMBOL_GPL(__wake_up_locked_key);
 
-void __wake_up_locked_key_bookmark(struct wait_queue_head *wq_head,
-		unsigned int mode, void *key, wait_queue_entry_t *bookmark)
-{
-	__wake_up_common(wq_head, mode, 1, 0, key, bookmark);
-}
-EXPORT_SYMBOL_GPL(__wake_up_locked_key_bookmark);
-
 /**
  * __wake_up_sync_key - wake up threads blocked on a waitqueue.
  * @wq_head: the waitqueue
@@ -233,7 +193,7 @@ EXPORT_SYMBOL_GPL(__wake_up_sync_key);
 void __wake_up_locked_sync_key(struct wait_queue_head *wq_head,
 			       unsigned int mode, void *key)
 {
-        __wake_up_common(wq_head, mode, 1, WF_SYNC, key, NULL);
+        __wake_up_common(wq_head, mode, 1, WF_SYNC, key);
 }
 EXPORT_SYMBOL_GPL(__wake_up_locked_sync_key);
 
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch
mpage-convert-map_buffer_to_folio-to-folio_create_empty_buffers.patch
ext4-convert-to-folio_create_empty_buffers.patch
buffer-add-get_nth_bh.patch
gfs2-convert-inode-unstuffing-to-use-a-folio.patch
gfs2-convert-gfs2_getbuf-to-folios.patch
gfs2-convert-gfs2_getjdatabuf-to-use-a-folio.patch
gfs2-convert-gfs2_write_buf_to_page-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_freeze_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_grab_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch
nilfs2-convert-nilfs_mdt_forget_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_get_frozen_buffer-to-use-a-folio.patch
nilfs2-remove-nilfs_page_get_nth_block.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-folio_create_empty_buffers.patch
ntfs-convert-ntfs_read_block-to-use-a-folio.patch
ntfs-convert-ntfs_writepage-to-use-a-folio.patch
ntfs-convert-ntfs_prepare_pages_for_non_resident_write-to-folios.patch
ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_page_blocks-to-use-a-folio.patch
reiserfs-convert-writepage-to-use-a-folio.patch
ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio.patch
ufs-use-ufs_get_locked_folio-in-ufs_alloc_lastblock.patch
ufs-convert-ufs_change_blocknr-to-use-folios.patch
ufs-remove-ufs_get_locked_page.patch
buffer-remove-folio_create_empty_buffers.patch

