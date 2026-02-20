Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52092D7DEF
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 20:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771620952; cv=none; b=RTSwMVHM9Dz8PH3LDV5ShnbKi8Ym9l2o2a9BXffQQ0VFm3iYQ2PgETz7igRrg94uHNcLlUametCdNWKdGdOK5Mfedz218KefdwzPS/umgs2rEEsPPMAlcC1fPaXXpG3iz+LQLWDDAVI9cPnKUja6kqwaNrc64QFg72xwyiRzILQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771620952; c=relaxed/simple;
	bh=YBqwSWais2EZUu06ruYpTh621fJfYLdcv3dCdutvuUo=;
	h=Date:To:From:Subject:Message-Id; b=Jm3VAioRzFv4/N/Yk3VOvXjnKYZU3lzW/IKRC5o/rw4ydF7s9bUzc0vloZnrnUPe9W/z/XNXaa3Iy+bbtFi7S0DbwXK+BlSV7IfZNYCJX8DHj2WsUfGCd25gjKcEZZoCbvRBojGhL478bZcBSUak3CCcLiNLwG/eN2ekg3UgYKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eQ58g4Sg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eQ58g4Sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC4AC116C6;
	Fri, 20 Feb 2026 20:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771620952;
	bh=YBqwSWais2EZUu06ruYpTh621fJfYLdcv3dCdutvuUo=;
	h=Date:To:From:Subject:From;
	b=eQ58g4SgamAbF8+soGyMo/78n378vcJT7Dt/lpQSBP1b9U59yvC9VkxG0mBiCU7qq
	 FKP1Rm7t/MlPPVgi9rJjJMQIjlGBa9CzfolegJnLnPqfuJxyj5fXaiHyVSCCr40Bxl
	 zDSMTKVIlFmzj/KWzep7O8iL/ymyrOrJPwrtKGbY=
Date: Fri, 20 Feb 2026 12:55:51 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter.patch added to mm-new branch
Message-Id: <20260220205552.6EC4AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: switch to native NR_VMALLOC vmstat counter
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: switch to native NR_VMALLOC vmstat counter
Date: Fri, 20 Feb 2026 14:10:35 -0500

Eliminates the custom memcg counter and results in a single, consolidated
accounting call in vmalloc code.

Link: https://lkml.kernel.org/r/20260220191035.3703800-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>
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
@@ -318,6 +318,7 @@ static const unsigned int memcg_node_sta
 	NR_SHMEM_THPS,
 	NR_FILE_THPS,
 	NR_ANON_THPS,
+	NR_VMALLOC,
 	NR_KERNEL_STACK_KB,
 	NR_PAGETABLE,
 	NR_SECONDARY_PAGETABLE,
@@ -353,7 +354,6 @@ static const unsigned int memcg_stat_ite
 	MEMCG_SWAP,
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
-	MEMCG_VMALLOC,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
@@ -1365,7 +1365,7 @@ static const struct memory_stat memory_s
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
 
-		mod_node_page_state(page, NR_VMALLOC, 1 << large_order);
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
 
-		mod_node_page_state(page, NR_VMALLOC, 1 << order);
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

mm-vmalloc-streamline-vmalloc-memory-accounting.patch
mm-memcontrol-switch-to-native-nr_vmalloc-vmstat-counter.patch

