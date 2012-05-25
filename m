From: akpm@linux-foundation.org
Subject: + memcg-decrement-static-keys-at-real-destroy-time-v7.patch added to -mm tree
Date: Fri, 25 May 2012 12:57:19 -0700
Message-ID: <20120525195719.BB616A021B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55583 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab2EYT5V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 15:57:21 -0400
Received: by qabg24 with SMTP id g24so200304qab.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 12:57:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, davem@davemloft.net, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, mhocko@suse.cz, tj@kernel.org


The patch titled
     Subject: memcg-decrement-static-keys-at-real-destroy-time-v7
has been added to the -mm tree.  Its filename is
     memcg-decrement-static-keys-at-real-destroy-time-v7.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: memcg-decrement-static-keys-at-real-destroy-time-v7

[v7: merged more comments from akpm ]

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/sock.h        |    2 +-
 mm/memcontrol.c           |   24 +++++++++++++-----------
 net/ipv4/tcp_memcontrol.c |    6 +++---
 3 files changed, 17 insertions(+), 15 deletions(-)

diff -puN include/net/sock.h~memcg-decrement-static-keys-at-real-destroy-time-v7 include/net/sock.h
--- a/include/net/sock.h~memcg-decrement-static-keys-at-real-destroy-time-v7
+++ a/include/net/sock.h
@@ -925,7 +925,7 @@ struct proto {
 /*
  * Bits in struct cg_proto.flags
  */
-enum sock_flag_bits {
+enum cg_proto_flags {
 	/* Currently active and new sockets should be assigned to cgroups */
 	MEMCG_SOCK_ACTIVE,
 	/* It was ever activated; we must disarm static keys on destruction */
diff -puN mm/memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time-v7 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time-v7
+++ a/mm/memcontrol.c
@@ -485,7 +485,10 @@ struct cg_proto *tcp_proto_cgroup(struct
 	return &memcg->tcp_mem.cg_proto;
 }
 EXPORT_SYMBOL(tcp_proto_cgroup);
+#endif /* CONFIG_INET */
+#endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
 
+#if defined(CONFIG_INET) && defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM)
 static void disarm_sock_keys(struct mem_cgroup *memcg)
 {
 	if (!memcg_proto_activated(&memcg->tcp_mem.cg_proto))
@@ -496,13 +499,7 @@ static void disarm_sock_keys(struct mem_
 static void disarm_sock_keys(struct mem_cgroup *memcg)
 {
 }
-#endif /* CONFIG_INET */
-#endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
-
-static void disarm_static_keys(struct mem_cgroup *memcg)
-{
-	disarm_sock_keys(memcg);
-}
+#endif
 
 static void drain_all_stock_async(struct mem_cgroup *memcg);
 
@@ -4946,11 +4943,16 @@ static void free_work(struct work_struct
 	memcg = container_of(work, struct mem_cgroup, work_freeing);
 	/*
 	 * We need to make sure that (at least for now), the jump label
-	 * destruction code runs outside of the cgroup lock. schedule_work()
-	 * will guarantee this happens. Be careful if you need to move this
-	 * disarm_static_keys around
+	 * destruction code runs outside of the cgroup lock. This is because
+	 * get_online_cpus(), which is called from the static_branch update,
+	 * can't be called inside the cgroup_lock. cpusets are the ones
+	 * enforcing this dependency, so if they ever change, we might as well.
+	 *
+	 * schedule_work() will guarantee this happens. Be careful if you need
+	 * to move this code around, and make sure it is outside
+	 * the cgroup_lock.
 	 */
-	disarm_static_keys(memcg);
+	disarm_sock_keys(memcg);
 	if (size < PAGE_SIZE)
 		kfree(memcg);
 	else
diff -puN net/ipv4/tcp_memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time-v7 net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time-v7
+++ a/net/ipv4/tcp_memcontrol.c
@@ -109,13 +109,13 @@ static int tcp_update_limit(struct mem_c
 	else if (val != RESOURCE_MAX) {
 		/*
 		 * The active bit needs to be written after the static_key
-		 * update.  This is what guarantees that the socket activation
-		 * function is the last one to run.  See sock_update_memcg() for
+		 * update. This is what guarantees that the socket activation
+		 * function is the last one to run. See sock_update_memcg() for
 		 * details, and note that we don't mark any socket as belonging
 		 * to this memcg until that flag is up.
 		 *
 		 * We need to do this, because static_keys will span multiple
-		 * sites, but we can't control their order.  If we mark a socket
+		 * sites, but we can't control their order. If we mark a socket
 		 * as accounted, but the accounting functions are not patched in
 		 * yet, we'll lose accounting.
 		 *
_
Subject: Subject: memcg-decrement-static-keys-at-real-destroy-time-v7

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
slab-move-full-state-transition-to-an-initcall.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
rescounters-add-res_counter_uncharge_until.patch
memcg-use-res_counter_uncharge_until-in-move_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0.patch
memcg-dont-uncharge-in-mem_cgroup_move_account.patch
remove-__must_check-for-res_counter_charge_nofail.patch
memcg-always-free-struct-memcg-through-schedule_work.patch
memcg-always-free-struct-memcg-through-schedule_work-fix.patch
memcg-decrement-static-keys-at-real-destroy-time.patch
memcg-decrement-static-keys-at-real-destroy-time-v6.patch
memcg-decrement-static-keys-at-real-destroy-time-v6-fix.patch
memcg-decrement-static-keys-at-real-destroy-time-v7.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

