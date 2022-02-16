Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1743C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 21:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiBPVVI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:21:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiBPVVI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 16:21:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4FC244D91
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 13:20:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF16461A00
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 21:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0BBC004E1;
        Wed, 16 Feb 2022 21:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645046454;
        bh=VlIAVw5G0rKIPukamZoOezBszElNLcUpl4nIx4XA548=;
        h=Date:To:From:Subject:From;
        b=XLMRv5iNveJEjbm73n1W0FFhi/DkJf/YtR6b5ST1MfAabFvvCVhUHOmgksMtTON1u
         XPbWTK44yppLqluiSlUTPQvZu6vh6bXVztyq6YN5TMruCgjAEqzc87IWOydT8zdiwb
         LdojzEZE7HO0KywrOM7t6q9WdqCT8dLrAAYd5HRs=
Date:   Wed, 16 Feb 2022 13:20:53 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com, lkp@intel.com,
        hannes@cmpxchg.org, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-add-per-memcg-total-kernel-memory-stat-v2.patch removed from -mm tree
Message-Id: <20220216212054.0A0BBC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-add-per-memcg-total-kernel-memory-stat-v2
has been removed from the -mm tree.  Its filename was
     memcg-add-per-memcg-total-kernel-memory-stat-v2.patch

This patch was dropped because it was folded into memcg-add-per-memcg-total-kernel-memory-stat.patch

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: memcg-add-per-memcg-total-kernel-memory-stat-v2

- Moved "kernel" stat ahead of other subset kernel stats.
- Renamed mem_cgroup_kmem_record() to memcg_account_kmem(), following
  Johannes's review to avoid the line wrap, but keeping a memcg_ prefix
  to stay consistent with other static functions in the file.
- Fixed a build error when CONFIG_MEMCG_KMEM is not set (added an empty
  version if the config is not set).

Link: https://lkml.kernel.org/r/20220203193856.972500-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: kernel test robot <lkp@intel.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   10 +++++-----
 mm/memcontrol.c                         |   15 +++++++++------
 2 files changed, 14 insertions(+), 11 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~memcg-add-per-memcg-total-kernel-memory-stat-v2
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1301,6 +1301,11 @@ PAGE_SIZE multiple when read back.
 		Amount of memory used to cache filesystem data,
 		including tmpfs and shared memory.
 
+	  kernel (npn)
+		Amount of total kernel memory, including
+		(kernel_stack, pagetables, percpu, vmalloc, slab) in
+		addition to other kernel memory use cases.
+
 	  kernel_stack
 		Amount of memory allocated to kernel stacks.
 
@@ -1317,11 +1322,6 @@ PAGE_SIZE multiple when read back.
 	  vmalloc (npn)
 		Amount of memory used for vmap backed memory.
 
-	  kernel (npn)
-		Amount of total kernel memory, including
-		(kernel_stack, pagetables, percpu, vmalloc, slab) in
-		addition to other kernel memory use cases.
-
 	  shmem
 		Amount of cached filesystem data that is swap-backed,
 		such as tmpfs, shm segments, shared anonymous mmap()s
--- a/mm/memcontrol.c~memcg-add-per-memcg-total-kernel-memory-stat-v2
+++ a/mm/memcontrol.c
@@ -1371,12 +1371,12 @@ struct memory_stat {
 static const struct memory_stat memory_stats[] = {
 	{ "anon",			NR_ANON_MAPPED			},
 	{ "file",			NR_FILE_PAGES			},
+	{ "kernel",			MEMCG_KMEM			},
 	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
 	{ "pagetables",			NR_PAGETABLE			},
 	{ "percpu",			MEMCG_PERCPU_B			},
 	{ "sock",			MEMCG_SOCK			},
 	{ "vmalloc",			MEMCG_VMALLOC			},
-	{ "kernel",			MEMCG_KMEM			},
 	{ "shmem",			NR_SHMEM			},
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
@@ -2115,6 +2115,7 @@ static DEFINE_MUTEX(percpu_charge_mutex)
 static void drain_obj_stock(struct obj_stock *stock);
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
+static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 
 #else
 static inline void drain_obj_stock(struct obj_stock *stock)
@@ -2125,6 +2126,9 @@ static bool obj_stock_flush_required(str
 {
 	return false;
 }
+static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages)
+{
+}
 #endif
 
 /**
@@ -2980,8 +2984,7 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
-static void mem_cgroup_kmem_record(struct mem_cgroup *memcg,
-				   int nr_pages)
+static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages)
 {
 	mod_memcg_state(memcg, MEMCG_KMEM, nr_pages);
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
@@ -3005,7 +3008,7 @@ static void obj_cgroup_uncharge_pages(st
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	mem_cgroup_kmem_record(memcg, -nr_pages);
+	memcg_account_kmem(memcg, -nr_pages);
 	refill_stock(memcg, nr_pages);
 
 	css_put(&memcg->css);
@@ -3031,7 +3034,7 @@ static int obj_cgroup_charge_pages(struc
 	if (ret)
 		goto out;
 
-	mem_cgroup_kmem_record(memcg, nr_pages);
+	memcg_account_kmem(memcg, nr_pages);
 out:
 	css_put(&memcg->css);
 
@@ -6814,7 +6817,7 @@ static void uncharge_batch(const struct
 		if (do_memsw_account())
 			page_counter_uncharge(&ug->memcg->memsw, ug->nr_memory);
 		if (ug->nr_kmem)
-			mem_cgroup_kmem_record(ug->memcg, -ug->nr_kmem);
+			memcg_account_kmem(ug->memcg, -ug->nr_kmem);
 		memcg_oom_recover(ug->memcg);
 	}
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

memcg-add-per-memcg-total-kernel-memory-stat.patch

