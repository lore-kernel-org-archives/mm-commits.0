From: akpm@linux-foundation.org
Subject: + mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
 added to -mm tree
Date: Tue, 14 Oct 2014 13:14:05 -0700
Message-ID: <543d840d.vZmP4LMpbp09/Rpy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaJNUOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 16:14:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: take a css reference for each charged page
has been added to the -mm tree.  Its filename is
     mm-memcontrol-take-a-css-reference-for-each-charged-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-take-a-css-reference-for-each-charged-page.patch

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
Subject: mm: memcontrol: take a css reference for each charged page

Charges currently pin the css indirectly by playing tricks during
css_offline(): user pages stall the offlining process until all of them
have been reparented, whereas kmemcg acquires a keep-alive reference if
outstanding kernel pages are detected at that point.

In preparation for removing all this complexity, make the pinning explicit
and acquire a css references for every charged page.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h          |   26 ++++++++++++++++
 include/linux/percpu-refcount.h |   47 ++++++++++++++++++++++++------
 mm/memcontrol.c                 |   21 ++++++++++---
 3 files changed, 81 insertions(+), 13 deletions(-)

diff -puN include/linux/cgroup.h~mm-memcontrol-take-a-css-reference-for-each-charged-page include/linux/cgroup.h
--- a/include/linux/cgroup.h~mm-memcontrol-take-a-css-reference-for-each-charged-page
+++ a/include/linux/cgroup.h
@@ -113,6 +113,19 @@ static inline void css_get(struct cgroup
 }
 
 /**
+ * css_get_many - obtain references on the specified css
+ * @css: target css
+ * @n: number of references to get
+ *
+ * The caller must already have a reference.
+ */
+static inline void css_get_many(struct cgroup_subsys_state *css, unsigned int n)
+{
+	if (!(css->flags & CSS_NO_REF))
+		percpu_ref_get_many(&css->refcnt, n);
+}
+
+/**
  * css_tryget - try to obtain a reference on the specified css
  * @css: target css
  *
@@ -159,6 +172,19 @@ static inline void css_put(struct cgroup
 		percpu_ref_put(&css->refcnt);
 }
 
+/**
+ * css_put_many - put css references
+ * @css: target css
+ * @n: number of references to put
+ *
+ * Put references obtained via css_get() and css_tryget_online().
+ */
+static inline void css_put_many(struct cgroup_subsys_state *css, unsigned int n)
+{
+	if (!(css->flags & CSS_NO_REF))
+		percpu_ref_put_many(&css->refcnt, n);
+}
+
 /* bits in struct cgroup flags field */
 enum {
 	/* Control Group requires release notifications to userspace */
diff -puN include/linux/percpu-refcount.h~mm-memcontrol-take-a-css-reference-for-each-charged-page include/linux/percpu-refcount.h
--- a/include/linux/percpu-refcount.h~mm-memcontrol-take-a-css-reference-for-each-charged-page
+++ a/include/linux/percpu-refcount.h
@@ -141,28 +141,42 @@ static inline bool __ref_is_percpu(struc
 }
 
 /**
- * percpu_ref_get - increment a percpu refcount
+ * percpu_ref_get_many - increment a percpu refcount
  * @ref: percpu_ref to get
+ * @nr: number of references to get
  *
- * Analagous to atomic_long_inc().
+ * Analogous to atomic_long_add().
  *
  * This function is safe to call as long as @ref is between init and exit.
  */
-static inline void percpu_ref_get(struct percpu_ref *ref)
+static inline void percpu_ref_get_many(struct percpu_ref *ref, unsigned long nr)
 {
 	unsigned long __percpu *percpu_count;
 
 	rcu_read_lock_sched();
 
 	if (__ref_is_percpu(ref, &percpu_count))
-		this_cpu_inc(*percpu_count);
+		this_cpu_add(*percpu_count, nr);
 	else
-		atomic_long_inc(&ref->count);
+		atomic_long_add(nr, &ref->count);
 
 	rcu_read_unlock_sched();
 }
 
 /**
+ * percpu_ref_get - increment a percpu refcount
+ * @ref: percpu_ref to get
+ *
+ * Analagous to atomic_long_inc().
+ *
+ * This function is safe to call as long as @ref is between init and exit.
+ */
+static inline void percpu_ref_get(struct percpu_ref *ref)
+{
+	percpu_ref_get_many(ref, 1);
+}
+
+/**
  * percpu_ref_tryget - try to increment a percpu refcount
  * @ref: percpu_ref to try-get
  *
@@ -225,29 +239,44 @@ static inline bool percpu_ref_tryget_liv
 }
 
 /**
- * percpu_ref_put - decrement a percpu refcount
+ * percpu_ref_put_many - decrement a percpu refcount
  * @ref: percpu_ref to put
+ * @nr: number of references to put
  *
  * Decrement the refcount, and if 0, call the release function (which was passed
  * to percpu_ref_init())
  *
  * This function is safe to call as long as @ref is between init and exit.
  */
-static inline void percpu_ref_put(struct percpu_ref *ref)
+static inline void percpu_ref_put_many(struct percpu_ref *ref, unsigned long nr)
 {
 	unsigned long __percpu *percpu_count;
 
 	rcu_read_lock_sched();
 
 	if (__ref_is_percpu(ref, &percpu_count))
-		this_cpu_dec(*percpu_count);
-	else if (unlikely(atomic_long_dec_and_test(&ref->count)))
+		this_cpu_sub(*percpu_count, nr);
+	else if (unlikely(atomic_long_sub_and_test(nr, &ref->count)))
 		ref->release(ref);
 
 	rcu_read_unlock_sched();
 }
 
 /**
+ * percpu_ref_put - decrement a percpu refcount
+ * @ref: percpu_ref to put
+ *
+ * Decrement the refcount, and if 0, call the release function (which was passed
+ * to percpu_ref_init())
+ *
+ * This function is safe to call as long as @ref is between init and exit.
+ */
+static inline void percpu_ref_put(struct percpu_ref *ref)
+{
+	percpu_ref_put_many(ref, 1);
+}
+
+/**
  * percpu_ref_is_zero - test whether a percpu refcount reached zero
  * @ref: percpu_ref to test
  *
diff -puN mm/memcontrol.c~mm-memcontrol-take-a-css-reference-for-each-charged-page mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-take-a-css-reference-for-each-charged-page
+++ a/mm/memcontrol.c
@@ -2256,6 +2256,7 @@ static void drain_stock(struct memcg_sto
 		page_counter_uncharge(&old->memory, stock->nr_pages);
 		if (do_swap_account)
 			page_counter_uncharge(&old->memsw, stock->nr_pages);
+		css_put_many(&old->css, stock->nr_pages);
 		stock->nr_pages = 0;
 	}
 	stock->cached = NULL;
@@ -2513,6 +2514,7 @@ bypass:
 	return -EINTR;
 
 done_restock:
+	css_get_many(&memcg->css, batch);
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 done:
@@ -2527,6 +2529,8 @@ static void cancel_charge(struct mem_cgr
 	page_counter_uncharge(&memcg->memory, nr_pages);
 	if (do_swap_account)
 		page_counter_uncharge(&memcg->memsw, nr_pages);
+
+	css_put_many(&memcg->css, nr_pages);
 }
 
 /*
@@ -2722,6 +2726,7 @@ static int memcg_charge_kmem(struct mem_
 		page_counter_charge(&memcg->memory, nr_pages);
 		if (do_swap_account)
 			page_counter_charge(&memcg->memsw, nr_pages);
+		css_get_many(&memcg->css, nr_pages);
 		ret = 0;
 	} else if (ret)
 		page_counter_uncharge(&memcg->kmem, nr_pages);
@@ -2737,8 +2742,10 @@ static void memcg_uncharge_kmem(struct m
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 
 	/* Not down to 0 */
-	if (page_counter_uncharge(&memcg->kmem, nr_pages))
+	if (page_counter_uncharge(&memcg->kmem, nr_pages)) {
+		css_put_many(&memcg->css, nr_pages);
 		return;
+	}
 
 	/*
 	 * Releases a reference taken in kmem_cgroup_css_offline in case
@@ -2750,6 +2757,8 @@ static void memcg_uncharge_kmem(struct m
 	 */
 	if (memcg_kmem_test_and_clear_dead(memcg))
 		css_put(&memcg->css);
+
+	css_put_many(&memcg->css, nr_pages);
 }
 
 /*
@@ -3377,10 +3386,13 @@ static int mem_cgroup_move_parent(struct
 	ret = mem_cgroup_move_account(page, nr_pages,
 				pc, child, parent);
 	if (!ret) {
+		if (!mem_cgroup_is_root(parent))
+			css_get_many(&parent->css, nr_pages);
 		/* Take charge off the local counters */
 		page_counter_cancel(&child->memory, nr_pages);
 		if (do_swap_account)
 			page_counter_cancel(&child->memsw, nr_pages);
