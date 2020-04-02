From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 142/155] hugetlb_cgroup: add interface for
 charge/uncharge hugetlb reservations
Date: Wed, 01 Apr 2020 21:11:15 -0700
Message-ID: <20200402041115.Pg_TV1gbu%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBELT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:11:19 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, almasrymina@google.com, gthelen@google.com, linux-mm@kvack.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, sandipan@linux.ibm.com, shakeelb@google.com, shuah@kernel.org, torvalds@linux-foundation.org

From: Mina Almasry <almasrymina@google.com>
Subject: hugetlb_cgroup: add interface for charge/uncharge hugetlb reservations

Augments hugetlb_cgroup_charge_cgroup to be able to charge hugetlb usage
or hugetlb reservation counter.

Adds a new interface to uncharge a hugetlb_cgroup counter via
hugetlb_cgroup_uncharge_counter.

Integrates the counter with hugetlb_cgroup, via hugetlb_cgroup_init,
hugetlb_cgroup_have_usage, and hugetlb_cgroup_css_offline.

Link: http://lkml.kernel.org/r/20200211213128.73302-2-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |  123 ++++++++++++++++++---
 mm/hugetlb.c                   |    2 
 mm/hugetlb_cgroup.c            |  174 +++++++++++++++++++++++++------
 3 files changed, 251 insertions(+), 48 deletions(-)

--- a/include/linux/hugetlb_cgroup.h~hugetlb_cgroup-add-interface-for-charge-uncharge-hugetlb-reservations
+++ a/include/linux/hugetlb_cgroup.h
@@ -20,32 +20,64 @@
 struct hugetlb_cgroup;
 /*
  * Minimum page order trackable by hugetlb cgroup.
- * At least 3 pages are necessary for all the tracking information.
+ * At least 4 pages are necessary for all the tracking information.
+ * The second tail page (hpage[2]) is the fault usage cgroup.
+ * The third tail page (hpage[3]) is the reservation usage cgroup.
  */
 #define HUGETLB_CGROUP_MIN_ORDER	2
 
 #ifdef CONFIG_CGROUP_HUGETLB
 
-static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
+static inline struct hugetlb_cgroup *
+__hugetlb_cgroup_from_page(struct page *page, bool rsvd)
 {
 	VM_BUG_ON_PAGE(!PageHuge(page), page);
 
 	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
 		return NULL;
-	return (struct hugetlb_cgroup *)page[2].private;
+	if (rsvd)
+		return (struct hugetlb_cgroup *)page[3].private;
+	else
+		return (struct hugetlb_cgroup *)page[2].private;
+}
+
+static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
+{
+	return __hugetlb_cgroup_from_page(page, false);
 }
 
-static inline
-int set_hugetlb_cgroup(struct page *page, struct hugetlb_cgroup *h_cg)
+static inline struct hugetlb_cgroup *
+hugetlb_cgroup_from_page_rsvd(struct page *page)
+{
+	return __hugetlb_cgroup_from_page(page, true);
+}
+
+static inline int __set_hugetlb_cgroup(struct page *page,
+				       struct hugetlb_cgroup *h_cg, bool rsvd)
 {
 	VM_BUG_ON_PAGE(!PageHuge(page), page);
 
 	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
 		return -1;
-	page[2].private	= (unsigned long)h_cg;
+	if (rsvd)
+		page[3].private = (unsigned long)h_cg;
+	else
+		page[2].private = (unsigned long)h_cg;
 	return 0;
 }
 
+static inline int set_hugetlb_cgroup(struct page *page,
+				     struct hugetlb_cgroup *h_cg)
+{
+	return __set_hugetlb_cgroup(page, h_cg, false);
+}
+
+static inline int set_hugetlb_cgroup_rsvd(struct page *page,
+					  struct hugetlb_cgroup *h_cg)
+{
+	return __set_hugetlb_cgroup(page, h_cg, true);
+}
+
 static inline bool hugetlb_cgroup_disabled(void)
 {
 	return !cgroup_subsys_enabled(hugetlb_cgrp_subsys);
@@ -53,13 +85,27 @@ static inline bool hugetlb_cgroup_disabl
 
 extern int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
 					struct hugetlb_cgroup **ptr);
+extern int hugetlb_cgroup_charge_cgroup_rsvd(int idx, unsigned long nr_pages,
+					     struct hugetlb_cgroup **ptr);
 extern void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 					 struct hugetlb_cgroup *h_cg,
 					 struct page *page);
+extern void hugetlb_cgroup_commit_charge_rsvd(int idx, unsigned long nr_pages,
+					      struct hugetlb_cgroup *h_cg,
+					      struct page *page);
 extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
 					 struct page *page);
