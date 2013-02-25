From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:59 -0800
Message-ID: <20130225204859.C52C55A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:57314 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217Ab3BYUtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:49:01 -0500
Received: by mail-qe0-f73.google.com with SMTP id 3so69079qea.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:49:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, r64343@freescale.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: make __compact_pgdat() and compact_pgdat() return void
has been removed from the -mm tree.  Its filename was
     mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: compaction: make __compact_pgdat() and compact_pgdat() return void

These functions always return 0.  Formalise this.

Cc: Jason Liu <r64343@freescale.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    5 ++---
 mm/compaction.c            |   12 +++++-------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void
+++ a/include/linux/compaction.h
@@ -23,7 +23,7 @@ extern int fragmentation_index(struct zo
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
 			bool sync, bool *contended);
-extern int compact_pgdat(pg_data_t *pgdat, int order);
+extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
 
@@ -80,9 +80,8 @@ static inline unsigned long try_to_compa
 	return COMPACT_CONTINUE;
 }
 
-static inline int compact_pgdat(pg_data_t *pgdat, int order)
+static inline void compact_pgdat(pg_data_t *pgdat, int order)
 {
-	return COMPACT_CONTINUE;
 }
 
 static inline void reset_isolation_suitable(pg_data_t *pgdat)
diff -puN mm/compaction.c~mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void mm/compaction.c
--- a/mm/compaction.c~mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void
+++ a/mm/compaction.c
@@ -1085,7 +1085,7 @@ unsigned long try_to_compact_pages(struc
 
 
 /* Compact all zones within a node */
-static int __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
+static void __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
 {
 	int zoneid;
 	struct zone *zone;
@@ -1118,28 +1118,26 @@ static int __compact_pgdat(pg_data_t *pg
 		VM_BUG_ON(!list_empty(&cc->freepages));
 		VM_BUG_ON(!list_empty(&cc->migratepages));
 	}
-
-	return 0;
 }
 
-int compact_pgdat(pg_data_t *pgdat, int order)
+void compact_pgdat(pg_data_t *pgdat, int order)
 {
 	struct compact_control cc = {
 		.order = order,
 		.sync = false,
 	};
 
-	return __compact_pgdat(pgdat, &cc);
+	__compact_pgdat(pgdat, &cc);
 }
 
-static int compact_node(int nid)
+static void compact_node(int nid)
 {
 	struct compact_control cc = {
 		.order = -1,
 		.sync = true,
 	};
 
-	return __compact_pgdat(NODE_DATA(nid), &cc);
+	__compact_pgdat(NODE_DATA(nid), &cc);
 }
 
 /* Compact all nodes in the system */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

