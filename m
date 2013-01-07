From: akpm@linux-foundation.org
Subject: + mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch added to -mm tree
Date: Mon, 07 Jan 2013 13:36:04 -0800
Message-ID: <20130107213605.A5A16200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:63203 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab3AGVgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 16:36:08 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so1268271fav.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 13:36:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org, r64343@freescale.com, riel@redhat.com


The patch titled
     Subject: mm: compaction: make __compact_pgdat() and compact_pgdat() return void
has been added to the -mm tree.  Its filename is
     mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: compaction: make __compact_pgdat() and compact_pgdat() return void

These functions always return 0.  Formalise this.

Cc: Jason Liu <r64343@freescale.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
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
 			bool sync, bool *contended, struct page **page);
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
@@ -1149,7 +1149,7 @@ unsigned long try_to_compact_pages(struc
 
 
 /* Compact all zones within a node */
-static int __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
+static void __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
 {
 	int zoneid;
 	struct zone *zone;
@@ -1182,11 +1182,9 @@ static int __compact_pgdat(pg_data_t *pg
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
@@ -1194,10 +1192,10 @@ int compact_pgdat(pg_data_t *pgdat, int 
 		.page = NULL,
 	};
 
-	return __compact_pgdat(pgdat, &cc);
+	__compact_pgdat(pgdat, &cc);
 }
 
-static int compact_node(int nid)
+static void compact_node(int nid)
 {
 	struct compact_control cc = {
 		.order = -1,
@@ -1205,7 +1203,7 @@ static int compact_node(int nid)
 		.page = NULL,
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
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch
drivers-rtc-rtc-da9055c-fix-cross-section-reference.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
kernel-auditc-avoid-negative-sleep-durations.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
aio-smoosh-struct-kiocb-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