+extern void hugetlb_cgroup_uncharge_page_rsvd(int idx, unsigned long nr_pages,
+					      struct page *page);
+
 extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg);
+extern void hugetlb_cgroup_uncharge_cgroup_rsvd(int idx, unsigned long nr_pages,
+						struct hugetlb_cgroup *h_cg);
+extern void hugetlb_cgroup_uncharge_counter(struct page_counter *p,
+					    unsigned long nr_pages,
+					    struct cgroup_subsys_state *css);
+
 extern void hugetlb_cgroup_file_init(void) __init;
 extern void hugetlb_cgroup_migrate(struct page *oldhpage,
 				   struct page *newhpage);
@@ -70,8 +116,26 @@ static inline struct hugetlb_cgroup *hug
 	return NULL;
 }
 
-static inline
-int set_hugetlb_cgroup(struct page *page, struct hugetlb_cgroup *h_cg)
+static inline struct hugetlb_cgroup *
+hugetlb_cgroup_from_page_resv(struct page *page)
+{
+	return NULL;
+}
+
+static inline struct hugetlb_cgroup *
+hugetlb_cgroup_from_page_rsvd(struct page *page)
+{
+	return NULL;
+}
+
+static inline int set_hugetlb_cgroup(struct page *page,
+				     struct hugetlb_cgroup *h_cg)
+{
+	return 0;
+}
+
+static inline int set_hugetlb_cgroup_rsvd(struct page *page,
+					  struct hugetlb_cgroup *h_cg)
 {
 	return 0;
 }
@@ -81,28 +145,51 @@ static inline bool hugetlb_cgroup_disabl
 	return true;
 }
 
-static inline int
-hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
-			     struct hugetlb_cgroup **ptr)
+static inline int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
+					       struct hugetlb_cgroup **ptr)
 {
 	return 0;
 }
 
-static inline void
-hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
-			     struct hugetlb_cgroup *h_cg,
-			     struct page *page)
+static inline int hugetlb_cgroup_charge_cgroup_rsvd(int idx,
+						    unsigned long nr_pages,
+						    struct hugetlb_cgroup **ptr)
+{
+	return 0;
+}
+
+static inline void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
+						struct hugetlb_cgroup *h_cg,
+						struct page *page)
 {
 }
 
 static inline void
-hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages, struct page *page)
+hugetlb_cgroup_commit_charge_rsvd(int idx, unsigned long nr_pages,
+				  struct hugetlb_cgroup *h_cg,
+				  struct page *page)
+{
+}
+
+static inline void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
+						struct page *page)
+{
+}
+
+static inline void hugetlb_cgroup_uncharge_page_rsvd(int idx,
+						     unsigned long nr_pages,
+						     struct page *page)
+{
+}
+static inline void hugetlb_cgroup_uncharge_cgroup(int idx,
+						  unsigned long nr_pages,
+						  struct hugetlb_cgroup *h_cg)
 {
 }
 
 static inline void
-hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
-			       struct hugetlb_cgroup *h_cg)
+hugetlb_cgroup_uncharge_cgroup_rsvd(int idx, unsigned long nr_pages,
+				    struct hugetlb_cgroup *h_cg)
 {
 }
 
--- a/mm/hugetlb.c~hugetlb_cgroup-add-interface-for-charge-uncharge-hugetlb-reservations
+++ a/mm/hugetlb.c
@@ -1072,6 +1072,7 @@ static void update_and_free_page(struct
 				1 << PG_writeback);
 	}
 	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
