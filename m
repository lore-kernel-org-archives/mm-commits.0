From: akpm@linux-foundation.org
Subject: + mm-migrate-make-core-migration-code-aware-of-hugepage.patch
 added to -mm tree
Date: Wed, 14 Aug 2013 16:41:41 -0700
Message-ID: <520c15b5.nu2wpkivOMKwItwP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab3HNXlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 19:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-migrate-make-core-migration-code-aware-of-hugepage.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 16:41:41 -0700


The patch titled
     Subject: mm: migrate: make core migration code aware of hugepage
has been added to the -mm tree.  Its filename is
     mm-migrate-make-core-migration-code-aware-of-hugepage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-make-core-migration-code-aware-of-hugepage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-make-core-migration-code-aware-of-hugepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: migrate: make core migration code aware of hugepage

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

mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-hugetlb-protect-reserved-pages-when-soft-offlining-a-hugepage.patch
mm-hugetlb-change-variable-name-reservations-to-resv.patch
mm-hugetlb-fix-subpool-accounting-handling.patch
mm-hugetlb-remove-useless-check-about-mapping-type.patch
mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch
mm-hugetlb-return-a-reserved-page-to-a-reserved-pool-if-failed.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch

