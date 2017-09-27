From: akpm@linux-foundation.org
Subject: + mm-make-count-list_lru_one-nr_items-lockless.patch added to -mm tree
Date: Wed, 27 Sep 2017 14:19:58 -0700
Message-ID: <59cc15fe.XeUSUjBEjAQ5qAKb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbdI0VT7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 17:19:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ktkhai@virtuozzo.com, apolyakov@beget.ru, aryabinin@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make counting of list_lru_one::nr_items lockless
has been added to the -mm tree.  Its filename is
     mm-make-count-list_lru_one-nr_items-lockless.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-count-list_lru_one-nr_items-lockless.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-count-list_lru_one-nr_items-lockless.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: mm: make counting of list_lru_one::nr_items lockless

During the reclaiming slab of a memcg, shrink_slab iterates over all
registered shrinkers in the system, and tries to count and consume objects
related to the cgroup.  In case of memory pressure, this behaves bad: I
observe high system time and time spent in list_lru_count_one() for many
processes on RHEL7 kernel (collected via $perf record --call-graph fp -j k
-a):

0,50%  nixstatsagent  [kernel.vmlinux]  [k] _raw_spin_lock                [k] _raw_spin_lock
0,26%  nixstatsagent  [kernel.vmlinux]  [k] shrink_slab                   [k] shrink_slab
0,23%  nixstatsagent  [kernel.vmlinux]  [k] super_cache_count             [k] super_cache_count
0,15%  nixstatsagent  [kernel.vmlinux]  [k] __list_lru_count_one.isra.2   [k] _raw_spin_lock
0,15%  nixstatsagent  [kernel.vmlinux]  [k] list_lru_count_one            [k] __list_lru_count_one.isra.2

0,94%  mysqld         [kernel.vmlinux]  [k] _raw_spin_lock                [k] _raw_spin_lock
0,57%  mysqld         [kernel.vmlinux]  [k] shrink_slab                   [k] shrink_slab
0,51%  mysqld         [kernel.vmlinux]  [k] super_cache_count             [k] super_cache_count
0,32%  mysqld         [kernel.vmlinux]  [k] __list_lru_count_one.isra.2   [k] _raw_spin_lock
0,32%  mysqld         [kernel.vmlinux]  [k] list_lru_count_one            [k] __list_lru_count_one.isra.2

0,73%  sshd           [kernel.vmlinux]  [k] _raw_spin_lock                [k] _raw_spin_lock
0,35%  sshd           [kernel.vmlinux]  [k] shrink_slab                   [k] shrink_slab
0,32%  sshd           [kernel.vmlinux]  [k] super_cache_count             [k] super_cache_count
0,21%  sshd           [kernel.vmlinux]  [k] __list_lru_count_one.isra.2   [k] _raw_spin_lock
0,21%  sshd           [kernel.vmlinux]  [k] list_lru_count_one            [k] __list_lru_count_one.isra.2

This patch aims to make super_cache_count() (and other functions, which
count LRU nr_items) more effective.  It allows list_lru_node::memcg_lrus
to be RCU-accessed, and makes __list_lru_count_one() count nr_items
lockless to minimize overhead introduced by locking operation, and to make
parallel reclaims more scalable.

Link: http://lkml.kernel.org/r/150583358557.26700.8490036563698102569.stgit@localhost.localdomain
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Alexander Polakov <apolyakov@beget.ru>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |    3 +
 mm/list_lru.c            |   59 +++++++++++++++++++++++--------------
 2 files changed, 39 insertions(+), 23 deletions(-)

diff -puN include/linux/list_lru.h~mm-make-count-list_lru_one-nr_items-lockless include/linux/list_lru.h
--- a/include/linux/list_lru.h~mm-make-count-list_lru_one-nr_items-lockless
+++ a/include/linux/list_lru.h
@@ -31,6 +31,7 @@ struct list_lru_one {
 };
 
 struct list_lru_memcg {
+	struct rcu_head		rcu;
 	/* array of per cgroup lists, indexed by memcg_cache_id */
 	struct list_lru_one	*lru[0];
 };
@@ -42,7 +43,7 @@ struct list_lru_node {
 	struct list_lru_one	lru;
 #if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 	/* for cgroup aware lrus points to per cgroup lists, otherwise NULL */
-	struct list_lru_memcg	*memcg_lrus;
+	struct list_lru_memcg	__rcu *memcg_lrus;
 #endif
 	long nr_items;
 } ____cacheline_aligned_in_smp;
