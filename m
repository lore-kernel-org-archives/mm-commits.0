From: akpm@linux-foundation.org
Subject: + hugetlb-provide-a-default-hpage_shift-if-config_hugetlb_page.patch added to -mm tree
Date: Thu, 17 Nov 2011 15:28:53 -0800
Message-ID: <201111172328.pAHNSrFm019745@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:40072 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab1KQX24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 18:28:56 -0500
Received: by vcbfl13 with SMTP id fl13so387020vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 15:28:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.daney@cavium.com, ralf@linux-mips.org, rientjes@google.com


The patch titled
     Subject: hugetlb: provide a default HPAGE_SHIFT if !CONFIG_HUGETLB_PAGE
has been added to the -mm tree.  Its filename is
     hugetlb-provide-a-default-hpage_shift-if-config_hugetlb_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Daney <david.daney@cavium.com>
Subject: hugetlb: provide a default HPAGE_SHIFT if !CONFIG_HUGETLB_PAGE

When linux-next 10111117 is build for MIPS with cavium-octeon_defconfig,
we get:

  arch/mips/mm/tlb-r4k.c: In function 'local_flush_tlb_range':
  arch/mips/mm/tlb-r4k.c:129:28: error: 'HPAGE_SHIFT' undeclared (first use in this function)

The fix is to supply a dummy HPAGE_SHIFT in the !CONFIG_HUGETLB_PAGE case.
Instead of supplying the non-huge value, as was done for HPAGE_MASK and
HPAGE_SIZE, we do BUG() instead.  This satisfies the compiler, but gives us
runtime safety if someone were to use HPAGE_SIZE incorrectly.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/hugetlb.h~hugetlb-provide-a-default-hpage_shift-if-config_hugetlb_page include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-provide-a-default-hpage_shift-if-config_hugetlb_page
+++ a/include/linux/hugetlb.h
@@ -113,6 +113,7 @@ static inline void copy_huge_page(struct
 #ifndef HPAGE_MASK
 #define HPAGE_MASK	PAGE_MASK		/* Keep the compiler happy */
 #define HPAGE_SIZE	PAGE_SIZE
+#define HPAGE_SHIFT	({BUG(); 0; })
 #endif
 
 #endif /* !CONFIG_HUGETLB_PAGE */
_
Subject: Subject: hugetlb: provide a default HPAGE_SHIFT if !CONFIG_HUGETLB_PAGE

Patches currently in -mm which might be from david.daney@cavium.com are

origin.patch
linux-next.patch
hugetlb-provide-a-default-hpage_shift-if-config_hugetlb_page.patch
hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size.patch
hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix.patch

