Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA8AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiANWFb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47066 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiANWFb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:05:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B205361FF6
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F53C36AE9;
        Fri, 14 Jan 2022 22:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197930;
        bh=F1ELaCyx4YcGBzGH+gZlEAcKQ7q0e/ULOdTBWIPHcWg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lFrpLxsxpqpJrPT+oQTJwLnymxBov9mT4XdLGdb4WQ9pLD//+jf/5JWIKA5k4Rbi3
         2IPk4d6z01V9xNWw+AqxlKl8TJMDpMhsjKohDGhEp/wY8s5UrSh8y9B30861VoiI2y
         nnmHtHgbSiQLoNlHrEOc6xFTZLjfNLtPFzJ3rrwc=
Date:   Fri, 14 Jan 2022 14:05:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [patch 048/146] mm: memcontrol: make cgroup_memory_nokmem
 static
Message-ID: <20220114220529.svLxttnTm%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: make cgroup_memory_nokmem static

commit 494c1dfe855e ("mm: memcg/slab: create a new set of kmalloc-cg-<n>
caches") makes cgroup_memory_nokmem global, however, it is unnecessary
because there is already a function mem_cgroup_kmem_disabled() which
exports it.

Just make it static and replace it with mem_cgroup_kmem_disabled() in
mm/slab_common.c.

Link: https://lkml.kernel.org/r/20211109065418.21693-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h    |    5 -----
 mm/memcontrol.c  |    2 +-
 mm/slab_common.c |    2 +-
 3 files changed, 2 insertions(+), 7 deletions(-)

--- a/mm/internal.h~mm-memcontrol-make-cgroup_memory_nokmem-static
+++ a/mm/internal.h
@@ -158,11 +158,6 @@ extern void reclaim_throttle(pg_data_t *
 extern pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
 
 /*
- * in mm/memcontrol.c:
- */
-extern bool cgroup_memory_nokmem;
-
-/*
  * in mm/page_alloc.c
  */
 
--- a/mm/memcontrol.c~mm-memcontrol-make-cgroup_memory_nokmem-static
+++ a/mm/memcontrol.c
@@ -84,7 +84,7 @@ EXPORT_PER_CPU_SYMBOL_GPL(int_active_mem
 static bool cgroup_memory_nosocket __ro_after_init;
 
 /* Kernel memory accounting disabled? */
-bool cgroup_memory_nokmem __ro_after_init;
+static bool cgroup_memory_nokmem __ro_after_init;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
--- a/mm/slab_common.c~mm-memcontrol-make-cgroup_memory_nokmem-static
+++ a/mm/slab_common.c
@@ -844,7 +844,7 @@ new_kmalloc_cache(int idx, enum kmalloc_
 	if (type == KMALLOC_RECLAIM) {
 		flags |= SLAB_RECLAIM_ACCOUNT;
 	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
-		if (cgroup_memory_nokmem) {
+		if (mem_cgroup_kmem_disabled()) {
 			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
 			return;
 		}
_
