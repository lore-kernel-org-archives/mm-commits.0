From: akpm@linux-foundation.org
Subject: [merged]
 cgroup-duplicate-cgroup-reference-when-cloning-sockets.patch removed from
 -mm tree
Date: Tue, 20 Sep 2016 12:30:57 -0700
Message-ID: <57e18e71.alZTSZhshPuNww8R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48718 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753596AbcITTa6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 15:30:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@fb.com, hannes@cmpxchg.org, mhocko@suse.cz, stable@vger.kernel.org, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: duplicate cgroup reference when cloning sockets
has been removed from the -mm tree.  Its filename was
     cgroup-duplicate-cgroup-reference-when-cloning-sockets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <jweiner@fb.com>
Subject: cgroup: duplicate cgroup reference when cloning sockets

When a socket is cloned, the associated sock_cgroup_data is duplicated
but not its reference on the cgroup. As a result, the cgroup reference
count will underflow when both sockets are destroyed later on.

Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
Link: http://lkml.kernel.org/r/20160914194846.11153-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: <stable@vger.kernel.org>	[4.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    6 ++++++
 net/core/sock.c |    5 ++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroup-duplicate-cgroup-reference-when-cloning-sockets kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-duplicate-cgroup-reference-when-cloning-sockets
+++ a/kernel/cgroup.c
@@ -6270,6 +6270,12 @@ void cgroup_sk_alloc(struct sock_cgroup_
 	if (cgroup_sk_alloc_disabled)
 		return;
 
+	/* Socket clone path */
+	if (skcd->val) {
+		cgroup_get(sock_cgroup_ptr(skcd));
+		return;
+	}
+
 	rcu_read_lock();
 
 	while (true) {
diff -puN net/core/sock.c~cgroup-duplicate-cgroup-reference-when-cloning-sockets net/core/sock.c
--- a/net/core/sock.c~cgroup-duplicate-cgroup-reference-when-cloning-sockets
+++ a/net/core/sock.c
@@ -1362,7 +1362,6 @@ static struct sock *sk_prot_alloc(struct
 		if (!try_module_get(prot->owner))
 			goto out_free_sec;
 		sk_tx_queue_clear(sk);
-		cgroup_sk_alloc(&sk->sk_cgrp_data);
 	}
 
 	return sk;
@@ -1422,6 +1421,7 @@ struct sock *sk_alloc(struct net *net, i
 		sock_net_set(sk, net);
 		atomic_set(&sk->sk_wmem_alloc, 1);
 
+		cgroup_sk_alloc(&sk->sk_cgrp_data);
 		sock_update_classid(&sk->sk_cgrp_data);
 		sock_update_netprioidx(&sk->sk_cgrp_data);
 	}
@@ -1566,6 +1566,9 @@ struct sock *sk_clone_lock(const struct
 		newsk->sk_priority = 0;
 		newsk->sk_incoming_cpu = raw_smp_processor_id();
 		atomic64_set(&newsk->sk_cookie, 0);
+
+		cgroup_sk_alloc(&newsk->sk_cgrp_data);
+
 		/*
 		 * Before updating sk_refcnt, we must commit prior changes to memory
 		 * (Documentation/RCU/rculist_nulls.txt for details)
_

Patches currently in -mm which might be from jweiner@fb.com are


