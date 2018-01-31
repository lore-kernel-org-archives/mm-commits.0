From: akpm@linux-foundation.org
Subject: [folded-merged] zswap-same-filled-pages-handling-v2.patch removed from -mm tree
Date: Wed, 31 Jan 2018 15:48:35 -0800
Message-ID: <5a7255d3.G+SLkJ9GbJod//j5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754271AbeAaXsg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:48:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srividya.dr@samsung.com, ddstreet@ieee.org, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap-same-filled-pages-handling-v2
has been removed from the -mm tree.  Its filename was
     zswap-same-filled-pages-handling-v2.patch

This patch was dropped because it was folded into zswap-same-filled-pages-handling.patch

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

