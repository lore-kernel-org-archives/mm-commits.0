From: akpm@linux-foundation.org
Subject: [merged] mmcompaction-serialize-waitqueue_active-checks.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:15:59 -0800
Message-ID: <58af510f.g4OjK6/+mZjPPwEy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40434 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVQB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:16:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,compaction: serialize waitqueue_active() checks
has been removed from the -mm tree.  Its filename was
     mmcompaction-serialize-waitqueue_active-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm,compaction: serialize waitqueue_active() checks

Without a memory barrier, the following race can occur with a high-order
allocation:

wakeup_kcompactd(order == 1)  		     kcompactd()
  [L] waitqueue_active(kcompactd_wait)
						[S] prepare_to_wait_event(kcompactd_wait)
						[L] (kcompactd_max_order == 0)
  [S] kcompactd_max_order = order;		      schedule()

Where the waitqueue_active() check is speculatively re-ordered to before
setting the actual condition (max_order), not seeing the threads that's
going to block; making us miss a wakeup. There are a couple of options to
fix this, including calling wq_has_sleepers() which adds a full barrier,
or unconditionally doing the wake_up_interruptible() and serialize on the
q->lock. However, to make use of the control dependency, we just need to
add L->L guarantees.

While this bug is theoretical, there have been other offenders of the lockless
waitqueue_active() in the past -- this is also documented in the call itself.

Link: http://lkml.kernel.org/r/1483975528-24342-1-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/compaction.c~mmcompaction-serialize-waitqueue_active-checks mm/compaction.c
--- a/mm/compaction.c~mmcompaction-serialize-waitqueue_active-checks
+++ a/mm/compaction.c
@@ -1966,6 +1966,13 @@ void wakeup_kcompactd(pg_data_t *pgdat,
 	if (pgdat->kcompactd_max_order < order)
 		pgdat->kcompactd_max_order = order;
 
+	/*
+	 * Pairs with implicit barrier in wait_event_freezable()
+	 * such that wakeups are not missed in the lockless
+	 * waitqueue_active() call.
+	 */
+	smp_acquire__after_ctrl_dep();
+
 	if (pgdat->kcompactd_classzone_idx > classzone_idx)
 		pgdat->kcompactd_classzone_idx = classzone_idx;
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

cris-use-generic-currenth.patch
alpha-use-generic-currenth.patch
ipc-shm-fix-shmat-mmap-nil-page-protection.patch

