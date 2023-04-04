Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8740C76188
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 21:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbjDDViu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236468AbjDDVir (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 17:38:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C96D40FD
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 14:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F028963821
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 21:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C8BC4339B;
        Tue,  4 Apr 2023 21:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680644325;
        bh=gKHU1dhPO5iSLL3OYtYcNVxdnQEup1NQTzxIyoY37DQ=;
        h=Date:To:From:Subject:From;
        b=UX/yjNQeukRs5jPckKFZzOr/jn7oxDnz0g2q+Jk+7WK/8/tUJE1UFDCc4wstfrqN5
         vk74T2Duk6O/fKcwnSgFu1jeiZoH4Ro9amYYnUa0th9vq4LO2tFvcaXjWxv5akdE07
         8warvjlKJsC2rrI5VClqaHl6M3jdOqiMu/NR/JxI=
Date:   Tue, 04 Apr 2023 14:38:44 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, shakeelb@google.com, roman.gushchin@linux.dev,
        rientjes@google.com, peterx@redhat.com, neilb@suse.de,
        mhocko@kernel.org, linmiaohe@huawei.com, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, djwong@kernel.org, david@redhat.com,
        david@fromorbit.com, cl@linux.com, 42.hyeyoo@gmail.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-refactor-updating-reclaimed-pages-in-reclaim_state.patch added to mm-unstable branch
Message-Id: <20230404213845.51C8BC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: refactor updating reclaimed pages in reclaim_state
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-refactor-updating-reclaimed-pages-in-reclaim_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-refactor-updating-reclaimed-pages-in-reclaim_state.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: vmscan: refactor updating reclaimed pages in reclaim_state
Date: Tue, 4 Apr 2023 00:13:52 +0000

During reclaim, we keep track of pages reclaimed from other means than
LRU-based reclaim through scan_control->reclaim_state->reclaimed_slab,
which we stash a pointer to in current task_struct.

However, we keep track of more than just reclaimed slab pages through
this.  We also use it for clean file pages dropped through pruned inodes,
and xfs buffer pages freed.  Rename reclaimed_slab to reclaimed, and add a
helper function that wraps updating it through current, so that future
changes to this logic are contained within mm/vmscan.c.

Link: https://lkml.kernel.org/r/20230404001353.468224-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c           |    3 +--
 fs/xfs/xfs_buf.c     |    3 +--
 include/linux/swap.h |   17 ++++++++++++++++-
 mm/slab.c            |    3 +--
 mm/slob.c            |    6 ++----
 mm/slub.c            |    5 ++---
 mm/vmscan.c          |   21 +++++++++++++++------
 7 files changed, 38 insertions(+), 20 deletions(-)

--- a/fs/inode.c~mm-vmscan-refactor-updating-reclaimed-pages-in-reclaim_state
+++ a/fs/inode.c
@@ -864,8 +864,7 @@ static enum lru_status inode_lru_isolate
 				__count_vm_events(KSWAPD_INODESTEAL, reap);
 			else
 				__count_vm_events(PGINODESTEAL, reap);
-			if (current->reclaim_state)
-				current->reclaim_state->reclaimed_slab += reap;
+			mm_account_reclaimed_pages(reap);
 		}
 		iput(inode);
 		spin_lock(lru_lock);
--- a/fs/xfs/xfs_buf.c~mm-vmscan-refactor-updating-reclaimed-pages-in-reclaim_state
+++ a/fs/xfs/xfs_buf.c
@@ -286,8 +286,7 @@ xfs_buf_free_pages(
 		if (bp->b_pages[i])
 			__free_page(bp->b_pages[i]);
 	}
-	if (current->reclaim_state)
-		current->reclaim_state->reclaimed_slab += bp->b_page_count;
+	mm_account_reclaimed_pages(bp->b_page_count);
 
 	if (bp->b_pages != bp->b_page_array)
 		kmem_free(bp->b_pages);
--- a/include/linux/swap.h~mm-vmscan-refactor-updating-reclaimed-pages-in-reclaim_state
+++ a/include/linux/swap.h
@@ -153,13 +153,28 @@ union swap_header {
  * memory reclaim
  */
 struct reclaim_state {
-	unsigned long reclaimed_slab;
+	/* pages reclaimed outside of LRU-based reclaim */
+	unsigned long reclaimed;
 #ifdef CONFIG_LRU_GEN
 	/* per-thread mm walk data */
 	struct lru_gen_mm_walk *mm_walk;
 #endif
 };
 
+/*
+ * mm_account_reclaimed_pages(): account reclaimed pages outside of LRU-based
+ * reclaim
+ * @pages: number of pages reclaimed
+ *
+ * If the current process is undergoing a reclaim operation, increment the
+ * number of reclaimed pages by @pages.
+ */
+static inline void mm_account_reclaimed_pages(unsigned long pages)
+{
+	if (current->reclaim_state)
+		current->reclaim_state->reclaimed += pages;
+}
+
 #ifdef __KERNEL__
 
 struct address_space;
--- a/mm/slab.c~mm-vmscan-refactor-updating-reclaimed-pages-in-reclaim_state
+++ a/mm/slab.c
@@ -1392,8 +1392,7 @@ static void kmem_freepages(struct kmem_c
 	smp_wmb();
 	__folio_clear_slab(folio);
 
-	if (current->reclaim_state)
-		current->reclaim_state->reclaimed_slab += 1 << order;
+	mm_account_reclaimed_pages(1 << order);
 	unaccount_slab(slab, order, cachep);
 	__free_pages(&folio->page, order);
 }
--- a/mm/slob.c~mm-vmscan-refactor-updating-reclaimed-pages-in-reclaim_state
+++ a/mm/slob.c
@@ -61,7 +61,7 @@
 #include <linux/slab.h>
 
 #include <linux/mm.h>
-#include <linux/swap.h> /* struct reclaim_state */
+#include <linux/swap.h> /* mm_account_reclaimed_pages() */
 #include <linux/cache.h>
 #include <linux/init.h>
 #include <linux/export.h>
@@ -211,9 +211,7 @@ static void slob_free_pages(void *b, int
 {
 	struct page *sp = virt_to_page(b);
 
-	if (current->reclaim_state)
-		current->reclaim_state->reclaimed_slab += 1 << order;
-
+	mm_account_reclaimed_pages(1 << order);
 	mod_node_page_state(page_pgdat(sp), NR_SLAB_UNRECLAIMABLE_B,
 			    -(PAGE_SIZE << order));
 	__free_pages(sp, order);
--- a/mm/slub.c~mm-vmscan-refactor-updating-reclaimed-pages-in-reclaim_state
+++ a/mm/slub.c
@@ -11,7 +11,7 @@
  */
 
 #include <linux/mm.h>
-#include <linux/swap.h> /* struct reclaim_state */
+#include <linux/swap.h> /* mm_account_reclaimed_pages() */
 #include <linux/module.h>
 #include <linux/bit_spinlock.h>
 #include <linux/interrupt.h>
@@ -2063,8 +2063,7 @@ static void __free_slab(struct kmem_cach
 	/* Make the mapping reset visible before clearing the flag */
 	smp_wmb();
 	__folio_clear_slab(folio);
-	if (current->reclaim_state)
-		current->reclaim_state->reclaimed_slab += pages;
+	mm_account_reclaimed_pages(pages);
 	unaccount_slab(slab, order, s);
 	__free_pages(&folio->page, order);
 }
--- a/mm/vmscan.c~mm-vmscan-refactor-updating-reclaimed-pages-in-reclaim_state
+++ a/mm/vmscan.c
@@ -528,6 +528,19 @@ static void set_task_reclaim_state(struc
 	task->reclaim_state = rs;
 }
 
+/*
+ * flush_reclaim_state(): add pages reclaimed outside of LRU-based reclaim to
+ * scan_control->nr_reclaimed.
+ */
+static void flush_reclaim_state(struct scan_control *sc,
+				struct reclaim_state *rs)
+{
+	if (rs) {
+		sc->nr_reclaimed += rs->reclaimed;
+		rs->reclaimed = 0;
+	}
+}
+
 static long xchg_nr_deferred(struct shrinker *shrinker,
 			     struct shrink_control *sc)
 {
@@ -5362,8 +5375,7 @@ static int shrink_one(struct lruvec *lru
 		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
 			   sc->nr_reclaimed - reclaimed);
 
-	sc->nr_reclaimed += current->reclaim_state->reclaimed_slab;
-	current->reclaim_state->reclaimed_slab = 0;
+	flush_reclaim_state(sc, current->reclaim_state);
 
 	return success ? MEMCG_LRU_YOUNG : 0;
 }
@@ -6484,10 +6496,7 @@ again:
 
 	shrink_node_memcgs(pgdat, sc);
 
-	if (reclaim_state) {
-		sc->nr_reclaimed += reclaim_state->reclaimed_slab;
-		reclaim_state->reclaimed_slab = 0;
-	}
+	flush_reclaim_state(sc, reclaim_state);
 
 	/* Record the subtree's reclaim efficiency */
 	if (!sc->proactive)
_

Patches currently in -mm which might be from yosryahmed@google.com are

cgroup-rename-cgroup_rstat_flush_irqsafe-to-atomic.patch
memcg-rename-mem_cgroup_flush_stats_delayed-to-ratelimited.patch
memcg-do-not-flush-stats-in-irq-context.patch
memcg-replace-stats_flush_lock-with-an-atomic.patch
memcg-sleep-during-flushing-stats-in-safe-contexts.patch
workingset-memcg-sleep-when-flushing-stats-in-workingset_refault.patch
vmscan-memcg-sleep-when-flushing-stats-during-reclaim.patch
memcg-do-not-modify-rstat-tree-for-zero-updates.patch
mm-vmscan-move-set_task_reclaim_state-after-global_reclaim.patch
mm-vmscan-refactor-updating-reclaimed-pages-in-reclaim_state.patch
mm-vmscan-ignore-non-lru-based-reclaim-in-memcg-reclaim.patch

