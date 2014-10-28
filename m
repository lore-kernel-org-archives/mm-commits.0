From: akpm@linux-foundation.org
Subject: +
 smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page-fix.patch added to -mm tree
Date: Tue, 28 Oct 2014 13:36:26 -0700
Message-ID: <544ffe4a.qiR5S7KASq20b1b/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaJ1UgZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 16:36:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yfw.kernel@gmail.com, dave.hansen@intel.com, fengguang.wu@intel.com, kirill@shutemov.name, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page-fix
has been added to the -mm tree.  Its filename is
     smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengwei Yin <yfw.kernel@gmail.com>
Subject: smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page-fix

fix build with/without CONFIG_TRANSPARENT_HUGEPAGE

Signed-off-by: Fengwei Yin <yfw.kernel@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/huge_mm.h~smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page-fix include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page-fix
+++ a/include/linux/huge_mm.h
@@ -34,8 +34,6 @@ extern int change_huge_pmd(struct vm_are
 			unsigned long addr, pgprot_t newprot,
 			int prot_numa);
 
-extern bool is_huge_zero_pfn(unsigned long pfn);
-
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
@@ -159,6 +157,8 @@ static inline int hpage_nr_pages(struct
 extern int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp);
 
+extern bool is_huge_zero_pfn(unsigned long pfn);
+
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
@@ -207,6 +207,11 @@ static inline int do_huge_pmd_numa_page(
 {
 	return 0;
 }
+
+static inline bool is_huge_zero_pfn(unsigned long pfn)
+{
+	return 0;
+}
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
_

Patches currently in -mm which might be from yfw.kernel@gmail.com are

smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page.patch
smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page-fix.patch

