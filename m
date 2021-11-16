Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F78BC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0154C61AE3
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240683AbhKPENr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:13:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242398AbhKPENS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:13:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C24B8619E8;
        Tue, 16 Nov 2021 04:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637035817;
        bh=bU/8Zaq9MyQ1WTxkp5rPlT7oZOd9l5lHvx80cWczBLY=;
        h=Date:From:To:Subject:From;
        b=jJdGTFT1aa6Gdld0VXUIZ3yIwGuNffziI80C3DHWtVvNT/qj/qzCsnrvy22QTOZBA
         DVIGKoHKynZ3uLytYxHZEmInknjp2UzXjxId8/DPQ+DbU+SLShz/IjKbIBNRxkvnhH
         JfT/GAs/yzmeIxyF1wsgDUj48UOWQUPEc+iny3DE=
Date:   Mon, 15 Nov 2021 20:10:16 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        vdavydov.dev@gmail.com
Subject:  + mm-memcontrol-make-cgroup_memory_nokmem-static.patch
 added to -mm tree
Message-ID: <20211116041016.nHujqXToa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: make cgroup_memory_nokmem static
has been added to the -mm tree.  Its filename is
     mm-memcontrol-make-cgroup_memory_nokmem-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-make-cgroup_memory_nokmem-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-make-cgroup_memory_nokmem-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -849,7 +849,7 @@ new_kmalloc_cache(int idx, enum kmalloc_
 	if (type == KMALLOC_RECLAIM) {
 		flags |= SLAB_RECLAIM_ACCOUNT;
 	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
-		if (cgroup_memory_nokmem) {
+		if (mem_cgroup_kmem_disabled()) {
 			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
 			return;
 		}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-slab-make-slab-iterator-functions-static.patch
mm-memcontrol-make-cgroup_memory_nokmem-static.patch

