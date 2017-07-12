From: akpm@linux-foundation.org
Subject: [patch 27/96] kfifo: clean up example to not use page_link
Date: Wed, 12 Jul 2017 14:34:22 -0700
Message-ID: <20170712213422.Y3UKddGE7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVeX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:34:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, logang@deltatee.com, mm-commits@vger.kernel.org, sbates@raithlin.com, stefani@seibold.net, torvalds@linux-foundation.org

From: Logan Gunthorpe <logang@deltatee.com>
Subject: kfifo: clean up example to not use page_link

This is a layering violation so we replace the uses with calls to
sg_page().  This is a prep patch for replacing page_link and this is one
of the very few uses outside of scatterlist.h.

Link: http://lkml.kernel.org/r/1495663199-22234-1-git-send-email-logang@deltatee.com
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
