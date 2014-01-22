From: akpm@linux-foundation.org
Subject: [merged]
 mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:14:42 -0800
Message-ID: <52e026b2.h30GKWiMK/NaIZSz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaAVUOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: [merged] mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting.patch removed from -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:42 -0800


The patch titled
     Subject: mm: numa: trace tasks that fail migration due to rate limiting
has been removed from the -mm tree.  Its filename was
     mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: trace tasks that fail migration due to rate limiting

A low local/remote numa hinting fault ratio is potentially explained by
failed migrations.  This patch adds a tracepoint that fires when migration
fails due to migration rate limitation.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/migrate.h |   26 ++++++++++++++++++++++++++
 mm/migrate.c                   |    5 ++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff -puN include/trace/events/migrate.h~mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting include/trace/events/migrate.h
--- a/include/trace/events/migrate.h~mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting
+++ a/include/trace/events/migrate.h
@@ -45,6 +45,32 @@ TRACE_EVENT(mm_migrate_pages,
 		__print_symbolic(__entry->reason, MIGRATE_REASON))
 );
 
+TRACE_EVENT(mm_numa_migrate_ratelimit,
+
+	TP_PROTO(struct task_struct *p, int dst_nid, unsigned long nr_pages),
+
+	TP_ARGS(p, dst_nid, nr_pages),
+
+	TP_STRUCT__entry(
+		__array(	char,		comm,	TASK_COMM_LEN)
+		__field(	pid_t,		pid)
+		__field(	int,		dst_nid)
+		__field(	unsigned long,	nr_pages)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->dst_nid	= dst_nid;
+		__entry->nr_pages	= nr_pages;
+	),
+
+	TP_printk("comm=%s pid=%d dst_nid=%d nr_pages=%lu",
+		__entry->comm,
+		__entry->pid,
+		__entry->dst_nid,
+		__entry->nr_pages)
+);
 #endif /* _TRACE_MIGRATE_H */
 
 /* This part must be outside protection */
diff -puN mm/migrate.c~mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting mm/migrate.c
--- a/mm/migrate.c~mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting
+++ a/mm/migrate.c
@@ -1614,8 +1614,11 @@ static bool numamigrate_update_ratelimit
 			msecs_to_jiffies(migrate_interval_millisecs);
 		spin_unlock(&pgdat->numabalancing_migrate_lock);
 	}
-	if (pgdat->numabalancing_migrate_nr_pages > ratelimit_pages)
+	if (pgdat->numabalancing_migrate_nr_pages > ratelimit_pages) {
+		trace_mm_numa_migrate_ratelimit(current, pgdat->node_id,
+								nr_pages);
 		return true;
+	}
 
 	/*
 	 * This is an unlocked non-atomic update so errors are possible.
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
numa-add-a-sysctl-for-numa_balancing.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch
mm-improve-documentation-of-page_order-v2.patch
mm-improve-documentation-of-page_order-v2-fix.patch
linux-next.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