+	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page_rsvd(page), page);
 	set_compound_page_dtor(page, NULL_COMPOUND_DTOR);
 	set_page_refcounted(page);
 	if (hstate_is_gigantic(h)) {
@@ -1257,6 +1258,7 @@ static void prep_new_huge_page(struct hs
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
 	spin_lock(&hugetlb_lock);
 	set_hugetlb_cgroup(page, NULL);
+	set_hugetlb_cgroup_rsvd(page, NULL);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
 	spin_unlock(&hugetlb_lock);
--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-add-interface-for-charge-uncharge-hugetlb-reservations
+++ a/mm/hugetlb_cgroup.c
@@ -61,14 +61,26 @@ struct hugetlb_cgroup {
 static struct hugetlb_cgroup *root_h_cgroup __read_mostly;
 
 static inline struct page_counter *
-hugetlb_cgroup_counter_from_cgroup(struct hugetlb_cgroup *h_cg, int idx,
-				   bool rsvd)
+__hugetlb_cgroup_counter_from_cgroup(struct hugetlb_cgroup *h_cg, int idx,
+				     bool rsvd)
 {
 	if (rsvd)
 		return &h_cg->rsvd_hugepage[idx];
 	return &h_cg->hugepage[idx];
 }
 
+static inline struct page_counter *
+hugetlb_cgroup_counter_from_cgroup(struct hugetlb_cgroup *h_cg, int idx)
+{
+	return __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, false);
+}
+
+static inline struct page_counter *
+hugetlb_cgroup_counter_from_cgroup_rsvd(struct hugetlb_cgroup *h_cg, int idx)
+{
+	return __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, true);
+}
+
 static inline
 struct hugetlb_cgroup *hugetlb_cgroup_from_css(struct cgroup_subsys_state *s)
 {
@@ -97,8 +109,12 @@ static inline bool hugetlb_cgroup_have_u
 	int idx;
 
 	for (idx = 0; idx < hugetlb_max_hstate; idx++) {
-		if (page_counter_read(&h_cg->hugepage[idx]))
+		if (page_counter_read(
+			    hugetlb_cgroup_counter_from_cgroup(h_cg, idx)) ||
+		    page_counter_read(hugetlb_cgroup_counter_from_cgroup_rsvd(
+			    h_cg, idx))) {
 			return true;
+		}
 	}
 	return false;
 }
@@ -109,18 +125,34 @@ static void hugetlb_cgroup_init(struct h
 	int idx;
 
 	for (idx = 0; idx < HUGE_MAX_HSTATE; idx++) {
-		struct page_counter *counter = &h_cgroup->hugepage[idx];
-		struct page_counter *parent = NULL;
+		struct page_counter *fault_parent = NULL;
+		struct page_counter *rsvd_parent = NULL;
 		unsigned long limit;
 		int ret;
 
-		if (parent_h_cgroup)
-			parent = &parent_h_cgroup->hugepage[idx];
-		page_counter_init(counter, parent);
+		if (parent_h_cgroup) {
+			fault_parent = hugetlb_cgroup_counter_from_cgroup(
+				parent_h_cgroup, idx);
+			rsvd_parent = hugetlb_cgroup_counter_from_cgroup_rsvd(
+				parent_h_cgroup, idx);
+		}
+		page_counter_init(hugetlb_cgroup_counter_from_cgroup(h_cgroup,
+								     idx),
+				  fault_parent);
+		page_counter_init(
+			hugetlb_cgroup_counter_from_cgroup_rsvd(h_cgroup, idx),
+			rsvd_parent);
 
 		limit = round_down(PAGE_COUNTER_MAX,
 				   1 << huge_page_order(&hstates[idx]));
-		ret = page_counter_set_max(counter, limit);
+
+		ret = page_counter_set_max(
+			hugetlb_cgroup_counter_from_cgroup(h_cgroup, idx),
+			limit);
+		VM_BUG_ON(ret);
+		ret = page_counter_set_max(
+			hugetlb_cgroup_counter_from_cgroup_rsvd(h_cgroup, idx),
+			limit);
 		VM_BUG_ON(ret);
 	}
 }
@@ -150,7 +182,6 @@ static void hugetlb_cgroup_css_free(stru
 	kfree(h_cgroup);
 }
 
-
 /*
  * Should be called with hugetlb_lock held.
  * Since we are holding hugetlb_lock, pages cannot get moved from
@@ -227,8 +258,9 @@ static inline void hugetlb_event(struct
 		 !hugetlb_cgroup_is_root(hugetlb));
 }
 
-int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
-				 struct hugetlb_cgroup **ptr)
+static int __hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
+					  struct hugetlb_cgroup **ptr,
+					  bool rsvd)
 {
 	int ret = 0;
 	struct page_counter *counter;
@@ -251,50 +283,103 @@ again:
 	}
 	rcu_read_unlock();
 
-	if (!page_counter_try_charge(&h_cg->hugepage[idx], nr_pages,
-				     &counter)) {
+	if (!page_counter_try_charge(
+		    __hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd),
+		    nr_pages, &counter)) {
 		ret = -ENOMEM;
 		hugetlb_event(h_cg, idx, HUGETLB_MAX);
+		css_put(&h_cg->css);
+		goto done;
 	}
-	css_put(&h_cg->css);
+	/* Reservations take a reference to the css because they do not get
+	 * reparented.
+	 */
+	if (!rsvd)
+		css_put(&h_cg->css);
 done:
 	*ptr = h_cg;
 	return ret;
 }
 
+int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
+				 struct hugetlb_cgroup **ptr)
+{
+	return __hugetlb_cgroup_charge_cgroup(idx, nr_pages, ptr, false);
+}
+
+int hugetlb_cgroup_charge_cgroup_rsvd(int idx, unsigned long nr_pages,
+				      struct hugetlb_cgroup **ptr)
+{
+	return __hugetlb_cgroup_charge_cgroup(idx, nr_pages, ptr, true);
+}
+
 /* Should be called with hugetlb_lock held */
