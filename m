From: akpm@linux-foundation.org
Subject: +
 mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2.patch
 added to -mm tree
Date: Mon, 12 May 2014 12:44:14 -0700
Message-ID: <5371248e.pnNwuh8ttRjIDTqy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaELToP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 15:44:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, rientjes@google.com

Subject: + mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2.patch added to -mm tree
To: rientjes@google.com,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 12:44:14 -0700


The patch titled
     Subject: mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2
has been added to the -mm tree.  Its filename is
     mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch
mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled-fix-2.patch
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
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

