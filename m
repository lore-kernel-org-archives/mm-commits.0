From: akpm@linux-foundation.org
Subject: [merged]
 fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:47 -0700
Message-ID: <5390ca8f.21k1sxm7JhbWzY1/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaFETws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, mgorman@suse.de

Subject: [merged] fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch removed from -mm tree
To: mgorman@suse.de,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,tytso@mit.edu,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:47 -0700


The patch titled
     Subject: fs: buffer: do not use unnecessary atomic operations when discarding buffers
has been removed from the -mm tree.  Its filename was
     fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: fs: buffer: do not use unnecessary atomic operations when discarding buffers

Discarding buffers uses a bunch of atomic operations when discarding
buffers because ......  I can't think of a reason.  Use a cmpxchg loop to
clear all the necessary flags.  In most (all?) cases this will be a single
atomic operations.

[akpm@linux-foundation.org: move BUFFER_FLAGS_DISCARD into the .c file]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN fs/buffer.c~fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers fs/buffer.c
--- a/fs/buffer.c~fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers
+++ a/fs/buffer.c
@@ -1483,16 +1483,27 @@ EXPORT_SYMBOL(set_bh_page);
 /*
  * Called when truncating a buffer on a page completely.
  */
+
+/* Bits that are cleared during an invalidate */
+#define BUFFER_FLAGS_DISCARD \
+	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
+	 1 << BH_Delay | 1 << BH_Unwritten)
+
 static void discard_buffer(struct buffer_head * bh)
 {
+	unsigned long b_state, b_state_old;
+
 	lock_buffer(bh);
 	clear_buffer_dirty(bh);
 	bh->b_bdev = NULL;
-	clear_buffer_mapped(bh);
-	clear_buffer_req(bh);
-	clear_buffer_new(bh);
-	clear_buffer_delay(bh);
-	clear_buffer_unwritten(bh);
+	b_state = bh->b_state;
+	for (;;) {
+		b_state_old = cmpxchg(&bh->b_state, b_state,
+				      (b_state & ~BUFFER_FLAGS_DISCARD));
+		if (b_state_old == b_state)
+			break;
+		b_state = b_state_old;
+	}
 	unlock_buffer(bh);
 }
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

