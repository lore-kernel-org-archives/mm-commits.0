From: akpm@linux-foundation.org
Subject: [patch 070/108] powerpc/hugetlb: enable hugetlb migration
 for ppc64
Date: Thu, 06 Jul 2017 15:39:05 -0700
Message-ID: <20170706223905.0dQhnwXpV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36564 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752056AbdGFWjG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:39:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, kravetz@us.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org

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
