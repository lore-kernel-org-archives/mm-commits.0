From: akpm@linux-foundation.org
Subject: + mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch added to -mm tree
Date: Tue, 14 Oct 2014 13:14:06 -0700
Message-ID: <543d840e.9A/7w4yrWfgWDgan%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbaJNUOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 16:14:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove obsolete kmemcg pinning tricks
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch

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
Subject: mm: memcontrol: remove obsolete kmemcg pinning tricks

As charges now pin the css explicitely, there is no more need for kmemcg
to acquire a proxy reference for outstanding pages during offlining, or
maintain state to identify such "dead" groups.

This was the last user of the uncharge functions' return values, so remove
them as well.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    4 -
 mm/memcontrol.c              |   74 ---------------------------------
 mm/page_counter.c            |   23 +---------
 3 files changed, 7 insertions(+), 94 deletions(-)

diff -puN include/linux/page_counter.h~mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks include/linux/page_counter.h
--- a/include/linux/page_counter.h~mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks
+++ a/include/linux/page_counter.h
@@ -32,12 +32,12 @@ static inline unsigned long page_counter
 	return atomic_long_read(&counter->count);
 }
 
-int page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
+void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 int page_counter_try_charge(struct page_counter *counter,
 			    unsigned long nr_pages,
 			    struct page_counter **fail);
-int page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
+void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 int page_counter_limit(struct page_counter *counter, unsigned long limit);
 int page_counter_memparse(const char *buf, unsigned long *nr_pages);
 
diff -puN mm/memcontrol.c~mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks
+++ a/mm/memcontrol.c
@@ -369,7 +369,6 @@ struct mem_cgroup {
 /* internal only representation about the status of kmem accounting. */
 enum {
 	KMEM_ACCOUNTED_ACTIVE, /* accounted by this cgroup itself */
-	KMEM_ACCOUNTED_DEAD, /* dead memcg with pending kmem charges */
 };
 
 #ifdef CONFIG_MEMCG_KMEM
@@ -383,22 +382,6 @@ static bool memcg_kmem_is_active(struct
 	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
 
-static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
-{
-	/*
-	 * Our caller must use css_get() first, because memcg_uncharge_kmem()
-	 * will call css_put() if it sees the memcg is dead.
-	 */
-	smp_wmb();
-	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags))
-		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_account_flags);
-}
-
-static bool memcg_kmem_test_and_clear_dead(struct mem_cgroup *memcg)
-{
-	return test_and_clear_bit(KMEM_ACCOUNTED_DEAD,
-				  &memcg->kmem_account_flags);
-}
 #endif
 
 /* Stuffs for move charges at task migration. */
@@ -2741,22 +2724,7 @@ static void memcg_uncharge_kmem(struct m
 	if (do_swap_account)
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 
-	/* Not down to 0 */
-	if (page_counter_uncharge(&memcg->kmem, nr_pages)) {
-		css_put_many(&memcg->css, nr_pages);
-		return;
-	}
-
-	/*
-	 * Releases a reference taken in kmem_cgroup_css_offline in case
-	 * this last uncharge is racing with the offlining code or it is
-	 * outliving the memcg existence.
-	 *
-	 * The memory barrier imposed by test&clear is paired with the
-	 * explicit one in memcg_kmem_mark_dead().
-	 */
-	if (memcg_kmem_test_and_clear_dead(memcg))
-		css_put(&memcg->css);
+	page_counter_uncharge(&memcg->kmem, nr_pages);
 
 	css_put_many(&memcg->css, nr_pages);
 }
@@ -4740,40 +4708,6 @@ static void memcg_destroy_kmem(struct me
 {
 	mem_cgroup_sockets_destroy(memcg);
 }
-
-static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
-{
-	if (!memcg_kmem_is_active(memcg))
-		return;
-
-	/*
-	 * kmem charges can outlive the cgroup. In the case of slab
-	 * pages, for instance, a page contain objects from various
-	 * processes. As we prevent from taking a reference for every
-	 * such allocation we have to be careful when doing uncharge
-	 * (see memcg_uncharge_kmem) and here during offlining.
-	 *
-	 * The idea is that that only the _last_ uncharge which sees
-	 * the dead memcg will drop the last reference. An additional
-	 * reference is taken here before the group is marked dead
-	 * which is then paired with css_put during uncharge resp. here.
-	 *
-	 * Although this might sound strange as this path is called from
-	 * css_offline() when the referencemight have dropped down to 0 and
-	 * shouldn't be incremented anymore (css_tryget_online() would
-	 * fail) we do not have other options because of the kmem
-	 * allocations lifetime.
-	 */
-	css_get(&memcg->css);
-
-	memcg_kmem_mark_dead(memcg);
-
-	if (page_counter_read(&memcg->kmem))
-		return;
-
-	if (memcg_kmem_test_and_clear_dead(memcg))
-		css_put(&memcg->css);
-}
 #else
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
@@ -4783,10 +4717,6 @@ static int memcg_init_kmem(struct mem_cg
 static void memcg_destroy_kmem(struct mem_cgroup *memcg)
 {
 }
-
-static void kmem_cgroup_css_offline(struct mem_cgroup *memcg)
-{
-}
 #endif
 
 /*
@@ -5390,8 +5320,6 @@ static void mem_cgroup_css_offline(struc
 	}
 	spin_unlock(&memcg->event_list_lock);
 
-	kmem_cgroup_css_offline(memcg);
-
 	/*
 	 * This requires that offlining is serialized.  Right now that is
 	 * guaranteed because css_killed_work_fn() holds the cgroup_mutex.
diff -puN mm/page_counter.c~mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks mm/page_counter.c
--- a/mm/page_counter.c~mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks
+++ a/mm/page_counter.c
@@ -14,19 +14,14 @@
  * page_counter_cancel - take pages out of the local counter
  * @counter: counter
  * @nr_pages: number of pages to cancel
- *
- * Returns whether there are remaining pages in the counter.
  */
-int page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
+void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
 {
 	long new;
 
 	new = atomic_long_sub_return(nr_pages, &counter->count);
-
 	/* More uncharges than charges? */
 	WARN_ON_ONCE(new < 0);
-
-	return new > 0;
 }
 
 /**
@@ -115,23 +110,13 @@ failed:
  * page_counter_uncharge - hierarchically uncharge pages
  * @counter: counter
  * @nr_pages: number of pages to uncharge
- *
- * Returns whether there are remaining charges in @counter.
  */
-int page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages)
+void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages)
 {
 	struct page_counter *c;
-	int ret = 1;
 
-	for (c = counter; c; c = c->parent) {
-		int remainder;
-
-		remainder = page_counter_cancel(c, nr_pages);
-		if (c == counter && !remainder)
-			ret = 0;
-	}
