From: akpm@linux-foundation.org
Subject: + mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch added to -mm tree
Date: Mon, 13 May 2013 16:14:06 -0700
Message-ID: <20130513231406.D912031C276@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:61633 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab3EMXOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:14:08 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so668525ggm.5
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:14:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, david@gibson.dropbear.id.au


The patch titled
     Subject: mm/THP: don't use HPAGE_SHIFT in transparent hugepage code
has been added to the -mm tree.  Its filename is
     mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch

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
