From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move.patch removed
 from -mm tree
Date: Mon, 15 Aug 2016 13:40:30 -0700
Message-ID: <57b228be.+vlkRF1PmR6L3LfH%akpm__44740.8269545578$1471293653$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbcHOUkb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Aug 2016 16:40:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix memcg id ref counter on swap charge move
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: fix memcg id ref counter on swap charge move

Since commit 73f576c04b941 swap entries do not pin memcg->css.refcnt
directly.  Instead, they pin memcg->id.ref.  So we should adjust the
reference counters accordingly when moving swap charges between cgroups.

Fixes: 73f576c04b941 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
Link: http://lkml.kernel.org/r/9ce297c64954a42dc90b543bc76106c4a94f07e8.1470219853.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[3.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move
+++ a/mm/memcontrol.c
@@ -4077,9 +4077,9 @@ static struct cftype mem_cgroup_legacy_f
 
 static DEFINE_IDR(mem_cgroup_idr);
 
-static void mem_cgroup_id_get(struct mem_cgroup *memcg)
+static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
 {
-	atomic_inc(&memcg->id.ref);
+	atomic_add(n, &memcg->id.ref);
 }
 
 static struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
@@ -4100,9 +4100,9 @@ static struct mem_cgroup *mem_cgroup_id_
 	return memcg;
 }
 
-static void mem_cgroup_id_put(struct mem_cgroup *memcg)
+static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
 {
-	if (atomic_dec_and_test(&memcg->id.ref)) {
+	if (atomic_sub_and_test(n, &memcg->id.ref)) {
 		idr_remove(&mem_cgroup_idr, memcg->id.id);
 		memcg->id.id = 0;
 
@@ -4111,6 +4111,16 @@ static void mem_cgroup_id_put(struct mem
 	}
 }
 
+static inline void mem_cgroup_id_get(struct mem_cgroup *memcg)
+{
+	mem_cgroup_id_get_many(memcg, 1);
+}
+
+static inline void mem_cgroup_id_put(struct mem_cgroup *memcg)
+{
+	mem_cgroup_id_put_many(memcg, 1);
+}
+
 /**
  * mem_cgroup_from_id - look up a memcg from a memcg id
  * @id: the memcg id to look up
@@ -4745,6 +4755,8 @@ static void __mem_cgroup_clear_mc(void)
 		if (!mem_cgroup_is_root(mc.from))
 			page_counter_uncharge(&mc.from->memsw, mc.moved_swap);
 
+		mem_cgroup_id_put_many(mc.from, mc.moved_swap);
+
 		/*
 		 * we charged both to->memory and to->memsw, so we
 		 * should uncharge to->memory.
@@ -4752,9 +4764,9 @@ static void __mem_cgroup_clear_mc(void)
 		if (!mem_cgroup_is_root(mc.to))
 			page_counter_uncharge(&mc.to->memory, mc.moved_swap);
 
-		css_put_many(&mc.from->css, mc.moved_swap);
+		mem_cgroup_id_get_many(mc.to, mc.moved_swap);
+		css_put_many(&mc.to->css, mc.moved_swap);
 
-		/* we've already done css_get(mc.to) */
 		mc.moved_swap = 0;
 	}
 	memcg_oom_recover(from);
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom-deduplicate-victim-selection-code-for-memcg-and-global-oom.patch
mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch

