From: akpm@linux-foundation.org
Subject: [wrecked] hugetlb-provide-a-default-hpage_shift-if-config_hugetlb_page.patch removed from -mm tree
Date: Mon, 21 Nov 2011 12:39:02 -0800
Message-ID: <201111212039.pALKd2Ne028605@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:47342 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab1KUUjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 15:39:05 -0500
Received: by ggnk3 with SMTP id k3so125898ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 12:39:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.daney@cavium.com, ralf@linux-mips.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: provide a default HPAGE_SHIFT if !CONFIG_HUGETLB_PAGE
has been removed from the -mm tree.  Its filename was
     hugetlb-provide-a-default-hpage_shift-if-config_hugetlb_page.patch

This patch was dropped because other changes were merged, which wrecked this patch

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

Patches currently in -mm which might be from david.daney@cavium.com are

origin.patch
linux-next.patch
hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size.patch
hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix.patch