+		css_put_many(&child->css, nr_pages);
 	}
 
 	if (nr_pages > 1)
@@ -5750,7 +5762,6 @@ static void __mem_cgroup_clear_mc(void)
 {
 	struct mem_cgroup *from = mc.from;
 	struct mem_cgroup *to = mc.to;
-	int i;
 
 	/* we must uncharge all the leftover precharges from mc.to */
 	if (mc.precharge) {
@@ -5778,8 +5789,7 @@ static void __mem_cgroup_clear_mc(void)
 		if (!mem_cgroup_is_root(mc.to))
 			page_counter_uncharge(&mc.to->memory, mc.moved_swap);
 
-		for (i = 0; i < mc.moved_swap; i++)
-			css_put(&mc.from->css);
+		css_put_many(&mc.from->css, mc.moved_swap);
 
 		/* we've already done css_get(mc.to) */
 		mc.moved_swap = 0;
@@ -6326,6 +6336,9 @@ static void uncharge_batch(struct mem_cg
 	__this_cpu_add(memcg->stat->nr_page_events, nr_anon + nr_file);
 	memcg_check_events(memcg, dummy_page);
 	local_irq_restore(flags);
+
+	if (!mem_cgroup_is_root(memcg))
+		css_put_many(&memcg->css, max(nr_mem, nr_memsw));
 }
 
 static void uncharge_list(struct list_head *page_list)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-memcontrol-lockless-page-counters.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
debugging-keep-track-of-page-owners.patch

