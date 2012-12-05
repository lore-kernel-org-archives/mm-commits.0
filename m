From: akpm@linux-foundation.org
Subject: + mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree.patch added to -mm tree
Date: Wed, 05 Dec 2012 14:58:53 -0800
Message-ID: <20121205225854.3D5E5200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:58337 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab2LEW64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2012 17:58:56 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so400194wey.1
        for <mm-commits@vger.kernel.org>; Wed, 05 Dec 2012 14:58:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, levinsasha928@gmail.com, mingo@elte.hu, rientjes@google.com


The patch titled
     Subject: mm, mempolicy: introduce spinlock to read shared policy tree
has been added to the -mm tree.  Its filename is
     mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: mm, mempolicy: introduce spinlock to read shared policy tree

Sasha was fuzzing with trinity and reported the following problem:

BUG: sleeping function called from invalid context at kernel/mutex.c:269
in_atomic(): 1, irqs_disabled(): 0, pid: 6361, name: trinity-main
2 locks held by trinity-main/6361:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff810aa314>] __do_page_fault+0x1e4/0x4f0
 #1:  (&(&mm->page_table_lock)->rlock){+.+...}, at: [<ffffffff8122f017>] handle_pte_fault+0x3f7/0x6a0
Pid: 6361, comm: trinity-main Tainted: G        W 3.7.0-rc2-next-20121024-sasha-00001-gd95ef01-dirty #74
Call Trace:
 [<ffffffff8114e393>] __might_sleep+0x1c3/0x1e0
 [<ffffffff83ae5209>] mutex_lock_nested+0x29/0x50
 [<ffffffff8124fc3e>] mpol_shared_policy_lookup+0x2e/0x90
 [<ffffffff81219ebe>] shmem_get_policy+0x2e/0x30
 [<ffffffff8124e99a>] get_vma_policy+0x5a/0xa0
 [<ffffffff8124fce1>] mpol_misplaced+0x41/0x1d0
 [<ffffffff8122f085>] handle_pte_fault+0x465/0x6a0

do_numa_page() calls the new mpol_misplaced() function introduced by
"sched, numa, mm: Add the scanning page fault machinery" in the page fault
patch while holding mm->page_table_lock and then
mpol_shared_policy_lookup() ends up trying to take the shared policy
mutex.

The fix is to protect the shared policy tree with both a spinlock and
mutex; both must be held to modify the tree, but only one is required to
read the tree.  This allows sp_lookup() to grab the spinlock for read.

[rientjes@google.com: wrote changelog]
Reported-by: Sasha Levin <levinsasha928@gmail.com>
Tested-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    1 +
 mm/mempolicy.c            |   23 ++++++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff -puN include/linux/mempolicy.h~mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree
+++ a/include/linux/mempolicy.h
@@ -123,6 +123,7 @@ struct sp_node {
 
 struct shared_policy {
 	struct rb_root root;
+	spinlock_t lock;
 	struct mutex mutex;
 };
 
diff -puN mm/mempolicy.c~mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree
+++ a/mm/mempolicy.c
@@ -2086,12 +2086,20 @@ bool __mpol_equal(struct mempolicy *a, s
  *
  * Remember policies even when nobody has shared memory mapped.
  * The policies are kept in Red-Black tree linked from the inode.
- * They are protected by the sp->lock spinlock, which should be held
- * for any accesses to the tree.
+ *
+ * The rb-tree is locked using both a mutex and a spinlock. Every modification
+ * to the tree must hold both the mutex and the spinlock, lookups can hold
+ * either to observe a stable tree.
+ *
+ * In particular, sp_insert() and sp_delete() take the spinlock, whereas
+ * sp_lookup() doesn't, this so users have choice.
+ *
+ * shared_policy_replace() and mpol_free_shared_policy() take the mutex
+ * and call sp_insert(), sp_delete().
  */
 
 /* lookup first element intersecting start-end */
-/* Caller holds sp->mutex */
+/* Caller holds either sp->lock and/or sp->mutex */
 static struct sp_node *
 sp_lookup(struct shared_policy *sp, unsigned long start, unsigned long end)
 {
@@ -2130,6 +2138,7 @@ static void sp_insert(struct shared_poli
 	struct rb_node *parent = NULL;
 	struct sp_node *nd;
 
+	spin_lock(&sp->lock);
 	while (*p) {
 		parent = *p;
 		nd = rb_entry(parent, struct sp_node, nd);
@@ -2142,6 +2151,7 @@ static void sp_insert(struct shared_poli
 	}
 	rb_link_node(&new->nd, parent, p);
 	rb_insert_color(&new->nd, &sp->root);
+	spin_unlock(&sp->lock);
 	pr_debug("inserting %lx-%lx: %d\n", new->start, new->end,
 		 new->policy ? new->policy->mode : 0);
 }
@@ -2155,13 +2165,13 @@ mpol_shared_policy_lookup(struct shared_
 
 	if (!sp->root.rb_node)
 		return NULL;
-	mutex_lock(&sp->mutex);
+	spin_lock(&sp->lock);
 	sn = sp_lookup(sp, idx, idx+1);
 	if (sn) {
 		mpol_get(sn->policy);
 		pol = sn->policy;
 	}
-	mutex_unlock(&sp->mutex);
+	spin_unlock(&sp->lock);
 	return pol;
 }
 
@@ -2319,8 +2329,10 @@ out_keep_page:
 static void sp_delete(struct shared_policy *sp, struct sp_node *n)
 {
 	pr_debug("deleting %lx-l%lx\n", n->start, n->end);
+	spin_lock(&sp->lock);
 	rb_erase(&n->nd, &sp->root);
 	sp_free(n);
+	spin_unlock(&sp->lock);
 }
 
 static struct sp_node *sp_alloc(unsigned long start, unsigned long end,
@@ -2405,6 +2417,7 @@ void mpol_shared_policy_init(struct shar
 	int ret;
 
 	sp->root = RB_ROOT;		/* empty tree == default mempolicy */
+	spin_lock_init(&sp->lock);
 	mutex_init(&sp->mutex);
 
 	if (mpol) {
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree.patch
mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch
mm-highmem-remove-useless-pool_lock.patch
mm-highmem-remove-page_address_pool-list.patch
mm-highmem-remove-page_address_pool-list-v2.patch
mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-semc-alternatives-to-preempt_disable.patch

