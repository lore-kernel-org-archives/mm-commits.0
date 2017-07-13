From: akpm@linux-foundation.org
Subject: [merged] kfifo-cleanup-example-to-not-use-page_link.patch
 removed from -mm tree
Date: Thu, 13 Jul 2017 13:41:01 -0700
Message-ID: <20170713204101.m-dide6H5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59072 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753095AbdGMUlC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: greg@kroah.com, logang@deltatee.com, mm-commits@vger.kernel.org, sbates@raithlin.com, stefani@seibold.net


The patch titled
     Subject: kfifo: clean up example to not use page_link
has been removed from the -mm tree.  Its filename was
     kfifo-cleanup-example-to-not-use-page_link.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from logang@deltatee.com are


