From: akpm@linux-foundation.org
Subject: + mm-migration-add-migrate_entry_wait_huge.patch added to -mm
 tree
Date: Tue, 04 Jun 2013 13:36:24 -0700
Message-ID: <51ae4fc8.yVPrTZ7gvJGxgz34%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3FDUgZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jun 2013 16:36:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com

Subject: + mm-migration-add-migrate_entry_wait_huge.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,andi@firstfloor.org,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Jun 2013 13:36:24 -0700


The patch titled
     Subject: mm: migration: add migrate_entry_wait_huge()
has been added to the -mm tree.  Its filename is
     mm-migration-add-migrate_entry_wait_huge.patch

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
Subject: mm: migration: add migrate_entry_wait_huge()

When we have a page fault for the address which is backed by a hugepage
under migration, the kernel can't wait correctly and do busy looping on
hugepage fault until the migration finishes.  As a result, users who try
to kick hugepage migration (via soft offlining, for example) occasionally
experience long delay or soft lockup.

This is because pte_offset_map_lock() can't get a correct migration entry
or a correct page table lock for hugepage.  This patch introduces
migration_entry_wait_huge() to solve this.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>	[2.6.35+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    3 +++
 mm/hugetlb.c            |    2 +-
 mm/migrate.c            |   23 ++++++++++++++++++-----
 3 files changed, 22 insertions(+), 6 deletions(-)

diff -puN include/linux/swapops.h~mm-migration-add-migrate_entry_wait_huge include/linux/swapops.h
--- a/include/linux/swapops.h~mm-migration-add-migrate_entry_wait_huge
+++ a/include/linux/swapops.h
@@ -137,6 +137,7 @@ static inline void make_migration_entry_
 
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
+extern void migration_entry_wait_huge(struct mm_struct *mm, pte_t *pte);
 #else
 
 #define make_migration_entry(page, write) swp_entry(0, 0)
@@ -148,6 +149,8 @@ static inline int is_migration_entry(swp
 static inline void make_migration_entry_read(swp_entry_t *entryp) { }
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					 unsigned long address) { }
+static inline void migration_entry_wait_huge(struct mm_struct *mm,
+					pte_t *pte) { }
 static inline int is_write_migration_entry(swp_entry_t entry)
 {
 	return 0;
diff -puN mm/hugetlb.c~mm-migration-add-migrate_entry_wait_huge mm/hugetlb.c
--- a/mm/hugetlb.c~mm-migration-add-migrate_entry_wait_huge
+++ a/mm/hugetlb.c
@@ -2839,7 +2839,7 @@ int hugetlb_fault(struct mm_struct *mm,
 	if (ptep) {
 		entry = huge_ptep_get(ptep);
 		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait(mm, (pmd_t *)ptep, address);
+			migration_entry_wait_huge(mm, ptep);
 			return 0;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
diff -puN mm/migrate.c~mm-migration-add-migrate_entry_wait_huge mm/migrate.c
--- a/mm/migrate.c~mm-migration-add-migrate_entry_wait_huge
+++ a/mm/migrate.c
@@ -200,15 +200,14 @@ static void remove_migration_ptes(struct
  * get to the page and wait until migration is finished.
  * When we return from this function the fault will be retried.
  */
-void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
-				unsigned long address)
+static void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
+				spinlock_t *ptl)
 {
-	pte_t *ptep, pte;
-	spinlock_t *ptl;
+	pte_t pte;
 	swp_entry_t entry;
 	struct page *page;
 
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	spin_lock(ptl);
 	pte = *ptep;
 	if (!is_swap_pte(pte))
 		goto out;
@@ -236,6 +235,20 @@ out:
 	pte_unmap_unlock(ptep, ptl);
 }
 
+void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
+				unsigned long address)
+{
+	spinlock_t *ptl = pte_lockptr(mm, pmd);
+	pte_t *ptep = pte_offset_map(pmd, address);
+	__migration_entry_wait(mm, ptep, ptl);
+}
+
+void migration_entry_wait_huge(struct mm_struct *mm, pte_t *pte)
+{
+	spinlock_t *ptl = &(mm)->page_table_lock;
+	__migration_entry_wait(mm, pte, ptl);
+}
+
 #ifdef CONFIG_BLOCK
 /* Returns true if all buffers are successfully locked */
 static bool buffer_migrate_lock_buffers(struct buffer_head *head,
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-migration-add-migrate_entry_wait_huge.patch
mm-memory-failurec-fix-memory-leak-in-successful-soft-offlining.patch

