Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC26C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26E696056B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347564AbhIBWAa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347907AbhIBWAR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E896660E8B;
        Thu,  2 Sep 2021 21:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619957;
        bh=XhTxat4L1X/USXOMMoHIxswhWcd5JXvXKvyNv4/2RPs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QIM2mRTXgUvBq6+ZXqC9Z/KiFg1Fx9XSB2jLHhLfxCPa28zAr7etPIiEoJhkdIY3t
         pGq7rl5pEvGR+E07U2KLkoUGJJlTTzuIRMTy9GULXJuiwlNxAGgYRTPM1tz1FA5VqZ
         p5pwX4mtK0O0piOFluAQbd+H4nt3u3qQgMzvRL+w=
Date:   Thu, 02 Sep 2021 14:59:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com, gthelen@google.com,
        kbusch@kernel.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rientjes@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        weixugc@google.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  [patch 176/212] mm/migrate: demote pages during reclaim
Message-ID: <20210902215916.mND1SEmQd%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm/migrate: demote pages during reclaim

This is mostly derived from a patch from Yang Shi:

	https://lore.kernel.org/linux-mm/1560468577-101178-10-git-send-email-yang.shi@linux.alibaba.com/

Add code to the reclaim path (shrink_page_list()) to "demote" data to
another NUMA node instead of discarding the data.  This always avoids the
cost of I/O needed to read the page back in and sometimes avoids the
writeout cost when the page is dirty.

A second pass through shrink_page_list() will be made if any demotions
fail.  This essentially falls back to normal reclaim behavior in the case
that demotions fail.  Previous versions of this patch may have simply
failed to reclaim pages which were eligible for demotion but were unable
to be demoted in practice.

For some cases, for example, MADV_PAGEOUT, the pages are always discarded
instead of demoted to follow the kernel API definition.  Because
MADV_PAGEOUT is defined as freeing specified pages regardless in which
tier they are.

Note: This just adds the start of infrastructure for migration.  It is
actually disabled next to the FIXME in migrate_demote_page_ok().

[dave.hansen@linux.intel.com: v11]
  Link: https://lkml.kernel.org/r/20210715055145.195411-5-ying.huang@intel.com
  Link: https://lkml.kernel.org/r/20210721063926.3024591-4-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20210715055145.195411-5-ying.huang@intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Wei Xu <weixugc@google.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h        |    9 +++
 include/trace/events/migrate.h |    3 -
 mm/vmscan.c                    |   85 +++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 1 deletion(-)

--- a/include/linux/migrate.h~mm-migrate-demote-pages-during-reclaim
+++ a/include/linux/migrate.h
@@ -28,6 +28,7 @@ enum migrate_reason {
 	MR_NUMA_MISPLACED,
 	MR_CONTIG_RANGE,
 	MR_LONGTERM_PIN,
+	MR_DEMOTION,
 	MR_TYPES
 };
 
