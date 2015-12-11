From: akpm@linux-foundation.org
Subject: +
 net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix.patch added to -mm tree
Date: Fri, 11 Dec 2015 15:44:32 -0800
Message-ID: <566b5fe0.ofJ7ufAvbltH+DMt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbLKXoc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Dec 2015 18:44:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter
has been added to the -mm tree.  Its filename is
     net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix.patch

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
Subject: net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter

Fixlet for the same-named patch currently in mmots. The forward decl
is no longer necessary when the socket directly points to the memcg.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/sock.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/net/sock.h~net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix include/net/sock.h
--- a/include/net/sock.h~net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix
+++ a/include/net/sock.h
@@ -227,7 +227,6 @@ struct sock_common {
 	/* public: */
 };
 
-struct cg_proto;
 /**
   *	struct sock - network layer representation of sockets
   *	@__sk_common: shared layout with inet_timewait_sock
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
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix.patch
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch
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

