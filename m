From: akpm@linux-foundation.org
Subject: + powerpc-hugetlb-enable-hugetlb-migration-for-ppc64.patch added
 to -mm tree
Date: Tue, 16 May 2017 13:12:27 -0700
Message-ID: <591b5d2b.3uf4m6amMjcONNbR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752735AbdEPUM2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 16:12:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, kravetz@us.ibm.com, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/hugetlb: enable hugetlb migration for ppc64
has been added to the -mm tree.  Its filename is
     powerpc-hugetlb-enable-hugetlb-migration-for-ppc64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-hugetlb-enable-hugetlb-migration-for-ppc64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-hugetlb-enable-hugetlb-migration-for-ppc64.patch

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
Subject: powerpc/hugetlb: enable hugetlb migration for ppc64

Link: http://lkml.kernel.org/r/1494926612-23928-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/Kconfig.cputype |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/powerpc/platforms/Kconfig.cputype~powerpc-hugetlb-enable-hugetlb-migration-for-ppc64 arch/powerpc/platforms/Kconfig.cputype
--- a/arch/powerpc/platforms/Kconfig.cputype~powerpc-hugetlb-enable-hugetlb-migration-for-ppc64
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -350,6 +350,11 @@ config PPC_RADIX_MMU
 	  is only implemented by IBM Power9 CPUs, if you don't have one of them
 	  you can probably disable this.
 
+config ARCH_ENABLE_HUGEPAGE_MIGRATION
+	def_bool y
+	depends on PPC_BOOK3S_64 && HUGETLB_PAGE && MIGRATION
+
+
 config PPC_MMU_NOHASH
 	def_bool y
 	depends on !PPC_STD_MMU
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

