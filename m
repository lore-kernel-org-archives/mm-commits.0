Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302FF36495B
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388599; cv=none; b=BMAENLVWyoVlakoDxiyaQ5sdlkaeWn551+LNG5MEAkiAMNYbNfIL0Bn+BlLC13ae0Mq2eP4bZS0N9B90tKDGONou5YWA8kTWnx02+Pf2u2HAl0GjzeRmrJ3TzWpFn9OhVtv4x8qowNZWHObJB8Xd+vx4H3I0co+an2cpyawjps0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388599; c=relaxed/simple;
	bh=E1zsOXRStYCPhQMoJXzBXpS63uULjrU6NNjaOpT5Okc=;
	h=Date:To:From:Subject:Message-Id; b=fwppQF4RN9zn3IF1jOFoxq8rNLOrZmhSnCG7qwMNnpW5gYBj+DumGaidBtHB/2oKzIcVZJLaSW/wF7/R4/HlWogCR/epgY/aVNmQuzanf6cE2IQ3cLqHr+Mx0++AKnh7El28q9BW1wozdEitbBSGIxgN3IczjA6l2xR7UaIInXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J1F9GJD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J1F9GJD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C43C19424;
	Tue, 24 Mar 2026 21:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388599;
	bh=E1zsOXRStYCPhQMoJXzBXpS63uULjrU6NNjaOpT5Okc=;
	h=Date:To:From:Subject:From;
	b=J1F9GJD3VpH8nJYqTSobjiqhfnNhNmAyQeDmKNngenDcQTzyQeGD2EF8uukxOvTqM
	 c/SaUXoqmt0YusQo7FBAdVYkBCS4MNuKFQyG6Y8h9SGfwPKoycKtwe+yjSMNaPMs1d
	 uVAyfm6bEhOjmsuAMEwa/0pnXfGPC7GMINEXyyGU=
Date: Tue, 24 Mar 2026 14:43:18 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter.patch removed from -mm tree
Message-Id: <20260324214319.03C43C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: switch to native NR_VMALLOC vmstat counter
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: switch to native NR_VMALLOC vmstat counter
Date: Mon, 23 Feb 2026 11:01:07 -0500

Eliminates the custom memcg counter and results in a single, consolidated
accounting call in vmalloc code.

Link: https://lkml.kernel.org/r/20260223160147.3792777-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 -
 mm/memcontrol.c            |    4 ++--
 mm/vmalloc.c               |   16 ++++------------
 3 files changed, 6 insertions(+), 15 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter
+++ a/include/linux/memcontrol.h
@@ -35,7 +35,6 @@ enum memcg_stat_item {
 	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
-	MEMCG_VMALLOC,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
--- a/mm/memcontrol.c~mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter
+++ a/mm/memcontrol.c
@@ -317,6 +317,7 @@ static const unsigned int memcg_node_sta
 	NR_SHMEM_THPS,
 	NR_FILE_THPS,
 	NR_ANON_THPS,
+	NR_VMALLOC,
 	NR_KERNEL_STACK_KB,
 	NR_PAGETABLE,
 	NR_SECONDARY_PAGETABLE,
@@ -352,7 +353,6 @@ static const unsigned int memcg_stat_ite
 	MEMCG_SWAP,
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
-	MEMCG_VMALLOC,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
@@ -1364,7 +1364,7 @@ static const struct memory_stat memory_s
 	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
 	{ "percpu",			MEMCG_PERCPU_B			},
 	{ "sock",			MEMCG_SOCK			},
-	{ "vmalloc",			MEMCG_VMALLOC			},
+	{ "vmalloc",			NR_VMALLOC			},
 	{ "shmem",			NR_SHMEM			},
 #ifdef CONFIG_ZSWAP
 	{ "zswap",			MEMCG_ZSWAP_B			},
--- a/mm/vmalloc.c~mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter
+++ a/mm/vmalloc.c
@@ -3459,9 +3459,6 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
-	/* All pages of vm should be charged to same memcg, so use first one. */
-	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
-		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
 	for (i = 0; i < vm->nr_pages; i++) {
 		struct page *page = vm->pages[i];
 
@@ -3471,7 +3468,7 @@ void vfree(const void *addr)
 		 * can be freed as an array of order-0 allocations
 		 */
 		if (!(vm->flags & VM_MAP_PUT_PAGES))
-			dec_node_page_state(page, NR_VMALLOC);
+			mod_lruvec_page_state(page, NR_VMALLOC, -1);
 		__free_page(page);
 		cond_resched();
 	}
@@ -3662,7 +3659,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			continue;
 		}
 
-		mod_node_page_state(page_pgdat(page), NR_VMALLOC, 1 << large_order);
+		mod_lruvec_page_state(page, NR_VMALLOC, 1 << large_order);
 
 		split_page(page, large_order);
 		for (i = 0; i < (1U << large_order); i++)
@@ -3709,7 +3706,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 							pages + nr_allocated);
 
 			for (i = nr_allocated; i < nr_allocated + nr; i++)
-				inc_node_page_state(pages[i], NR_VMALLOC);
+				mod_lruvec_page_state(pages[i], NR_VMALLOC, 1);
 
 			nr_allocated += nr;
 
@@ -3735,7 +3732,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		if (unlikely(!page))
 			break;
 
-		mod_node_page_state(page_pgdat(page), NR_VMALLOC, 1 << order);
+		mod_lruvec_page_state(page, NR_VMALLOC, 1 << order);
 
 		/*
 		 * High-order allocations must be able to be treated as
@@ -3879,11 +3876,6 @@ static void *__vmalloc_area_node(struct
 			vmalloc_gfp_adjust(gfp_mask, page_order), node,
 			page_order, nr_small_pages, area->pages);
 
-	/* All pages of vm should be charged to same memcg, so use first one. */
-	if (gfp_mask & __GFP_ACCOUNT && area->nr_pages)
-		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
-				     area->nr_pages);
-
 	/*
 	 * If not enough pages were obtained to accomplish an
 	 * allocation request, free them via vfree() if any.
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-split-out-__obj_cgroup_charge.patch
mm-memcontrol-use-__account_obj_stock-in-the-locked-path.patch
mm-memcg-separate-slab-stat-accounting-from-objcg-charge-cache.patch
mm-list_lru-lock_list_lru_of_memcg-cannot-return-null-if-skip_empty.patch
mm-list_lru-deduplicate-unlock_list_lru.patch
mm-list_lru-move-list-dead-check-to-lock_list_lru_of_memcg.patch
mm-list_lru-deduplicate-lock_list_lru.patch
mm-list_lru-introduce-caller-locking-for-additions-and-deletions.patch
mm-list_lru-introduce-folio_memcg_list_lru_alloc.patch
mm-switch-deferred-split-shrinker-to-list_lru.patch

