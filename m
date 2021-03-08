Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC90C4332D
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9C55652B6
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhCHXI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:08:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231254AbhCHXIT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 18:08:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 061DC6529C;
        Mon,  8 Mar 2021 23:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615244899;
        bh=C6c8DVtVr+Z4aVD9bEQ/svtToPlLE+SMVOkSN35vqjk=;
        h=Date:From:To:Subject:From;
        b=r+16nM64mSYmNF9pdZjtdmEQtKg/Qnen+Sp6ZaXIDpxudLeLiG0OjooZ+MTplLm0Q
         LZB03lNH+hJ4GOrKu3OvXkLJeZbG3TRPrDn3EthVeHC5bT7wIU6vMd7606cprZpKTn
         cD4EMx/eYXpbkFgG6bCqDOzVTDEGZf3tiFxkWVak=
Date:   Mon, 08 Mar 2021 15:08:18 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org
Subject:  + mm-memcontrol-kill-mem_cgroup_nodeinfo.patch added to
 -mm tree
Message-ID: <20210308230818.76PeUNv-h%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: kill mem_cgroup_nodeinfo()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-kill-mem_cgroup_nodeinfo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-kill-mem_cgroup=
_nodeinfo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-kill-mem_cgroup=
_nodeinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: kill mem_cgroup_nodeinfo()

No need to encapsulate a simple struct member access.

Link: https://lkml.kernel.org/r/20210209163304.77088-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 +-------
 mm/memcontrol.c            |   21 +++++++++++----------
 2 files changed, 12 insertions(+), 17 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-kill-mem_cgroup_nodeinfo
+++ a/include/linux/memcontrol.h
@@ -605,12 +605,6 @@ void mem_cgroup_uncharge_list(struct lis
=20
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
=20
-static struct mem_cgroup_per_node *
-mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
-{
-	return memcg->nodeinfo[nid];
-}
-
 /**
  * mem_cgroup_lruvec - get the lru list vector for a memcg & node
  * @memcg: memcg of the wanted lruvec
@@ -634,7 +628,7 @@ static inline struct lruvec *mem_cgroup_
 	if (!memcg)
 		memcg =3D root_mem_cgroup;
=20
-	mz =3D mem_cgroup_nodeinfo(memcg, pgdat->node_id);
+	mz =3D memcg->nodeinfo[pgdat->node_id];
 	lruvec =3D &mz->lruvec;
 out:
 	/*
--- a/mm/memcontrol.c~mm-memcontrol-kill-mem_cgroup_nodeinfo
+++ a/mm/memcontrol.c
@@ -414,13 +414,14 @@ static int memcg_expand_one_shrinker_map
 					 int size, int old_size)
 {
 	struct memcg_shrinker_map *new, *old;
+	struct mem_cgroup_per_node *pn;
 	int nid;
=20
 	lockdep_assert_held(&memcg_shrinker_map_mutex);
=20
 	for_each_node(nid) {
-		old =3D rcu_dereference_protected(
-			mem_cgroup_nodeinfo(memcg, nid)->shrinker_map, true);
+		pn =3D memcg->nodeinfo[nid];
+		old =3D rcu_dereference_protected(pn->shrinker_map, true);
 		/* Not yet online memcg */
 		if (!old)
 			return 0;
@@ -433,7 +434,7 @@ static int memcg_expand_one_shrinker_map
 		memset(new->map, (int)0xff, old_size);
 		memset((void *)new->map + old_size, 0, size - old_size);
=20
-		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_map, new);
+		rcu_assign_pointer(pn->shrinker_map, new);
 		call_rcu(&old->rcu, memcg_free_shrinker_map_rcu);
 	}
=20
@@ -450,7 +451,7 @@ static void memcg_free_shrinker_maps(str
 		return;
=20
 	for_each_node(nid) {
-		pn =3D mem_cgroup_nodeinfo(memcg, nid);
+		pn =3D memcg->nodeinfo[nid];
 		map =3D rcu_dereference_protected(pn->shrinker_map, true);
 		kvfree(map);
 		rcu_assign_pointer(pn->shrinker_map, NULL);
@@ -713,7 +714,7 @@ static void mem_cgroup_remove_from_trees
 	int nid;
=20
 	for_each_node(nid) {
-		mz =3D mem_cgroup_nodeinfo(memcg, nid);
+		mz =3D memcg->nodeinfo[nid];
 		mctz =3D soft_limit_tree_node(nid);
 		if (mctz)
 			mem_cgroup_remove_exceeded(mz, mctz);
@@ -796,7 +797,7 @@ parent_nodeinfo(struct mem_cgroup_per_no
 	parent =3D parent_mem_cgroup(pn->memcg);
 	if (!parent)
 		return NULL;
-	return mem_cgroup_nodeinfo(parent, nid);
+	return parent->nodeinfo[nid];
 }
=20
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item i=
dx,
@@ -1136,7 +1137,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	if (reclaim) {
 		struct mem_cgroup_per_node *mz;
=20
-		mz =3D mem_cgroup_nodeinfo(root, reclaim->pgdat->node_id);
+		mz =3D root->nodeinfo[reclaim->pgdat->node_id];
 		iter =3D &mz->iter;
=20
 		if (prev && reclaim->generation !=3D iter->generation)
@@ -1238,7 +1239,7 @@ static void __invalidate_reclaim_iterato
 	int nid;
=20
 	for_each_node(nid) {
-		mz =3D mem_cgroup_nodeinfo(from, nid);
+		mz =3D from->nodeinfo[nid];
 		iter =3D &mz->iter;
 		cmpxchg(&iter->position, dead_memcg, NULL);
 	}
@@ -2397,7 +2398,7 @@ static int memcg_hotplug_cpu_dead(unsign
 				struct mem_cgroup_per_node *pn;
 				long x;
=20
-				pn =3D mem_cgroup_nodeinfo(memcg, nid);
+				pn =3D memcg->nodeinfo[nid];
 				lstatc =3D per_cpu_ptr(pn->lruvec_stat_cpu, cpu);
=20
 				x =3D lstatc->count[i];
@@ -4098,7 +4099,7 @@ static int memcg_stat_show(struct seq_fi
 		unsigned long file_cost =3D 0;
=20
 		for_each_online_pgdat(pgdat) {
-			mz =3D mem_cgroup_nodeinfo(memcg, pgdat->node_id);
+			mz =3D memcg->nodeinfo[pgdat->node_id];
=20
 			anon_cost +=3D mz->lruvec.anon_cost;
 			file_cost +=3D mz->lruvec.file_cost;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback.patch
mm-memcontrol-fix-cpuhotplug-statistics-flushing.patch
mm-memcontrol-kill-mem_cgroup_nodeinfo.patch
mm-memcontrol-privatize-memcg_page_state-query-functions.patch
cgroup-rstat-support-cgroup1.patch
cgroup-rstat-punt-root-level-optimization-to-individual-controllers.patch
mm-memcontrol-switch-to-rstat.patch
mm-memcontrol-consolidate-lruvec-stat-flushing.patch
kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch

