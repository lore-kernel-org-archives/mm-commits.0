From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-introduce-config_arch_enable_thp_migration.patch removed from -mm
 tree
Date: Mon, 11 Sep 2017 12:38:20 -0700
Message-ID: <20170911193820.QHDoxPykQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48410 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdIKTi1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:38:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dave.hansen@intel.com, dnellans@nvidia.com, hpa@zytor.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, tglx@linutronix.de, vbabka@suse.cz, zi.yan@cs.rutgers.edu


The patch titled
     Subject: mm: thp: introduce CONFIG_ARCH_ENABLE_THP_MIGRATION
has been removed from the -mm tree.  Its filename was
     mm-thp-introduce-config_arch_enable_thp_migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: thp: introduce CONFIG_ARCH_ENABLE_THP_MIGRATION

Introduce CONFIG_ARCH_ENABLE_THP_MIGRATION to limit thp migration
functionality to x86_64, which should be safer at the first step.

Link: http://lkml.kernel.org/r/20170717193955.20207-5-zi.yan@sent.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Reviewed-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig        |    4 ++++
 include/linux/huge_mm.h |   10 ++++++++++
 mm/Kconfig              |    3 +++
 3 files changed, 17 insertions(+)

diff -puN arch/x86/Kconfig~mm-thp-introduce-config_arch_enable_thp_migration arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-thp-introduce-config_arch_enable_thp_migration
+++ a/arch/x86/Kconfig
@@ -2343,6 +2343,10 @@ config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	def_bool y
 	depends on X86_64 && HUGETLB_PAGE && MIGRATION
 
+config ARCH_ENABLE_THP_MIGRATION
+	def_bool y
+	depends on X86_64 && TRANSPARENT_HUGEPAGE
+
 menu "Power management and ACPI options"
 
 config ARCH_HIBERNATION_HEADER
diff -puN include/linux/huge_mm.h~mm-thp-introduce-config_arch_enable_thp_migration include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-introduce-config_arch_enable_thp_migration
+++ a/include/linux/huge_mm.h
@@ -233,6 +233,11 @@ void mm_put_huge_zero_page(struct mm_str
 
 #define mk_huge_pmd(page, prot) pmd_mkhuge(mk_pmd(page, prot))
 
+static inline bool thp_migration_supported(void)
+{
+	return IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);
+}
+
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
@@ -336,6 +341,11 @@ static inline struct page *follow_devmap
 {
 	return NULL;
 }
+
+static inline bool thp_migration_supported(void)
+{
+	return false;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff -puN mm/Kconfig~mm-thp-introduce-config_arch_enable_thp_migration mm/Kconfig
--- a/mm/Kconfig~mm-thp-introduce-config_arch_enable_thp_migration
+++ a/mm/Kconfig
@@ -262,6 +262,9 @@ config MIGRATION
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
 
+config ARCH_ENABLE_THP_MIGRATION
+	bool
+
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


