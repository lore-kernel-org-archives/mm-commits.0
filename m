From: akpm@linux-foundation.org
Subject: + memcg-decrement-static-keys-at-real-destroy-time.patch added to -mm tree
Date: Wed, 16 May 2012 14:13:59 -0700
Message-ID: <20120516211400.1DA52A0358@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60348 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab2EPVOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 17:14:01 -0400
Received: by mail-we0-f202.google.com with SMTP id f13so61501wer.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 14:14:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, davem@davemloft.net, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, mhocko@suse.cz, tj@kernel.org


The patch titled
     Subject: memcg: decrement static keys at real destroy time
has been added to the -mm tree.  Its filename is
     memcg-decrement-static-keys-at-real-destroy-time.patch

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
Subject: memcg: decrement static keys at real destroy time

We call the destroy function when a cgroup starts to be removed, such as
by a rmdir event.

However, because of our reference counters, some objects are still
inflight.  Right now, we are decrementing the static_keys at destroy()
time, meaning that if we get rid of the last static_key reference, some
objects will still have charges, but the code to properly uncharge them
won't be run.

This becomes a problem specially if it is ever enabled again, because now
new charges will be added to the staled charges making keeping it pretty
much impossible.

We just need to be careful with the static branch activation: since there
is no particular preferred order of their activation, we need to make sure
that we only start using it after all call sites are active.  This is
achieved by having a per-memcg flag that is only updated after
static_key_slow_inc() returns.  At this time, we are sure all sites are
active.

This is made per-memcg, not global, for a reason: it also has the effect
of making socket accounting more consistent.  The first memcg to be
limited will trigger static_key() activation, therefore, accounting.  But
all the others will then be accounted no matter what.  After this patch,
only limited memcgs will have its sockets accounted.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/sock.h        |    9 +++++++++
 mm/memcontrol.c           |   26 ++++++++++++++++++++++++--
 net/ipv4/tcp_memcontrol.c |   32 +++++++++++++++++++++++++-------
 3 files changed, 58 insertions(+), 9 deletions(-)

diff -puN include/net/sock.h~memcg-decrement-static-keys-at-real-destroy-time include/net/sock.h
--- a/include/net/sock.h~memcg-decrement-static-keys-at-real-destroy-time
+++ a/include/net/sock.h
@@ -928,6 +928,15 @@ struct cg_proto {
 	int			*memory_pressure;
 	long			*sysctl_mem;
 	/*
+	 * active means it is currently active, and new sockets should
+	 * be assigned to cgroups.
+	 *
+	 * activated means it was ever activated, and we need to
+	 * disarm the static keys on destruction
+	 */
+	bool			activated;
+	bool			active;
+	/*
 	 * memcg field is used to find which memcg we belong directly
 	 * Each memcg struct can hold more than one cg_proto, so container_of
 	 * won't really cut.
diff -puN mm/memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time
+++ a/mm/memcontrol.c
@@ -438,6 +438,7 @@ void sock_update_memcg(struct sock *sk)
 {
 	if (mem_cgroup_sockets_enabled) {
 		struct mem_cgroup *memcg;
+		struct cg_proto *cg_proto;
 
 		BUG_ON(!sk->sk_prot->proto_cgroup);
 
@@ -457,9 +458,10 @@ void sock_update_memcg(struct sock *sk)
 
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
-		if (!mem_cgroup_is_root(memcg)) {
+		cg_proto = sk->sk_prot->proto_cgroup(memcg);
+		if (!mem_cgroup_is_root(memcg) && cg_proto->active) {
 			mem_cgroup_get(memcg);
-			sk->sk_cgrp = sk->sk_prot->proto_cgroup(memcg);
+			sk->sk_cgrp = cg_proto;
 		}
 		rcu_read_unlock();
 	}
@@ -476,6 +478,14 @@ void sock_release_memcg(struct sock *sk)
 	}
 }
 
+static void disarm_static_keys(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_INET
+	if (memcg->tcp_mem.cg_proto.activated)
+		static_key_slow_dec(&memcg_socket_limit_enabled);
+#endif
+}
+
 #ifdef CONFIG_INET
 struct cg_proto *tcp_proto_cgroup(struct mem_cgroup *memcg)
 {
@@ -486,6 +496,11 @@ struct cg_proto *tcp_proto_cgroup(struct
 }
 EXPORT_SYMBOL(tcp_proto_cgroup);
 #endif /* CONFIG_INET */
+#else
+static inline void disarm_static_keys(struct mem_cgroup *memcg)
+{
+}
+
 #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
 
 static void drain_all_stock_async(struct mem_cgroup *memcg);
@@ -4934,6 +4949,13 @@ static void free_work(struct work_struct
 	int size = sizeof(struct mem_cgroup);
 
 	memcg = container_of(work, struct mem_cgroup, work_freeing);
+	/*
+	 * We need to make sure that (at least for now), the jump label
+	 * destruction code runs outside of the cgroup lock. schedule_work()
+	 * will guarantee this happens. Be careful if you need to move this
+	 * disarm_static_keys around
+	 */
+	disarm_static_keys(memcg);
 	if (size < PAGE_SIZE)
 		kfree(memcg);
 	else
diff -puN net/ipv4/tcp_memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~memcg-decrement-static-keys-at-real-destroy-time
+++ a/net/ipv4/tcp_memcontrol.c
@@ -74,9 +74,6 @@ void tcp_destroy_cgroup(struct mem_cgrou
 	percpu_counter_destroy(&tcp->tcp_sockets_allocated);
 
 	val = res_counter_read_u64(&tcp->tcp_memory_allocated, RES_LIMIT);
-
-	if (val != RESOURCE_MAX)
-		static_key_slow_dec(&memcg_socket_limit_enabled);
 }
 EXPORT_SYMBOL(tcp_destroy_cgroup);
 
@@ -107,10 +104,31 @@ static int tcp_update_limit(struct mem_c
 		tcp->tcp_prot_mem[i] = min_t(long, val >> PAGE_SHIFT,
 					     net->ipv4.sysctl_tcp_mem[i]);
 
-	if (val == RESOURCE_MAX && old_lim != RESOURCE_MAX)
-		static_key_slow_dec(&memcg_socket_limit_enabled);
-	else if (old_lim == RESOURCE_MAX && val != RESOURCE_MAX)
-		static_key_slow_inc(&memcg_socket_limit_enabled);
+	if (val == RESOURCE_MAX)
+		cg_proto->active = false;
+	else if (val != RESOURCE_MAX) {
+		/*
+		 * ->activated needs to be written after the static_key update.
+		 *  This is what guarantees that the socket activation function
+		 *  is the last one to run. See sock_update_memcg() for details,
+		 *  and note that we don't mark any socket as belonging to this
+		 *  memcg until that flag is up.
+		 *
+		 *  We need to do this, because static_keys will span multiple
+		 *  sites, but we can't control their order. If we mark a socket
+		 *  as accounted, but the accounting functions are not patched in
+		 *  yet, we'll lose accounting.
+		 *
+		 *  We never race with the readers in sock_update_memcg(), because
+		 *  when this value change, the code to process it is not patched in
+		 *  yet.
+		 */
+		if (!cg_proto->activated) {
+			static_key_slow_inc(&memcg_socket_limit_enabled);
+			cg_proto->activated = true;
+		}
+		cg_proto->active = true;
+	}
 
 	return 0;
 }
_
Subject: Subject: memcg: decrement static keys at real destroy time

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
memcg-decrement-static-keys-at-real-destroy-time-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

