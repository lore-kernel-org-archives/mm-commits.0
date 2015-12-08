From: akpm@linux-foundation.org
Subject: +
 net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch added
 to -mm tree
Date: Tue, 08 Dec 2015 14:51:51 -0800
Message-ID: <56675f07.du+yq7OL9AfzlUC8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbbLHWvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:51:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net: tcp_memcontrol: remove bogus hierarchy pressure propagation
has been added to the -mm tree.  Its filename is
     net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1153,14 +1153,8 @@ static inline void sk_leave_memory_press
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
@@ -1168,13 +1162,8 @@ static inline void sk_enter_memory_press
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

maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-memcontrol-export-root_mem_cgroup.patch
net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch
net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter.patch
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch

