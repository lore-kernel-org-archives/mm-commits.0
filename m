From: akpm@linux-foundation.org
Subject: + get-7%-more-pages-in-a-pagevec.patch added to -mm tree
Date: Tue, 12 Dec 2017 15:32:08 -0800
Message-ID: <5a3066f8.b6jwpVWZaywhfhXg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39766 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752807AbdLLXcJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Dec 2017 18:32:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@infradead.org, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: get 7% more pages in a pagevec
has been added to the -mm tree.  Its filename is
     get-7%-more-pages-in-a-pagevec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get-7%25-more-pages-in-a-pagevec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get-7%25-more-pages-in-a-pagevec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-add-unmap_mapping_pages.patch
get-7%-more-pages-in-a-pagevec.patch

