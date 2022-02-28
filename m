Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CC7C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 18:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiB1TAY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiB1TAF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 14:00:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AEF74842
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 10:59:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E18661564
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 18:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFE6C340F1;
        Mon, 28 Feb 2022 18:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646074764;
        bh=oXfnXxEoh7LOexyBjAlSrvics9U+D/W1nVlWjihdYqU=;
        h=Date:To:From:Subject:From;
        b=IcEJf0OPWvmOvCZAEE4obYAqV2qLFY9pI7LlmVNHOuh5ZcK5A4/A0gVJiYqppTRKF
         4uRWvshB+qhCTBP8+UWp/yrgBQ/0qeCepE5gyDRpVu7vr7fRAK/BPhKuXZoAz2GcCe
         igOb3ljyivlaCnw8WRs7+QHPBs5xyJTSCJcJ0f54=
Date:   Mon, 28 Feb 2022 10:59:23 -0800
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        tytso@mit.edu, trond.myklebust@hammerspace.com,
        shy828301@gmail.com, shakeelb@google.com, roman.gushchin@linux.dev,
        richard.weiyang@gmail.com, mhocko@kernel.org,
        kari.argillander@gmail.com, jaegeuk@kernel.org, hannes@cmpxchg.org,
        fam.zheng@bytedance.com, duanxiongchun@bytedance.com,
        david@fromorbit.com, chao@kernel.org, Anna.Schumaker@Netapp.com,
        alexs@kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-rename-list_lru_per_memcg-to-list_lru_memcg.patch added to -mm tree
Message-Id: <20220228185924.5AFE6C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: list_lru: rename list_lru_per_memcg to list_lru_memcg
has been added to the -mm tree.  Its filename is
     mm-list_lru-rename-list_lru_per_memcg-to-list_lru_memcg.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-list_lru-rename-list_lru_per_memcg-to-list_lru_memcg.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lru-rename-list_lru_per_memcg-to-list_lru_memcg.patch

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
Subject: mm: list_lru: rename list_lru_per_memcg to list_lru_memcg

The name of list_lru_memcg was occupied before and became free since last
commit.  Rename list_lru_per_memcg to list_lru_memcg since the name is
brief.

Link: https://lkml.kernel.org/r/20220228122126.37293-16-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kari Argillander <kari.argillander@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |    2 +-
 mm/list_lru.c            |   18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-rename-list_lru_per_memcg-to-list_lru_memcg
+++ a/include/linux/list_lru.h
@@ -32,7 +32,7 @@ struct list_lru_one {
 	long			nr_items;
 };
 