@@ -167,6 +168,14 @@ struct migrate_vma {
 int migrate_vma_setup(struct migrate_vma *args);
 void migrate_vma_pages(struct migrate_vma *migrate);
 void migrate_vma_finalize(struct migrate_vma *migrate);
+int next_demotion_node(int node);
+
+#else /* CONFIG_MIGRATION disabled: */
+
+static inline int next_demotion_node(int node)
+{
+	return NUMA_NO_NODE;
+}
 
 #endif /* CONFIG_MIGRATION */
 
--- a/include/trace/events/migrate.h~mm-migrate-demote-pages-during-reclaim
+++ a/include/trace/events/migrate.h
@@ -21,7 +21,8 @@
 	EM( MR_MEMPOLICY_MBIND,	"mempolicy_mbind")		\
 	EM( MR_NUMA_MISPLACED,	"numa_misplaced")		\
 	EM( MR_CONTIG_RANGE,	"contig_range")			\
-	EMe(MR_LONGTERM_PIN,	"longterm_pin")
+	EM( MR_LONGTERM_PIN,	"longterm_pin")			\
+	EMe(MR_DEMOTION,	"demotion")
 
 /*
  * First define the enums in the above macros to be exported to userspace
--- a/mm/vmscan.c~mm-migrate-demote-pages-during-reclaim
+++ a/mm/vmscan.c
@@ -41,6 +41,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/memcontrol.h>
+#include <linux/migrate.h>
 #include <linux/delayacct.h>
 #include <linux/sysctl.h>
 #include <linux/oom.h>
@@ -121,6 +122,9 @@ struct scan_control {
 	/* The file pages on the current node are dangerously low */
 	unsigned int file_is_tiny:1;
 
+	/* Always discard instead of demoting to lower tier memory */
+	unsigned int no_demotion:1;
+
 	/* Allocation order */
 	s8 order;
 
@@ -518,6 +522,17 @@ static long add_nr_deferred(long nr, str
 	return atomic_long_add_return(nr, &shrinker->nr_deferred[nid]);
 }
 
+static bool can_demote(int nid, struct scan_control *sc)
+{
+	if (sc->no_demotion)
+		return false;
+	if (next_demotion_node(nid) == NUMA_NO_NODE)
+		return false;
+
+	// FIXME: actually enable this later in the series
+	return false;
+}
+
 /*
  * This misses isolated pages which are not accounted for to save counters.
  * As the data only determines if reclaim or compaction continues, it is
@@ -1263,6 +1278,49 @@ static void page_check_dirty_writeback(s
 		mapping->a_ops->is_dirty_writeback(page, dirty, writeback);
 }
 
+static struct page *alloc_demote_page(struct page *page, unsigned long node)
+{
+	struct migration_target_control mtc = {
+		/*
+		 * Allocate from 'node', or fail quickly and quietly.
+		 * When this happens, 'page' will likely just be discarded
+		 * instead of migrated.
+		 */
+		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
+			    __GFP_THISNODE  | __GFP_NOWARN |
+			    __GFP_NOMEMALLOC | GFP_NOWAIT,
+		.nid = node
+	};
+
+	return alloc_migration_target(page, (unsigned long)&mtc);
+}
+
+/*
+ * Take pages on @demote_list and attempt to demote them to
+ * another node.  Pages which are not demoted are left on
+ * @demote_pages.
+ */
+static unsigned int demote_page_list(struct list_head *demote_pages,
+				     struct pglist_data *pgdat)
+{
+	int target_nid = next_demotion_node(pgdat->node_id);
+	unsigned int nr_succeeded;
+	int err;
+
+	if (list_empty(demote_pages))
+		return 0;
+
+	if (target_nid == NUMA_NO_NODE)
+		return 0;
+
+	/* Demotion ignores all cpuset and mempolicy settings */
+	err = migrate_pages(demote_pages, alloc_demote_page, NULL,
+			    target_nid, MIGRATE_ASYNC, MR_DEMOTION,
+			    &nr_succeeded);
+
+	return nr_succeeded;
+}
+
 /*
  * shrink_page_list() returns the number of reclaimed pages
  */
@@ -1274,12 +1332,16 @@ static unsigned int shrink_page_list(str
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
+	LIST_HEAD(demote_pages);
 	unsigned int nr_reclaimed = 0;
 	unsigned int pgactivate = 0;
+	bool do_demote_pass;
 
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
+	do_demote_pass = can_demote(pgdat->node_id, sc);
 
+retry:
 	while (!list_empty(page_list)) {
 		struct address_space *mapping;
 		struct page *page;
@@ -1429,6 +1491,17 @@ static unsigned int shrink_page_list(str
 		}
 
 		/*
+		 * Before reclaiming the page, try to relocate
+		 * its contents to another node.
+		 */
+		if (do_demote_pass &&
+		    (thp_migration_supported() || !PageTransHuge(page))) {
+			list_add(&page->lru, &demote_pages);
+			unlock_page(page);
+			continue;
+		}
+
+		/*
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
 		 * Lazyfree page could be freed directly
@@ -1679,6 +1752,17 @@ keep:
 		list_add(&page->lru, &ret_pages);
 		VM_BUG_ON_PAGE(PageLRU(page) || PageUnevictable(page), page);
 	}
+	/* 'page_list' is always empty here */
+
+	/* Migrate pages selected for demotion */
+	nr_reclaimed += demote_page_list(&demote_pages, pgdat);
+	/* Pages that could not be demoted are still in @demote_pages */
+	if (!list_empty(&demote_pages)) {
+		/* Pages which failed to demoted go back on @page_list for retry: */
+		list_splice_init(&demote_pages, page_list);
+		do_demote_pass = false;
+		goto retry;
+	}
 
 	pgactivate = stat->nr_activate[0] + stat->nr_activate[1];
 
@@ -2326,6 +2410,7 @@ unsigned long reclaim_pages(struct list_
 		.may_writepage = 1,
 		.may_unmap = 1,
 		.may_swap = 1,
+		.no_demotion = 1,
 	};
 
 	noreclaim_flag = memalloc_noreclaim_save();
_
