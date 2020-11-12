Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2A2C2D0E4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CA8421D79
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:57:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xOZjDpHJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgKLX53 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:57:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbgKLX52 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 18:57:28 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 357DF20723;
        Thu, 12 Nov 2020 23:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605225447;
        bh=9qr/egWtzYGn3F7dLsF/4Keph+DaaTZoFJ5cH7oFp2g=;
        h=Date:From:To:Subject:From;
        b=xOZjDpHJdhBVqGkIWAJOhJt18NdMLKrsh+Y/Sz42HHrbmoIBdivMqUvcJt/2gUa9Y
         8UFBHvTASyd084/8Qo04SR8cMQtv5mQ8xpBbOIXb8AJoEN5xJAXY+SM1zpFRZsvHeM
         CDrNseXO+syxuZXsf2sDVPji+7vOOinbVaDiqpkI=
Date:   Thu, 12 Nov 2020 15:57:26 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, vbabka@suse.cz
Subject:  +
 mm-page_alloc-disable-pcplists-during-memory-offline.patch added to -mm
 tree
Message-ID: <20201112235726.jdT-_FHdX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: disable pcplists during memory offline
has been added to the -mm tree.  Its filename is
     mm-page_alloc-disable-pcplists-during-memory-offline.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-disable-pcplists-during-memory-offline.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-disable-pcplists-during-memory-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: disable pcplists during memory offline

Memory offlining relies on page isolation to guarantee a forward progress
because pages cannot be reused while they are isolated.  But the page
isolation itself doesn't prevent from races while freed pages are stored
on pcp lists and thus can be reused.  This can be worked around by
repeated draining of pcplists, as done by commit 968318261221
("mm/memory_hotplug: drain per-cpu pages again during memory offline").

David and Michal would prefer that this race was closed in a way that
callers of page isolation who need stronger guarantees don't need to
repeatedly drain.  David suggested disabling pcplists usage completely
during page isolation, instead of repeatedly draining them.

To achieve this without adding special cases in alloc/free fastpath, we
can use the same approach as boot pagesets - when pcp->high is 0, any
pcplist addition will be immediately flushed.

The race can thus be closed by setting pcp->high to 0 and draining
pcplists once, before calling start_isolate_page_range().  The draining
will serialize after processes that already disabled interrupts and read
the old value of pcp->high in free_unref_page_commit(), and processes that
have not yet disabled interrupts, will observe pcp->high == 0 when they
are rescheduled, and skip pcplists.  This guarantees no stray pages on
pcplists in zones where isolation happens.

This patch thus adds zone_pcp_disable() and zone_pcp_enable() functions
that page isolation users can call before start_isolate_page_range() and
after unisolating (or offlining) the isolated pages.

Also, drain_all_pages() is optimized to only execute on cpus where
pcplists are not empty.  The check can however race with a free to pcplist
that has not yet increased the pcp->count from 0 to 1.  Thus make the
drain optionally skip the racy check and drain on all cpus, and use this
option in zone_pcp_disable().

As we have to avoid external updates to high and batch while pcplists are
disabled, we take pcp_batch_high_lock in zone_pcp_disable() and release it
in zone_pcp_enable().  This also synchronizes multiple users of
zone_pcp_disable()/enable().

Currently the only user of this functionality is offline_pages().

Link: https://lkml.kernel.org/r/20201111092812.11329-8-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |    2 +
 mm/memory_hotplug.c |   28 +++++++----------
 mm/page_alloc.c     |   69 ++++++++++++++++++++++++++++++++----------
 mm/page_isolation.c |    6 +--
 4 files changed, 71 insertions(+), 34 deletions(-)

--- a/mm/internal.h~mm-page_alloc-disable-pcplists-during-memory-offline
+++ a/mm/internal.h
@@ -201,6 +201,8 @@ extern int user_min_free_kbytes;
 
 extern void zone_pcp_update(struct zone *zone);
 extern void zone_pcp_reset(struct zone *zone);
