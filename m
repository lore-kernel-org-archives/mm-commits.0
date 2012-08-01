From: akpm@linux-foundation.org
Subject: [merged] hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:12:33 -0700
Message-ID: <20120801201234.31A095C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51698 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:12:36 -0400
Received: by eaao12 with SMTP id o12so293205eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:12:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb/cgroup: add the cgroup pointer to page lru
has been removed from the -mm tree.  Its filename was
     hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb/cgroup: add the cgroup pointer to page lru

Add the hugetlb cgroup pointer to 3rd page lru.next.  This limit the usage
to hugetlb cgroup to only hugepages with 3 or more normal pages.  I guess
that is an acceptable limitation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |   37 +++++++++++++++++++++++++++++++
 mm/hugetlb.c                   |    4 +++
 2 files changed, 41 insertions(+)

diff -puN include/linux/hugetlb_cgroup.h~hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru
+++ a/include/linux/hugetlb_cgroup.h
@@ -18,8 +18,34 @@
 #include <linux/res_counter.h>
 
 struct hugetlb_cgroup;
+/*
+ * Minimum page order trackable by hugetlb cgroup.
+ * At least 3 pages are necessary for all the tracking information.
+ */
+#define HUGETLB_CGROUP_MIN_ORDER	2
 
 #ifdef CONFIG_CGROUP_HUGETLB
+
+static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
+{
+	VM_BUG_ON(!PageHuge(page));
+
+	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
+		return NULL;
+	return (struct hugetlb_cgroup *)page[2].lru.next;
+}
+
+static inline
+int set_hugetlb_cgroup(struct page *page, struct hugetlb_cgroup *h_cg)
+{
+	VM_BUG_ON(!PageHuge(page));
+
+	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
+		return -1;
+	page[2].lru.next = (void *)h_cg;
+	return 0;
+}
+
 static inline bool hugetlb_cgroup_disabled(void)
 {
 	if (hugetlb_subsys.disabled)
@@ -28,6 +54,17 @@ static inline bool hugetlb_cgroup_disabl
 }
 
 #else
+static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
+{
+	return NULL;
+}
+
+static inline
+int set_hugetlb_cgroup(struct page *page, struct hugetlb_cgroup *h_cg)
+{
+	return 0;
+}
+
 static inline bool hugetlb_cgroup_disabled(void)
 {
 	return true;
diff -puN mm/hugetlb.c~hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru
+++ a/mm/hugetlb.c
@@ -28,6 +28,7 @@
 
 #include <linux/io.h>
 #include <linux/hugetlb.h>
+#include <linux/hugetlb_cgroup.h>
 #include <linux/node.h>
 #include "internal.h"
 
@@ -591,6 +592,7 @@ static void update_and_free_page(struct 
 				1 << PG_active | 1 << PG_reserved |
 				1 << PG_private | 1 << PG_writeback);
 	}
+	VM_BUG_ON(hugetlb_cgroup_from_page(page));
 	set_compound_page_dtor(page, NULL);
 	set_page_refcounted(page);
 	arch_release_hugepage(page);
@@ -643,6 +645,7 @@ static void prep_new_huge_page(struct hs
 	INIT_LIST_HEAD(&page->lru);
 	set_compound_page_dtor(page, free_huge_page);
 	spin_lock(&hugetlb_lock);
+	set_hugetlb_cgroup(page, NULL);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
 	spin_unlock(&hugetlb_lock);
@@ -892,6 +895,7 @@ static struct page *alloc_buddy_huge_pag
 		INIT_LIST_HEAD(&page->lru);
 		r_nid = page_to_nid(page);
 		set_compound_page_dtor(page, free_huge_page);
+		set_hugetlb_cgroup(page, NULL);
 		/*
 		 * We incremented the global counters already
 		 */
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
linux-next.patch

