From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 072/155] memcg: css_tryget_online cleanups
Date: Wed, 01 Apr 2020 21:07:10 -0700
Message-ID: <20200402040710.sXUFpqbRO%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEHM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:07:12 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: css_tryget_online cleanups

Currently multiple locations in memcg code, css_tryget_online() is being
used. However it doesn't matter whether the cgroup is online for the
callers. Online used to matter when we had reparenting on offlining and
we needed a way to prevent new ones from showing up.

The failure case for couple of these css_tryget_online usage is to
fallback to root_mem_cgroup which kind of make bypassing the memcg
limits possible for some workloads. For example creating an inotify
group in a subcontainer and then deleting that container after moving the
process to a different container will make all the event objects
allocated for that group to the root_mem_cgroup. So, using
css_tryget_online() is dangerous for such cases.

Two locations still use the online version. The swapin of offlined
memcg's pages and the memcg kmem cache creation. The kmem cache indeed
needs the online version as the kernel does the reparenting of memcg
kmem caches. For the swapin case, it has been left for later as the
fallback is not really that concerning.

With swap accounting enabled, if the memcg of the swapped out page is
not online then the memcg extracted from the given 'mm' will be charged
and if 'mm' is NULL then root memcg will be charged.  However I could
not find a code path where the given 'mm' will be NULL for swap-in
case.

Link: http://lkml.kernel.org/r/20200302203109.179417-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~memcg-css_tryget_online-cleanups
+++ a/mm/memcontrol.c
@@ -656,7 +656,7 @@ retry:
 	 */
 	__mem_cgroup_remove_exceeded(mz, mctz);
 	if (!soft_limit_excess(mz->memcg) ||
-	    !css_tryget_online(&mz->memcg->css))
+	    !css_tryget(&mz->memcg->css))
 		goto retry;
 done:
 	return mz;
@@ -972,7 +972,8 @@ struct mem_cgroup *get_mem_cgroup_from_p
 		return NULL;
 
 	rcu_read_lock();
-	if (!memcg || !css_tryget_online(&memcg->css))
+	/* Page should not get uncharged and freed memcg under us. */
+	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
 		memcg = root_mem_cgroup;
 	rcu_read_unlock();
 	return memcg;
@@ -985,10 +986,13 @@ EXPORT_SYMBOL(get_mem_cgroup_from_page);
 static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
 {
 	if (unlikely(current->active_memcg)) {
-		struct mem_cgroup *memcg = root_mem_cgroup;
+		struct mem_cgroup *memcg;
 
 		rcu_read_lock();
-		if (css_tryget_online(&current->active_memcg->css))
+		/* current->active_memcg must hold a ref. */
+		if (WARN_ON_ONCE(!css_tryget(&current->active_memcg->css)))
+			memcg = root_mem_cgroup;
+		else
 			memcg = current->active_memcg;
 		rcu_read_unlock();
 		return memcg;
@@ -6789,7 +6793,7 @@ void mem_cgroup_sk_alloc(struct sock *sk
 		goto out;
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcpmem_active)
 		goto out;
-	if (css_tryget_online(&memcg->css))
+	if (css_tryget(&memcg->css))
 		sk->sk_memcg = memcg;
 out:
 	rcu_read_unlock();
_
