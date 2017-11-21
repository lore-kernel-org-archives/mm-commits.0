From: akpm@linux-foundation.org
Subject: + zswap-same-filled-pages-handling-v2.patch added to -mm tree
Date: Tue, 21 Nov 2017 12:49:34 -0800
Message-ID: <5a14915e.DVylVut/gl5twtxf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57820 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdKUUtf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 15:49:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srividya.dr@samsung.com, ddstreet@ieee.org, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap-same-filled-pages-handling-v2
has been added to the -mm tree.  Its filename is
     zswap-same-filled-pages-handling-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zswap-same-filled-pages-handling-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zswap-same-filled-pages-handling-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Srividya Desireddy <srividya.dr@samsung.com>
Subject: zswap-same-filled-pages-handling-v2

Added memset_l instead of for loop.

Signed-off-by: Srividya Desireddy <srividya.dr@samsung.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN mm/zswap.c~zswap-same-filled-pages-handling-v2 mm/zswap.c
--- a/mm/zswap.c~zswap-same-filled-pages-handling-v2
+++ a/mm/zswap.c
@@ -984,16 +984,10 @@ static int zswap_is_page_same_filled(voi
 
 static void zswap_fill_page(void *ptr, unsigned long value)
 {
-	unsigned int pos;
 	unsigned long *page;
 
 	page = (unsigned long *)ptr;
-	if (value == 0)
-		memset(page, 0, PAGE_SIZE);
-	else {
-		for (pos = 0; pos < PAGE_SIZE / sizeof(*page); pos++)
-			page[pos] = value;
-	}
+	memset_l(page, value, PAGE_SIZE / sizeof(unsigned long));
 }
 
 /*********************************
_

Patches currently in -mm which might be from srividya.dr@samsung.com are

zswap-same-filled-pages-handling.patch
zswap-same-filled-pages-handling-v2.patch

