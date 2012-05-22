From: akpm@linux-foundation.org
Subject: + memcg-decrement-static-keys-at-real-destroy-time-v6.patch added to -mm tree
Date: Tue, 22 May 2012 15:46:33 -0700
Message-ID: <20120522224634.E2F83A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:59692 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2EVWqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 May 2012 18:46:36 -0400
Received: by qcsp5 with SMTP id p5so806807qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 22 May 2012 15:46:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, mhocko@suse.cz, tj@kernel.org


The patch titled
     Subject: decrement static keys on real destroy time
has been added to the -mm tree.  Its filename is
     memcg-decrement-static-keys-at-real-destroy-time-v6.patch

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
Subject: decrement static keys on real destroy time

[v6: changed active and activated to a flags field, as suggested by akpm ]

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++++
 include/net/sock.h         |   20 +++++++++++---------
 mm/memcontrol.c            |   27 +++++++++++++++------------
 net/ipv4/tcp_memcontrol.c  |   14 ++++++++------
 4 files changed, 39 insertions(+), 27 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-decrement-static-keys-at-real-destroy-time-v6 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-decrement-static-keys-at-real-destroy-time-v6
+++ a/include/linux/memcontrol.h
@@ -405,6 +405,11 @@ enum {
 	OVER_LIMIT,
 };
 
+enum sock_flag_bits {
+	MEMCG_SOCK_ACTIVE,
+	MEMCG_SOCK_ACTIVATED,
+};
+
 struct sock;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
 void sock_update_memcg(struct sock *sk);
diff -puN include/net/sock.h~memcg-decrement-static-keys-at-real-destroy-time-v6 include/net/sock.h
--- a/include/net/sock.h~memcg-decrement-static-keys-at-real-destroy-time-v6
+++ a/include/net/sock.h
@@ -927,15 +927,7 @@ struct cg_proto {
 	struct percpu_counter	*sockets_allocated;	/* Current number of sockets. */
 	int			*memory_pressure;
 	long			*sysctl_mem;
-	/*
-	 * active means it is currently active, and new sockets should
-	 * be assigned to cgroups.
-	 *
-	 * activated means it was ever activated, and we need to
-	 * disarm the static keys on destruction
-	 */
-	bool			activated;
-	bool			active;
+	unsigned long		flags;
 	/*
 	 * memcg field is used to find which memcg we belong directly
 	 * Each memcg struct can hold more than one cg_proto, so container_of
@@ -951,6 +943,16 @@ struct cg_proto {
 extern int proto_register(struct proto *prot, int alloc_slab);
 extern void proto_unregister(struct proto *prot);
 
+static inline bool memcg_proto_active(struct cg_proto *cg_proto)
+{
+	return cg_proto->flags & (1 << MEMCG_SOCK_ACTIVE);
+}
+
+static inline bool memcg_proto_activated(struct cg_proto *cg_proto)
+{
+	return cg_proto->flags & (1 << MEMCG_SOCK_ACTIVATED);
+}
+
 #ifdef SOCK_REFCNT_DEBUG
 static inline void sk_refcnt_debug_inc(struct sock *sk)
 {
diff -puN mm/memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time-v6 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time-v6
+++ a/mm/memcontrol.c
@@ -457,7 +457,7 @@ void sock_update_memcg(struct sock *sk)
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
 		cg_proto = sk->sk_prot->proto_cgroup(memcg);
-		if (!mem_cgroup_is_root(memcg) && cg_proto->active) {
+		if (!mem_cgroup_is_root(memcg) && memcg_proto_active(cg_proto)) {
 			mem_cgroup_get(memcg);
 			sk->sk_cgrp = cg_proto;
 		}
@@ -476,14 +476,6 @@ void sock_release_memcg(struct sock *sk)
 	}
 }
 
-static void disarm_static_keys(struct mem_cgroup *memcg)
-{
-#ifdef CONFIG_INET
-	if (memcg->tcp_mem.cg_proto.activated)
-		static_key_slow_dec(&memcg_socket_limit_enabled);
-#endif
-}
-
 #ifdef CONFIG_INET
 struct cg_proto *tcp_proto_cgroup(struct mem_cgroup *memcg)
 {
@@ -493,14 +485,25 @@ struct cg_proto *tcp_proto_cgroup(struct
 	return &memcg->tcp_mem.cg_proto;
 }
 EXPORT_SYMBOL(tcp_proto_cgroup);
-#endif /* CONFIG_INET */
+
+static void disarm_sock_keys(struct mem_cgroup *memcg)
+{
+	if (!memcg_proto_activated(&memcg->tcp_mem.cg_proto))
+		return;
+	static_key_slow_dec(&memcg_socket_limit_enabled);
+}
 #else
-static inline void disarm_static_keys(struct mem_cgroup *memcg)
+static void disarm_sock_keys(struct mem_cgroup *memcg)
 {
 }
-
+#endif /* CONFIG_INET */
 #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
 
+static void disarm_static_keys(struct mem_cgroup *memcg)
+{
+	disarm_sock_keys(memcg);
+}
+
 static void drain_all_stock_async(struct mem_cgroup *memcg);
 
 static struct mem_cgroup_per_zone *
diff -puN net/ipv4/tcp_memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time-v6 net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time-v6
+++ a/net/ipv4/tcp_memcontrol.c
@@ -105,10 +105,10 @@ static int tcp_update_limit(struct mem_c
 					     net->ipv4.sysctl_tcp_mem[i]);
 
 	if (val == RESOURCE_MAX)
-		cg_proto->active = false;
+		clear_bit(MEMCG_SOCK_ACTIVE, &cg_proto->flags);
 	else if (val != RESOURCE_MAX) {
 		/*
-		 * ->activated needs to be written after the static_key update.
+		 *  The active bit needs to be written after the static_key update.
 		 *  This is what guarantees that the socket activation function
 		 *  is the last one to run. See sock_update_memcg() for details,
 		 *  and note that we don't mark any socket as belonging to this
@@ -122,12 +122,14 @@ static int tcp_update_limit(struct mem_c
 		 *  We never race with the readers in sock_update_memcg(), because
 		 *  when this value change, the code to process it is not patched in
 		 *  yet.
+		 *
+		 *  The activated bit is used to guarantee that no two writers will
+		 *  do the update in the same memcg. Without that, we can't properly
+		 *  shutdown the static key.
 		 */
-		if (!cg_proto->activated) {
+		if (!test_and_set_bit(MEMCG_SOCK_ACTIVATED, &cg_proto->flags))
 			static_key_slow_inc(&memcg_socket_limit_enabled);
-			cg_proto->activated = true;
-		}
-		cg_proto->active = true;
+		set_bit(MEMCG_SOCK_ACTIVE, &cg_proto->flags);
 	}
 
 	return 0;
_
Subject: Subject: decrement static keys on real destroy time

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch
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
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

