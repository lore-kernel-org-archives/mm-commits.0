From: akpm@linux-foundation.org
Subject: [merged] gadget-atmel_usba_udc-change-way-of-specifying-bias-function.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:12:26 -0700
Message-ID: <200906091812.n59ICQRx018662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757117AbZFISMf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, dbrownell@users.sourceforge.net, greg@kroah.com, haavard.skinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     gadget: atmel_usba_udc: change way of specifying bias function
has been removed from the -mm tree.  Its filename was
     gadget-atmel_usba_udc-change-way-of-specifying-bias-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gadget: atmel_usba_udc: change way of specifying bias function
From: Nicolas Ferre <nicolas.ferre@atmel.com>

The toggle_bias() function was specified differently for avr32 and at91
architectures.  Now, new at91 have the same behavior as avr32. 
Consequently, we change to a particular chip function definition: only for
at91sam9rl.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/atmel_usba_udc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/usb/gadget/atmel_usba_udc.c~gadget-atmel_usba_udc-change-way-of-specifying-bias-function drivers/usb/gadget/atmel_usba_udc.c
--- a/drivers/usb/gadget/atmel_usba_udc.c~gadget-atmel_usba_udc-change-way-of-specifying-bias-function
+++ a/drivers/usb/gadget/atmel_usba_udc.c
@@ -326,13 +326,7 @@ static int vbus_is_present(struct usba_u
 	return 1;
 }
 
-#if defined(CONFIG_AVR32)
-
-static void toggle_bias(int is_on)
-{
-}
-
-#elif defined(CONFIG_ARCH_AT91)
+#if defined(CONFIG_ARCH_AT91SAM9RL)
 
 #include <mach/at91_pmc.h>
 
@@ -346,7 +340,13 @@ static void toggle_bias(int is_on)
 		at91_sys_write(AT91_CKGR_UCKR, uckr & ~(AT91_PMC_BIASEN));
 }
 
-#endif /* CONFIG_ARCH_AT91 */
+#else
+
+static void toggle_bias(int is_on)
+{
+}
+
+#endif /* CONFIG_ARCH_AT91SAM9RL */
 
 static void next_fifo_transaction(struct usba_ep *ep, struct usba_request *req)
 {
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch
atmel-lcdc-fix-pixclock-upper-bound-detection.patch

