From: akpm@linux-foundation.org
Subject: + memcg-kill-memcg-refcnt.patch added to -mm tree
Date: Fri, 28 Jun 2013 16:00:33 -0700
Message-ID: <51ce1591.6N/eyiKzOnQNSidk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3F1XAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jun 2013 19:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, glommer@openvz.org, lizefan@huawei.com

Subject: + memcg-kill-memcg-refcnt.patch added to -mm tree
To: lizefan@huawei.com,glommer@openvz.org,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 28 Jun 2013 16:00:33 -0700


The patch titled
     Subject: memcg: kill memcg refcnt
has been added to the -mm tree.  Its filename is
     memcg-kill-memcg-refcnt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: memcg: kill memcg refcnt

Now memcg has the same life cycle as its corresponding cgroup.
Kill the useless refcnt.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcg-kill-memcg-refcnt mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-kill-memcg-refcnt
+++ a/mm/memcontrol.c
@@ -299,8 +299,6 @@ struct mem_cgroup {
 	bool		oom_lock;
 	atomic_t	under_oom;
 
-	atomic_t	refcnt;
-
 	int	swappiness;
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
@@ -503,8 +501,6 @@ enum res_type {
  */
 static DEFINE_MUTEX(memcg_create_mutex);
 
-static void mem_cgroup_put(struct mem_cgroup *memcg);
-
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *s)
 {
@@ -6229,17 +6225,6 @@ static void free_rcu(struct rcu_head *rc
 	schedule_work(&memcg->work_freeing);
 }
 
-static void __mem_cgroup_put(struct mem_cgroup *memcg, int count)
-{
-	if (atomic_sub_and_test(count, &memcg->refcnt))
-		call_rcu(&memcg->rcu_freeing, free_rcu);
-}
-
-static void mem_cgroup_put(struct mem_cgroup *memcg)
-{
-	__mem_cgroup_put(memcg, 1);
-}
-
 /*
  * Returns the parent mem_cgroup in memcgroup hierarchy with hierarchy enabled.
  */
@@ -6299,7 +6284,6 @@ mem_cgroup_css_alloc(struct cgroup *cont
 
 	memcg->last_scanned_node = MAX_NUMNODES;
 	INIT_LIST_HEAD(&memcg->oom_notify);
-	atomic_set(&memcg->refcnt, 1);
 	memcg->move_charge_at_immigrate = 0;
 	mutex_init(&memcg->thresholds_lock);
 	spin_lock_init(&memcg->move_lock);
@@ -6391,7 +6375,7 @@ static void mem_cgroup_css_free(struct c
 
 	mem_cgroup_sockets_destroy(memcg);
 
-	mem_cgroup_put(memcg);
+	call_rcu(&memcg->rcu_freeing, free_rcu);
 }
 
 #ifdef CONFIG_MMU
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
linux-next.patch
memcg-update-todo-list-in-documentation.patch
revert-memcg-avoid-dangling-reference-count-in-creation-failure.patch
memcg-kmem-fix-reference-count-handling-on-the-error-path.patch
memcg-use-css_get-in-sock_update_memcg.patch
memcg-dont-use-mem_cgroup_get-when-creating-a-kmemcg-cache.patch
memcg-use-css_get-put-when-charging-uncharging-kmem.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix.patch
memcg-use-css_get-put-for-swap-memcg.patch
memcg-dont-need-to-get-a-reference-to-the-parent.patch
memcg-kill-memcg-refcnt.patch
memcg-dont-need-to-free-memcg-via-rcu-or-workqueue.patch

