From: akpm@linux-foundation.org
Subject: + powerpc-mm-hugetlb-add-support-for-1g-huge-pages.patch added to -mm tree
Date: Wed, 17 May 2017 15:06:44 -0700
Message-ID: <591cc974.biX+VGmcG279G5Bs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753658AbdEQWGp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2017 18:06:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm/hugetlb: add support for 1G huge pages
has been added to the -mm tree.  Its filename is
     powerpc-mm-hugetlb-add-support-for-1g-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-hugetlb-add-support-for-1g-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-hugetlb-add-support-for-1g-huge-pages.patch

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

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-hugetlb-migration-use-set_huge_pte_at-instead-of-set_pte_at.patch
mm-follow_page_mask-split-follow_page_mask-to-smaller-functions.patch
mm-hugetlb-export-hugetlb_entry_migration-helper.patch
mm-hugetlb-move-default-definition-of-hugepd_t-earlier-in-the-header.patch
mm-follow_page_mask-add-support-for-hugepage-directory-entry.patch
powerpc-hugetlb-add-follow_huge_pd-implementation-for-ppc64.patch
powerpc-mm-hugetlb-remove-follow_huge_addr-for-powerpc.patch
powerpc-hugetlb-enable-hugetlb-migration-for-ppc64.patch
mm-hugetlb-cleanup-arch_has_gigantic_page.patch
powerpc-mm-hugetlb-add-support-for-1g-huge-pages.patch