-struct list_lru_per_memcg {
+struct list_lru_memcg {
 	struct rcu_head		rcu;
 	/* array of per cgroup per node lists, indexed by node id */
 	struct list_lru_one	node[];
--- a/mm/list_lru.c~mm-list_lru-rename-list_lru_per_memcg-to-list_lru_memcg
+++ a/mm/list_lru.c
@@ -53,7 +53,7 @@ static inline struct list_lru_one *
 list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 {
 	if (list_lru_memcg_aware(lru) && idx >= 0) {
-		struct list_lru_per_memcg *mlru = xa_load(&lru->xa, idx);
+		struct list_lru_memcg *mlru = xa_load(&lru->xa, idx);
 
 		return mlru ? &mlru->node[nid] : NULL;
 	}
@@ -306,7 +306,7 @@ unsigned long list_lru_walk_node(struct
 
 #ifdef CONFIG_MEMCG_KMEM
 	if (*nr_to_walk > 0 && list_lru_memcg_aware(lru)) {
-		struct list_lru_per_memcg *mlru;
+		struct list_lru_memcg *mlru;
 		unsigned long index;
 
 		xa_for_each(&lru->xa, index, mlru) {
@@ -335,10 +335,10 @@ static void init_one_lru(struct list_lru
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static struct list_lru_per_memcg *memcg_init_list_lru_one(gfp_t gfp)
+static struct list_lru_memcg *memcg_init_list_lru_one(gfp_t gfp)
 {
 	int nid;
-	struct list_lru_per_memcg *mlru;
+	struct list_lru_memcg *mlru;
 
 	mlru = kmalloc(struct_size(mlru, node, nr_node_ids), gfp);
 	if (!mlru)
@@ -352,7 +352,7 @@ static struct list_lru_per_memcg *memcg_
 
 static void memcg_list_lru_free(struct list_lru *lru, int src_idx)
 {
-	struct list_lru_per_memcg *mlru = xa_erase_irq(&lru->xa, src_idx);
+	struct list_lru_memcg *mlru = xa_erase_irq(&lru->xa, src_idx);
 
 	/*
 	 * The __list_lru_walk_one() can walk the list of this node.
@@ -374,7 +374,7 @@ static inline void memcg_init_list_lru(s
 static void memcg_destroy_list_lru(struct list_lru *lru)
 {
 	XA_STATE(xas, &lru->xa, 0);
-	struct list_lru_per_memcg *mlru;
+	struct list_lru_memcg *mlru;
 
 	if (!list_lru_memcg_aware(lru))
 		return;
@@ -476,7 +476,7 @@ int memcg_list_lru_alloc(struct mem_cgro
 	unsigned long flags;
 	struct list_lru_memcg *mlrus;
 	struct list_lru_memcg_table {
-		struct list_lru_per_memcg *mlru;
+		struct list_lru_memcg *mlru;
 		struct mem_cgroup *memcg;
 	} *table;
 	XA_STATE(xas, &lru->xa, 0);
@@ -492,7 +492,7 @@ int memcg_list_lru_alloc(struct mem_cgro
 	/*
 	 * Because the list_lru can be reparented to the parent cgroup's
 	 * list_lru, we should make sure that this cgroup and all its
-	 * ancestors have allocated list_lru_per_memcg.
+	 * ancestors have allocated list_lru_memcg.
 	 */
 	for (i = 0; memcg; memcg = parent_mem_cgroup(memcg), i++) {
 		if (memcg_list_lru_allocated(memcg, lru))
@@ -511,7 +511,7 @@ int memcg_list_lru_alloc(struct mem_cgro
 	xas_lock_irqsave(&xas, flags);
 	while (i--) {
 		int index = READ_ONCE(table[i].memcg->kmemcg_id);
-		struct list_lru_per_memcg *mlru = table[i].mlru;
+		struct list_lru_memcg *mlru = table[i].mlru;
 
 		xas_set(&xas, index);
 retry:
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-list_lru-transpose-the-array-of-per-node-per-memcg-lru-lists.patch
mm-introduce-kmem_cache_alloc_lru.patch
fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode.patch
fs-allocate-inode-by-using-alloc_inode_sb.patch
f2fs-allocate-inode-by-using-alloc_inode_sb.patch
nfs42-use-a-specific-kmem_cache-to-allocate-nfs4_xattr_entry.patch
mm-dcache-use-kmem_cache_alloc_lru-to-allocate-dentry.patch
xarray-use-kmem_cache_alloc_lru-to-allocate-xa_node.patch
mm-memcontrol-move-memcg_online_kmem-to-mem_cgroup_css_online.patch
mm-list_lru-allocate-list_lru_one-only-when-needed.patch
mm-list_lru-rename-memcg_drain_all_list_lrus-to-memcg_reparent_list_lrus.patch
mm-list_lru-replace-linear-array-with-xarray.patch
mm-memcontrol-reuse-memory-cgroup-id-for-kmem-id.patch
mm-memcontrol-fix-cannot-alloc-the-maximum-memcg-id.patch
mm-list_lru-rename-list_lru_per_memcg-to-list_lru_memcg.patch
mm-memcontrol-rename-memcg_cache_id-to-memcg_kmem_id.patch
mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch
mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch
mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch
mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch
mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch
mm-userfaultfd-fix-missing-cache-flush-in-mcopy_atomic_pte-and-__mcopy_atomic.patch
mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch

