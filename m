From: akpm@linux-foundation.org
Subject: + hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size.patch added to -mm tree
Date: Thu, 17 Nov 2011 15:28:57 -0800
Message-ID: <201111172328.pAHNSvfe014558@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:62639 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab1KQX3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 18:29:01 -0500
Received: by faap16 with SMTP id p16so80710faa.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 15:29:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.daney@cavium.com, rientjes@google.com


The patch titled
     Subject: hugetlb: provide safer dummy values for HPAGE_MASK and HPAGE_SIZE
has been added to the -mm tree.  Its filename is
     hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size.patch

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
Subject: Subject: hugetlb: provide safer dummy values for HPAGE_MASK and HPAGE_SIZE

Patches currently in -mm which might be from david.daney@cavium.com are

origin.patch
linux-next.patch
hugetlb-provide-a-default-hpage_shift-if-config_hugetlb_page.patch
hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size.patch
hugetlb-provide-safer-dummy-values-for-hpage_mask-and-hpage_size-fix.patch

