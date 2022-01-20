Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759B2C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbiATVZL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377836AbiATVZK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:25:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AE8C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:25:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6484E60B08
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA9CC340E3;
        Thu, 20 Jan 2022 21:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713908;
        bh=KmPh34YOeTw2PrP7MWh6Z7SqWUxAU6s8WwiL4hsSII4=;
        h=Date:From:To:Subject:From;
        b=aVG914QF1COzZ5p/wtHD6y9awjADUtJLM2ItacfPCe+d1E51Qbz37aEzI0TRAw0tX
         2IxPNDmyF/AI5/VpAidd4Lj6vYFG3GbvE4CV/R5uMgRvJ0Qhx3nIWP65MVyKW1ok/I
         uPmWBYfNmF2ZqpSnVVv4FnxRXFQiL++pIUt2VQWE=
Date:   Thu, 20 Jan 2022 13:25:08 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com
Subject:  [merged] memcg-add-per-memcg-vmalloc-stat.patch removed
 from -mm tree
Message-ID: <20220120212508.JOotqqUet%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add per-memcg vmalloc stat
has been removed from the -mm tree.  Its filename was
     memcg-add-per-memcg-vmalloc-stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: add per-memcg vmalloc stat

The kvmalloc* allocation functions can fallback to vmalloc allocations
and more often on long running machines.  In addition the kernel does have
__GFP_ACCOUNT kvmalloc* calls.  So, often on long running machines, the
memory.stat does not tell the complete picture which type of memory is
charged to the memcg.  So add a per-memcg vmalloc stat.

[shakeelb@google.com: page_memcg() within rcu lock, per Muchun]
  Link: https://lkml.kernel.org/r/20211222052457.1960701-1-shakeelb@google.com
[akpm@linux-foundation.org: remove cast, per Muchun]
[shakeelb@google.com: remove area->page[0] checks and move to page by page accounting per Michal]
  Link: https://lkml.kernel.org/r/20220104222341.3972772-1-shakeelb@google.com
Link: https://lkml.kernel.org/r/20211221215336.1922823-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    3 +++
 include/linux/memcontrol.h              |   21 +++++++++++++++++++++
 mm/memcontrol.c                         |    1 +
 mm/vmalloc.c                            |   13 +++++++++++--
 4 files changed, 36 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~memcg-add-per-memcg-vmalloc-stat
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1314,6 +1314,9 @@ PAGE_SIZE multiple when read back.
 	  sock (npn)
 		Amount of memory used in network transmission buffers
 
+	  vmalloc (npn)
+		Amount of memory used for vmap backed memory.
+
 	  shmem
 		Amount of cached filesystem data that is swap-backed,
 		such as tmpfs, shm segments, shared anonymous mmap()s
--- a/include/linux/memcontrol.h~memcg-add-per-memcg-vmalloc-stat
+++ a/include/linux/memcontrol.h
@@ -33,6 +33,7 @@ enum memcg_stat_item {
 	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
+	MEMCG_VMALLOC,
 	MEMCG_NR_STAT,
 };
 
@@ -992,6 +993,21 @@ static inline void mod_memcg_state(struc
 	local_irq_restore(flags);
 }
 
+static inline void mod_memcg_page_state(struct page *page,
+					int idx, int val)
+{
+	struct mem_cgroup *memcg;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	rcu_read_lock();
+	memcg = page_memcg(page);
+	if (memcg)
+		mod_memcg_state(memcg, idx, val);
+	rcu_read_unlock();
+}
+
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 {
 	return READ_ONCE(memcg->vmstats.state[idx]);
@@ -1447,6 +1463,11 @@ static inline void mod_memcg_state(struc
 {
 }
 
+static inline void mod_memcg_page_state(struct page *page,
+					int idx, int val)
+{
+}
+
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 {
 	return 0;
--- a/mm/memcontrol.c~memcg-add-per-memcg-vmalloc-stat
+++ a/mm/memcontrol.c
@@ -1375,6 +1375,7 @@ static const struct memory_stat memory_s
 	{ "pagetables",			NR_PAGETABLE			},
 	{ "percpu",			MEMCG_PERCPU_B			},
 	{ "sock",			MEMCG_SOCK			},
+	{ "vmalloc",			MEMCG_VMALLOC			},
 	{ "shmem",			NR_SHMEM			},
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
--- a/mm/vmalloc.c~memcg-add-per-memcg-vmalloc-stat
+++ a/mm/vmalloc.c
@@ -31,6 +31,7 @@
 #include <linux/kmemleak.h>
 #include <linux/atomic.h>
 #include <linux/compiler.h>
+#include <linux/memcontrol.h>
 #include <linux/llist.h>
 #include <linux/bitops.h>
 #include <linux/rbtree_augmented.h>
@@ -2623,12 +2624,13 @@ static void __vunmap(const void *addr, i
 
 	if (deallocate_pages) {
 		unsigned int page_order = vm_area_page_order(area);
-		int i;
+		int i, step = 1U << page_order;
 
-		for (i = 0; i < area->nr_pages; i += 1U << page_order) {
+		for (i = 0; i < area->nr_pages; i += step) {
 			struct page *page = area->pages[i];
 
 			BUG_ON(!page);
+			mod_memcg_page_state(page, MEMCG_VMALLOC, -step);
 			__free_pages(page, page_order);
 			cond_resched();
 		}
@@ -2955,6 +2957,13 @@ static void *__vmalloc_area_node(struct
 		page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
+	if (gfp_mask & __GFP_ACCOUNT) {
+		int i, step = 1U << page_order;
+
+		for (i = 0; i < area->nr_pages; i += step)
+			mod_memcg_page_state(area->pages[i], MEMCG_VMALLOC,
+					     step);
+	}
 
 	/*
 	 * If not enough pages were obtained to accomplish an
_

Patches currently in -mm which might be from shakeelb@google.com are


