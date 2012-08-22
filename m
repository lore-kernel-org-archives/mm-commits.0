From: akpm@linux-foundation.org
Subject: + mempolicy-fix-a-race-in-shared_policy_replace.patch added to -mm tree
Date: Wed, 22 Aug 2012 12:08:00 -0700
Message-ID: <20120822190801.A122F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:59211 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab2HVTIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Aug 2012 15:08:04 -0400
Received: by bkcjc3 with SMTP id jc3so63313bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Aug 2012 12:08:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, cl@linux.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mempolicy: fix a race in shared_policy_replace()
has been added to the -mm tree.  Its filename is
     mempolicy-fix-a-race-in-shared_policy_replace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mempolicy: fix a race in shared_policy_replace()

shared_policy_replace() use of sp_alloc() is unsafe.  1) sp_node cannot be
dereferenced if sp->lock is not held and 2) another thread can modify
sp_node between spin_unlock for allocating a new sp node and next
spin_lock.  The bug was introduced before 2.6.12-rc2.

Kosaki's original patch for this problem was to allocate an sp node and
policy within shared_policy_replace and initialise it when the lock is
reacquired.  I was not keen on this approach because it partially
duplicates sp_alloc().  As the paths were sp->lock is taken are not that
performance critical this patch converts sp->lock to sp->mutex so it can
sleep when calling sp_alloc().

[kosaki.motohiro@jp.fujitsu.com: Original patch]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 -
 mm/mempolicy.c            |   37 +++++++++++++++---------------------
 2 files changed, 17 insertions(+), 22 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-fix-a-race-in-shared_policy_replace include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-fix-a-race-in-shared_policy_replace
+++ a/include/linux/mempolicy.h
@@ -188,7 +188,7 @@ struct sp_node {
 
 struct shared_policy {
 	struct rb_root root;
-	spinlock_t lock;
+	struct mutex mutex;
 };
 
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol);
diff -puN mm/mempolicy.c~mempolicy-fix-a-race-in-shared_policy_replace mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-fix-a-race-in-shared_policy_replace
+++ a/mm/mempolicy.c
@@ -2083,7 +2083,7 @@ bool __mpol_equal(struct mempolicy *a, s
  */
 
 /* lookup first element intersecting start-end */
-/* Caller holds sp->lock */
+/* Caller holds sp->mutex */
 static struct sp_node *
 sp_lookup(struct shared_policy *sp, unsigned long start, unsigned long end)
 {
@@ -2147,13 +2147,13 @@ mpol_shared_policy_lookup(struct shared_
 
 	if (!sp->root.rb_node)
 		return NULL;
-	spin_lock(&sp->lock);
+	mutex_lock(&sp->mutex);
 	sn = sp_lookup(sp, idx, idx+1);
 	if (sn) {
 		mpol_get(sn->policy);
 		pol = sn->policy;
 	}
-	spin_unlock(&sp->lock);
+	mutex_unlock(&sp->mutex);
 	return pol;
 }
 
@@ -2193,10 +2193,10 @@ static struct sp_node *sp_alloc(unsigned
 static int shared_policy_replace(struct shared_policy *sp, unsigned long start,
 				 unsigned long end, struct sp_node *new)
 {
-	struct sp_node *n, *new2 = NULL;
+	struct sp_node *n;
+	int ret = 0;
 
-restart:
-	spin_lock(&sp->lock);
+	mutex_lock(&sp->mutex);
 	n = sp_lookup(sp, start, end);
 	/* Take care of old policies in the same range. */
 	while (n && n->start < end) {
@@ -2209,16 +2209,14 @@ restart:
 		} else {
 			/* Old policy spanning whole new range. */
 			if (n->end > end) {
+				struct sp_node *new2;
+				new2 = sp_alloc(end, n->end, n->policy);
 				if (!new2) {
-					spin_unlock(&sp->lock);
-					new2 = sp_alloc(end, n->end, n->policy);
-					if (!new2)
-						return -ENOMEM;
-					goto restart;
+					ret = -ENOMEM;
+					goto out;
 				}
 				n->end = start;
 				sp_insert(sp, new2);
-				new2 = NULL;
 				break;
 			} else
 				n->end = start;
@@ -2229,12 +2227,9 @@ restart:
 	}
 	if (new)
 		sp_insert(sp, new);
-	spin_unlock(&sp->lock);
-	if (new2) {
-		mpol_put(new2->policy);
-		kmem_cache_free(sn_cache, new2);
-	}
-	return 0;
+out:
+	mutex_unlock(&sp->mutex);
+	return ret;
 }
 
 /**
@@ -2252,7 +2247,7 @@ void mpol_shared_policy_init(struct shar
 	int ret;
 
 	sp->root = RB_ROOT;		/* empty tree == default mempolicy */
-	spin_lock_init(&sp->lock);
+	mutex_init(&sp->mutex);
 
 	if (mpol) {
 		struct vm_area_struct pvma;
@@ -2318,7 +2313,7 @@ void mpol_free_shared_policy(struct shar
 
 	if (!p->root.rb_node)
 		return;
-	spin_lock(&p->lock);
+	mutex_lock(&p->mutex);
 	next = rb_first(&p->root);
 	while (next) {
 		n = rb_entry(next, struct sp_node, nd);
@@ -2327,7 +2322,7 @@ void mpol_free_shared_policy(struct shar
 		mpol_put(n->policy);
 		kmem_cache_free(sn_cache, n);
 	}
-	spin_unlock(&p->lock);
+	mutex_unlock(&p->mutex);
 }
 
 /* assumes fs == KERNEL_DS */
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-hugetlbfs-correctly-populate-shared-pmd.patch
netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag.patch
mm-correct-page-pfmemalloc-to-fix-deactivate_slab-regression.patch
mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages-v2.patch
mm-compaction-abort-async-compaction-if-locks-are-contended-or-taking-too-long-v2.patch
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2.patch

