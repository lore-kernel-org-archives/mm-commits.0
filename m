From: akpm@linux-foundation.org
Subject: [merged]
 slub-do-not-assert-not-having-lock-in-removing-freed-partial.patch removed
 from -mm tree
Date: Tue, 11 Feb 2014 11:23:42 -0800
Message-ID: <52fa78be.JyNpmNsE6sL1uYYI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbaBKTXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, rientjes@google.com, penberg@kernel.org, cl@linux.com, rostedt@goodmis.org

Subject: [merged] slub-do-not-assert-not-having-lock-in-removing-freed-partial.patch removed from -mm tree
To: rostedt@goodmis.org,cl@linux.com,penberg@kernel.org,rientjes@google.com,vdavydov@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:42 -0800


The patch titled
     Subject: slub: do not assert not having lock in removing freed partial
has been removed from the -mm tree.  Its filename was
     slub-do-not-assert-not-having-lock-in-removing-freed-partial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: slub: do not assert not having lock in removing freed partial

Vladimir reported the following issue:

Commit c65c1877bd68 ("slub: use lockdep_assert_held") requires
remove_partial() to be called with n->list_lock held, but free_partial()
called from kmem_cache_close() on cache destruction does not follow this
rule, leading to a warning:

  WARNING: CPU: 0 PID: 2787 at mm/slub.c:1536 __kmem_cache_shutdown+0x1b2/0x1f0()
  Modules linked in:
  CPU: 0 PID: 2787 Comm: modprobe Tainted: G        W    3.14.0-rc1-mm1+ #1
  Hardware name:
   0000000000000600 ffff88003ae1dde8 ffffffff816d9583 0000000000000600
   0000000000000000 ffff88003ae1de28 ffffffff8107c107 0000000000000000
   ffff880037ab2b00 ffff88007c240d30 ffffea0001ee5280 ffffea0001ee52a0
  Call Trace:
   [<ffffffff816d9583>] dump_stack+0x51/0x6e
   [<ffffffff8107c107>] warn_slowpath_common+0x87/0xb0
   [<ffffffff8107c145>] warn_slowpath_null+0x15/0x20
   [<ffffffff811c7fe2>] __kmem_cache_shutdown+0x1b2/0x1f0
   [<ffffffff811908d3>] kmem_cache_destroy+0x43/0xf0
   [<ffffffffa013a123>] xfs_destroy_zones+0x103/0x110 [xfs]
   [<ffffffffa0192b54>] exit_xfs_fs+0x38/0x4e4 [xfs]
   [<ffffffff811036fa>] SyS_delete_module+0x19a/0x1f0
   [<ffffffff816dfcd8>] ? retint_swapgs+0x13/0x1b
   [<ffffffff810d2125>] ? trace_hardirqs_on_caller+0x105/0x1d0
   [<ffffffff81359efe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
   [<ffffffff816e8539>] system_call_fastpath+0x16/0x1b

His solution was to add a spinlock in order to quiet lockdep. Although
there would be no contention to adding the lock, that lock also
requires disabling of interrupts which will have a larger impact on the
system.

Instead of adding a spinlock to a location where it is not needed for
lockdep, make a __remove_partial() function that does not test if
the list_lock is held, as no one should have it due to it being freed.

Also added a __add_partial() function that does not do the lock validation
either, as it is not needed for the creation of the cache.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Vladimir Davydov <vdavydov@parallels.com>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff -puN mm/slub.c~slub-do-not-assert-not-having-lock-in-removing-freed-partial mm/slub.c
--- a/mm/slub.c~slub-do-not-assert-not-having-lock-in-removing-freed-partial
+++ a/mm/slub.c
@@ -1518,11 +1518,9 @@ static void discard_slab(struct kmem_cac
 /*
  * Management of partially allocated slabs.
  */
-static inline void add_partial(struct kmem_cache_node *n,
-				struct page *page, int tail)
+static inline void
+__add_partial(struct kmem_cache_node *n, struct page *page, int tail)
 {
-	lockdep_assert_held(&n->list_lock);
-
 	n->nr_partial++;
 	if (tail == DEACTIVATE_TO_TAIL)
 		list_add_tail(&page->lru, &n->partial);
@@ -1530,15 +1528,27 @@ static inline void add_partial(struct km
 		list_add(&page->lru, &n->partial);
 }
 
-static inline void remove_partial(struct kmem_cache_node *n,
-					struct page *page)
+static inline void add_partial(struct kmem_cache_node *n,
+				struct page *page, int tail)
 {
 	lockdep_assert_held(&n->list_lock);
+	__add_partial(n, page, tail);
+}
 
+static inline void
+__remove_partial(struct kmem_cache_node *n, struct page *page)
+{
 	list_del(&page->lru);
 	n->nr_partial--;
 }
 
+static inline void remove_partial(struct kmem_cache_node *n,
+					struct page *page)
+{
+	lockdep_assert_held(&n->list_lock);
+	__remove_partial(n, page);
+}
+
 /*
  * Remove slab from the partial list, freeze it and
  * return the pointer to the freelist.
@@ -2904,12 +2914,10 @@ static void early_kmem_cache_node_alloc(
 	inc_slabs_node(kmem_cache_node, node, page->objects);
 
 	/*
-	 * the lock is for lockdep's sake, not for any actual
-	 * race protection
+	 * No locks need to be taken here as it has just been
+	 * initialized and there is no concurrent access.
 	 */
-	spin_lock(&n->list_lock);
-	add_partial(n, page, DEACTIVATE_TO_HEAD);
-	spin_unlock(&n->list_lock);
+	__add_partial(n, page, DEACTIVATE_TO_HEAD);
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)
@@ -3195,7 +3203,7 @@ static void free_partial(struct kmem_cac
 
 	list_for_each_entry_safe(page, h, &n->partial, lru) {
 		if (!page->inuse) {
-			remove_partial(n, page);
+			__remove_partial(n, page);
 			discard_slab(s, page);
 		} else {
 			list_slab_objects(s, page,
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
lib-devresc-fix-some-sparse-warnings.patch
linux-next.patch

