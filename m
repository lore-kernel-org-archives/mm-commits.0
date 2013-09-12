From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-make-core-migration-code-aware-of-hugepage.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:44:11 -0700
Message-ID: <5232198b.tSV64lXwJcWIUOPv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] mm-migrate-make-core-migration-code-aware-of-hugepage.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:11 -0700


The patch titled
     Subject: mm: migrate: make core migration code aware of hugepage
has been removed from the -mm tree.  Its filename was
     mm-migrate-make-core-migration-code-aware-of-hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: migrate: make core migration code aware of hugepage

Currently hugepage migration is available only for soft offlining, but
it's also useful for some other users of page migration (clearly because
users of hugepage can enjoy the benefit of mempolicy and memory hotplug.)
So this patchset tries to extend such users to support hugepage migration.

The target of this patchset is to enable hugepage migration for NUMA
related system calls (migrate_pages(2), move_pages(2), and mbind(2)), and
memory hotplug.

This patchset does not add hugepage migration for memory compaction,
because users of memory compaction mainly expect to construct thp by
arranging raw pages, and there's little or no need to compact hugepages. 
CMA, another user of page migration, can have benefit from hugepage
migration, but is not enabled to support it for now (just because of lack
of testing and expertise in CMA.)

Hugepage migration of non pmd-based hugepage (for example 1GB hugepage in
x86_64, or hugepages in architectures like ia64) is not enabled for now
(again, because of lack of testing.)

As for how these are achived, I extended the API (migrate_pages()) to
handle hugepage (with patch 1 and 2) and adjusted code of each caller to
check and collect movable hugepages (with patch 3-7).  Remaining 2 patches
are kind of miscellaneous ones to avoid unexpected behavior.  Patch 8 is
about making sure that we only migrate pmd-based hugepages.  And patch 9
is about choosing appropriate zone for hugepage allocation.

My test is mainly functional one, simply kicking hugepage migration via
each entry point and confirm that migration is done correctly.  Test code
is available here:

  git://github.com/Naoya-Horiguchi/test_hugepage_migration_extension.git

And I always run libhugetlbfs test when changing hugetlbfs's code.  With
this patchset, no regression was found in the test.



This patch (of 9):

Before enabling each user of page migration to support hugepage,
this patch enables the list of pages for migration to link not only
LRU pages, but also hugepages. As a result, putback_movable_pages()
and migrate_pages() can handle both of LRU pages and hugepages.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++++
 mm/hugetlb.c            |   23 ++++++++++++++++++++++-
 mm/migrate.c            |   10 +++++++++-
 3 files changed, 35 insertions(+), 2 deletions(-)

diff -puN include/linux/hugetlb.h~mm-migrate-make-core-migration-code-aware-of-hugepage include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-migrate-make-core-migration-code-aware-of-hugepage
+++ a/include/linux/hugetlb.h
@@ -66,6 +66,8 @@ int hugetlb_reserve_pages(struct inode *
 						vm_flags_t vm_flags);
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
 int dequeue_hwpoisoned_huge_page(struct page *page);
+bool isolate_huge_page(struct page *page, struct list_head *list);
+void putback_active_hugepage(struct page *page);
 void copy_huge_page(struct page *dst, struct page *src);
 
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
@@ -134,6 +136,8 @@ static inline int dequeue_hwpoisoned_hug
 	return 0;
 }
 
+#define isolate_huge_page(p, l) false
+#define putback_active_hugepage(p)	do {} while (0)
 static inline void copy_huge_page(struct page *dst, struct page *src)
 {
 }
diff -puN mm/hugetlb.c~mm-migrate-make-core-migration-code-aware-of-hugepage mm/hugetlb.c
--- a/mm/hugetlb.c~mm-migrate-make-core-migration-code-aware-of-hugepage
+++ a/mm/hugetlb.c
@@ -48,7 +48,8 @@ static unsigned long __initdata default_
 static unsigned long __initdata default_hstate_size;
 
 /*
- * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
+ * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
+ * free_huge_pages, and surplus_huge_pages.
  */
 DEFINE_SPINLOCK(hugetlb_lock);
 
@@ -3422,3 +3423,23 @@ int dequeue_hwpoisoned_huge_page(struct
 	return ret;
 }
 #endif
+
+bool isolate_huge_page(struct page *page, struct list_head *list)
+{
+	VM_BUG_ON(!PageHead(page));
+	if (!get_page_unless_zero(page))
+		return false;
+	spin_lock(&hugetlb_lock);
+	list_move_tail(&page->lru, list);
+	spin_unlock(&hugetlb_lock);
+	return true;
+}
+
+void putback_active_hugepage(struct page *page)
+{
+	VM_BUG_ON(!PageHead(page));
+	spin_lock(&hugetlb_lock);
+	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
+	spin_unlock(&hugetlb_lock);
+	put_page(page);
+}
diff -puN mm/migrate.c~mm-migrate-make-core-migration-code-aware-of-hugepage mm/migrate.c
--- a/mm/migrate.c~mm-migrate-make-core-migration-code-aware-of-hugepage
+++ a/mm/migrate.c
@@ -100,6 +100,10 @@ void putback_movable_pages(struct list_h
 	struct page *page2;
 
 	list_for_each_entry_safe(page, page2, l, lru) {
+		if (unlikely(PageHuge(page))) {
+			putback_active_hugepage(page);
+			continue;
+		}
 		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
@@ -1025,7 +1029,11 @@ int migrate_pages(struct list_head *from
 		list_for_each_entry_safe(page, page2, from, lru) {
 			cond_resched();
 
-			rc = unmap_and_move(get_new_page, private,
+			if (PageHuge(page))
+				rc = unmap_and_move_huge_page(get_new_page,
+						private, page, pass > 2, mode);
+			else
+				rc = unmap_and_move(get_new_page, private,
 						page, pass > 2, mode);
 
 			switch(rc) {
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

