From: akpm@linux-foundation.org
Subject: + usb-musb-use-ioreadwrite_rep-accessors.patch added to -mm tree
Date: Thu, 13 Dec 2012 14:46:47 -0800
Message-ID: <20121213224648.B57AD200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:55528 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab2LMWqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Dec 2012 17:46:52 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so141128lag.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Dec 2012 14:46:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthew@mattleach.net, arnd@arndb.de, balbi@ti.com, benh@kernel.crashing.org, greg@kroah.com, will.deacon@arm.com


The patch titled
     Subject: usb: musb: use io{read,write}*_rep accessors
has been added to the -mm tree.  Its filename is
     usb-musb-use-ioreadwrite_rep-accessors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Leach <matthew@mattleach.net>
Subject: usb: musb: use io{read,write}*_rep accessors

The {read,write}s{b,w,l} operations are not defined by all architectures
and are being removed from the asm-generic/io.h interface.

This patch replaces the usage of these string functions in the musb
accessors with io{read,write}{8,16,32}_rep calls instead.

Signed-off-by: Matthew Leach <matthew@mattleach.net>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/musb/musb_core.c |   12 ++++++------
 drivers/usb/musb/musb_io.h   |   21 ---------------------
 2 files changed, 6 insertions(+), 27 deletions(-)

diff -puN drivers/usb/musb/musb_core.c~usb-musb-use-ioreadwrite_rep-accessors drivers/usb/musb/musb_core.c
--- a/drivers/usb/musb/musb_core.c~usb-musb-use-ioreadwrite_rep-accessors
+++ a/drivers/usb/musb/musb_core.c
@@ -251,7 +251,7 @@ void musb_write_fifo(struct musb_hw_ep *
 		/* best case is 32bit-aligned source address */
 		if ((0x02 & (unsigned long) src) == 0) {
 			if (len >= 4) {
-				writesl(fifo, src + index, len >> 2);
+				iowrite32_rep(fifo, src + index, len >> 2);
 				index += len & ~0x03;
 			}
 			if (len & 0x02) {
@@ -260,7 +260,7 @@ void musb_write_fifo(struct musb_hw_ep *
 			}
 		} else {
 			if (len >= 2) {
-				writesw(fifo, src + index, len >> 1);
+				iowrite16_rep(fifo, src + index, len >> 1);
 				index += len & ~0x01;
 			}
 		}
@@ -268,7 +268,7 @@ void musb_write_fifo(struct musb_hw_ep *
 			musb_writeb(fifo, 0, src[index]);
 	} else  {
 		/* byte aligned */
-		writesb(fifo, src, len);
+		iowrite8_rep(fifo, src, len);
 	}
 }
 
@@ -294,7 +294,7 @@ void musb_read_fifo(struct musb_hw_ep *h
 		/* best case is 32bit-aligned destination address */
 		if ((0x02 & (unsigned long) dst) == 0) {
 			if (len >= 4) {
-				readsl(fifo, dst, len >> 2);
+				ioread32_rep(fifo, dst, len >> 2);
 				index = len & ~0x03;
 			}
 			if (len & 0x02) {
@@ -303,7 +303,7 @@ void musb_read_fifo(struct musb_hw_ep *h
 			}
 		} else {
 			if (len >= 2) {
-				readsw(fifo, dst, len >> 1);
+				ioread16_rep(fifo, dst, len >> 1);
 				index = len & ~0x01;
 			}
 		}
@@ -311,7 +311,7 @@ void musb_read_fifo(struct musb_hw_ep *h
 			dst[index] = musb_readb(fifo, 0);
 	} else  {
 		/* byte aligned */
-		readsb(fifo, dst, len);
+		ioread8_rep(fifo, dst, len);
 	}
 }
 #endif
diff -puN drivers/usb/musb/musb_io.h~usb-musb-use-ioreadwrite_rep-accessors drivers/usb/musb/musb_io.h
--- a/drivers/usb/musb/musb_io.h~usb-musb-use-ioreadwrite_rep-accessors
+++ a/drivers/usb/musb/musb_io.h
@@ -37,27 +37,6 @@
 
 #include <linux/io.h>
 
-#if !defined(CONFIG_ARM) && !defined(CONFIG_SUPERH) \
-	&& !defined(CONFIG_AVR32) && !defined(CONFIG_PPC32) \
-	&& !defined(CONFIG_PPC64) && !defined(CONFIG_BLACKFIN) \
-	&& !defined(CONFIG_MIPS) && !defined(CONFIG_M68K) \
-	&& !defined(CONFIG_XTENSA)
-static inline void readsl(const void __iomem *addr, void *buf, int len)
-	{ insl((unsigned long)addr, buf, len); }
-static inline void readsw(const void __iomem *addr, void *buf, int len)
-	{ insw((unsigned long)addr, buf, len); }
-static inline void readsb(const void __iomem *addr, void *buf, int len)
-	{ insb((unsigned long)addr, buf, len); }
-
-static inline void writesl(const void __iomem *addr, const void *buf, int len)
-	{ outsl((unsigned long)addr, buf, len); }
-static inline void writesw(const void __iomem *addr, const void *buf, int len)
-	{ outsw((unsigned long)addr, buf, len); }
-static inline void writesb(const void __iomem *addr, const void *buf, int len)
-	{ outsb((unsigned long)addr, buf, len); }
-
-#endif
