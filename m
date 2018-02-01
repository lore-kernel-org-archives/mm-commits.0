From: akpm@linux-foundation.org
Subject: [merged] get-7%-more-pages-in-a-pagevec.patch removed from
 -mm tree
Date: Thu, 01 Feb 2018 11:31:58 -0800
Message-ID: <20180201193158.Pk9Zzoyue%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58408 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753126AbeBATb7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:31:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm: get 7% more pages in a pagevec
has been removed from the -mm tree.  Its filename was
     get-7%-more-pages-in-a-pagevec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm: get 7% more pages in a pagevec

We don't have to use an entire 'long' for the number of elements in the
pagevec; we know it's a number between 0 and 14 (now 15).  So we can store
it in a char, and then the bool packs next to it and we still have two or
six bytes of padding for more elements in the header.  That gives us space
to cram in an extra page.

Link: http://lkml.kernel.org/r/20171206022521.GM26021@bombadil.infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/pagevec.h~get-7%-more-pages-in-a-pagevec include/linux/pagevec.h
--- a/include/linux/pagevec.h~get-7%-more-pages-in-a-pagevec
+++ a/include/linux/pagevec.h
@@ -9,14 +9,14 @@
 #ifndef _LINUX_PAGEVEC_H
 #define _LINUX_PAGEVEC_H
 
-/* 14 pointers + two long's align the pagevec structure to a power of two */
-#define PAGEVEC_SIZE	14
+/* 15 pointers + header align the pagevec structure to a power of two */
+#define PAGEVEC_SIZE	15
 
 struct page;
 struct address_space;
 
 struct pagevec {
-	unsigned long nr;
+	unsigned char nr;
 	bool percpu_pvec_drained;
 	struct page *pages[PAGEVEC_SIZE];
 };
_

Patches currently in -mm which might be from willy@infradead.org are


