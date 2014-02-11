From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch removed from
 -mm tree
Date: Tue, 11 Feb 2014 11:23:30 -0800
Message-ID: <52fa78b2.+u+iPUFhSVoVRdRs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbaBKTXb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, paulmck@linux.vnet.ibm.com, cl@linux.com, Larry.Finger@lwfinger.net, rientjes@google.com

Subject: [merged] mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch removed from -mm tree
To: rientjes@google.com,Larry.Finger@lwfinger.net,cl@linux.com,paulmck@linux.vnet.ibm.com,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:30 -0800


The patch titled
     Subject: mm/slub.c: list_lock may not be held in some circumstances
has been removed from the -mm tree.  Its filename was
     mm-slub-list_lock-may-not-be-held-in-some-circumstances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
mm-readaheadc-fix-readahead-fail-for-no-local-memory-and-limit-readahead-pages.patch
mm-utilc-add-kstrimdup.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch

