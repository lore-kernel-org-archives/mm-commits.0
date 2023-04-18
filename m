Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A95CCC77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjDRXi6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbjDRXg4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4AD7EC2
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21D9F639E7
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BE8C433D2;
        Tue, 18 Apr 2023 23:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860951;
        bh=i8fclGvDefTuzpYf+Z51xtJ43UmCZCrt3Zn6v8BkBi8=;
        h=Date:To:From:Subject:From;
        b=Oz/7AxQs+REvcGgv9x0hrEtreSUQruZGwGZ57kLUNV5dKJCN7ddFDJ8R20Y0G/Xbn
         H4ES+cYG0MvetEnEkrrDpKLbuOv9++i+DN1QYJ+0ra9mR7NR7Jifuj+aid2ymX2HFW
         GJYqsaXPiKb9hAydIoaYpatljKCnMv26Jd4p0jZg=
Date:   Tue, 18 Apr 2023 16:35:50 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        viro@zeniv.linux.org.uk, vbabka@suse.cz,
        tim.c.chen@linux.intel.com, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com, peterx@redhat.com,
        neilb@suse.de, mhocko@suse.com, linmiaohe@huawei.com,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, djwong@kernel.org,
        david@redhat.com, david@fromorbit.com, cl@linux.com,
        42.hyeyoo@gmail.com, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-refactor-updating-current-reclaim_state.patch removed from -mm tree
Message-Id: <20230418233551.46BE8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmscan: refactor updating current->reclaim_state
has been removed from the -mm tree.  Its filename was
     mm-vmscan-refactor-updating-current-reclaim_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: vmscan: refactor updating current->reclaim_state
Date: Thu, 13 Apr 2023 10:40:34 +0000

During reclaim, we keep track of pages reclaimed from other means than
LRU-based reclaim through scan_control->reclaim_state->reclaimed_slab,
which we stash a pointer to in current task_struct.

However, we keep track of more than just reclaimed slab pages through
this.  We also use it for clean file pages dropped through pruned inodes,
and xfs buffer pages freed.  Rename reclaimed_slab to reclaimed, and add a
helper function that wraps updating it through current, so that future
changes to this logic are contained within include/linux/swap.h.

Link: https://lkml.kernel.org/r/20230413104034.1086717-4-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
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
 6 files changed, 23 insertions(+), 14 deletions(-)

--- a/fs/inode.c~mm-vmscan-refactor-updating-current-reclaim_state
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
--- a/fs/xfs/xfs_buf.c~mm-vmscan-refactor-updating-current-reclaim_state
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
--- a/include/linux/swap.h~mm-vmscan-refactor-updating-current-reclaim_state
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
--- a/mm/slab.c~mm-vmscan-refactor-updating-current-reclaim_state
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
--- a/mm/slob.c~mm-vmscan-refactor-updating-current-reclaim_state
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
--- a/mm/slub.c~mm-vmscan-refactor-updating-current-reclaim_state
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
_

Patches currently in -mm which might be from yosryahmed@google.com are


