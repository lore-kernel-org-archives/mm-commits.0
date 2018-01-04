From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch added to
 -mm tree
Date: Wed, 03 Jan 2018 16:05:02 -0800
Message-ID: <5a4d6fae./xAKcn5l/9sh/k83%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36112 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751300AbeADAFE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jan 2018 19:05:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, ar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: do not rely on overcommit limit during migration
has been added to the -mm tree.  Its filename is
     mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, hugetlb: do not rely on overcommit limit during migration

hugepage migration relies on __alloc_buddy_huge_page to get a new page. 
This has 2 main disadvantages.

1) it doesn't allow to migrate any huge page if the pool is used
   completely which is not an exceptional case as the pool is static and
   unused memory is just wasted.

2) it leads to a weird semantic when migration between two numa nodes
   might increase the pool size of the destination NUMA node while the
   page is in use.  The issue is caused by per NUMA node surplus pages
   tracking (see free_huge_page).

Address both issues by changing the way how we allocate and account pages
allocated for migration.  Those should temporal by definition.  So we mark
them that way (we will abuse page flags in the 3rd page) and update
free_huge_page to free such pages to the page allocator.  Page migration
path then just transfers the temporal status from the new page to the old
one which will be freed on the last reference.  The global surplus count
will never change during this path but we still have to be careful when
migrating a per-node suprlus page.  This is now handled in
move_hugetlb_state which is called from the migration path and it copies
the hugetlb specific page state and fixes up the accounting when needed

Rename __alloc_buddy_huge_page to __alloc_surplus_huge_page to better
reflect its purpose.  The new allocation routine for the migration path is
__alloc_migrate_huge_page.

The user visible effect of this patch is that migrated pages are really
temporal and they travel between NUMA nodes as per the migration request:

Before migration
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/free_hugepages:0
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages:1
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/surplus_hugepages:0
/sys/devices/system/node/node1/hugepages/hugepages-2048kB/free_hugepages:0
/sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages:0
/sys/devices/system/node/node1/hugepages/hugepages-2048kB/surplus_hugepages:0

After

/sys/devices/system/node/node0/hugepages/hugepages-2048kB/free_hugepages:0
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages:0
/sys/devices/system/node/node0/hugepages/hugepages-2048kB/surplus_hugepages:0
/sys/devices/system/node/node1/hugepages/hugepages-2048kB/free_hugepages:0
/sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages:1
/sys/devices/system/node/node1/hugepages/hugepages-2048kB/surplus_hugepages:0

with the previous implementation, both nodes would have nr_hugepages:1
until the page is freed.

Link: http://lkml.kernel.org/r/20180103093213.26329-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Reale <ar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 +
 mm/hugetlb.c            |  111 ++++++++++++++++++++++++++++++++------
 mm/migrate.c            |    3 -
 3 files changed, 99 insertions(+), 18 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration
+++ a/include/linux/hugetlb.h
@@ -119,6 +119,7 @@ long hugetlb_unreserve_pages(struct inod
 						long freed);
 bool isolate_huge_page(struct page *page, struct list_head *list);
 void putback_active_hugepage(struct page *page);
+void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason);
 void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
@@ -157,6 +158,7 @@ unsigned long hugetlb_change_protection(
 		unsigned long address, unsigned long end, pgprot_t newprot);
 
 bool is_hugetlb_entry_migration(pte_t pte);
+
 #else /* !CONFIG_HUGETLB_PAGE */
 
 static inline void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
@@ -197,6 +199,7 @@ static inline bool isolate_huge_page(str
 	return false;
 }
 #define putback_active_hugepage(p)	do {} while (0)
+#define move_hugetlb_state(old, new, reason)	do {} while (0)
 
 static inline unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pgprot_t newprot)
diff -puN mm/hugetlb.c~mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration
+++ a/mm/hugetlb.c
@@ -34,6 +34,7 @@
 #include <linux/hugetlb_cgroup.h>
 #include <linux/node.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/page_owner.h>
 #include "internal.h"
 
 int hugetlb_max_hstate __read_mostly;
