From: akpm@linux-foundation.org
Subject: [wrecked] hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size.patch removed from -mm tree
Date: Mon, 21 Nov 2011 12:39:15 -0800
Message-ID: <201111212039.pALKdFoN002065@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:47342 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1KUUjQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 15:39:16 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so125898ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 12:39:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.daney@cavium.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: provide safer dummy values for HPAGE_MASK and HPAGE_SIZE
has been removed from the -mm tree.  Its filename was
     hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Daney <david.daney@cavium.com>
Subject: hugetlb: provide safer dummy values for HPAGE_MASK and HPAGE_SIZE

It was pointed out by David Rientjes that the dummy values for HPAGE_MASK
and HPAGE_SIZE are quite unsafe.  It they are inadvertently used with
!CONFIG_HUGETLB_PAGE, compilation would succeed, but the resulting code
would surly not do anything sensible.

Place BUG() in the these dummy definitions, as we do in similar
circumstances in other places, so any abuse can be easily detected.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size
+++ a/include/linux/hugetlb.h
@@ -111,8 +111,9 @@ static inline void copy_huge_page(struct
 #define hugetlb_change_protection(vma, address, end, newprot)
 
 #ifndef HPAGE_MASK
-#define HPAGE_MASK	PAGE_MASK		/* Keep the compiler happy */
-#define HPAGE_SIZE	PAGE_SIZE
+/* Keep the compiler happy with some dummy (but BUGgy) values */
+#define HPAGE_MASK	({BUG(); 0; })
+#define HPAGE_SIZE	({BUG(); 0; })
 #define HPAGE_SHIFT	({BUG(); 0; })
 #endif
 
_

Patches currently in -mm which might be from david.daney@cavium.com are

origin.patch
linux-next.patch
hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix.patch

