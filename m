From: akpm@linux-foundation.org
Subject: [merged] mm-gup-make-__gup_device_-require-thp.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:38:31 -0700
Message-ID: <20170907183831.YkKzgmaft%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55680 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755874AbdIGSic (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:38:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, oohall@gmail.com


The patch titled
     Subject: mm/gup: make __gup_device_* require THP
has been removed from the -mm tree.  Its filename was
     mm-gup-make-__gup_device_-require-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Oliver O'Halloran" <oohall@gmail.com>
Subject: mm/gup: make __gup_device_* require THP

These functions are the only bits of generic code that use {pud,pmd}_pfn()
without checking for CONFIG_TRANSPARENT_HUGEPAGE.  This works fine on x86,
the only arch with devmap support, since the *_pfn() functions are always
defined there, but this isn't true for every architecture.

Link: http://lkml.kernel.org/r/20170626063833.11094-1-oohall@gmail.com
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/gup.c~mm-gup-make-__gup_device_-require-thp mm/gup.c
--- a/mm/gup.c~mm-gup-make-__gup_device_-require-thp
+++ a/mm/gup.c
@@ -1352,7 +1352,7 @@ static int gup_pte_range(pmd_t pmd, unsi
 }
 #endif /* __HAVE_ARCH_PTE_SPECIAL */
 
-#ifdef __HAVE_ARCH_PTE_DEVMAP
+#if defined(__HAVE_ARCH_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
 static int __gup_device_huge(unsigned long pfn, unsigned long addr,
 		unsigned long end, struct page **pages, int *nr)
 {
_

Patches currently in -mm which might be from oohall@gmail.com are


