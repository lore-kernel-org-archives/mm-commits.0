Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F11BC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 20:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbiBAUdZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 15:33:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44850 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237971AbiBAUdZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 15:33:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FC6DB82F8A
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 20:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C231EC340EB;
        Tue,  1 Feb 2022 20:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643747603;
        bh=GV1G6erb6x9obRsAkPp7i8AmI30E5UvWNr5FkxDfuiQ=;
        h=Date:To:From:Subject:From;
        b=arAljx/mCv35EagIjXPqUj4Fyfow2wyq5cJYjB+8IN8LelA13zloOsppRdCKBdBXl
         F7LkLfWeJ/SbglW2zEFx9oL1Io84u014+NjaBHflOXmNfFQlMfYUQQK/UmNBSpMScK
         7FMZw+1QFrUPJjDiA2lQ5GA5sV49RdgInmRQ5mV0=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 12:33:21 -0800
Date:   Tue, 01 Feb 2022 12:33:21 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-add-per-memcg-total-kernel-memory-stat.patch added to -mm tree
Message-Id: <20220201203321.C231EC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add per-memcg total kernel memory stat
has been added to the -mm tree.  Its filename is
     memcg-add-per-memcg-total-kernel-memory-stat.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-add-per-memcg-total-kernel-memory-stat.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-add-per-memcg-total-kernel-memory-stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20220201200823.3283171-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    5 ++++
 include/linux/memcontrol.h              |    1 
 mm/memcontrol.c                         |   24 ++++++++++++++++------
 3 files changed, 24 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~memcg-add-per-memcg-total-kernel-memory-stat
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1317,6 +1317,11 @@ PAGE_SIZE multiple when read back.
 	  vmalloc (npn)
 		Amount of memory used for vmap backed memory.
 
+	  kernel (npn)
+		Amount of total kernel memory, including
+		(kernel_stack, pagetables, percpu, vmalloc, slab) in
+		addition to other kernel memory use cases.
+
 	  shmem
 		Amount of cached filesystem data that is swap-backed,
 		such as tmpfs, shm segments, shared anonymous mmap()s
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
@@ -1376,6 +1376,7 @@ static const struct memory_stat memory_s
 	{ "percpu",			MEMCG_PERCPU_B			},
 	{ "sock",			MEMCG_SOCK			},
 	{ "vmalloc",			MEMCG_VMALLOC			},
+	{ "kernel",			MEMCG_KMEM			},
 	{ "shmem",			NR_SHMEM			},
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
@@ -2979,6 +2980,19 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
+static void mem_cgroup_kmem_record(struct mem_cgroup *memcg,
+				   int nr_pages)
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
@@ -2991,8 +3005,7 @@ static void obj_cgroup_uncharge_pages(st
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		page_counter_uncharge(&memcg->kmem, nr_pages);
+	mem_cgroup_kmem_record(memcg, -nr_pages);
 	refill_stock(memcg, nr_pages);
 
 	css_put(&memcg->css);
@@ -3018,8 +3031,7 @@ static int obj_cgroup_charge_pages(struc
 	if (ret)
 		goto out;
 
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		page_counter_charge(&memcg->kmem, nr_pages);
+	mem_cgroup_kmem_record(memcg, nr_pages);
 out:
 	css_put(&memcg->css);
 
@@ -6801,8 +6813,8 @@ static void uncharge_batch(const struct
 		page_counter_uncharge(&ug->memcg->memory, ug->nr_memory);
 		if (do_memsw_account())
 			page_counter_uncharge(&ug->memcg->memsw, ug->nr_memory);
-		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && ug->nr_kmem)
-			page_counter_uncharge(&ug->memcg->kmem, ug->nr_kmem);
+		if (ug->nr_kmem)
+			mem_cgroup_kmem_record(ug->memcg, -ug->nr_kmem);
 		memcg_oom_recover(ug->memcg);
 	}
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

memcg-add-per-memcg-total-kernel-memory-stat.patch

