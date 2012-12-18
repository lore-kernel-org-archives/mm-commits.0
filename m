From: akpm@linux-foundation.org
Subject: [merged] musb-tusb6010-use-ioreadwrite_rep-accessors.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:06 -0800
Message-ID: <20121218200307.343EE200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:57983 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUDK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:03:10 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so63369lag.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:03:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@mattleach.net, arnd@arndb.de, balbi@ti.com, benh@kernel.crashing.org, greg@kroah.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: musb: tusb6010: use io{read,write}*_rep accessors
has been removed from the -mm tree.  Its filename was
     musb-tusb6010-use-ioreadwrite_rep-accessors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Leach <matthew@mattleach.net>
Subject: musb: tusb6010: use io{read,write}*_rep accessors

The {read,write}s{b,w,l} operations are not defined by all architectures
and are being removed from the asm-generic/io.h interface.

This patch replaces the usage of these string functions in the tusb6010
accessors with io{read,write}{8,16,32}_rep calls instead.

Signed-off-by: Matthew Leach <matthew@mattleach.net>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/musb/tusb6010.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/usb/musb/tusb6010.c~musb-tusb6010-use-ioreadwrite_rep-accessors drivers/usb/musb/tusb6010.c
--- a/drivers/usb/musb/tusb6010.c~musb-tusb6010-use-ioreadwrite_rep-accessors
+++ a/drivers/usb/musb/tusb6010.c
@@ -22,6 +22,7 @@
 #include <linux/prefetch.h>
 #include <linux/usb.h>
 #include <linux/irq.h>
+#include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/usb/nop-usb-xceiv.h>
@@ -198,7 +199,7 @@ void musb_write_fifo(struct musb_hw_ep *
 		/* Best case is 32bit-aligned destination address */
 		if ((0x02 & (unsigned long) buf) == 0) {
 			if (len >= 4) {
-				writesl(fifo, buf, len >> 2);
+				iowrite32_rep(fifo, buf, len >> 2);
 				buf += (len & ~0x03);
 				len &= 0x03;
 			}
@@ -245,7 +246,7 @@ void musb_read_fifo(struct musb_hw_ep *h
 		/* Best case is 32bit-aligned destination address */
 		if ((0x02 & (unsigned long) buf) == 0) {
 			if (len >= 4) {
-				readsl(fifo, buf, len >> 2);
+				ioread32_rep(fifo, buf, len >> 2);
 				buf += (len & ~0x03);
 				len &= 0x03;
 			}
_

Patches currently in -mm which might be from matthew@mattleach.net are

origin.patch
linux-next.patch

