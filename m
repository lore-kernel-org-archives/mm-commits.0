From: akpm@linux-foundation.org
Subject: + 10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:46:15 -0700
Message-ID: <20120613204616.04C9BA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35262 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab2FMUqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:46:16 -0400
Received: by mail-gg0-f202.google.com with SMTP id h3so89256gge.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:46:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: hugetlb/cgroup: add the cgroup pointer to page lru
has been added to the -mm tree.  Its filename is
     10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb/cgroup: add the cgroup pointer to page lru

Add the hugetlb cgroup pointer to 3rd page lru.next.  This limit the usage
to hugetlb cgroup to only hugepages with 3 or more normal pages.  I guess
that is an acceptable limitation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |   37 +++++++++++++++++++++++++++++++
 mm/hugetlb.c                   |    4 +++
 2 files changed, 41 insertions(+)

diff -puN include/linux/hugetlb_cgroup.h~10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru
+++ a/include/linux/hugetlb_cgroup.h
@@ -18,8 +18,34 @@
 #include <linux/res_counter.h>
 
 struct hugetlb_cgroup;
+/*
+ * Minimum page order trackable by hugetlb cgroup.
+ * At least 3 pages are necessary for all the tracking information.
+ */
+#define HUGETLB_CGROUP_MIN_ORDER	2
 
 #ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
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
diff -puN mm/hugetlb.c~10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru mm/hugetlb.c
--- a/mm/hugetlb.c~10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru
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
Subject: Subject: hugetlb/cgroup: add the cgroup pointer to page lru

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch

