From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:46:40 -0700
Message-ID: <538fa1d0.x6MK126qU4jyjIiC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaFDWql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, mgorman@suse.de, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, akpm@linux-foundation.org

Subject: [folded-merged] fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mgorman@suse.de,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,tytso@mit.edu,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:46:40 -0700


The patch titled
     Subject: fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix
has been removed from the -mm tree.  Its filename was
     fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch

This patch was dropped because it was folded into fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix

move BUFFER_FLAGS_DISCARD into the .c file

Cc: Mel Gorman <mgorman@suse.de>
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

 fs/buffer.c                 |    9 ++++++++-
 include/linux/buffer_head.h |    5 -----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/buffer.c~fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix fs/buffer.c
--- a/fs/buffer.c~fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix
+++ a/fs/buffer.c
@@ -1483,6 +1483,12 @@ EXPORT_SYMBOL(set_bh_page);
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
 	unsigned long b_state, b_state_old;
@@ -1492,7 +1498,8 @@ static void discard_buffer(struct buffer
 	bh->b_bdev = NULL;
 	b_state = bh->b_state;
 	for (;;) {
-		b_state_old = cmpxchg(&bh->b_state, b_state, (b_state & ~BUFFER_FLAGS_DISCARD));
+		b_state_old = cmpxchg(&bh->b_state, b_state,
+				      (b_state & ~BUFFER_FLAGS_DISCARD));
 		if (b_state_old == b_state)
 			break;
 		b_state = b_state_old;
diff -puN include/linux/buffer_head.h~fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix
+++ a/include/linux/buffer_head.h
@@ -77,11 +77,6 @@ struct buffer_head {
 	atomic_t b_count;		/* users using this buffer_head */
 };
 
-/* Bits that are cleared during an invalidate */
-#define BUFFER_FLAGS_DISCARD \
-	(1 << BH_Mapped | 1 << BH_New | 1 << BH_Req | \
-	 1 << BH_Delay | 1 << BH_Unwritten)
-
 /*
  * macro tricks to expand the set_buffer_foo(), clear_buffer_foo()
  * and buffer_foo() functions.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted.patch
fs-add-generic-data-flush-to-fsync.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
swap-use-bdev_read_page-bdev_write_page.patch
mm-update-comment-for-default_max_map_count.patch
memcg-fold-mem_cgroup_stolen.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch
mm-document-do_fault_around-feature-fix.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch

