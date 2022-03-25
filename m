Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52D1C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357347AbiCYBcG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357353AbiCYBbu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E35A38BF5
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BED00617C7
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223E7C340ED;
        Fri, 25 Mar 2022 01:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171812;
        bh=NkVa9wUTZzoAW86C+nH26/PhlLmJ490MAzMjCXx8tM8=;
        h=Date:To:From:Subject:From;
        b=kjsr5O2MY4aWoM1XjG9kClge1MQYwvHbgH0ARZQebky2eQCBjYWcvFReioxPaqz7P
         OSWWx/lDCK0RqamloSTCWL1c9XUEXyQLX+7zU84tjoBTD8q76V8UGfm2JZNQLl8doE
         urX9v1hAN8m+isDgnXP3BB5RN5CPxznfzm3opSiY=
Date:   Thu, 24 Mar 2022 18:30:11 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] memcg-add-per-memcg-total-kernel-memory-stat.patch removed from -mm tree
Message-Id: <20220325013012.223E7C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add per-memcg total kernel memory stat
has been removed from the -mm tree.  Its filename was
     memcg-add-per-memcg-total-kernel-memory-stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: memcg: add per-memcg total kernel memory stat

Currently memcg stats show several types of kernel memory: kernel stack,
page tables, sock, vmalloc, and slab.  However, there are other
allocations with __GFP_ACCOUNT (or supersets such as GFP_KERNEL_ACCOUNT)
that are not accounted in any of those stats, a few examples are:

- various kvm allocations (e.g. allocated pages to create vcpus)
- io_uring
- tmp_page in pipes during pipe_write()
- bpf ringbuffers
- unix sockets

Keeping track of the total kernel memory is essential for the ease of
migration from cgroup v1 to v2 as there are large discrepancies between
v1's kmem.usage_in_bytes and the sum of the available kernel memory stats
in v2.  Adding separate memcg stats for all __GFP_ACCOUNT kernel
allocations is an impractical maintenance burden as there a lot of those
all over the kernel code, with more use cases likely to show up in the
future.

Therefore, add a "kernel" memcg stat that is analogous to kmem page
counter, with added benefits such as using rstat infrastructure which
aggregates stats more efficiently.  Additionally, this provides a lighter
alternative in case the legacy kmem is deprecated in the future

[yosryahmed@google.com: v2]
  Link: https://lkml.kernel.org/r/20220203193856.972500-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20220201200823.3283171-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    5 ++++
 include/linux/memcontrol.h              |    1 
 mm/memcontrol.c                         |   27 +++++++++++++++++-----
 3 files changed, 27 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~memcg-add-per-memcg-total-kernel-memory-stat
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
 
--- a/include/linux/memcontrol.h~memcg-add-per-memcg-total-kernel-memory-stat
+++ a/include/linux/memcontrol.h
@@ -34,6 +34,7 @@ enum memcg_stat_item {
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
 	MEMCG_VMALLOC,
+	MEMCG_KMEM,
 	MEMCG_NR_STAT,
 };
 
--- a/mm/memcontrol.c~memcg-add-per-memcg-total-kernel-memory-stat
+++ a/mm/memcontrol.c
@@ -1371,6 +1371,7 @@ struct memory_stat {
 static const struct memory_stat memory_stats[] = {
 	{ "anon",			NR_ANON_MAPPED			},
 	{ "file",			NR_FILE_PAGES			},
+	{ "kernel",			MEMCG_KMEM			},
 	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
 	{ "pagetables",			NR_PAGETABLE			},
 	{ "percpu",			MEMCG_PERCPU_B			},
@@ -2114,6 +2115,7 @@ static DEFINE_MUTEX(percpu_charge_mutex)
 static void drain_obj_stock(struct obj_stock *stock);
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
+static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 
 #else
 static inline void drain_obj_stock(struct obj_stock *stock)
@@ -2124,6 +2126,9 @@ static bool obj_stock_flush_required(str
 {
 	return false;
 }
+static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages)
+{
+}
 #endif
 
 /**
@@ -2979,6 +2984,18 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
+static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages)
+{
+	mod_memcg_state(memcg, MEMCG_KMEM, nr_pages);
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		if (nr_pages > 0)
+			page_counter_charge(&memcg->kmem, nr_pages);
+		else
+			page_counter_uncharge(&memcg->kmem, -nr_pages);
+	}
+}
+
+
 /*
  * obj_cgroup_uncharge_pages: uncharge a number of kernel pages from a objcg
  * @objcg: object cgroup to uncharge
@@ -2991,8 +3008,7 @@ static void obj_cgroup_uncharge_pages(st
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		page_counter_uncharge(&memcg->kmem, nr_pages);
+	memcg_account_kmem(memcg, -nr_pages);
 	refill_stock(memcg, nr_pages);
 
 	css_put(&memcg->css);
@@ -3018,8 +3034,7 @@ static int obj_cgroup_charge_pages(struc
 	if (ret)
 		goto out;
 
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		page_counter_charge(&memcg->kmem, nr_pages);
+	memcg_account_kmem(memcg, nr_pages);
 out:
 	css_put(&memcg->css);
 
@@ -6801,8 +6816,8 @@ static void uncharge_batch(const struct
 		page_counter_uncharge(&ug->memcg->memory, ug->nr_memory);
 		if (do_memsw_account())
 			page_counter_uncharge(&ug->memcg->memsw, ug->nr_memory);
-		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && ug->nr_kmem)
-			page_counter_uncharge(&ug->memcg->kmem, ug->nr_kmem);
+		if (ug->nr_kmem)
+			memcg_account_kmem(ug->memcg, -ug->nr_kmem);
 		memcg_oom_recover(ug->memcg);
 	}
 
_

Patches currently in -mm which might be from yosryahmed@google.com are


