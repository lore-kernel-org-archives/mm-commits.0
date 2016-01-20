From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
 removed from -mm tree
Date: Wed, 20 Jan 2016 14:42:13 -0800
Message-ID: <56a00d45.2Vi5yGZDfZObX0TQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbcATWmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:42:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: clean up alloc, online, offline, free functions fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch

This patch was dropped because it was folded into mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: clean up alloc, online, offline, free functions fix

Fixlets based on review feedback from Vladimir:

1. The memcg_create_mutex is to stabilize a cgroup's hereditary
   settings that are not allowed to change once the cgroup has
   children: kmem accounting and hierarchy mode. However, the cleanup
   patch moves inheritance of these settings from onlining time to
   allocation time, before the new child will show up in the parent's
   list of children, and this opens a race window where the parent can
   change a setting that has been passed on to a new child already.

   That being said, this rule for kmem and hierarchy mode is somewhat
   gratuitous: there is no strong reason why these configurations
   shouldn't exist, and the outcome of a race is not harmful. It's
   also unlikely that somebody will even trigger this race because we
   don't expect anybody to flip-flop either settings while creating
   child groups. So instead of readding complexity to close an
   unlikely race window that doesn't do any harm, simply remove the
   now pointless mutex as a follow-up cleanup.

2. Kmem initialization consists of several steps that are undone in
   both css_offline() and css_free(). However, if css allocation fails
   later on then css_offline() is never called and we don't properly
   free the kmem state. Let css_free() detect this and call kmem
   offlining itself.

3. Children in !use_hierarchy mode would inherit the OOM killer
   setting from their physical parent rather than the logical parent,
   rootmemcg.  This is silly, but no reason to change the semantics as
   part of this cleanup patch, so restore it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix
+++ a/mm/memcontrol.c
@@ -250,13 +250,6 @@ enum res_type {
 /* Used for OOM nofiier */
 #define OOM_CONTROL		(0)
 
-/*
- * The memcg_create_mutex will be held whenever a new cgroup is created.
- * As a consequence, any change that needs to protect against new child cgroups
- * appearing has to hold it as well.
- */
-static DEFINE_MUTEX(memcg_create_mutex);
-
 /* Some nice accessors for the vmpressure. */
 struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg)
 {
@@ -2681,14 +2674,6 @@ static inline bool memcg_has_children(st
 {
 	bool ret;
 
-	/*
-	 * The lock does not prevent addition or deletion of children, but
-	 * it prevents a new child from being initialized based on this
-	 * parent in css_online(), so it's enough to decide whether
-	 * hierarchically inherited attributes can still be changed or not.
-	 */
-	lockdep_assert_held(&memcg_create_mutex);
-
 	rcu_read_lock();
 	ret = css_next_child(NULL, &memcg->css);
 	rcu_read_unlock();
@@ -2751,10 +2736,8 @@ static int mem_cgroup_hierarchy_write(st
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup *parent_memcg = mem_cgroup_from_css(memcg->css.parent);
 
-	mutex_lock(&memcg_create_mutex);
-
 	if (memcg->use_hierarchy == val)
-		goto out;
+		return 0;
 
 	/*
 	 * If parent's use_hierarchy is set, we can't make any modifications
@@ -2773,9 +2756,6 @@ static int mem_cgroup_hierarchy_write(st
 	} else
 		retval = -EINVAL;
 
-out:
-	mutex_unlock(&memcg_create_mutex);
-
 	return retval;
 }
 
@@ -2950,6 +2930,10 @@ static void memcg_offline_kmem(struct me
 
 static void memcg_free_kmem(struct mem_cgroup *memcg)
 {
+	/* css_alloc() failed, offlining didn't happen */
+	if (unlikely(memcg->kmem_state == KMEM_ONLINE))
+		memcg_offline_kmem(memcg);
+
 	if (memcg->kmem_state == KMEM_ALLOCATED) {
 		memcg_destroy_kmem_caches(memcg);
 		static_branch_dec(&memcg_kmem_enabled_key);
@@ -2977,11 +2961,9 @@ static int memcg_update_kmem_limit(struc
 	mutex_lock(&memcg_limit_mutex);
 	/* Top-level cgroup doesn't propagate from root */
 	if (!memcg_kmem_online(memcg)) {
-		mutex_lock(&memcg_create_mutex);
 		if (cgroup_is_populated(memcg->css.cgroup) ||
 		    (memcg->use_hierarchy && memcg_has_children(memcg)))
 			ret = -EBUSY;
-		mutex_unlock(&memcg_create_mutex);
 		if (ret)
 			goto out;
 		ret = memcg_online_kmem(memcg);
@@ -4206,14 +4188,14 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	if (!memcg)
 		return ERR_PTR(error);
 
-	mutex_lock(&memcg_create_mutex);
 	memcg->high = PAGE_COUNTER_MAX;
 	memcg->soft_limit = PAGE_COUNTER_MAX;
-	if (parent)
+	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
+		memcg->oom_kill_disable = parent->oom_kill_disable;
+	}
 	if (parent && parent->use_hierarchy) {
 		memcg->use_hierarchy = true;
-		memcg->oom_kill_disable = parent->oom_kill_disable;
 		page_counter_init(&memcg->memory, &parent->memory);
 		page_counter_init(&memcg->memsw, &parent->memsw);
 		page_counter_init(&memcg->kmem, &parent->kmem);
@@ -4231,7 +4213,6 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		if (parent != root_mem_cgroup)
 			memory_cgrp_subsys.broken_hierarchy = true;
 	}
-	mutex_unlock(&memcg_create_mutex);
 
 	/* The following stuff does not apply to the root */
 	if (!parent) {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

