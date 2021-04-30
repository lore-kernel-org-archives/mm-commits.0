Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E9CC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC7D361463
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhD3F5S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230119AbhD3F5S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5002C6147D;
        Fri, 30 Apr 2021 05:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762190;
        bh=7TC2nv8BwKJppIC2NTpCUlnHgpjYWdmx7vsLPAPGkK4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Neh4DUg1ccSYgL7lQ2NX9bWuQotHyLm7ddUgl2PCl1ksoZ7qk0gQO99sKpMLv3LN/
         SFaMIRZ2jles7awoHS79p7n34ODj5iDpWSuOAwWujP3q/Bvr8x2O4LwwsLAgPE3sEx
         4H5/4XP+StvR6Oq+LiUkwtdmrcOaG82GWm+ZhT3s=
Date:   Thu, 29 Apr 2021 22:56:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 065/178] mm: memcontrol: consolidate lruvec stat
 flushing
Message-ID: <20210430055629.-hrHiisdN%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: consolidate lruvec stat flushing

There are two functions to flush the per-cpu data of an lruvec into the
rest of the cgroup tree: when the cgroup is being freed, and when a CPU
disappears during hotplug.  The difference is whether all CPUs or just one
is being collected, but the rest of the flushing code is the same.  Merge
them into one function and share the common code.

Link: https://lkml.kernel.org/r/20210209163304.77088-8-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   76 +++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 47 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-consolidate-lruvec-stat-flushing
+++ a/mm/memcontrol.c
@@ -2364,6 +2364,29 @@ static void drain_all_stock(struct mem_c
 	mutex_unlock(&percpu_charge_mutex);
 }
=20
+static void memcg_flush_lruvec_page_state(struct mem_cgroup *memcg, int cp=
u)
+{
+	int nid;
+
+	for_each_node(nid) {
+		struct mem_cgroup_per_node *pn =3D memcg->nodeinfo[nid];
+		unsigned long stat[NR_VM_NODE_STAT_ITEMS];
+		struct batched_lruvec_stat *lstatc;
+		int i;
+
+		lstatc =3D per_cpu_ptr(pn->lruvec_stat_cpu, cpu);
+		for (i =3D 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+			stat[i] =3D lstatc->count[i];
+			lstatc->count[i] =3D 0;
+		}
+
+		do {
+			for (i =3D 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+				atomic_long_add(stat[i], &pn->lruvec_stat[i]);
+		} while ((pn =3D parent_nodeinfo(pn, nid)));
+	}
+}
+
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
 	struct memcg_stock_pcp *stock;
@@ -2372,31 +2395,8 @@ static int memcg_hotplug_cpu_dead(unsign
 	stock =3D &per_cpu(memcg_stock, cpu);
 	drain_stock(stock);
=20
-	for_each_mem_cgroup(memcg) {
-		int i;
-
-		for (i =3D 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
-			int nid;
-
-			for_each_node(nid) {
-				struct batched_lruvec_stat *lstatc;
-				struct mem_cgroup_per_node *pn;
-				long x;
-
-				pn =3D memcg->nodeinfo[nid];
-				lstatc =3D per_cpu_ptr(pn->lruvec_stat_cpu, cpu);
-
-				x =3D lstatc->count[i];
-				lstatc->count[i] =3D 0;
-
-				if (x) {
-					do {
-						atomic_long_add(x, &pn->lruvec_stat[i]);
-					} while ((pn =3D parent_nodeinfo(pn, nid)));
-				}
-			}
-		}
-	}
+	for_each_mem_cgroup(memcg)
+		memcg_flush_lruvec_page_state(memcg, cpu);
=20
 	return 0;
 }
@@ -3583,27 +3583,6 @@ static u64 mem_cgroup_read_u64(struct cg
 	}
 }
=20
-static void memcg_flush_lruvec_page_state(struct mem_cgroup *memcg)
-{
-	int node;
-
-	for_each_node(node) {
-		struct mem_cgroup_per_node *pn =3D memcg->nodeinfo[node];
-		unsigned long stat[NR_VM_NODE_STAT_ITEMS] =3D { 0 };
-		struct mem_cgroup_per_node *pi;
-		int cpu, i;
-
-		for_each_online_cpu(cpu)
-			for (i =3D 0; i < NR_VM_NODE_STAT_ITEMS; i++)
-				stat[i] +=3D per_cpu(
-					pn->lruvec_stat_cpu->count[i], cpu);
-
-		for (pi =3D pn; pi; pi =3D parent_nodeinfo(pi, node))
-			for (i =3D 0; i < NR_VM_NODE_STAT_ITEMS; i++)
-				atomic_long_add(stat[i], &pi->lruvec_stat[i]);
-	}
-}
-
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
@@ -5139,12 +5118,15 @@ static void __mem_cgroup_free(struct mem
=20
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
+	int cpu;
+
 	memcg_wb_domain_exit(memcg);
 	/*
 	 * Flush percpu lruvec stats to guarantee the value
 	 * correctness on parent's and all ancestor levels.
 	 */
-	memcg_flush_lruvec_page_state(memcg);
+	for_each_online_cpu(cpu)
+		memcg_flush_lruvec_page_state(memcg, cpu);
 	__mem_cgroup_free(memcg);
 }
=20
_
