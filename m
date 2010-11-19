From: akpm@linux-foundation.org
Subject: + mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run.patch added to -mm tree
Date: Thu, 18 Nov 2010 17:27:40 -0800
Message-ID: <201011190127.oAJ1Re9W017308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982Ab0KSB3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Nov 2010 20:29:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, akataria@vmware.com, cl@linux-foundation.org, penberg@cs.helsinki.fi, petr@vmware.com, tj@kernel.org


The patch titled
     mm/page_alloc.c: fix build_all_zonelist() where percpu_alloc() is wrongly called under stop_machine_run()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run.patch

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
Subject: mm/page_alloc.c: fix build_all_zonelist() where percpu_alloc() is wrongly called under stop_machine_run()
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

During memory hotplug, build_allzonelists() may be called under
stop_machine_run().  In this function, setup_zone_pageset() is called. 
But it's bug because it will do page allocation under stop_machine_run().

Here is a report from Alok Kataria.

[  142.339267] BUG: sleeping function called from invalid context at kernel/mutex.c:94
[  142.339276] in_atomic(): 0, irqs_disabled(): 1, pid: 4, name: migration/0
[  142.339283] Pid: 4, comm: migration/0 Not tainted 2.6.35.6-45.fc14.x86_64 #1
[  142.339288] Call Trace:
[  142.339305]  [<ffffffff8103d12b>] __might_sleep+0xeb/0xf0
[  142.339316]  [<ffffffff81468245>] mutex_lock+0x24/0x50
[  142.339326]  [<ffffffff8110eaa6>] pcpu_alloc+0x6d/0x7ee
[  142.339336]  [<ffffffff81048888>] ? load_balance+0xbe/0x60e
[  142.339343]  [<ffffffff8103a1b3>] ? rt_se_boosted+0x21/0x2f
[  142.339349]  [<ffffffff8103e1cf>] ? dequeue_rt_stack+0x18b/0x1ed
[  142.339356]  [<ffffffff8110f237>] __alloc_percpu+0x10/0x12
[  142.339362]  [<ffffffff81465e22>] setup_zone_pageset+0x38/0xbe
[  142.339373]  [<ffffffff810d6d81>] ? build_zonelists_node.clone.58+0x79/0x8c
[  142.339384]  [<ffffffff81452539>] __build_all_zonelists+0x419/0x46c
[  142.339395]  [<ffffffff8108ef01>] ? cpu_stopper_thread+0xb2/0x198
[  142.339401]  [<ffffffff8108f075>] stop_machine_cpu_stop+0x8e/0xc5
[  142.339407]  [<ffffffff8108efe7>] ? stop_machine_cpu_stop+0x0/0xc5
[  142.339414]  [<ffffffff8108ef57>] cpu_stopper_thread+0x108/0x198
[  142.339420]  [<ffffffff81467a37>] ? schedule+0x5b2/0x5cc
[  142.339426]  [<ffffffff8108ee4f>] ? cpu_stopper_thread+0x0/0x198
[  142.339434]  [<ffffffff81065f29>] kthread+0x7f/0x87
[  142.339443]  [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
[  142.339449]  [<ffffffff81065eaa>] ? kthread+0x0/0x87
[  142.339455]  [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
[  142.340099] Built 5 zonelists in Node order, mobility grouping on.  Total pages: 289456
[  142.340108] Policy zone: Normal

This patch tries to fix the issue by moving setup_zone_pageset() out from
stop_machine_run(). It's obviously not necessary to be called under
stop_machine_run().

Reported-by: Alok Kataria <akataria@vmware.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Petr Vandrovec <petr@vmware.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run
+++ a/mm/page_alloc.c
@@ -3008,14 +3008,6 @@ static __init_refok int __build_all_zone
 		build_zonelist_cache(pgdat);
 	}
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-	/* Setup real pagesets for the new zone */
-	if (data) {
-		struct zone *zone = data;
-		setup_zone_pageset(zone);
-	}
-#endif
-
 	/*
 	 * Initialize the boot_pagesets that are going to be used
 	 * for bootstrapping processors. The real pagesets for
@@ -3064,7 +3056,13 @@ void build_all_zonelists(void *data)
 	} else {
 		/* we have to stop all cpus to guarantee there is no user
 		   of zonelist */
-		stop_machine(__build_all_zonelists, data, NULL);
+#ifdef CONFIG_MEMORY_HOTPLUG
+		if (data) {
+			struct zone *zone = (struct zone *)data;
+			setup_zone_pageset(zone);
+		}
+#endif
+		stop_machine(__build_all_zonelists, NULL, NULL);
 		/* cpuset refresh routine should be here */
 	}
 	vm_total_pages = nr_free_pagecache_pages();
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-avoid-deadlock-between-move-charge-and-try_charge.patch
cgroups-make-swap-accounting-default-behavior-configurable.patch
cgroups-make-swap-accounting-default-behavior-configurable-update.patch
mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run.patch
mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run-cleanup.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