+extern void zone_pcp_disable(struct zone *zone);
+extern void zone_pcp_enable(struct zone *zone);
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
--- a/mm/memory_hotplug.c~mm-page_alloc-disable-pcplists-during-memory-offline
+++ a/mm/memory_hotplug.c
@@ -1491,17 +1491,21 @@ int __ref offline_pages(unsigned long st
 	}
 	node = zone_to_nid(zone);
 
+	/*
+	 * Disable pcplists so that page isolation cannot race with freeing
+	 * in a way that pages from isolated pageblock are left on pcplists.
+	 */
+	zone_pcp_disable(zone);
+
 	/* set above range as isolated */
 	ret = start_isolate_page_range(start_pfn, end_pfn,
 				       MIGRATE_MOVABLE,
 				       MEMORY_OFFLINE | REPORT_FAILURE);
 	if (ret) {
 		reason = "failure to isolate range";
-		goto failed_removal;
+		goto failed_removal_pcplists_disabled;
 	}
 
-	drain_all_pages(zone);
-
 	arg.start_pfn = start_pfn;
 	arg.nr_pages = nr_pages;
 	node_states_check_changes_offline(nr_pages, zone, &arg);
@@ -1551,20 +1555,8 @@ int __ref offline_pages(unsigned long st
 			goto failed_removal_isolated;
 		}
 
-		/*
-		 * per-cpu pages are drained after start_isolate_page_range, but
-		 * if there are still pages that are not free, make sure that we
-		 * drain again, because when we isolated range we might have
-		 * raced with another thread that was adding pages to pcp list.
-		 *
-		 * Forward progress should be still guaranteed because
-		 * pages on the pcp list can only belong to MOVABLE_ZONE
-		 * because has_unmovable_pages explicitly checks for
-		 * PageBuddy on freed pages on other zones.
-		 */
 		ret = test_pages_isolated(start_pfn, end_pfn, MEMORY_OFFLINE);
-		if (ret)
-			drain_all_pages(zone);
+
 	} while (ret);
 
 	/* Mark all sections offline and remove free pages from the buddy. */