@@ -1219,6 +1220,28 @@ static void clear_page_huge_active(struc
 	ClearPagePrivate(&page[1]);
 }
 
+/*
+ * Internal hugetlb specific page flag. Do not use outside of the hugetlb
+ * code
+ */
+static inline bool PageHugeTemporary(struct page *page)
+{
+	if (!PageHuge(page))
+		return false;
+
+	return (unsigned long)page[2].mapping == -1U;
+}
+
+static inline void SetPageHugeTemporary(struct page *page)
+{
+	page[2].mapping = (void *)-1U;
+}
+
+static inline void ClearPageHugeTemporary(struct page *page)
+{
+	page[2].mapping = NULL;
+}
+
 void free_huge_page(struct page *page)
 {
 	/*
@@ -1253,7 +1276,11 @@ void free_huge_page(struct page *page)
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
-	if (h->surplus_huge_pages_node[nid]) {
+	if (PageHugeTemporary(page)) {
+		list_del(&page->lru);
+		ClearPageHugeTemporary(page);
+		update_and_free_page(h, page);
+	} else if (h->surplus_huge_pages_node[nid]) {
 		/* remove the page from active list */
 		list_del(&page->lru);
 		update_and_free_page(h, page);
@@ -1507,7 +1534,10 @@ int dissolve_free_huge_pages(unsigned lo
 	return rc;
 }
 
-static struct page *__alloc_buddy_huge_page(struct hstate *h, gfp_t gfp_mask,
+/*
+ * Allocates a fresh surplus page from the page allocator.
+ */
+static struct page *__alloc_surplus_huge_page(struct hstate *h, gfp_t gfp_mask,
 		int nid, nodemask_t *nmask)
 {
 	struct page *page;
@@ -1571,6 +1601,28 @@ static struct page *__alloc_buddy_huge_p
 	return page;
 }
 
+static struct page *__alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
+		int nid, nodemask_t *nmask)
+{
+	struct page *page;
+
+	if (hstate_is_gigantic(h))
+		return NULL;
+
+	page = __hugetlb_alloc_buddy_huge_page(h, gfp_mask, nid, nmask);
+	if (!page)
+		return NULL;
+
+	/*
+	 * We do not account these pages as surplus because they are only
+	 * temporary and will be released properly on the last reference
+	 */
+	prep_new_huge_page(h, page, page_to_nid(page));
+	SetPageHugeTemporary(page);
+
+	return page;
+}
+
 /*
  * Use the VMA's mpolicy to allocate a huge page from the buddy.
  */
@@ -1585,17 +1637,13 @@ struct page *__alloc_buddy_huge_page_wit
 	nodemask_t *nodemask;
 
 	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
-	page = __alloc_buddy_huge_page(h, gfp_mask, nid, nodemask);
+	page = __alloc_surplus_huge_page(h, gfp_mask, nid, nodemask);
 	mpol_cond_put(mpol);
 
 	return page;
 }
 