diff -puN mm/list_lru.c~mm-make-count-list_lru_one-nr_items-lockless mm/list_lru.c
--- a/mm/list_lru.c~mm-make-count-list_lru_one-nr_items-lockless
+++ a/mm/list_lru.c
@@ -52,14 +52,15 @@ static inline bool list_lru_memcg_aware(
 static inline struct list_lru_one *
 list_lru_from_memcg_idx(struct list_lru_node *nlru, int idx)
 {
+	struct list_lru_memcg *memcg_lrus;
 	/*
-	 * The lock protects the array of per cgroup lists from relocation
-	 * (see memcg_update_list_lru_node).
+	 * Either lock or RCU protects the array of per cgroup lists
+	 * from relocation (see memcg_update_list_lru_node).
 	 */
-	lockdep_assert_held(&nlru->lock);
-	if (nlru->memcg_lrus && idx >= 0)
-		return nlru->memcg_lrus->lru[idx];
-
+	memcg_lrus = rcu_dereference_check(nlru->memcg_lrus,
+					   lockdep_is_held(&nlru->lock));
+	if (memcg_lrus && idx >= 0)
+		return memcg_lrus->lru[idx];
 	return &nlru->lru;
 }
 
@@ -168,10 +169,10 @@ static unsigned long __list_lru_count_on
 	struct list_lru_one *l;
 	unsigned long count;
 
-	spin_lock(&nlru->lock);
+	rcu_read_lock();
 	l = list_lru_from_memcg_idx(nlru, memcg_idx);
 	count = l->nr_items;
-	spin_unlock(&nlru->lock);
+	rcu_read_unlock();
 
 	return count;
 }
@@ -323,24 +324,33 @@ fail:
 
 static int memcg_init_list_lru_node(struct list_lru_node *nlru)
 {
+	struct list_lru_memcg *memcg_lrus;
 	int size = memcg_nr_cache_ids;
 
-	nlru->memcg_lrus = kmalloc(size * sizeof(void *), GFP_KERNEL);
-	if (!nlru->memcg_lrus)
+	memcg_lrus = kmalloc(sizeof(*memcg_lrus) +
+			     size * sizeof(void *), GFP_KERNEL);
+	if (!memcg_lrus)
 		return -ENOMEM;
 
-	if (__memcg_init_list_lru_node(nlru->memcg_lrus, 0, size)) {
-		kfree(nlru->memcg_lrus);
+	if (__memcg_init_list_lru_node(memcg_lrus, 0, size)) {
+		kfree(memcg_lrus);
 		return -ENOMEM;
 	}
+	RCU_INIT_POINTER(nlru->memcg_lrus, memcg_lrus);
 
 	return 0;
 }
 
 static void memcg_destroy_list_lru_node(struct list_lru_node *nlru)
 {
-	__memcg_destroy_list_lru_node(nlru->memcg_lrus, 0, memcg_nr_cache_ids);
-	kfree(nlru->memcg_lrus);
+	struct list_lru_memcg *memcg_lrus;
+	/*
+	 * This is called when shrinker has already been unregistered,
+	 * and nobody can use it. So, there is no need to use kfree_rcu().
+	 */
+	memcg_lrus = rcu_dereference_protected(nlru->memcg_lrus, true);
+	__memcg_destroy_list_lru_node(memcg_lrus, 0, memcg_nr_cache_ids);
+	kfree(memcg_lrus);
 }
 
 static int memcg_update_list_lru_node(struct list_lru_node *nlru,
@@ -350,8 +360,9 @@ static int memcg_update_list_lru_node(st
 
 	BUG_ON(old_size > new_size);
 
-	old = nlru->memcg_lrus;
-	new = kmalloc(new_size * sizeof(void *), GFP_KERNEL);
+	old = rcu_dereference_protected(nlru->memcg_lrus,
+					lockdep_is_held(&list_lrus_mutex));
+	new = kmalloc(sizeof(*new) + new_size * sizeof(void *), GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
 
@@ -360,29 +371,33 @@ static int memcg_update_list_lru_node(st
 		return -ENOMEM;
 	}
 
-	memcpy(new, old, old_size * sizeof(void *));
+	memcpy(&new->lru, &old->lru, old_size * sizeof(void *));
 
 	/*
-	 * The lock guarantees that we won't race with a reader
-	 * (see list_lru_from_memcg_idx).
+	 * The locking below allows readers that hold nlru->lock avoid taking
+	 * rcu_read_lock (see list_lru_from_memcg_idx).
 	 *
 	 * Since list_lru_{add,del} may be called under an IRQ-safe lock,
 	 * we have to use IRQ-safe primitives here to avoid deadlock.
 	 */
 	spin_lock_irq(&nlru->lock);
-	nlru->memcg_lrus = new;
+	rcu_assign_pointer(nlru->memcg_lrus, new);
 	spin_unlock_irq(&nlru->lock);
 
-	kfree(old);
+	kfree_rcu(old, rcu);
 	return 0;
 }
 
 static void memcg_cancel_update_list_lru_node(struct list_lru_node *nlru,
 					      int old_size, int new_size)
 {
+	struct list_lru_memcg *memcg_lrus;
+
+	memcg_lrus = rcu_dereference_protected(nlru->memcg_lrus,
+					       lockdep_is_held(&list_lrus_mutex));
 	/* do not bother shrinking the array back to the old size, because we
 	 * cannot handle allocation failures here */
-	__memcg_destroy_list_lru_node(nlru->memcg_lrus, old_size, new_size);
+	__memcg_destroy_list_lru_node(memcg_lrus, old_size, new_size);
 }
 
 static int memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
_

Patches currently in -mm which might be from ktkhai@virtuozzo.com are

ksm-fix-unlocked-iteration-over-vmas-in-cmp_and_merge_page.patch
mm-make-count-list_lru_one-nr_items-lockless.patch

