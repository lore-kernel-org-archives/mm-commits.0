From: akpm@linux-foundation.org
Subject: + mm-gup-make-__gup_device_-require-thp.patch added to -mm tree
Date: Fri, 21 Jul 2017 16:14:03 -0700
Message-ID: <59728abb.SEsdjufPDI/LLir5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753111AbdGUXOD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 19:14:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oohall@gmail.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: make __gup_device_* require THP
has been added to the -mm tree.  Its filename is
     mm-gup-make-__gup_device_-require-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-make-__gup_device_-require-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-make-__gup_device_-require-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1370,7 +1370,7 @@ static int gup_pte_range(pmd_t pmd, unsi
 }
 #endif /* __HAVE_ARCH_PTE_SPECIAL */
 
-#ifdef __HAVE_ARCH_PTE_DEVMAP
+#if defined(__HAVE_ARCH_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
 static int __gup_device_huge(unsigned long pfn, unsigned long addr,
 		unsigned long end, struct page **pages, int *nr)
 {
_

Patches currently in -mm which might be from oohall@gmail.com are

mm-gup-make-__gup_device_-require-thp.patch

