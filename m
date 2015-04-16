From: akpm@linux-foundation.org
Subject: [merged] memcg-zap-mem_cgroup_lookup.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:51:17 -0700
Message-ID: <552fe885.YxOxbx+Fq3ZoXV07%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbbDPQps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: zap mem_cgroup_lookup()
has been removed from the -mm tree.  Its filename was
     memcg-zap-mem_cgroup_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: zap mem_cgroup_lookup()

mem_cgroup_lookup() is a wrapper around mem_cgroup_from_id(), which checks
that id != 0 before issuing the function call.  Today, there is no point
in this additional check apart from optimization, because there is no css
with id <= 0, so that css_from_id, called by mem_cgroup_from_id, will
return NULL for any id <= 0.

Since mem_cgroup_from_id is only called from mem_cgroup_lookup, let us zap
mem_cgroup_lookup, substituting calls to it with mem_cgroup_from_id and
moving the check if id > 0 to css_from_id.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 mm/memcontrol.c |   24 ++++++++----------------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff -puN kernel/cgroup.c~memcg-zap-mem_cgroup_lookup kernel/cgroup.c
--- a/kernel/cgroup.c~memcg-zap-mem_cgroup_lookup
+++ a/kernel/cgroup.c
@@ -5451,7 +5451,7 @@ struct cgroup_subsys_state *css_tryget_o
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return idr_find(&ss->css_idr, id);
+	return id > 0 ? idr_find(&ss->css_idr, id) : NULL;
 }
 
 #ifdef CONFIG_CGROUP_DEBUG
diff -puN mm/memcontrol.c~memcg-zap-mem_cgroup_lookup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-zap-mem_cgroup_lookup
+++ a/mm/memcontrol.c
@@ -460,6 +460,12 @@ static inline unsigned short mem_cgroup_
 	return memcg->css.id;
 }
 
+/*
+ * A helper function to get mem_cgroup from ID. must be called under
+ * rcu_read_lock().  The caller is responsible for calling
+ * css_tryget_online() if the mem_cgroup is used for charging. (dropping
+ * refcnt from swap can be called against removed memcg.)
+ */
 static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 {
 	struct cgroup_subsys_state *css;
@@ -2349,20 +2355,6 @@ static void cancel_charge(struct mem_cgr
 }
 
 /*
- * A helper function to get mem_cgroup from ID. must be called under
- * rcu_read_lock().  The caller is responsible for calling
- * css_tryget_online() if the mem_cgroup is used for charging. (dropping
- * refcnt from swap can be called against removed memcg.)
- */
-static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
-{
-	/* ID 0 is unused ID */
-	if (!id)
-		return NULL;
-	return mem_cgroup_from_id(id);
-}
-
-/*
  * try_get_mem_cgroup_from_page - look up page's memcg association
  * @page: the page
  *
@@ -2388,7 +2380,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 		ent.val = page_private(page);
 		id = lookup_swap_cgroup_id(ent);
 		rcu_read_lock();
-		memcg = mem_cgroup_lookup(id);
+		memcg = mem_cgroup_from_id(id);
 		if (memcg && !css_tryget_online(&memcg->css))
 			memcg = NULL;
 		rcu_read_unlock();
@@ -5869,7 +5861,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
 
 	id = swap_cgroup_record(entry, 0);
 	rcu_read_lock();
-	memcg = mem_cgroup_lookup(id);
+	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
 		if (!mem_cgroup_is_root(memcg))
 			page_counter_uncharge(&memcg->memsw, 1);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
signal-remove-warning-about-using-si_tkill-in-rt_sigqueueinfo.patch
linux-next.patch

