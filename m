From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_counter-let-page_counter_try_charge-return-bool.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:17:14 -0800
Message-ID: <563d0aca.MmrjxLDJeyFQrYBA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162924AbbKFURO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_counter: let page_counter_try_charge() return bool
has been removed from the -mm tree.  Its filename was
     mm-page_counter-let-page_counter_try_charge-return-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_counter: let page_counter_try_charge() return bool

page_counter_try_charge() currently returns 0 on success and -ENOMEM on
failure, which is surprising behavior given the function name.

Make it follow the expected pattern of try_stuff() functions that return a
boolean true to indicate success, or false for failure.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_counter.h |    6 +++---
 mm/hugetlb_cgroup.c          |    3 ++-
 mm/memcontrol.c              |   11 +++++------
 mm/page_counter.c            |   14 +++++++-------
 4 files changed, 17 insertions(+), 17 deletions(-)

diff -puN include/linux/page_counter.h~mm-page_counter-let-page_counter_try_charge-return-bool include/linux/page_counter.h
--- a/include/linux/page_counter.h~mm-page_counter-let-page_counter_try_charge-return-bool
+++ a/include/linux/page_counter.h
@@ -36,9 +36,9 @@ static inline unsigned long page_counter
 
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
-int page_counter_try_charge(struct page_counter *counter,
-			    unsigned long nr_pages,
-			    struct page_counter **fail);
+bool page_counter_try_charge(struct page_counter *counter,
+			     unsigned long nr_pages,
+			     struct page_counter **fail);
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 int page_counter_limit(struct page_counter *counter, unsigned long limit);
 int page_counter_memparse(const char *buf, const char *max,
diff -puN mm/hugetlb_cgroup.c~mm-page_counter-let-page_counter_try_charge-return-bool mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-page_counter-let-page_counter_try_charge-return-bool
+++ a/mm/hugetlb_cgroup.c
@@ -186,7 +186,8 @@ again:
 	}
 	rcu_read_unlock();
 
-	ret = page_counter_try_charge(&h_cg->hugepage[idx], nr_pages, &counter);
+	if (!page_counter_try_charge(&h_cg->hugepage[idx], nr_pages, &counter))
+		ret = -ENOMEM;
 	css_put(&h_cg->css);
 done:
 	*ptr = h_cg;
diff -puN mm/memcontrol.c~mm-page_counter-let-page_counter_try_charge-return-bool mm/memcontrol.c
--- a/mm/memcontrol.c~mm-page_counter-let-page_counter_try_charge-return-bool
+++ a/mm/memcontrol.c
@@ -2016,8 +2016,8 @@ retry:
 		return 0;
 
 	if (!do_swap_account ||
-	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (!page_counter_try_charge(&memcg->memory, batch, &counter))
+	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
+		if (page_counter_try_charge(&memcg->memory, batch, &counter))
 			goto done_restock;
 		if (do_swap_account)
 			page_counter_uncharge(&memcg->memsw, batch);
@@ -2381,14 +2381,13 @@ int __memcg_kmem_charge_memcg(struct pag
 {
 	unsigned int nr_pages = 1 << order;
 	struct page_counter *counter;
-	int ret = 0;
+	int ret;
 
 	if (!memcg_kmem_is_active(memcg))
 		return 0;
 
-	ret = page_counter_try_charge(&memcg->kmem, nr_pages, &counter);
-	if (ret)
-		return ret;
+	if (!page_counter_try_charge(&memcg->kmem, nr_pages, &counter))
+		return -ENOMEM;
 
 	ret = try_charge(memcg, gfp, nr_pages);
 	if (ret) {
diff -puN mm/page_counter.c~mm-page_counter-let-page_counter_try_charge-return-bool mm/page_counter.c
--- a/mm/page_counter.c~mm-page_counter-let-page_counter_try_charge-return-bool
+++ a/mm/page_counter.c
@@ -56,12 +56,12 @@ void page_counter_charge(struct page_cou
  * @nr_pages: number of pages to charge
  * @fail: points first counter to hit its limit, if any
  *
- * Returns 0 on success, or -ENOMEM and @fail if the counter or one of
- * its ancestors has hit its configured limit.
+ * Returns %true on success, or %false and @fail if the counter or one
+ * of its ancestors has hit its configured limit.
  */
-int page_counter_try_charge(struct page_counter *counter,
-			    unsigned long nr_pages,
-			    struct page_counter **fail)
+bool page_counter_try_charge(struct page_counter *counter,
+			     unsigned long nr_pages,
+			     struct page_counter **fail)
 {
 	struct page_counter *c;
 
@@ -99,13 +99,13 @@ int page_counter_try_charge(struct page_
 		if (new > c->watermark)
 			c->watermark = new;
 	}
-	return 0;
+	return true;
 
 failed:
 	for (c = counter; c != *fail; c = c->parent)
 		page_counter_cancel(c, nr_pages);
 
-	return -ENOMEM;
+	return false;
 }
 
 /**
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix.patch

