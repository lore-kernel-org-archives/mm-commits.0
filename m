Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150DCC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377828AbiATVY6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377821AbiATVY5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5416FC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:24:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BECBB81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7BCC340E0;
        Thu, 20 Jan 2022 21:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713894;
        bh=QSh24bXdhVdvwaKYzMpt81U1tnQEEVucKjkzuPk6fNA=;
        h=Date:From:To:Subject:From;
        b=lMqin+zxlrYcR72pquacoHqMTe4jnBYRtbZAQ8v/mSvxOam0xZdi6o74ohBgz+uIM
         7hBSgUHdIUeRupzWir6bxis5c4bpkKWrdwf3NCxO+Pf4NKW2843bhaOEtjdXYuJ0RB
         rdQPMAppZtuJJhHJoY9+dqd2MZFlWDzSjSZ9BgM4=
Date:   Thu, 20 Jan 2022 13:24:54 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        vbabka@suse.cz, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-make-cgroup_memory_nokmem-static.patch removed from -mm tree
Message-ID: <20220120212454.zLGOWGe44%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: make cgroup_memory_nokmem static
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-make-cgroup_memory_nokmem-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch
fs-proc-store-pde-data-into-inode-i_private.patch
proc-remove-pde_data-completely.patch

