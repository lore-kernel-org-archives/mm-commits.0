From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2.patch
 removed from -mm tree
Date: Wed, 04 Jun 2014 15:21:40 -0700
Message-ID: <538f9bf4.VRZPIrLV1UoiXu+K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaFDWVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, rientjes@google.com

Subject: [folded-merged] mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2.patch removed from -mm tree
To: rientjes@google.com,fengguang.wu@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:21:40 -0700


The patch titled
     Subject: mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2
has been removed from the -mm tree.  Its filename was
     mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2.patch

This patch was dropped because it was folded into mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2

Only define count_free() when CONFIG_SLUB_DEBUG since that's the only
context in which it is referenced.  Only define count_partial() when
CONFIG_SLUB_DEBUG or CONFIG_SYSFS since the sysfs interface still uses it
for partial slab counts.

Also only define node_nr_objs() when CONFIG_SLUB_DEBUG since that's the
only context in which it is referenced.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/slub.c~mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2 mm/slub.c
--- a/mm/slub.c~mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2
+++ a/mm/slub.c
@@ -2119,11 +2119,19 @@ static inline int node_match(struct page
 	return 1;
 }
 
+#ifdef CONFIG_SLUB_DEBUG
 static int count_free(struct page *page)
 {
 	return page->objects - page->inuse;
 }
 
+static inline unsigned long node_nr_objs(struct kmem_cache_node *n)
+{
+	return atomic_long_read(&n->total_objects);
+}
+#endif /* CONFIG_SLUB_DEBUG */
+
+#if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SYSFS)
 static unsigned long count_partial(struct kmem_cache_node *n,
 					int (*get_count)(struct page *))
 {
@@ -2137,15 +2145,7 @@ static unsigned long count_partial(struc
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return x;
 }
-
-static inline unsigned long node_nr_objs(struct kmem_cache_node *n)
-{
-#ifdef CONFIG_SLUB_DEBUG
-	return atomic_long_read(&n->total_objects);
-#else
-	return 0;
-#endif
-}
+#endif /* CONFIG_SLUB_DEBUG || CONFIG_SYSFS */
 
 static noinline void
 slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
kthread-fix-return-value-of-kthread_create-upon-sigkill.patch
mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch
mm-slub-fix-alloc_slowpath-stat.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
mm-debug-make-bad_range-output-more-usable-and-readable.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-compaction-embed-migration-mode-in-compact_control-fix-fix.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch
slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix-2.patch
mm-memcg-periodically-schedule-when-emptying-page-list.patch
mm-zswap-numa-aware-allocation-for-zswap_dstmem.patch