@@ -1580,6 +1572,8 @@ int __ref offline_pages(unsigned long st
 	zone->nr_isolate_pageblock -= nr_pages / pageblock_nr_pages;
 	spin_unlock_irqrestore(&zone->lock, flags);
 
+	zone_pcp_enable(zone);
+
 	/* removal success */
 	adjust_managed_page_count(pfn_to_page(start_pfn), -nr_pages);
 	zone->present_pages -= nr_pages;
@@ -1612,6 +1606,8 @@ int __ref offline_pages(unsigned long st
 failed_removal_isolated:
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
+failed_removal_pcplists_disabled:
+	zone_pcp_enable(zone);
 failed_removal:
 	pr_debug("memory offlining [mem %#010llx-%#010llx] failed due to %s\n",
 		 (unsigned long long) start_pfn << PAGE_SHIFT,
--- a/mm/page_alloc.c~mm-page_alloc-disable-pcplists-during-memory-offline
+++ a/mm/page_alloc.c
@@ -3024,14 +3024,7 @@ static void drain_local_pages_wq(struct
 	preempt_enable();
 }
 
-/*
- * Spill all the per-cpu pages from all CPUs back into the buddy allocator.
- *
- * When zone parameter is non-NULL, spill just the single zone's pages.
- *
- * Note that this can be extremely slow as the draining happens in a workqueue.
- */
-void drain_all_pages(struct zone *zone)
+void __drain_all_pages(struct zone *zone, bool force_all_cpus)
 {
 	int cpu;
 
@@ -3070,7 +3063,13 @@ void drain_all_pages(struct zone *zone)
 		struct zone *z;
 		bool has_pcps = false;
 
-		if (zone) {
+		if (force_all_cpus) {
+			/*
+			 * The pcp.count check is racy, some callers need a
+			 * guarantee that no cpu is missed.
+			 */
+			has_pcps = true;
+		} else if (zone) {
 			pcp = per_cpu_ptr(zone->pageset, cpu);
 			if (pcp->pcp.count)
 				has_pcps = true;
@@ -3103,6 +3102,18 @@ void drain_all_pages(struct zone *zone)
 	mutex_unlock(&pcpu_drain_mutex);
 }
 
+/*
+ * Spill all the per-cpu pages from all CPUs back into the buddy allocator.
+ *
+ * When zone parameter is non-NULL, spill just the single zone's pages.
+ *
+ * Note that this can be extremely slow as the draining happens in a workqueue.
+ */
+void drain_all_pages(struct zone *zone)
+{
+	__drain_all_pages(zone, false);
+}
+
 #ifdef CONFIG_HIBERNATION
 
 /*
@@ -6302,6 +6313,18 @@ static void pageset_init(struct per_cpu_
 	pcp->batch = BOOT_PAGESET_BATCH;
 }
 
+void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high,
+		unsigned long batch)
+{
+	struct per_cpu_pageset *p;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		p = per_cpu_ptr(zone->pageset, cpu);
+		pageset_update(&p->pcp, high, batch);
+	}
+}
+
 /*
  * Calculate and set new high and batch values for all per-cpu pagesets of a
  * zone, based on the zone's size and the percpu_pagelist_fraction sysctl.
@@ -6309,8 +6332,6 @@ static void pageset_init(struct per_cpu_
 static void zone_set_pageset_high_and_batch(struct zone *zone)
 {
 	unsigned long new_high, new_batch;
-	struct per_cpu_pageset *p;
-	int cpu;
 
 	if (percpu_pagelist_fraction) {
 		new_high = zone_managed_pages(zone) / percpu_pagelist_fraction;
@@ -6330,10 +6351,7 @@ static void zone_set_pageset_high_and_ba
 	zone->pageset_high = new_high;
 	zone->pageset_batch = new_batch;
 
-	for_each_possible_cpu(cpu) {
-		p = per_cpu_ptr(zone->pageset, cpu);
-		pageset_update(&p->pcp, new_high, new_batch);
-	}
+	__zone_set_pageset_high_and_batch(zone, new_high, new_batch);
 }
 
 void __meminit setup_zone_pageset(struct zone *zone)
@@ -8728,6 +8746,27 @@ void __meminit zone_pcp_update(struct zo
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
+/*
+ * Effectively disable pcplists for the zone by setting the high limit to 0
+ * and draining all cpus. A concurrent page freeing on another CPU that's about
+ * to put the page on pcplist will either finish before the drain and the page
+ * will be drained, or observe the new high limit and skip the pcplist.
+ *
+ * Must be paired with a call to zone_pcp_enable().
+ */
+void zone_pcp_disable(struct zone *zone)
+{
+	mutex_lock(&pcp_batch_high_lock);
+	__zone_set_pageset_high_and_batch(zone, 0, 1);
+	__drain_all_pages(zone, true);
+}
+
+void zone_pcp_enable(struct zone *zone)
+{
+	__zone_set_pageset_high_and_batch(zone, zone->pageset_high, zone->pageset_batch);
+	mutex_unlock(&pcp_batch_high_lock);
+}
+
 void zone_pcp_reset(struct zone *zone)
 {
 	unsigned long flags;
--- a/mm/page_isolation.c~mm-page_alloc-disable-pcplists-during-memory-offline
+++ a/mm/page_isolation.c
@@ -174,9 +174,9 @@ __first_valid_page(unsigned long pfn, un
  * A call to drain_all_pages() after isolation can flush most of them. However
  * in some cases pages might still end up on pcp lists and that would allow
  * for their allocation even when they are in fact isolated already. Depending
- * on how strong of a guarantee the caller needs, further drain_all_pages()
- * might be needed (e.g. __offline_pages will need to call it after check for
- * isolated range for a next retry).
+ * on how strong of a guarantee the caller needs, zone_pcp_disable/enable()
+ * might be used to flush and disable pcplist before isolation and enable after
+ * unisolation.
  *
  * Return: 0 on success and -EBUSY if any part of range cannot be isolated.
  */
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_alloc-clean-up-pageset-high-and-batch-update.patch
mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch
mm-page_alloc-remove-setup_pageset.patch
mm-page_alloc-simplify-pageset_update.patch
mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch
mm-page_alloc-move-draining-pcplists-to-page-isolation-users.patch
mm-page_alloc-disable-pcplists-during-memory-offline.patch
mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch

