From: akpm@linux-foundation.org
Subject: + mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch
 added to -mm tree
Date: Mon, 03 Feb 2014 15:54:42 -0800
Message-ID: <52f02c42.6FJM3hbUKG7kgzt8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaBCXyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 18:54:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, paulmck@linux.vnet.ibm.com, cl@linux.com, Larry.Finger@lwfinger.net, rientjes@google.com

Subject: + mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch added to -mm tree
To: rientjes@google.com,Larry.Finger@lwfinger.net,cl@linux.com,paulmck@linux.vnet.ibm.com,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 15:54:42 -0800


The patch titled
     Subject: mm/slub.c: list_lock may not be held in some circumstances
has been added to the -mm tree.  Its filename is
     mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm/slub.c: list_lock may not be held in some circumstances

Commit c65c1877bd68 ("slub: use lockdep_assert_held") incorrectly required
that add_full() and remove_full() hold n->list_lock.  The lock is only
taken when kmem_cache_debug(s), since that's the only time it actually
does anything.

Require that the lock only be taken under such a condition.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~mm-slub-list_lock-may-not-be-held-in-some-circumstances mm/slub.c
--- a/mm/slub.c~mm-slub-list_lock-may-not-be-held-in-some-circumstances
+++ a/mm/slub.c
@@ -1004,21 +1004,19 @@ static inline void slab_free_hook(struct
 static void add_full(struct kmem_cache *s,
 	struct kmem_cache_node *n, struct page *page)
 {
-	lockdep_assert_held(&n->list_lock);
-
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
+	lockdep_assert_held(&n->list_lock);
 	list_add(&page->lru, &n->full);
 }
 
 static void remove_full(struct kmem_cache *s, struct kmem_cache_node *n, struct page *page)
 {
-	lockdep_assert_held(&n->list_lock);
-
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
+	lockdep_assert_held(&n->list_lock);
 	list_del(&page->lru);
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

documentation-kernel-parameterstxt-fix-memmap=-language.patch
mm-__set_page_dirty_nobuffers-uses-spin_lock_irqseve-instead-of-spin_lock_irq.patch
mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
mm-utilc-add-kstrimdup.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch

