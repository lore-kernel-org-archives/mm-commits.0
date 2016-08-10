From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move.patch removed
 from -mm tree
Date: Wed, 10 Aug 2016 15:24:18 -0700
Message-ID: <57aba992.9SikV32ZB39YTtxf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933863AbcHJWYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 18:24:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix memcg id ref counter on swap charge move
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: fix memcg id ref counter on swap charge move

Since commit 73f576c04b941 swap entries do not pin memcg->css.refcnt
directly. Instead, they pin memcg->id.ref. So we should adjust the
reference counters accordingly when moving swap charges between cgroups.

Fixes: 73f576c04b941 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
Link: http://lkml.kernel.org/r/3119b9b4526b18e6afcf55d3b4220437d642b00d.1470057819.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
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
 
 static struct mem_cgroup *mem_cgroup_id_get_active(struct mem_cgroup *memcg)
@@ -4089,9 +4089,9 @@ static struct mem_cgroup *mem_cgroup_id_
 	return memcg;
 }
 
-static void mem_cgroup_id_put(struct mem_cgroup *memcg)
+static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
 {
-	if (atomic_dec_and_test(&memcg->id.ref)) {
+	if (atomic_sub_and_test(n, &memcg->id.ref)) {
 		idr_remove(&mem_cgroup_idr, memcg->id.id);
 		memcg->id.id = 0;
 
@@ -4100,6 +4100,16 @@ static void mem_cgroup_id_put(struct mem
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
@@ -4734,6 +4744,8 @@ static void __mem_cgroup_clear_mc(void)
 		if (!mem_cgroup_is_root(mc.from))
 			page_counter_uncharge(&mc.from->memsw, mc.moved_swap);
 
+		mem_cgroup_id_put_many(mc.from, mc.moved_swap);
+
 		/*
 		 * we charged both to->memory and to->memsw, so we
 		 * should uncharge to->memory.
@@ -4741,9 +4753,9 @@ static void __mem_cgroup_clear_mc(void)
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

mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch
mm-oom-deduplicate-victim-selection-code-for-memcg-and-global-oom.patch

