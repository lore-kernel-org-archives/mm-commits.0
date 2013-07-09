From: akpm@linux-foundation.org
Subject: [merged]
 memcg-kmem-fix-reference-count-handling-on-the-error-path.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:20:35 -0700
Message-ID: <51dc9ac3.4FLIiYV5of7XO3SK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3GIXUg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org, lizefan@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, glommer@openvz.org, mhocko@suse.cz

Subject: [merged] memcg-kmem-fix-reference-count-handling-on-the-error-path.patch removed from -mm tree
To: mhocko@suse.cz,glommer@openvz.org,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,lizefan@huawei.com,stable@vger.kernel.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:35 -0700


The patch titled
     Subject: memcg, kmem: fix reference count handling on the error path
has been removed from the -mm tree.  Its filename was
     memcg-kmem-fix-reference-count-handling-on-the-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg, kmem: fix reference count handling on the error path

mem_cgroup_css_online calls mem_cgroup_put if memcg_init_kmem fails.  This
is not correct because only memcg_propagate_kmem takes an additional
reference while mem_cgroup_sockets_init is allowed to fail as well
(although no current implementation fails) but it doesn't take any
reference.  This all suggests that it should be memcg_propagate_kmem that
should clean up after itself so this patch moves mem_cgroup_put over
there.

Unfortunately this is not that easy (as pointed out by Li Zefan) because
memcg_kmem_mark_dead marks the group dead (KMEM_ACCOUNTED_DEAD) if it is
marked active (KMEM_ACCOUNTED_ACTIVE) which is the case even if
memcg_propagate_kmem fails so the additional reference is dropped in that
case in kmem_cgroup_destroy which means that the reference would be
dropped two times.

The easiest way then would be to simply remove mem_cgrroup_put from
mem_cgroup_css_online and rely on kmem_cgroup_destroy doing the right
thing.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[3.8]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-kmem-fix-reference-count-handling-on-the-error-path mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-kmem-fix-reference-count-handling-on-the-error-path
+++ a/mm/memcontrol.c
@@ -6345,14 +6345,6 @@ mem_cgroup_css_online(struct cgroup *con
 
 	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
 	mutex_unlock(&memcg_create_mutex);
-	if (error) {
-		/*
-		 * We call put now because our (and parent's) refcnts
-		 * are already in place. mem_cgroup_put() will internally
-		 * call __mem_cgroup_free, so return directly
-		 */
-		mem_cgroup_put(memcg);
-	}
 	return error;
 }
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
drop_caches-add-some-documentation-and-info-messsge.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch
staging-lustre-replace-num_physpages-with-totalram_pages.patch

