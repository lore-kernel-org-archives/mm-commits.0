Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F70C43334
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 00:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiGQAsj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jul 2022 20:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGQAsj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Jul 2022 20:48:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4AE1835F
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 17:48:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C40B2B80D20
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 00:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645C8C34114;
        Sun, 17 Jul 2022 00:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658018915;
        bh=xvvI6ardh8P7m34jWunZEVGE81nXG9uPoC5bHUta9vM=;
        h=Date:To:From:Subject:From;
        b=EBPCjnIm1trz55jRNkgrNrhu0RNbO9Vp/TADEa3pdyu+f+bDCbV46KOmKOqw29SP6
         45uEu6ELDlubu0OcuSUWRmCKj1E/zHVPbCXUEkpws1eqYByiCiR8vQjKv5P63HKLs9
         JwN7Biu7ivOzmuzzKCS+tfSbkiaDcnNngQJ3U4Lo=
Date:   Sat, 16 Jul 2022 17:48:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, peterx@redhat.com, neilb@suse.de,
        mhocko@kernel.org, linmiaohe@huawei.com, hannes@cmpxchg.org,
        david@redhat.com, apopple@nvidia.com, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure.patch added to mm-unstable branch
Message-Id: <20220717004835.645C8C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmpressure: don't count proactive reclaim in vmpressure
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure.patch

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
Subject: mm: vmpressure: don't count proactive reclaim in vmpressure
Date: Thu, 14 Jul 2022 06:49:18 +0000

vmpressure is used in cgroup v1 to notify userspace of reclaim efficiency
events, and is also used in both cgroup v1 and v2 as a signal for memory
pressure for networking, see mem_cgroup_under_socket_pressure().

Proactive reclaim intends to probe memcgs for cold memory, without
affecting their performance.  Hence, reclaim caused by writing to
memory.reclaim should not trigger vmpressure.

Link: https://lkml.kernel.org/r/20220714064918.2576464-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 ++++-
 mm/memcontrol.c      |   24 ++++++++++++++----------
 mm/vmscan.c          |   27 +++++++++++++++++----------
 3 files changed, 35 insertions(+), 21 deletions(-)

--- a/include/linux/swap.h~mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure
+++ a/include/linux/swap.h
@@ -411,10 +411,13 @@ extern void lru_cache_add_inactive_or_un
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
+
+#define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
+#define MEMCG_RECLAIM_PROACTIVE (1 << 2)
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
-						  bool may_swap);
+						  unsigned int reclaim_options);
 extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						pg_data_t *pgdat,
--- a/mm/memcontrol.c~mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure
+++ a/mm/memcontrol.c
@@ -2330,7 +2330,8 @@ static unsigned long reclaim_high(struct
 
 		psi_memstall_enter(&pflags);
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
-							     gfp_mask, true);
+							gfp_mask,
+							MEMCG_RECLAIM_MAY_SWAP);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2575,7 +2576,7 @@ static int try_charge_memcg(struct mem_c
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
-	bool may_swap = true;
+	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
@@ -2593,7 +2594,7 @@ retry:
 		mem_over_limit = mem_cgroup_from_counter(counter, memory);
 	} else {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
-		may_swap = false;
+		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 	}
 
 	if (batch > nr_pages) {
@@ -2621,7 +2622,7 @@ retry:
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, may_swap);
+						    gfp_mask, reclaim_options);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -3439,8 +3440,8 @@ static int mem_cgroup_resize_max(struct
 			continue;
 		}
 
-		if (!try_to_free_mem_cgroup_pages(memcg, 1,
-					GFP_KERNEL, !memsw)) {
+		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
+					memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -3550,7 +3551,8 @@ static int mem_cgroup_force_empty(struct
 		if (signal_pending(current))
 			return -EINTR;
 
-		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, true))
+		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
+						  MEMCG_RECLAIM_MAY_SWAP))
 			nr_retries--;
 	}
 
@@ -6302,7 +6304,7 @@ static ssize_t memory_high_write(struct
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-							 GFP_KERNEL, true);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -6351,7 +6353,7 @@ static ssize_t memory_max_write(struct k
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-							  GFP_KERNEL, true))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP))
 				nr_reclaims--;
 			continue;
 		}
@@ -6480,6 +6482,7 @@ static ssize_t memory_reclaim(struct ker
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
+	unsigned int reclaim_options;
 	int err;
 
 	buf = strstrip(buf);
@@ -6487,6 +6490,7 @@ static ssize_t memory_reclaim(struct ker
 	if (err)
 		return err;
 
+	reclaim_options	= MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE;
 	while (nr_reclaimed < nr_to_reclaim) {
 		unsigned long reclaimed;
 
@@ -6503,7 +6507,7 @@ static ssize_t memory_reclaim(struct ker
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						nr_to_reclaim - nr_reclaimed,
-						GFP_KERNEL, true);
+						GFP_KERNEL, reclaim_options);
 
 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
--- a/mm/vmscan.c~mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure
+++ a/mm/vmscan.c
@@ -101,6 +101,9 @@ struct scan_control {
 	/* Can pages be swapped as part of reclaim? */
 	unsigned int may_swap:1;
 
+	/* Proactive reclaim invoked by userspace through memory.reclaim */
+	unsigned int proactive:1;
+
 	/*
 	 * Cgroup memory below memory.low is protected as long as we
 	 * don't threaten to OOM. If any cgroup is reclaimed at
@@ -3175,9 +3178,10 @@ static void shrink_node_memcgs(pg_data_t
 			    sc->priority);
 
 		/* Record the group's reclaim efficiency */
-		vmpressure(sc->gfp_mask, memcg, false,
-			   sc->nr_scanned - scanned,
-			   sc->nr_reclaimed - reclaimed);
+		if (!sc->proactive)
+			vmpressure(sc->gfp_mask, memcg, false,
+				   sc->nr_scanned - scanned,
+				   sc->nr_reclaimed - reclaimed);
 
 	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, NULL)));
 }
@@ -3300,9 +3304,10 @@ again:
 	}
 
 	/* Record the subtree's reclaim efficiency */
-	vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
-		   sc->nr_scanned - nr_scanned,
-		   sc->nr_reclaimed - nr_reclaimed);
+	if (!sc->proactive)
+		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
+			   sc->nr_scanned - nr_scanned,
+			   sc->nr_reclaimed - nr_reclaimed);
 
 	if (sc->nr_reclaimed - nr_reclaimed)
 		reclaimable = true;
@@ -3584,8 +3589,9 @@ retry:
 		__count_zid_vm_events(ALLOCSTALL, sc->reclaim_idx, 1);
 
 	do {
-		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
-				sc->priority);
+		if (!sc->proactive)
+			vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
+					sc->priority);
 		sc->nr_scanned = 0;
 		shrink_zones(zonelist, sc);
 
@@ -3875,7 +3881,7 @@ unsigned long mem_cgroup_shrink_node(str
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
-					   bool may_swap)
+					   unsigned int reclaim_options)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
@@ -3888,7 +3894,8 @@ unsigned long try_to_free_mem_cgroup_pag
 		.priority = DEF_PRIORITY,
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
-		.may_swap = may_swap,
+		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
+		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure.patch

