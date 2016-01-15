From: akpm@linux-foundation.org
Subject: [merged]
 net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:34:28 -0800
Message-ID: <569973f4.zGuiFeWqMqc8Txvk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net: tcp_memcontrol: remove bogus hierarchy pressure propagation
has been removed from the -mm tree.  Its filename was
     net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: net: tcp_memcontrol: remove bogus hierarchy pressure propagation

When a cgroup currently breaches its socket memory limit, it enters memory
pressure mode for itself and its *ancestors*.  This throttles transmission
in unrelated sibling and cousin subtrees that have nothing to do with the
breached limit.

On the contrary, breaching a limit should make that group and its
*children* enter memory pressure mode.  But this happens already, albeit
lazily: if an ancestor limit is breached, siblings will enter memory
pressure on their own once the next packet arrives for them.

So no additional hierarchy code is needed. Remove the bogus stuff.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/sock.h |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff -puN include/net/sock.h~net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation include/net/sock.h
--- a/include/net/sock.h~net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation
+++ a/include/net/sock.h
@@ -1155,14 +1155,8 @@ static inline void sk_leave_memory_press
 	if (*memory_pressure)
 		*memory_pressure = 0;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp) {
-		struct cg_proto *cg_proto = sk->sk_cgrp;
-		struct proto *prot = sk->sk_prot;
-
-		for (; cg_proto; cg_proto = parent_cg_proto(prot, cg_proto))
-			cg_proto->memory_pressure = 0;
-	}
-
+	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
+		sk->sk_cgrp->memory_pressure = 0;
 }
 
 static inline void sk_enter_memory_pressure(struct sock *sk)
@@ -1170,13 +1164,8 @@ static inline void sk_enter_memory_press
 	if (!sk->sk_prot->enter_memory_pressure)
 		return;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_cgrp) {
-		struct cg_proto *cg_proto = sk->sk_cgrp;
-		struct proto *prot = sk->sk_prot;
-
-		for (; cg_proto; cg_proto = parent_cg_proto(prot, cg_proto))
-			cg_proto->memory_pressure = 1;
-	}
+	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
+		sk->sk_cgrp->memory_pressure = 1;
 
 	sk->sk_prot->enter_memory_pressure(sk);
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

