From: akpm@linux-foundation.org
Subject: + memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch added to -mm tree
Date: Wed, 24 Nov 2010 15:24:19 -0800
Message-ID: <201011242324.oAONOJaW010163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754064Ab0KXXYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 18:24:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@in.ibm.com, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com


The patch titled
     memcg: fix unit mismatch in memcg oom limit calculation
has been added to the -mm tree.  Its filename is
     memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch

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
Subject: memcg: fix unit mismatch in memcg oom limit calculation
From: Johannes Weiner <hannes@cmpxchg.org>

Adding the number of swap pages to the byte limit of a memory control
group makes no sense.  Convert the pages to bytes before adding them.

The only user of this code is the OOM killer, and the way it is used means
that the error results in a higher OOM badness value.  Since the cgroup
limit is the same for all tasks in the cgroup, the error should have no
practical impact at the moment.

But let's not wait for future or changing users to trip over it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation
+++ a/mm/memcontrol.c
@@ -1312,8 +1312,9 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 	u64 limit;
 	u64 memsw;
 
-	limit = res_counter_read_u64(&memcg->res, RES_LIMIT) +
-			total_swap_pages;
+	limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
+	limit += total_swap_pages << PAGE_SHIFT;
+
 	memsw = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
 	/*
 	 * If memsw is finite and limits the amount of swap space available
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-fix-false-positive-vm_bug-on-non-smp.patch
writeback-integrated-background-writeback-work.patch
writeback-trace-wakeup-event-for-background-writeback.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works-update.patch
writeback-avoid-livelocking-wb_sync_all-writeback.patch
writeback-avoid-livelocking-wb_sync_all-writeback-update.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch

