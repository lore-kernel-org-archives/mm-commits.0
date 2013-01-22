From: akpm@linux-foundation.org
Subject: + mm-remove-unused-memclear_highpage_flush.patch added to -mm tree
Date: Tue, 22 Jan 2013 14:34:39 -0800
Message-ID: <20130122223439.9888B5A4260@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:40321 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3AVWek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 17:34:40 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so65897qea.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 14:34:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com


The patch titled
     Subject: mm: remove unused memclear_highpage_flush()
has been added to the -mm tree.  Its filename is
     mm-remove-unused-memclear_highpage_flush.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: remove unused memclear_highpage_flush()

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    6 ------
 1 file changed, 6 deletions(-)

diff -puN include/linux/highmem.h~mm-remove-unused-memclear_highpage_flush include/linux/highmem.h
--- a/include/linux/highmem.h~mm-remove-unused-memclear_highpage_flush
+++ a/include/linux/highmem.h
@@ -219,12 +219,6 @@ static inline void zero_user(struct page
 	zero_user_segments(page, start, start + size, 0, 0);
 }
 
-static inline void __deprecated memclear_highpage_flush(struct page *page,
-			unsigned int offset, unsigned int size)
-{
-	zero_user(page, offset, size);
-}