-/*
- * This allocation function is useful in the context where vma is irrelevant.
- * E.g. soft-offlining uses this function because it only cares physical
- * address of error page.
- */
+/* page migration callback function */
 struct page *alloc_huge_page_node(struct hstate *h, int nid)
 {
 	gfp_t gfp_mask = htlb_alloc_mask(h);
@@ -1610,12 +1658,12 @@ struct page *alloc_huge_page_node(struct
 	spin_unlock(&hugetlb_lock);
 
 	if (!page)
-		page = __alloc_buddy_huge_page(h, gfp_mask, nid, NULL);
+		page = __alloc_migrate_huge_page(h, gfp_mask, nid, NULL);
 
 	return page;
 }
 
-
+/* page migration callback function */
 struct page *alloc_huge_page_nodemask(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask)
 {
@@ -1633,9 +1681,7 @@ struct page *alloc_huge_page_nodemask(st
 	}
 	spin_unlock(&hugetlb_lock);
 
-	/* No reservations, try to overcommit */
-
-	return __alloc_buddy_huge_page(h, gfp_mask, preferred_nid, nmask);
+	return __alloc_migrate_huge_page(h, gfp_mask, preferred_nid, nmask);
 }
 
 /*
@@ -1663,7 +1709,7 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
-		page = __alloc_buddy_huge_page(h, htlb_alloc_mask(h),
+		page = __alloc_surplus_huge_page(h, htlb_alloc_mask(h),
 				NUMA_NO_NODE, NULL);
 		if (!page) {
 			alloc_ok = false;
@@ -2260,7 +2306,7 @@ static unsigned long set_max_huge_pages(
 	 * First take pages out of surplus state.  Then make up the
 	 * remaining difference by allocating fresh huge pages.
 	 *
-	 * We might race with __alloc_buddy_huge_page() here and be unable
+	 * We might race with __alloc_surplus_huge_page() here and be unable
 	 * to convert a surplus huge page to a normal huge page. That is
 	 * not critical, though, it just means the overall size of the
 	 * pool might be one hugepage larger than it needs to be, but
@@ -2303,7 +2349,7 @@ static unsigned long set_max_huge_pages(
 	 * By placing pages into the surplus state independent of the
 	 * overcommit value, we are allowing the surplus pool size to
 	 * exceed overcommit. There are few sane options here. Since
-	 * __alloc_buddy_huge_page() is checking the global counter,
+	 * __alloc_surplus_huge_page() is checking the global counter,
 	 * though, we'll note that we're not allowed to exceed surplus
 	 * and won't grow the pool anywhere else. Not until one of the
 	 * sysctls are changed, or the surplus pages go out of use.
@@ -4779,3 +4825,36 @@ void putback_active_hugepage(struct page
 	spin_unlock(&hugetlb_lock);
 	put_page(page);
 }
+
+void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason)
+{
+	struct hstate *h = page_hstate(oldpage);
+
+	hugetlb_cgroup_migrate(oldpage, newpage);
+	set_page_owner_migrate_reason(newpage, reason);
+
+	/*
+	 * transfer temporary state of the new huge page. This is
+	 * reverse to other transitions because the newpage is going to
+	 * be final while the old one will be freed so it takes over
+	 * the temporary status.
+	 *
+	 * Also note that we have to transfer the per-node surplus state
+	 * here as well otherwise the global surplus count will not match
+	 * the per-node's.
+	 */
+	if (PageHugeTemporary(newpage)) {
+		int old_nid = page_to_nid(oldpage);
+		int new_nid = page_to_nid(newpage);
+
+		SetPageHugeTemporary(oldpage);
+		ClearPageHugeTemporary(newpage);
+
+		spin_lock(&hugetlb_lock);
+		if (h->surplus_huge_pages_node[old_nid]) {
+			h->surplus_huge_pages_node[old_nid]--;
+			h->surplus_huge_pages_node[new_nid]++;
+		}
+		spin_unlock(&hugetlb_lock);
+	}
+}
diff -puN mm/migrate.c~mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration mm/migrate.c
--- a/mm/migrate.c~mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration
+++ a/mm/migrate.c
@@ -1310,9 +1310,8 @@ put_anon:
 		put_anon_vma(anon_vma);
 
 	if (rc == MIGRATEPAGE_SUCCESS) {
-		hugetlb_cgroup_migrate(hpage, new_hpage);
+		move_hugetlb_state(hpage, new_hpage, reason);
 		put_new_page = NULL;
-		set_page_owner_migrate_reason(new_hpage, reason);
 	}
 
 	unlock_page(hpage);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-drop-hotplug-lock-from-lru_add_drain_all.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-unclutter-thp-migration.patch
mm-hugetlb-unify-core-page-allocation-accounting-and-initialization.patch
mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-allocation-path.patch
mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch
mm-hugetlb-get-rid-of-surplus-page-accounting-tricks.patch
mm-hugetlb-further-simplify-hugetlb-allocation-api.patch
hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch

