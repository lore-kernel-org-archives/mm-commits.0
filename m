From: akpm@linux-foundation.org
Subject: + kfifo-cleanup-example-to-not-use-page_link.patch added to -mm
 tree
Date: Thu, 01 Jun 2017 14:55:36 -0700
Message-ID: <59308d58.KJd7H/sIosyT7q0l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33044 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdFAVzh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2017 17:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: logang@deltatee.com, greg@kroah.com, sbates@raithlin.com, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kfifo: clean up example to not use page_link
has been added to the -mm tree.  Its filename is
     kfifo-cleanup-example-to-not-use-page_link.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kfifo-cleanup-example-to-not-use-page_link.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kfifo-cleanup-example-to-not-use-page_link.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Logan Gunthorpe <logang@deltatee.com>
Subject: kfifo: clean up example to not use page_link

This is a layering violation so we replace the uses with calls to
sg_page().  This is a prep patch for replacing page_link and this is one
of the very few uses outside of scatterlist.h.

Link: http://lkml.kernel.org/r/1496333486.1567.0.camel@seibold.net
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Stephen Bates <sbates@raithlin.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kfifo/dma-example.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN samples/kfifo/dma-example.c~kfifo-cleanup-example-to-not-use-page_link samples/kfifo/dma-example.c
--- a/samples/kfifo/dma-example.c~kfifo-cleanup-example-to-not-use-page_link
+++ a/samples/kfifo/dma-example.c
@@ -75,8 +75,8 @@ static int __init example_init(void)
 	for (i = 0; i < nents; i++) {
 		printk(KERN_INFO
 		"sg[%d] -> "
-		"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
-			i, sg[i].page_link, sg[i].offset, sg[i].length);
+		"page %p offset 0x%.8x length 0x%.8x\n",
+			i, sg_page(&sg[i]), sg[i].offset, sg[i].length);
 
 		if (sg_is_last(&sg[i]))
 			break;
@@ -104,8 +104,8 @@ static int __init example_init(void)
 	for (i = 0; i < nents; i++) {
 		printk(KERN_INFO
 		"sg[%d] -> "
-		"page_link 0x%.8lx offset 0x%.8x length 0x%.8x\n",
-			i, sg[i].page_link, sg[i].offset, sg[i].length);
+		"page %p offset 0x%.8x length 0x%.8x\n",
+			i, sg_page(&sg[i]), sg[i].offset, sg[i].length);
 
 		if (sg_is_last(&sg[i]))
 			break;
_

Patches currently in -mm which might be from logang@deltatee.com are

tile-provide-default-ioremap-declaration.patch
kfifo-cleanup-example-to-not-use-page_link.patch

