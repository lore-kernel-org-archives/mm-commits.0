From: akpm@linux-foundation.org
Subject: + kfifo-replace-the-old-non-generic-api-kfifo-fix-scatterlist-usage.patch added to -mm tree
Date: Wed, 02 Jun 2010 13:19:35 -0700
Message-ID: <201006022019.o52KJZQC014816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932937Ab0FBUTw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 16:19:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@irasnyder.com, greg@kroah.com, stefani@seibold.net


The patch titled
     kfifo: fix scatterlist usage
has been added to the -mm tree.  Its filename is
     kfifo-replace-the-old-non-generic-api-kfifo-fix-scatterlist-usage.patch

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
Subject: kfifo: fix scatterlist usage
From: Ira W. Snyder <kernel@irasnyder.com>

The current kfifo scatterlist implementation will not work with chained
scatterlists.  It assumes that struct scatterlist arrays are allocated
contiguously, which is not the case when chained scatterlists (struct
sg_table) are in use.

Signed-off-by: Ira W. Snyder <kernel@irasnyder.com>
Cc: Greg KH <greg@kroah.com>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kfifo.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/kfifo.c~kfifo-replace-the-old-non-generic-api-kfifo-fix-scatterlist-usage kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-replace-the-old-non-generic-api-kfifo-fix-scatterlist-usage
+++ a/kernel/kfifo.c
@@ -333,17 +333,16 @@ static int setup_sgl_buf(struct scatterl
 		buf += PAGE_SIZE;
 		npage = virt_to_page(buf);
 		if (page_to_phys(page) != page_to_phys(npage) - l) {
-			sgl->page_link = 0;
-			sg_set_page(sgl++, page, l - off, off);
-			if (++n == nents)
+			sg_set_page(sgl, page, l - off, off);
+			sgl = sg_next(sgl);
+			if (++n == nents || sgl == NULL)
 				return n;
 			page = npage;
 			len -= l - off;
 			l = off = 0;
 		}
 	}
-	sgl->page_link = 0;
-	sg_set_page(sgl++, page, len, off);
+	sg_set_page(sgl, page, len, off);
 	return n + 1;
 }
 
_

Patches currently in -mm which might be from kernel@irasnyder.com are

kfifo-replace-the-old-non-generic-api-kfifo-fix-scatterlist-usage.patch

