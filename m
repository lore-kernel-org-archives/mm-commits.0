From: akpm@linux-foundation.org
Subject: + mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread.patch added to -mm tree
Date: Wed, 07 Sep 2011 15:19:58 -0700
Message-ID: <201109072219.p87MJw87023802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757359Ab1IGWUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2011 18:20:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, fengguang.wu@intel.com


The patch titled
     mm: add comment explaining task state setting in bdi_forker_thread()
has been added to the -mm tree.  Its filename is
     mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add comment explaining task state setting in bdi_forker_thread()
From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/backing-dev.c~mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread mm/backing-dev.c
--- a/mm/backing-dev.c~mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread
+++ a/mm/backing-dev.c
@@ -401,6 +401,13 @@ static int bdi_forker_thread(void *ptr)
 		}
 
 		spin_lock_bh(&bdi_lock);
+		/*
+		 * In the following loop we are going to check whether we have
+		 * some work to do without any synchronization with tasks
+		 * waking us up to do work for them. So we have to set task
+		 * state already here so that we don't miss wakeups coming
+		 * after we verify some condition.
+		 */
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		list_for_each_entry(bdi, &bdi_list, bdi_list) {
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
mm-clean-up-clearing-of-bdi_pending-bit-in-bdi_forker_thread.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch

