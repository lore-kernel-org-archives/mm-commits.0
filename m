From: akpm@linux-foundation.org
Subject: +
 mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
 added to -mm tree
Date: Wed, 14 Aug 2013 16:41:55 -0700
Message-ID: <520c15c3.kAXTPisX+BewiUI4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab3HNXl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 19:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, aneesh.kumar@linux.vnet.ibm.com, ak@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: + mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,ak@linux.intel.com,aneesh.kumar@linux.vnet.ibm.com,dhillf@gmail.com,hughd@google.com,kosaki.motohiro@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 16:41:55 -0700


The patch titled
     Subject: mm: migrate: check movability of hugepage in unmap_and_move_huge_page()
has been added to the -mm tree.  Its filename is
     mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch

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
Subject: mm: migrate: check movability of hugepage in unmap_and_move_huge_page()

Currently hugepage migration works well only for pmd-based hugepages
(mainly due to lack of testing,) so we had better not enable migration of
other levels of hugepages until we are ready for it.

Some users of hugepage migration (mbind, move_pages, and migrate_pages) do
page table walk and check pud/pmd_huge() there, so they are safe.  But the
other users (softoffline and memory hotremove) don't do this, so without
this patch they can try to migrate unexpected types of hugepages.

To prevent this, we introduce hugepage_migration_support() as an
architecture dependent check of whether hugepage are implemented on a pmd
basis or not.  And on some architecture multiple sizes of hugepages are
available, so hugepage_migration_support() also checks hugepage size.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/hugetlbpage.c     |    5 +++++
 arch/arm64/mm/hugetlbpage.c   |    5 +++++
 arch/ia64/mm/hugetlbpage.c    |    5 +++++
 arch/metag/mm/hugetlbpage.c   |    5 +++++
 arch/mips/mm/hugetlbpage.c    |    5 +++++
 arch/powerpc/mm/hugetlbpage.c |   10 ++++++++++
 arch/s390/mm/hugetlbpage.c    |    5 +++++
 arch/sh/mm/hugetlbpage.c      |    5 +++++
 arch/sparc/mm/hugetlbpage.c   |    5 +++++
 arch/tile/mm/hugetlbpage.c    |    5 +++++
 arch/x86/mm/hugetlbpage.c     |    8 ++++++++
 include/linux/hugetlb.h       |   12 ++++++++++++
 mm/migrate.c                  |   10 ++++++++++
 13 files changed, 85 insertions(+)

diff -puN arch/arm/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page arch/arm/mm/hugetlbpage.c
--- a/arch/arm/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/arch/arm/mm/hugetlbpage.c
@@ -99,3 +99,8 @@ int pmd_huge(pmd_t pmd)
 {
 	return pmd_val(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
 }
+
+int pmd_huge_support(void)
+{
+	return 1;
+}
diff -puN arch/arm64/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page arch/arm64/mm/hugetlbpage.c
--- a/arch/arm64/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -54,6 +54,11 @@ int pud_huge(pud_t pud)
 	return !(pud_val(pud) & PUD_TABLE_BIT);
 }
 
+int pmd_huge_support(void)
+{
+	return 1;
+}
+
 static __init int setup_hugepagesz(char *opt)
 {
 	unsigned long ps = memparse(opt, &opt);
diff -puN arch/ia64/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -114,6 +114,11 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
+int pmd_huge_support(void)
+{
+	return 0;
+}
+
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address, pmd_t *pmd, int write)
 {
diff -puN arch/metag/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page arch/metag/mm/hugetlbpage.c
--- a/arch/metag/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/arch/metag/mm/hugetlbpage.c
@@ -110,6 +110,11 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
+int pmd_huge_support(void)
+{
+	return 1;
+}
+
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff -puN arch/mips/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page arch/mips/mm/hugetlbpage.c
--- a/arch/mips/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/arch/mips/mm/hugetlbpage.c
@@ -85,6 +85,11 @@ int pud_huge(pud_t pud)
 	return (pud_val(pud) & _PAGE_HUGE) != 0;
 }
 
+int pmd_huge_support(void)
+{
+	return 1;
+}
+
 struct page *
 follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 		pmd_t *pmd, int write)
diff -puN arch/powerpc/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -86,6 +86,11 @@ int pgd_huge(pgd_t pgd)
 	 */
 	return ((pgd_val(pgd) & 0x3) != 0x0);
 }
+
+int pmd_huge_support(void)
+{
+	return 1;
+}
 #else
 int pmd_huge(pmd_t pmd)
 {
@@ -101,6 +106,11 @@ int pgd_huge(pgd_t pgd)
 {
 	return 0;
 }
+
+int pmd_huge_support(void)
+{
+	return 0;
+}
 #endif
 
 pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
diff -puN arch/s390/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page arch/s390/mm/hugetlbpage.c
--- a/arch/s390/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/arch/s390/mm/hugetlbpage.c
@@ -117,6 +117,11 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
+int pmd_huge_support(void)
+{
+	return 1;
+}
+
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmdp, int write)
 {
diff -puN arch/sh/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page arch/sh/mm/hugetlbpage.c
--- a/arch/sh/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/arch/sh/mm/hugetlbpage.c
@@ -83,6 +83,11 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
+int pmd_huge_support(void)
+{
+	return 0;
+}
+
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff -puN arch/sparc/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page arch/sparc/mm/hugetlbpage.c
--- a/arch/sparc/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -234,6 +234,11 @@ int pud_huge(pud_t pud)
 	return 0;
 }
 
+int pmd_huge_support(void)
+{
+	return 0;
+}
+
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff -puN arch/tile/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page arch/tile/mm/hugetlbpage.c
--- a/arch/tile/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/arch/tile/mm/hugetlbpage.c
@@ -198,6 +198,11 @@ int pud_huge(pud_t pud)
 	return !!(pud_val(pud) & _PAGE_HUGE_PAGE);
 }
 
+int pmd_huge_support(void)
+{
+	return 1;
+}
+
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 			     pmd_t *pmd, int write)
 {
diff -puN arch/x86/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/arch/x86/mm/hugetlbpage.c
@@ -59,6 +59,10 @@ follow_huge_pmd(struct mm_struct *mm, un
 	return NULL;
 }
 
+int pmd_huge_support(void)
+{
+	return 0;
+}
 #else
 
 struct page *
@@ -77,6 +81,10 @@ int pud_huge(pud_t pud)
 	return !!(pud_val(pud) & _PAGE_PSE);
 }
 
+int pmd_huge_support(void)
+{
+	return 1;
+}
 #endif
 
 /* x86_64 also uses this file */
diff -puN include/linux/hugetlb.h~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/include/linux/hugetlb.h
@@ -381,6 +381,16 @@ static inline pgoff_t basepage_index(str
 
 extern void dissolve_free_huge_pages(unsigned long start_pfn,
 				     unsigned long end_pfn);
+int pmd_huge_support(void);
+/*
+ * Currently hugepage migration is enabled only for pmd-based hugepage.
+ * This function will be updated when hugepage migration is more widely
+ * supported.
+ */
+static inline int hugepage_migration_support(struct hstate *h)
+{
+	return pmd_huge_support() && (huge_page_shift(h) == PMD_SHIFT);
+}
 
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
@@ -409,6 +419,8 @@ static inline pgoff_t basepage_index(str
 	return page->index;
 }
 #define dissolve_free_huge_pages(s, e)	do {} while (0)
+#define pmd_huge_support()	0
+#define hugepage_migration_support(h)	0
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 #endif /* _LINUX_HUGETLB_H */
diff -puN mm/migrate.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page mm/migrate.c
--- a/mm/migrate.c~mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page
+++ a/mm/migrate.c
@@ -949,6 +949,16 @@ static int unmap_and_move_huge_page(new_
 	struct page *new_hpage = get_new_page(hpage, private, &result);
 	struct anon_vma *anon_vma = NULL;
 
+	/*
+	 * Movability of hugepages depends on architectures and hugepage size.
+	 * This check is necessary because some callers of hugepage migration
+	 * like soft offline and memory hotremove don't walk through page
+	 * tables or check whether the hugepage is pmd-based or not before
+	 * kicking migration.
+	 */
+	if (!hugepage_migration_support(page_hstate(hpage)))
+		return -ENOSYS;
+
 	if (!new_hpage)
 		return -ENOMEM;
 
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

