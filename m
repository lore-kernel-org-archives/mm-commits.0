Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556C7C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Dec 2021 22:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhLUWu7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 17:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhLUWu7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 17:50:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C7DC061574
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 14:50:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89A9AB81A26
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 22:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B5FC36AE9;
        Tue, 21 Dec 2021 22:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640127056;
        bh=90azojem68KbZN7oPpKV8p4P356cDHDmN8Eft+2p4Iw=;
        h=Date:From:To:Subject:From;
        b=O8V6614qglOTj3Q9sm41LJxm7mHoS3FYsutDDHdN1FYLW85RaGDe1y9Cu8+26OrCA
         G3PyWdprOBO9EMUUUe4Se2+WNFguWbnaDJQD9o+OH52o9Vw1Q0pWHyMnnPpV1CyvaB
         rO5lL70sxoknt6MxIX4UTnBDon5pPjzrD39u5KrY=
Date:   Tue, 21 Dec 2021 14:50:55 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mhocko@kernel.org, hannes@cmpxchg.org, guro@fb.com,
        shakeelb@google.com
Subject:  + memcg-add-per-memcg-vmalloc-stat.patch added to -mm tree
Message-ID: <20211221225055.dQ7gH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add per-memcg vmalloc stat
has been added to the -mm tree.  Its filename is
     memcg-add-per-memcg-vmalloc-stat.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-add-per-memcg-vmalloc-stat.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-add-per-memcg-vmalloc-stat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: add per-memcg vmalloc stat

The kvmalloc* allocation functions can fallback to vmalloc allocations
and more often on long running machines. In addition the kernel does
have __GFP_ACCOUNT kvmalloc* calls. So, often on long running machines,
the memory.stat does not tell the complete picture which type of memory
is charged to the memcg. So add a per-memcg vmalloc stat.

Link: https://lkml.kernel.org/r/20211221215336.1922823-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    3 +++
 include/linux/memcontrol.h              |   15 +++++++++++++++
 mm/memcontrol.c                         |    1 +
 mm/vmalloc.c                            |    5 +++++
 4 files changed, 24 insertions(+)

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
 
@@ -992,6 +993,15 @@ static inline void mod_memcg_state(struc
 	local_irq_restore(flags);
 }
 
+static inline void mod_memcg_page_state(struct page *page,
+					int idx, int val)
+{
+	struct mem_cgroup *memcg = page_memcg(page);
+
+	if (!mem_cgroup_disabled() && memcg)
+		mod_memcg_state(memcg, idx, val);
+}
+
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 {
 	return READ_ONCE(memcg->vmstats.state[idx]);
@@ -1447,6 +1457,11 @@ static inline void mod_memcg_state(struc
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
@@ -2625,6 +2626,9 @@ static void __vunmap(const void *addr, i
 		unsigned int page_order = vm_area_page_order(area);
 		int i;
 
+		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
+				     -(int)area->nr_pages);
+
 		for (i = 0; i < area->nr_pages; i += 1U << page_order) {
 			struct page *page = area->pages[i];
 
@@ -2955,6 +2959,7 @@ static void *__vmalloc_area_node(struct
 		page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
+	mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC, area->nr_pages);
 
 	/*
 	 * If not enough pages were obtained to accomplish an
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-better-bounds-on-the-memcg-stats-updates.patch
memcg-add-per-memcg-vmalloc-stat.patch

