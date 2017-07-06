From: akpm@linux-foundation.org
Subject: [patch 075/108] powerpc/mm/hugetlb: add support for 1G
 huge pages
Date: Thu, 06 Jul 2017 15:39:20 -0700
Message-ID: <20170706223920.Xa2AeH_Ni%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36616 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbdGFWjW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:39:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, torvalds@linux-foundation.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc/mm/hugetlb: add support for 1G huge pages

POWER9 supports hugepages of size 2M and 1G in radix MMU mode.  This patch
enables the usage of 1G page size for hugetlbfs.  This also update the
helper such we can do 1G page allocation at runtime.

We still don't enable 1G page size on DD1 version.  This is to avoid doing
workaround mentioned in commit: 6d3a0379ebdc8 ("powerpc/mm: Add
radix__tlb_flush_pte_p9_dd1()").

Link: http://lkml.kernel.org/r/1494995292-4443-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/hugetlb.h |   10 ++++++++++
 arch/powerpc/mm/hugetlbpage.c                |    7 +++++--
 arch/powerpc/platforms/Kconfig.cputype       |    1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/hugetlb.h~powerpc-mm-hugetlb-add-support-for-1g-huge-pages arch/powerpc/include/asm/book3s/64/hugetlb.h
--- a/arch/powerpc/include/asm/book3s/64/hugetlb.h~powerpc-mm-hugetlb-add-support-for-1g-huge-pages
+++ a/arch/powerpc/include/asm/book3s/64/hugetlb.h
@@ -50,4 +50,14 @@ static inline pte_t arch_make_huge_pte(p
 	else
 		return entry;
 }
+
+#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
+static inline bool gigantic_page_supported(void)
+{
+	if (radix_enabled())
+		return true;
+	return false;
+}
+#endif
+
 #endif
diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-mm-hugetlb-add-support-for-1g-huge-pages arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-mm-hugetlb-add-support-for-1g-huge-pages
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -742,8 +742,11 @@ static int __init add_huge_page_size(uns
 	 * Hash: 16M and 16G
 	 */
 	if (radix_enabled()) {
-		if (mmu_psize != MMU_PAGE_2M)
-			return -EINVAL;
+		if (mmu_psize != MMU_PAGE_2M) {
+			if (cpu_has_feature(CPU_FTR_POWER9_DD1) ||
+			    (mmu_psize != MMU_PAGE_1G))
+				return -EINVAL;
+		}
 	} else {
 		if (mmu_psize != MMU_PAGE_16M && mmu_psize != MMU_PAGE_16G)
 			return -EINVAL;
diff -puN arch/powerpc/platforms/Kconfig.cputype~powerpc-mm-hugetlb-add-support-for-1g-huge-pages arch/powerpc/platforms/Kconfig.cputype
--- a/arch/powerpc/platforms/Kconfig.cputype~powerpc-mm-hugetlb-add-support-for-1g-huge-pages
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -344,6 +344,7 @@ config PPC_STD_MMU_64
 config PPC_RADIX_MMU
 	bool "Radix MMU Support"
 	depends on PPC_BOOK3S_64
+	select ARCH_HAS_GIGANTIC_PAGE if (MEMORY_ISOLATION && COMPACTION) || CMA
 	default y
 	help
 	  Enable support for the Power ISA 3.0 Radix style MMU. Currently this
_
