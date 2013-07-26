From: akpm@linux-foundation.org
Subject: +
 lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt.patch added to -mm tree
Date: Fri, 26 Jul 2013 14:15:35 -0700
Message-ID: <51f2e6f7.UtIRhNfJegYQ7WEO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab3GZVPg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 17:15:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz

Subject: + lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt.patch added to -mm tree
To: jack@suse.cz,jaxboe@fusionio.com
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 14:15:35 -0700


The patch titled
     Subject: lib/radix-tree.c: make radix_tree_node_alloc() work correctly within interrupt
has been added to the -mm tree.  Its filename is
     lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: lib/radix-tree.c: make radix_tree_node_alloc() work correctly within interrupt

With users of radix_tree_preload() run from interrupt (block/blk-ioc.c is
one such possible user), the following race can happen:

radix_tree_preload()
...
radix_tree_insert()
  radix_tree_node_alloc()
    if (rtp->nr) {
      ret = rtp->nodes[rtp->nr - 1];
<interrupt>
...
radix_tree_preload()
...
radix_tree_insert()
  radix_tree_node_alloc()
    if (rtp->nr) {
      ret = rtp->nodes[rtp->nr - 1];

And we give out one radix tree node twice.  That clearly results in radix
tree corruption with different results (usually OOPS) depending on which
two users of radix tree race.

We fix the problem by making radix_tree_node_alloc() always allocate fresh
radix tree nodes when in interrupt.  Using preloading when in interrupt
doesn't make sense since all the allocations have to be atomic anyway and
we cannot steal nodes from process-context users because some users rely
on radix_tree_insert() succeeding after radix_tree_preload(). 
in_interrupt() check is somewhat ugly but we cannot simply key off passed
gfp_mask as that is acquired from root_gfp_mask() and thus the same for
all preload users.

Another part of the fix is to avoid node preallocation in
radix_tree_preload() when passed gfp_mask doesn't allow waiting.  Again,
preallocation in such case doesn't make sence and when preallocation would
happen in interrupt we could possibly leak some allocated nodes.  However,
some users of radix_tree_preload() require following radix_tree_insert()
to succeed.  To avoid unexpected effects for these users,
radix_tree_preload() only warns if passed gfp mask doesn't allow waiting
and we provide a new function radix_tree_maybe_preload() for those users
which get different gfp mask from different call sites and which are
prepared to handle radix_tree_insert() failure.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-ioc.c            |    2 -
 fs/fscache/page.c          |    2 -
 include/linux/radix-tree.h |    1 
 lib/radix-tree.c           |   41 +++++++++++++++++++++++++++++++++--
 mm/filemap.c               |    2 -
 mm/shmem.c                 |    2 -
 mm/swap_state.c            |    4 +--
 7 files changed, 46 insertions(+), 8 deletions(-)

diff -puN block/blk-ioc.c~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt block/blk-ioc.c
--- a/block/blk-ioc.c~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt
+++ a/block/blk-ioc.c
@@ -367,7 +367,7 @@ struct io_cq *ioc_create_icq(struct io_c
 	if (!icq)
 		return NULL;
 
-	if (radix_tree_preload(gfp_mask) < 0) {
+	if (radix_tree_maybe_preload(gfp_mask) < 0) {
 		kmem_cache_free(et->icq_cache, icq);
 		return NULL;
 	}
diff -puN fs/fscache/page.c~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt fs/fscache/page.c
--- a/fs/fscache/page.c~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt
+++ a/fs/fscache/page.c
@@ -890,7 +890,7 @@ int __fscache_write_page(struct fscache_
 		(1 << FSCACHE_OP_WAITING) |
 		(1 << FSCACHE_OP_UNUSE_COOKIE);
 
-	ret = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
+	ret = radix_tree_maybe_preload(gfp & ~__GFP_HIGHMEM);
 	if (ret < 0)
 		goto nomem_free;
 
diff -puN include/linux/radix-tree.h~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt
+++ a/include/linux/radix-tree.h
@@ -231,6 +231,7 @@ unsigned long radix_tree_next_hole(struc
 unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
 				unsigned long index, unsigned long max_scan);
 int radix_tree_preload(gfp_t gfp_mask);
+int radix_tree_maybe_preload(gfp_t gfp_mask);
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *root,
 			unsigned long index, unsigned int tag);
diff -puN lib/radix-tree.c~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt lib/radix-tree.c
--- a/lib/radix-tree.c~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt
+++ a/lib/radix-tree.c
@@ -32,6 +32,7 @@
 #include <linux/string.h>
 #include <linux/bitops.h>
 #include <linux/rcupdate.h>
+#include <linux/hardirq.h>		/* in_interrupt() */
 
 
 #ifdef __KERNEL__
@@ -207,7 +208,12 @@ radix_tree_node_alloc(struct radix_tree_
 	struct radix_tree_node *ret = NULL;
 	gfp_t gfp_mask = root_gfp_mask(root);
 
-	if (!(gfp_mask & __GFP_WAIT)) {
+	/*
+	 * Preload code isn't irq safe and it doesn't make sence to use
+	 * preloading in the interrupt anyway as all the allocations have to
+	 * be atomic. So just do normal allocation when in interrupt.
+	 */
+	if (!(gfp_mask & __GFP_WAIT) && !in_interrupt()) {
 		struct radix_tree_preload *rtp;
 
 		/*
@@ -264,7 +270,7 @@ radix_tree_node_free(struct radix_tree_n
  * To make use of this facility, the radix tree must be initialised without
  * __GFP_WAIT being passed to INIT_RADIX_TREE().
  */
-int radix_tree_preload(gfp_t gfp_mask)
+static int __radix_tree_preload(gfp_t gfp_mask)
 {
 	struct radix_tree_preload *rtp;
 	struct radix_tree_node *node;
@@ -288,9 +294,40 @@ int radix_tree_preload(gfp_t gfp_mask)
 out:
 	return ret;
 }
+
+/*
+ * Load up this CPU's radix_tree_node buffer with sufficient objects to
+ * ensure that the addition of a single element in the tree cannot fail.  On
+ * success, return zero, with preemption disabled.  On error, return -ENOMEM
+ * with preemption not disabled.
+ *
+ * To make use of this facility, the radix tree must be initialised without
+ * __GFP_WAIT being passed to INIT_RADIX_TREE().
+ */
+int radix_tree_preload(gfp_t gfp_mask)
+{
+	/* Warn on non-sensical use... */
+	WARN_ON_ONCE(!(gfp_mask & __GFP_WAIT));
+	return __radix_tree_preload(gfp_mask);
+}
 EXPORT_SYMBOL(radix_tree_preload);
 
 /*
+ * The same as above function, except we don't guarantee preloading happens.
+ * We do it, if we decide it helps. On success, return zero with preemption
+ * disabled. On error, return -ENOMEM with preemption not disabled.
+ */
+int radix_tree_maybe_preload(gfp_t gfp_mask)
+{
+	if (gfp_mask & __GFP_WAIT)
+		return __radix_tree_preload(gfp_mask);
+	/* Preloading doesn't help anything with this gfp mask, skip it */
+	preempt_disable();
+	return 0;
+}
+EXPORT_SYMBOL(radix_tree_maybe_preload);
+
+/*
  *	Return the maximum key which can be store into a
  *	radix tree with height HEIGHT.
  */
diff -puN mm/filemap.c~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt mm/filemap.c
--- a/mm/filemap.c~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt
+++ a/mm/filemap.c
@@ -469,7 +469,7 @@ int add_to_page_cache_locked(struct page
 	if (error)
 		return error;
 
-	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
+	error = radix_tree_maybe_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (error) {
 		mem_cgroup_uncharge_cache_page(page);
 		return error;
diff -puN mm/shmem.c~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt mm/shmem.c
--- a/mm/shmem.c~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt
+++ a/mm/shmem.c
@@ -1205,7 +1205,7 @@ repeat:
 						gfp & GFP_RECLAIM_MASK);
 		if (error)
 			goto decused;
-		error = radix_tree_preload(gfp & GFP_RECLAIM_MASK);
+		error = radix_tree_maybe_preload(gfp & GFP_RECLAIM_MASK);
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
 							gfp, NULL);
diff -puN mm/swap_state.c~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt mm/swap_state.c
--- a/mm/swap_state.c~lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt
+++ a/mm/swap_state.c
@@ -124,7 +124,7 @@ int add_to_swap_cache(struct page *page,
 {
 	int error;
 
-	error = radix_tree_preload(gfp_mask);
+	error = radix_tree_maybe_preload(gfp_mask);
 	if (!error) {
 		error = __add_to_swap_cache(page, entry);
 		radix_tree_preload_end();
@@ -333,7 +333,7 @@ struct page *read_swap_cache_async(swp_e
 		/*
 		 * call radix_tree_preload() while we can wait.
 		 */
-		err = radix_tree_preload(gfp_mask & GFP_KERNEL);
+		err = radix_tree_maybe_preload(gfp_mask & GFP_KERNEL);
 		if (err)
 			break;
 
_

Patches currently in -mm which might be from jack@suse.cz are

thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
lib-radix-treec-make-radix_tree_node_alloc-work-correctly-within-interrupt.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch

