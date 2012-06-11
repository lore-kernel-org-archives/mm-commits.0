From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlb-simplify-migrate_huge_page.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:09:42 -0700
Message-ID: <20120611210942.8B545A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:57036 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2FKVJp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:09:45 -0400
Received: by mail-ey0-f202.google.com with SMTP id o13so251205eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:09:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: simplify migrate_huge_page()
has been removed from the -mm tree.  Its filename was
     hugetlb-simplify-migrate_huge_page.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb: simplify migrate_huge_page()

Since we migrate only one hugepage don't use linked list for passing the
page around.  Directly pass page that need to be migrated as argument. 
This also remove the usage page->lru in migrate path.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 +-
 mm/memory-failure.c     |   13 +------
 mm/migrate.c            |   67 ++++++++++++--------------------------
 3 files changed, 26 insertions(+), 58 deletions(-)

diff -puN include/linux/migrate.h~hugetlb-simplify-migrate_huge_page include/linux/migrate.h
--- a/include/linux/migrate.h~hugetlb-simplify-migrate_huge_page
+++ a/include/linux/migrate.h
@@ -15,7 +15,7 @@ extern int migrate_page(struct address_s
 extern int migrate_pages(struct list_head *l, new_page_t x,
 			unsigned long private, bool offlining,
 			enum migrate_mode mode);
-extern int migrate_huge_pages(struct list_head *l, new_page_t x,
+extern int migrate_huge_page(struct page *, new_page_t x,
 			unsigned long private, bool offlining,
 			enum migrate_mode mode);
 
@@ -40,7 +40,7 @@ static inline void putback_lru_pages(str
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, bool offlining,
 		enum migrate_mode mode) { return -ENOSYS; }
-static inline int migrate_huge_pages(struct list_head *l, new_page_t x,
+static inline int migrate_huge_page(struct page *page, new_page_t x,
 		unsigned long private, bool offlining,
 		enum migrate_mode mode) { return -ENOSYS; }
 
diff -puN mm/memory-failure.c~hugetlb-simplify-migrate_huge_page mm/memory-failure.c
--- a/mm/memory-failure.c~hugetlb-simplify-migrate_huge_page
+++ a/mm/memory-failure.c
@@ -1414,7 +1414,6 @@ static int soft_offline_huge_page(struct
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
 	struct page *hpage = compound_head(page);
-	LIST_HEAD(pagelist);
 
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
@@ -1429,19 +1428,11 @@ static int soft_offline_huge_page(struct
 	}
 
 	/* Keep page count to indicate a given hugepage is isolated. */
-
-	list_add(&hpage->lru, &pagelist);
-	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
-				true);
+	ret = migrate_huge_page(page, new_page, MPOL_MF_MOVE_ALL, 0, true);
+	put_page(page);
 	if (ret) {
-		struct page *page1, *page2;
-		list_for_each_entry_safe(page1, page2, &pagelist, lru)
-			put_page(page1);
-
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 			pfn, ret, page->flags);
-		if (ret > 0)
-			ret = -EIO;
 		return ret;
 	}
 done:
diff -puN mm/migrate.c~hugetlb-simplify-migrate_huge_page mm/migrate.c
--- a/mm/migrate.c~hugetlb-simplify-migrate_huge_page
+++ a/mm/migrate.c
@@ -936,15 +936,8 @@ static int unmap_and_move_huge_page(new_
 	if (anon_vma)
 		put_anon_vma(anon_vma);
 	unlock_page(hpage);
-
 out:
-	if (rc != -EAGAIN) {
-		list_del(&hpage->lru);
-		put_page(hpage);
-	}
-
 	put_page(new_hpage);
-
 	if (result) {
 		if (rc)
 			*result = rc;
@@ -1112,48 +1105,32 @@ out:
 	return nr_failed + retry;
 }
 
-int migrate_huge_pages(struct list_head *from,
-		new_page_t get_new_page, unsigned long private, bool offlining,
-		enum migrate_mode mode)
-{
-	int retry = 1;
-	int nr_failed = 0;
-	int pass = 0;
-	struct page *page;
-	struct page *page2;
-	int rc;
-
-	for (pass = 0; pass < 10 && retry; pass++) {
-		retry = 0;
-
-		list_for_each_entry_safe(page, page2, from, lru) {
+int migrate_huge_page(struct page *hpage, new_page_t get_new_page,
+		      unsigned long private, bool offlining,
+		      enum migrate_mode mode)
+{
+	int pass, rc;
+
+	for (pass = 0; pass < 10; pass++) {
+		rc = unmap_and_move_huge_page(get_new_page,
+					      private, hpage, pass > 2, offlining,
+					      mode);
+		switch (rc) {
+		case -ENOMEM:
+			goto out;
+		case -EAGAIN:
+			/* try again */
 			cond_resched();
-
-			rc = unmap_and_move_huge_page(get_new_page,
-					private, page, pass > 2, offlining,
-					mode);
-
-			switch(rc) {
-			case -ENOMEM:
-				goto out;
-			case -EAGAIN:
-				retry++;
-				break;
-			case 0:
-				break;
-			default:
-				/* Permanent failure */
-				nr_failed++;
-				break;
-			}
+			break;
+		case 0:
+			goto out;
+		default:
+			rc = -EIO;
+			goto out;
 		}
 	}
-	rc = 0;
 out:
-	if (rc)
-		return rc;
-
-	return nr_failed + retry;
+	return rc;
 }
 
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

