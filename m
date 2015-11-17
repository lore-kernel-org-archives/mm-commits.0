From: akpm@linux-foundation.org
Subject: + mempolicy-convert-the-shared_policy-lock-to-a-rwlock.patch
 added to -mm tree
Date: Tue, 17 Nov 2015 13:58:57 -0800
Message-ID: <564ba321.r72PWPr1AKijbHlk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbKQV66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:58:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, aneesh.kumar@linux.vnet.ibm.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, nyc@holomorphy.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: convert the shared_policy lock to a rwlock
has been added to the -mm tree.  Its filename is
     mempolicy-convert-the-shared_policy-lock-to-a-rwlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempolicy-convert-the-shared_policy-lock-to-a-rwlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempolicy-convert-the-shared_policy-lock-to-a-rwlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: mm/mempolicy.c: convert the shared_policy lock to a rwlock

When running the SPECint_rate gcc on some very large boxes it was noticed
that the system was spending lots of time in mpol_shared_policy_lookup(). 
The gamess benchmark can also show it and is what I mostly used to chase
down the issue since the setup for that I found to be easier.

To be clear the binaries were on tmpfs because of disk I/O requirements. 
We then used text replication to avoid icache misses and having all the
copies banging on the memory where the instruction code resides.  This
results in us hitting a bottleneck in mpol_shared_policy_lookup() since
lookup is serialised by the shared_policy lock.

I have only reproduced this on very large (3k+ cores) boxes.  The problem
starts showing up at just a few hundred ranks getting worse until it
threatens to livelock once it gets large enough.  For example on the
gamess benchmark at 128 ranks this area consumes only ~1% of time, at 512
ranks it consumes nearly 13%, and at 2k ranks it is over 90%.

To alleviate the contention in this area I converted the spinlock to an
rwlock.  This allows a large number of lookups to happen simultaneously. 
The results were quite good reducing this consumtion at max ranks to
around 2%.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c      |    2 +-
 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |   20 ++++++++++----------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mempolicy-convert-the-shared_policy-lock-to-a-rwlock fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mempolicy-convert-the-shared_policy-lock-to-a-rwlock
+++ a/fs/hugetlbfs/inode.c
@@ -739,7 +739,7 @@ static struct inode *hugetlbfs_get_inode
 		/*
 		 * The policy is initialized here even if we are creating a
 		 * private inode because initialization simply creates an
-		 * an empty rb tree and calls spin_lock_init(), later when we
+		 * an empty rb tree and calls rwlock_init(), later when we
 		 * call mpol_free_shared_policy() it will just return because
 		 * the rb tree will still be empty.
 		 */
diff -puN include/linux/mempolicy.h~mempolicy-convert-the-shared_policy-lock-to-a-rwlock include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-convert-the-shared_policy-lock-to-a-rwlock
+++ a/include/linux/mempolicy.h
@@ -122,7 +122,7 @@ struct sp_node {
 
 struct shared_policy {
 	struct rb_root root;
-	spinlock_t lock;
+	rwlock_t lock;
 };
 
 int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst);
diff -puN mm/mempolicy.c~mempolicy-convert-the-shared_policy-lock-to-a-rwlock mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-convert-the-shared_policy-lock-to-a-rwlock
+++ a/mm/mempolicy.c
@@ -2142,7 +2142,7 @@ bool __mpol_equal(struct mempolicy *a, s
  *
  * Remember policies even when nobody has shared memory mapped.
  * The policies are kept in Red-Black tree linked from the inode.
- * They are protected by the sp->lock spinlock, which should be held
+ * They are protected by the sp->lock rwlock, which should be held
  * for any accesses to the tree.
  */
 
@@ -2179,7 +2179,7 @@ sp_lookup(struct shared_policy *sp, unsi
 }
 
 /* Insert a new shared policy into the list. */
-/* Caller holds sp->lock */
+/* Caller holds the write of sp->lock */
 static void sp_insert(struct shared_policy *sp, struct sp_node *new)
 {
 	struct rb_node **p = &sp->root.rb_node;
@@ -2211,13 +2211,13 @@ mpol_shared_policy_lookup(struct shared_
 
 	if (!sp->root.rb_node)
 		return NULL;
-	spin_lock(&sp->lock);
+	read_lock(&sp->lock);
 	sn = sp_lookup(sp, idx, idx+1);
 	if (sn) {
 		mpol_get(sn->policy);
 		pol = sn->policy;
 	}
-	spin_unlock(&sp->lock);
+	read_unlock(&sp->lock);
 	return pol;
 }
 
@@ -2360,7 +2360,7 @@ static int shared_policy_replace(struct
 	int ret = 0;
 
 restart:
-	spin_lock(&sp->lock);
+	write_lock(&sp->lock);
 	n = sp_lookup(sp, start, end);
 	/* Take care of old policies in the same range. */
 	while (n && n->start < end) {
@@ -2393,7 +2393,7 @@ restart:
 	}
 	if (new)
 		sp_insert(sp, new);
-	spin_unlock(&sp->lock);
+	write_unlock(&sp->lock);
 	ret = 0;
 
 err_out:
@@ -2405,7 +2405,7 @@ err_out:
 	return ret;
 
 alloc_new:
-	spin_unlock(&sp->lock);
+	write_unlock(&sp->lock);
 	ret = -ENOMEM;
 	n_new = kmem_cache_alloc(sn_cache, GFP_KERNEL);
 	if (!n_new)
@@ -2431,7 +2431,7 @@ void mpol_shared_policy_init(struct shar
 	int ret;
 
 	sp->root = RB_ROOT;		/* empty tree == default mempolicy */
-	spin_lock_init(&sp->lock);
+	rwlock_init(&sp->lock);
 
 	if (mpol) {
 		struct vm_area_struct pvma;
@@ -2497,14 +2497,14 @@ void mpol_free_shared_policy(struct shar
 
 	if (!p->root.rb_node)
 		return;
-	spin_lock(&p->lock);
+	write_lock(&p->lock);
 	next = rb_first(&p->root);
 	while (next) {
 		n = rb_entry(next, struct sp_node, nd);
 		next = rb_next(&n->nd);
 		sp_delete(p, n);
 	}
-	spin_unlock(&p->lock);
+	write_unlock(&p->lock);
 }
 
 #ifdef CONFIG_NUMA_BALANCING
_

Patches currently in -mm which might be from nzimmer@sgi.com are

mempolicy-convert-the-shared_policy-lock-to-a-rwlock.patch

