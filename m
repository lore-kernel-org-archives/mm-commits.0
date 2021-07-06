Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75863C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F1B561C7A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhGFTN0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231766AbhGFTN0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:13:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B416461C6C;
        Tue,  6 Jul 2021 19:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598647;
        bh=HZEFogaH1bHq8PtdlfDpOdADi7Z4fXGjfHaGhLq15rI=;
        h=Date:From:To:Subject:From;
        b=Ua+xMH6tjacOFGaGMjhvpbl8Y6GL3g+LEYw4KbQcDLYtp9SLOwclLcQd2NPYfNWwf
         +8j1ta1QRqedT8j0YFWEBPI9m1FyvX+ik6zcsOW4bVAimjCuN4aCSkHd/4QkDGeK0L
         K3jZmy8wZr+ENE+VQzqj1HnxLoZgzWwfrlQGBt/c=
Date:   Tue, 06 Jul 2021 12:10:46 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, david@redhat.com, dennis@kernel.org,
        hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        linmiaohe@huawei.com, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        shy828301@gmail.com, tim.c.chen@linux.intel.com,
        willy@infradead.org, ying.huang@intel.com, yuzhao@google.com
Subject:  [merged]
 mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
 removed from -mm tree
Message-ID: <20210706191046.atl5nLIVA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: use percpu_ref to serialize against concurrent swapoff
has been removed from the -mm tree.  Its filename was
     mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile: use percpu_ref to serialize against concurrent swapoff

Patch series "close various race windows for swap", v6.

When I was investigating the swap code, I found some possible race
windows.  This series aims to fix all these races.  But using current
get/put_swap_device() to guard against concurrent swapoff for
swap_readpage() looks terrible because swap_readpage() may take really
long time.  And to reduce the performance overhead on the hot-path as much
as possible, it appears we can use the percpu_ref to close this race
window(as suggested by Huang, Ying).  The patch 1 adds percpu_ref support
for swap and most of the remaining patches try to use this to close
various race windows.  More details can be found in the respective
changelogs.  


This patch (of 4):

Using current get/put_swap_device() to guard against concurrent swapoff
for some swap ops, e.g.  swap_readpage(), looks terrible because they
might take really long time.  This patch adds the percpu_ref support to
serialize against concurrent swapoff(as suggested by Huang, Ying).  Also
we remove the SWP_VALID flag because it's used together with RCU solution.

Link: https://lkml.kernel.org/r/20210426123316.806267-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210426123316.806267-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +-
 mm/swapfile.c        |   79 +++++++++++++++++++++++++----------------
 2 files changed, 52 insertions(+), 32 deletions(-)

--- a/include/linux/swap.h~mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff
+++ a/include/linux/swap.h
@@ -177,7 +177,6 @@ enum {
 	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
-	SWP_VALID	= (1 << 13),	/* swap is valid to be operated on? */
 					/* add others here before... */
 	SWP_SCANNING	= (1 << 14),	/* refcount in scan_swap_map */
 };
