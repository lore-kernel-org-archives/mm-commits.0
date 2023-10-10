Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED1CCD8CAC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 18:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbjJJSSL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Oct 2023 14:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjJJSSK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2023 14:18:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCEE9D
        for <mm-commits@vger.kernel.org>; Tue, 10 Oct 2023 11:18:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD59DC433C7;
        Tue, 10 Oct 2023 18:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696961888;
        bh=oSectCM1vKBB/Tb9nocm2EI01Ys4heiaXr1WuYKJocw=;
        h=Date:To:From:Subject:From;
        b=uaaQaoO/9dAbqVv/v/JfpwtBftZyqFlb0v4W4eAskvHNi0D85YRdn6cuyRho0jccG
         WZJZ4Vn6yz1wsUT7f7rwEgXP5ObjgIaNOVEBBWoW2WTmwvXy4omInxtDJ6Ds6WTZ+Z
         9MzBXTcc5mgz3alLII7TVhQIfX5l1Is3YOmzeW0Y=
Date:   Tue, 10 Oct 2023 11:17:58 -0700
To:     mm-commits@vger.kernel.org, vschneid@redhat.com,
        vincent.guittot@linaro.org, sclaibin@gmail.com,
        rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com,
        mingo@kernel.org, mgorman@suse.de, juri.lelli@redhat.com,
        dietmar.eggemann@arm.com, bsegall@google.com, bristot@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-remove-wait-bookmarks.patch added to mm-unstable branch
Message-Id: <20231010181805.CD59DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched: remove wait bookmarks
has been added to the -mm mm-unstable branch.  Its filename is
     sched-remove-wait-bookmarks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-remove-wait-bookmarks.patch

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

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch
iomap-hold-state_lock-over-call-to-ifs_set_range_uptodate.patch
iomap-protect-read_bytes_pending-with-the-state_lock.patch
mm-add-folio_end_read.patch
ext4-use-folio_end_read.patch
buffer-use-folio_end_read.patch
iomap-use-folio_end_read.patch
bitops-add-xor_unlock_is_negative_byte.patch
alpha-implement-xor_unlock_is_negative_byte.patch
m68k-implement-xor_unlock_is_negative_byte.patch
mips-implement-xor_unlock_is_negative_byte.patch
powerpc-implement-arch_xor_unlock_is_negative_byte-on-32-bit.patch
riscv-implement-xor_unlock_is_negative_byte.patch
s390-implement-arch_xor_unlock_is_negative_byte.patch
mm-delete-checks-for-xor_unlock_is_negative_byte.patch
mm-add-folio_xor_flags_has_waiters.patch
mm-make-__end_folio_writeback-return-void.patch
mm-use-folio_xor_flags_has_waiters-in-folio_end_writeback.patch
filemap-remove-use-of-wait-bookmarks.patch
sched-remove-wait-bookmarks.patch

