From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix-2.patch added to -mm tree
Date: Wed, 23 Dec 2015 14:33:05 -0800
Message-ID: <567b2121.4iUBAbteUDDlHTxz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934377AbbLWWdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Dec 2015 17:33:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix possible memcg leak due to interrupted reclaim fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix-2.patch

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
Subject: mm: memcontrol: fix possible memcg leak due to interrupted reclaim fix

When we handled multiple css references in mem_cgroup_iter() it got a
little confusing which puts belong to which gets. Now that we only ref
the position css it's obvious, and a multi-line comment to explain it
gets in the way of reading an already long function.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix-2
+++ a/mm/memcontrol.c
@@ -969,10 +969,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		 */
 		(void)cmpxchg(&iter->position, pos, memcg);
 
-		/*
-		 * pairs with css_tryget when dereferencing iter->position
-		 * above.
-		 */
 		if (pos)
 			css_put(&pos->css);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-fix-possible-memcg-leak-due-to-interrupted-reclaim-fix-2.patch
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
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch

