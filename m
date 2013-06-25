From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch removed from -mm tree
Date: Tue, 25 Jun 2013 12:23:02 -0700
Message-ID: <51c9ee16.oP9Y0Uq+U082umZB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3FYTXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:23:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, david@gibson.dropbear.id.au, benh@kernel.crashing.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com

Subject: [merged] mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch removed from -mm tree
To: aneesh.kumar@linux.vnet.ibm.com,aarcange@redhat.com,benh@kernel.crashing.org,david@gibson.dropbear.id.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:23:02 -0700


The patch titled
     Subject: mm/THP: don't use HPAGE_SHIFT in transparent hugepage code
has been removed from the -mm tree.  Its filename was
     mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/THP: don't use HPAGE_SHIFT in transparent hugepage code

For architectures like powerpc that support multiple explicit hugepage
sizes, HPAGE_SHIFT indicate the default explicit hugepage shift.  For THP
to work the hugepage size should be same as PMD_SIZE.  So use PMD_SHIFT
directly.  So move the define outside CONFIG_TRANSPARENT_HUGEPAGE #ifdef
because we want to use these defines in generic code with if
(pmd_trans_huge()) conditional.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN include/linux/huge_mm.h~mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code
+++ a/include/linux/huge_mm.h
@@ -58,12 +58,11 @@ extern pmd_t *page_check_address_pmd(str
 
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
+#define HPAGE_PMD_SHIFT PMD_SHIFT
+#define HPAGE_PMD_SIZE	((1UL) << HPAGE_PMD_SHIFT)
+#define HPAGE_PMD_MASK	(~(HPAGE_PMD_SIZE - 1))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define HPAGE_PMD_SHIFT HPAGE_SHIFT
-#define HPAGE_PMD_MASK HPAGE_MASK
-#define HPAGE_PMD_SIZE HPAGE_SIZE
