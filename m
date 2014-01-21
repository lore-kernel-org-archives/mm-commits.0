From: akpm@linux-foundation.org
Subject: [folded-merged]
 sched-add-tracepoints-related-to-numa-task-migration-fix.patch removed from -mm tree
Date: Tue, 21 Jan 2014 15:35:07 -0800
Message-ID: <52df042b.MoINi3ryJAQ65pQi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaAUXfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:35:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, athorlton@sgi.com, akpm@linux-foundation.org

Subject: [folded-merged] sched-add-tracepoints-related-to-numa-task-migration-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,athorlton@sgi.com,mgorman@suse.de,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:35:07 -0800


The patch titled
     Subject: sched-add-tracepoints-related-to-numa-task-migration-fix
has been removed from the -mm tree.  Its filename was
     sched-add-tracepoints-related-to-numa-task-migration-fix.patch

This patch was dropped because it was folded into sched-add-tracepoints-related-to-numa-task-migration.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sched-add-tracepoints-related-to-numa-task-migration-fix

remove semicolon-after-if, repair coding-style

Cc: Alex Thorlton <athorlton@sgi.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/sched/fair.c~sched-add-tracepoints-related-to-numa-task-migration-fix kernel/sched/fair.c
--- a/kernel/sched/fair.c~sched-add-tracepoints-related-to-numa-task-migration-fix
+++ a/kernel/sched/fair.c
@@ -1258,12 +1258,14 @@ static int task_numa_migrate(struct task
 	p->numa_scan_period = task_scan_min(p);
 
 	if (env.best_task == NULL) {
-		if ((ret = migrate_task_to(p, env.best_cpu)) != 0)
+		ret = migrate_task_to(p, env.best_cpu);
+		if (ret != 0)
 			trace_sched_stick_numa(p, env.src_cpu, env.best_cpu);
 		return ret;
 	}
 
-	if ((ret = migrate_swap(p, env.best_task)) != 0);
+	ret = migrate_swap(p, env.best_task);
+	if (ret != 0)
 		trace_sched_stick_numa(p, env.src_cpu, task_cpu(env.best_task));
 	put_task_struct(env.best_task);
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
posix_acl-uninlining.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
mm-add-overcommit_kbytes-sysctl-variable.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
sched-add-tracepoints-related-to-numa-task-migration.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch

