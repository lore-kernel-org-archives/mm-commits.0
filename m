From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-move-default-definition-of-hugepd_t-earlier-in-the-header.patch
 added to -mm tree
Date: Tue, 16 May 2017 13:12:18 -0700
Message-ID: <591b5d22.AfbOlJvI8b9B8JGh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbdEPUMT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 16:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, kravetz@us.ibm.com, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: move default definition of hugepd_t earlier in the header
has been added to the -mm tree.  Its filename is
     mm-hugetlb-move-default-definition-of-hugepd_t-earlier-in-the-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-move-default-definition-of-hugepd_t-earlier-in-the-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-move-default-definition-of-hugepd_t-earlier-in-the-header.patch

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
Subject: mm/hugetlb: move default definition of hugepd_t earlier in the header

This enable to use the hugepd_t type early.  No functional change in this
patch.

Link: http://lkml.kernel.org/r/1494926612-23928-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   47 +++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-move-default-definition-of-hugepd_t-earlier-in-the-header include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-move-default-definition-of-hugepd_t-earlier-in-the-header
+++ a/include/linux/hugetlb.h
@@ -14,6 +14,30 @@ struct ctl_table;
 struct user_struct;
 struct mmu_gather;
 
+#ifndef is_hugepd
+/*
+ * Some architectures requires a hugepage directory format that is
+ * required to support multiple hugepage sizes. For example
+ * a4fe3ce76 "powerpc/mm: Allow more flexible layouts for hugepage pagetables"
+ * introduced the same on powerpc. This allows for a more flexible hugepage
+ * pagetable layout.
+ */
+typedef struct { unsigned long pd; } hugepd_t;
+#define is_hugepd(hugepd) (0)
+#define __hugepd(x) ((hugepd_t) { (x) })
+static inline int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
+			      unsigned pdshift, unsigned long end,
+			      int write, struct page **pages, int *nr)
+{
+	return 0;
+}
+#else
+extern int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
+		       unsigned pdshift, unsigned long end,
+		       int write, struct page **pages, int *nr);
+#endif
+
+
 #ifdef CONFIG_HUGETLB_PAGE
 
 #include <linux/mempolicy.h>
@@ -222,29 +246,6 @@ static inline int pud_write(pud_t pud)
 }
 #endif
 
-#ifndef is_hugepd
-/*
- * Some architectures requires a hugepage directory format that is
- * required to support multiple hugepage sizes. For example
- * a4fe3ce76 "powerpc/mm: Allow more flexible layouts for hugepage pagetables"
- * introduced the same on powerpc. This allows for a more flexible hugepage
- * pagetable layout.
- */
-typedef struct { unsigned long pd; } hugepd_t;
-#define is_hugepd(hugepd) (0)
-#define __hugepd(x) ((hugepd_t) { (x) })
-static inline int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
-			      unsigned pdshift, unsigned long end,
-			      int write, struct page **pages, int *nr)
-{
-	return 0;
-}
-#else
-extern int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
-		       unsigned pdshift, unsigned long end,
-		       int write, struct page **pages, int *nr);
-#endif
