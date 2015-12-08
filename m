From: akpm@linux-foundation.org
Subject: +
 net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch added to
 -mm tree
Date: Tue, 08 Dec 2015 14:51:49 -0800
Message-ID: <56675f05.azsCpRYGgHtTOvDN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbbLHWvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:51:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net: tcp_memcontrol: properly detect ancestor socket pressure
has been added to the -mm tree.  Its filename is
     net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch

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
Subject: net: tcp_memcontrol: properly detect ancestor socket pressure

When charging socket memory, the code currently checks only the local page
counter for excess to determine whether the memcg is under socket
pressure.  But even if the local counter is fine, one of the ancestors
could have breached its limit, which should also force this child to enter
socket pressure.  This currently doesn't happen.

Fix this by using page_counter_try_charge() first.  If that fails, it
means that either the local counter or one of the ancestors are in excess
of their limit, and the child should enter socket pressure.

Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/sock.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN include/net/sock.h~net-tcp_memcontrol-properly-detect-ancestor-socket-pressure include/net/sock.h
--- a/include/net/sock.h~net-tcp_memcontrol-properly-detect-ancestor-socket-pressure
+++ a/include/net/sock.h
@@ -1191,11 +1191,13 @@ static inline void memcg_memory_allocate
 					      unsigned long amt,
 					      int *parent_status)
 {
-	page_counter_charge(&prot->memory_allocated, amt);
+	struct page_counter *counter;
+
+	if (page_counter_try_charge(&prot->memory_allocated, amt, &counter))
+		return;
 
-	if (page_counter_read(&prot->memory_allocated) >
-	    prot->memory_allocated.limit)
-		*parent_status = OVER_LIMIT;
+	page_counter_charge(&prot->memory_allocated, amt);
+	*parent_status = OVER_LIMIT;
 }
 
 static inline void memcg_memory_allocated_sub(struct cg_proto *prot,
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

