From: akpm@linux-foundation.org
Subject: [patch 059/119] mm: get 7% more pages in a pagevec
Date: Wed, 31 Jan 2018 16:17:40 -0800
Message-ID: <20180201001740.50Y5ub3VO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35004 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754177AbeBAARl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:17:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, willy@infradead.org

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