-void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
-				  struct hugetlb_cgroup *h_cg,
-				  struct page *page)
+static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
+					   struct hugetlb_cgroup *h_cg,
+					   struct page *page, bool rsvd)
 {
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
 
-	set_hugetlb_cgroup(page, h_cg);
+	__set_hugetlb_cgroup(page, h_cg, rsvd);
 	return;
 }
 
+void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
+				  struct hugetlb_cgroup *h_cg,
+				  struct page *page)
+{
+	__hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, page, false);
+}
+
+void hugetlb_cgroup_commit_charge_rsvd(int idx, unsigned long nr_pages,
+				       struct hugetlb_cgroup *h_cg,
+				       struct page *page)
+{
+	__hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, page, true);
+}
+
 /*
  * Should be called with hugetlb_lock held
  */
-void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
-				  struct page *page)
+static void __hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
+					   struct page *page, bool rsvd)
 {
 	struct hugetlb_cgroup *h_cg;
 
 	if (hugetlb_cgroup_disabled())
 		return;
 	lockdep_assert_held(&hugetlb_lock);
-	h_cg = hugetlb_cgroup_from_page(page);
+	h_cg = __hugetlb_cgroup_from_page(page, rsvd);
 	if (unlikely(!h_cg))
 		return;
-	set_hugetlb_cgroup(page, NULL);
-	page_counter_uncharge(&h_cg->hugepage[idx], nr_pages);
+	__set_hugetlb_cgroup(page, NULL, rsvd);
+
+	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
+								   rsvd),
+			      nr_pages);
+
+	if (rsvd)
+		css_put(&h_cg->css);
+
 	return;
 }
 
-void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
-				    struct hugetlb_cgroup *h_cg)
+void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
+				  struct page *page)
+{
+	__hugetlb_cgroup_uncharge_page(idx, nr_pages, page, false);
+}
+
+void hugetlb_cgroup_uncharge_page_rsvd(int idx, unsigned long nr_pages,
+				       struct page *page)
+{
+	__hugetlb_cgroup_uncharge_page(idx, nr_pages, page, true);
+}
+
+static void __hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
+					     struct hugetlb_cgroup *h_cg,
+					     bool rsvd)
 {
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
@@ -302,8 +387,35 @@ void hugetlb_cgroup_uncharge_cgroup(int
 	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
 		return;
 
-	page_counter_uncharge(&h_cg->hugepage[idx], nr_pages);
-	return;
+	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
+								   rsvd),
+			      nr_pages);
+
+	if (rsvd)
+		css_put(&h_cg->css);
+}
+
+void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
+				    struct hugetlb_cgroup *h_cg)
+{
+	__hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg, false);
+}
+
+void hugetlb_cgroup_uncharge_cgroup_rsvd(int idx, unsigned long nr_pages,
+					 struct hugetlb_cgroup *h_cg)
+{
+	__hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg, true);
+}
+
+void hugetlb_cgroup_uncharge_counter(struct page_counter *p,
+				     unsigned long nr_pages,
+				     struct cgroup_subsys_state *css)
+{
+	if (hugetlb_cgroup_disabled() || !p || !css)
+		return;
+
+	page_counter_uncharge(p, nr_pages);
+	css_put(css);
 }
 
 enum {
@@ -418,7 +530,7 @@ static ssize_t hugetlb_cgroup_write(stru
 	case RES_LIMIT:
 		mutex_lock(&hugetlb_limit_mutex);
 		ret = page_counter_set_max(
-			hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd),
+			__hugetlb_cgroup_counter_from_cgroup(h_cg, idx, rsvd),
 			nr_pages);
 		mutex_unlock(&hugetlb_limit_mutex);
 		break;
@@ -674,6 +786,7 @@ void __init hugetlb_cgroup_file_init(voi
 void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 {
 	struct hugetlb_cgroup *h_cg;
+	struct hugetlb_cgroup *h_cg_rsvd;
 	struct hstate *h = page_hstate(oldhpage);
 
 	if (hugetlb_cgroup_disabled())
@@ -682,10 +795,11 @@ void hugetlb_cgroup_migrate(struct page
 	VM_BUG_ON_PAGE(!PageHuge(oldhpage), oldhpage);
 	spin_lock(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(oldhpage);
+	h_cg_rsvd = hugetlb_cgroup_from_page_rsvd(oldhpage);
 	set_hugetlb_cgroup(oldhpage, NULL);
 
 	/* move the h_cg details to new cgroup */
-	set_hugetlb_cgroup(newhpage, h_cg);
+	set_hugetlb_cgroup_rsvd(newhpage, h_cg_rsvd);
 	list_move(&newhpage->lru, &h->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
 	return;
_