@@ -240,6 +239,7 @@ struct swap_cluster_list {
  * The in-memory structure used to track swap areas.
  */
 struct swap_info_struct {
+	struct percpu_ref users;	/* indicate and keep swap device valid. */
 	unsigned long	flags;		/* SWP_USED etc: see above */
 	signed short	prio;		/* swap priority of this type */
 	struct plist_node list;		/* entry in swap_active_head */
@@ -260,6 +260,7 @@ struct swap_info_struct {
 	struct block_device *bdev;	/* swap device or bdev of swap file */
 	struct file *swap_file;		/* seldom referenced */
 	unsigned int old_block_size;	/* seldom referenced */
+	struct completion comp;		/* seldom referenced */
 #ifdef CONFIG_FRONTSWAP
 	unsigned long *frontswap_map;	/* frontswap in-use, one bit per page */
 	atomic_t frontswap_pages;	/* frontswap pages in-use counter */
@@ -511,7 +512,7 @@ sector_t swap_page_sector(struct page *p
 
 static inline void put_swap_device(struct swap_info_struct *si)
 {
-	rcu_read_unlock();
+	percpu_ref_put(&si->users);
 }
 
 #else /* CONFIG_SWAP */
--- a/mm/swapfile.c~mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff
+++ a/mm/swapfile.c
@@ -39,6 +39,7 @@
 #include <linux/export.h>
 #include <linux/swap_slots.h>
 #include <linux/sort.h>
+#include <linux/completion.h>
 
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
@@ -511,6 +512,14 @@ static void swap_discard_work(struct wor
 	spin_unlock(&si->lock);
 }
 
+static void swap_users_ref_free(struct percpu_ref *ref)
+{
+	struct swap_info_struct *si;
+
+	si = container_of(ref, struct swap_info_struct, users);
+	complete(&si->comp);
+}
+
 static void alloc_cluster(struct swap_info_struct *si, unsigned long idx)
 {
 	struct swap_cluster_info *ci = si->cluster_info;
@@ -1270,18 +1279,12 @@ static unsigned char __swap_entry_free_l
  * via preventing the swap device from being swapoff, until
  * put_swap_device() is called.  Otherwise return NULL.
  *
- * The entirety of the RCU read critical section must come before the
- * return from or after the call to synchronize_rcu() in
- * enable_swap_info() or swapoff().  So if "si->flags & SWP_VALID" is
- * true, the si->map, si->cluster_info, etc. must be valid in the
- * critical section.
- *
  * Notice that swapoff or swapoff+swapon can still happen before the
- * rcu_read_lock() in get_swap_device() or after the rcu_read_unlock()
- * in put_swap_device() if there isn't any other way to prevent
- * swapoff, such as page lock, page table lock, etc.  The caller must
- * be prepared for that.  For example, the following situation is
- * possible.
+ * percpu_ref_tryget_live() in get_swap_device() or after the
+ * percpu_ref_put() in put_swap_device() if there isn't any other way
+ * to prevent swapoff, such as page lock, page table lock, etc.  The
+ * caller must be prepared for that.  For example, the following
+ * situation is possible.
  *
  *   CPU1				CPU2
  *   do_swap_page()
@@ -1309,21 +1312,27 @@ struct swap_info_struct *get_swap_device
 	si = swp_swap_info(entry);
 	if (!si)
 		goto bad_nofile;
-
-	rcu_read_lock();
-	if (data_race(!(si->flags & SWP_VALID)))
-		goto unlock_out;
+	if (!percpu_ref_tryget_live(&si->users))
+		goto out;
+	/*
+	 * Guarantee the si->users are checked before accessing other
+	 * fields of swap_info_struct.
+	 *
+	 * Paired with the spin_unlock() after setup_swap_info() in
+	 * enable_swap_info().
+	 */
+	smp_rmb();
 	offset = swp_offset(entry);
 	if (offset >= si->max)
-		goto unlock_out;
+		goto put_out;
 
 	return si;
 bad_nofile:
 	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
 out:
 	return NULL;
-unlock_out:
-	rcu_read_unlock();
+put_out:
+	percpu_ref_put(&si->users);
 	return NULL;
 }
 
@@ -2466,7 +2475,7 @@ static void setup_swap_info(struct swap_
 
 static void _enable_swap_info(struct swap_info_struct *p)
 {
-	p->flags |= SWP_WRITEOK | SWP_VALID;
+	p->flags |= SWP_WRITEOK;
 	atomic_long_add(p->pages, &nr_swap_pages);
 	total_swap_pages += p->pages;
 
@@ -2497,10 +2506,9 @@ static void enable_swap_info(struct swap
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	/*
-	 * Guarantee swap_map, cluster_info, etc. fields are valid
-	 * between get/put_swap_device() if SWP_VALID bit is set
+	 * Finished initializing swap device, now it's safe to reference it.
 	 */
-	synchronize_rcu();
+	percpu_ref_resurrect(&p->users);
 	spin_lock(&swap_lock);
 	spin_lock(&p->lock);
 	_enable_swap_info(p);
@@ -2616,16 +2624,16 @@ SYSCALL_DEFINE1(swapoff, const char __us
 
 	reenable_swap_slots_cache_unlock();
 
-	spin_lock(&swap_lock);
-	spin_lock(&p->lock);
-	p->flags &= ~SWP_VALID;		/* mark swap device as invalid */
-	spin_unlock(&p->lock);
-	spin_unlock(&swap_lock);
 	/*
-	 * wait for swap operations protected by get/put_swap_device()
-	 * to complete
+	 * Wait for swap operations protected by get/put_swap_device()
+	 * to complete.
+	 *
+	 * We need synchronize_rcu() here to protect the accessing to
+	 * the swap cache data structure.
 	 */
+	percpu_ref_kill(&p->users);
 	synchronize_rcu();
+	wait_for_completion(&p->comp);
 
 	flush_work(&p->discard_work);
 
@@ -2857,6 +2865,12 @@ static struct swap_info_struct *alloc_sw
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
+	if (percpu_ref_init(&p->users, swap_users_ref_free,
+			    PERCPU_REF_INIT_DEAD, GFP_KERNEL)) {
+		kvfree(p);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	spin_lock(&swap_lock);
 	for (type = 0; type < nr_swapfiles; type++) {
 		if (!(swap_info[type]->flags & SWP_USED))
@@ -2864,6 +2878,7 @@ static struct swap_info_struct *alloc_sw
 	}
 	if (type >= MAX_SWAPFILES) {
 		spin_unlock(&swap_lock);
+		percpu_ref_exit(&p->users);
 		kvfree(p);
 		return ERR_PTR(-EPERM);
 	}
@@ -2891,9 +2906,13 @@ static struct swap_info_struct *alloc_sw
 		plist_node_init(&p->avail_lists[i], 0);
 	p->flags = SWP_USED;
 	spin_unlock(&swap_lock);
-	kvfree(defer);
+	if (defer) {
+		percpu_ref_exit(&defer->users);
+		kvfree(defer);
+	}
 	spin_lock_init(&p->lock);
 	spin_lock_init(&p->cont_lock);
+	init_completion(&p->comp);
 
 	return p;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

