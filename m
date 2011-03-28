From: akpm@linux-foundation.org
Subject: + memstick-make-enable_dma-less-generic-in-r592.patch added to -mm tree
Date: Mon, 28 Mar 2011 16:38:05 -0700
Message-ID: <201103282338.p2SNc5au004870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044Ab1C1Xiq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Mar 2011 19:38:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, fujita.tomonori@lab.ntt.co.jp, maximlevitsky@gmail.com, oakad@yahoo.com


The patch titled
     memstick: make enable_dma less generic in r592
has been added to the -mm tree.  Its filename is
     memstick-make-enable_dma-less-generic-in-r592.patch

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
Subject: memstick: make enable_dma less generic in r592
From: Stephen Rothwell <sfr@canb.auug.org.au>

Fixes this build error:

drivers/memstick/host/r592.c:26: error: 'enable_dma' redeclared as different kind of symbol
arch/powerpc/include/asm/dma.h:189: note: previous definition of 'enable_dma' was here

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/r592.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/memstick/host/r592.c~memstick-make-enable_dma-less-generic-in-r592 drivers/memstick/host/r592.c
--- a/drivers/memstick/host/r592.c~memstick-make-enable_dma-less-generic-in-r592
+++ a/drivers/memstick/host/r592.c
@@ -23,7 +23,7 @@
 #include <linux/swab.h>
 #include "r592.h"
 
-static int enable_dma = 1;
+static int r592_enable_dma = 1;
 static int debug;
 
 static const char *tpc_names[] = {
@@ -267,7 +267,7 @@ static void r592_stop_dma(struct r592_de
 /* Test if hardware supports DMA */
 static void r592_check_dma(struct r592_device *dev)
 {
-	dev->dma_capable = enable_dma &&
+	dev->dma_capable = r592_enable_dma &&
 		(r592_read_reg(dev, R592_FIFO_DMA_SETTINGS) &
 			R592_FIFO_DMA_SETTINGS_CAP);
 }
@@ -898,7 +898,7 @@ static void __exit r592_module_exit(void
 module_init(r592_module_init);
 module_exit(r592_module_exit);
 
-module_param(enable_dma, bool, S_IRUGO);
+module_param_named(enable_dma, r592_enable_dma, bool, S_IRUGO);
 MODULE_PARM_DESC(enable_dma, "Enable usage of the DMA (default)");
 module_param(debug, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug level (0-3)");
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
memstick-make-enable_dma-less-generic-in-r592.patch
linux-next.patch

