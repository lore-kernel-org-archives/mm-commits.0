From: akpm@linux-foundation.org
Subject: [merged] memcg-zap-kmem_account_flags.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:07:09 -0800
Message-ID: <548d0ced.6cOY7L1QNJat0Opq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaLNEHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: zap kmem_account_flags
has been removed from the -mm tree.  Its filename was
     memcg-zap-kmem_account_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: zap kmem_account_flags

The only such flag is KMEM_ACCOUNTED_ACTIVE, but it's set iff
mem_cgroup->kmemcg_id is initialized, so we can check kmemcg_id instead of
having a separate flags field.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff -puN mm/memcontrol.c~memcg-zap-kmem_account_flags mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-zap-kmem_account_flags
+++ a/mm/memcontrol.c
@@ -296,7 +296,6 @@ struct mem_cgroup {
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
 	bool use_hierarchy;
-	unsigned long kmem_account_flags; /* See KMEM_ACCOUNTED_*, below */
 
 	bool		oom_lock;
 	atomic_t	under_oom;
@@ -366,22 +365,11 @@ struct mem_cgroup {
 	/* WARNING: nodeinfo must be the last member here */
 };
 
-/* internal only representation about the status of kmem accounting. */
-enum {
-	KMEM_ACCOUNTED_ACTIVE, /* accounted by this cgroup itself */
-};
-
 #ifdef CONFIG_MEMCG_KMEM
-static inline void memcg_kmem_set_active(struct mem_cgroup *memcg)
-{
-	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
-}
-
 static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 {
-	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
+	return memcg->kmemcg_id >= 0;
 }
-
 #endif
 
 /* Stuffs for move charges at task migration. */
@@ -3564,23 +3552,21 @@ static int memcg_activate_kmem(struct me
 		goto out;
 	}
 
-	memcg->kmemcg_id = memcg_id;
-	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
-
 	/*
-	 * We couldn't have accounted to this cgroup, because it hasn't got the
-	 * active bit set yet, so this should succeed.
+	 * We couldn't have accounted to this cgroup, because it hasn't got
+	 * activated yet, so this should succeed.
 	 */
 	err = page_counter_limit(&memcg->kmem, nr_pages);
 	VM_BUG_ON(err);
 
 	static_key_slow_inc(&memcg_kmem_enabled_key);
 	/*
-	 * Setting the active bit after enabling static branching will
+	 * A memory cgroup is considered kmem-active as soon as it gets
+	 * kmemcg_id. Setting the id after enabling static branching will
 	 * guarantee no one starts accounting before all call sites are
 	 * patched.
 	 */
-	memcg_kmem_set_active(memcg);
+	memcg->kmemcg_id = memcg_id;
 out:
 	return err;
 }
@@ -4252,7 +4238,6 @@ static int memcg_init_kmem(struct mem_cg
 {
 	int ret;
 
-	memcg->kmemcg_id = -1;
 	ret = memcg_propagate_kmem(memcg);
 	if (ret)
 		return ret;
@@ -4786,6 +4771,10 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->event_list);
 	spin_lock_init(&memcg->event_list_lock);
+#ifdef CONFIG_MEMCG_KMEM
+	memcg->kmemcg_id = -1;
+	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
+#endif
 
 	return &memcg->css;
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

