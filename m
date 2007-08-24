From: akpm@linux-foundation.org
Subject: - ohci-fix-oddball-gcc-warning.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:08 -0700
Message-ID: <200708242058.l7OKw8oA014287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37243 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762857AbXHXVIT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     ohci: fix oddball gcc warning
has been removed from the -mm tree.  Its filename was
     ohci-fix-oddball-gcc-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ohci: fix oddball gcc warning
From: David Brownell <david-b@pacbell.net>

Some versions of GCC recently grew annoying warnings about constants.
This gets rid of that warning from the OHCI driver.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ohci-dbg.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/ohci-dbg.c~ohci-fix-oddball-gcc-warning drivers/usb/host/ohci-dbg.c
--- a/drivers/usb/host/ohci-dbg.c~ohci-fix-oddball-gcc-warning
+++ a/drivers/usb/host/ohci-dbg.c
@@ -74,7 +74,7 @@ urb_print (struct urb * urb, char * str,
 
 #define ohci_dbg_sw(ohci, next, size, format, arg...) \
 	do { \
-	if (next) { \
+	if (next != NULL) { \
 		unsigned s_len; \
 		s_len = scnprintf (*next, *size, format, ## arg ); \
 		*size -= s_len; *next += s_len; \
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
spi-driver-hotplug-coldplug-fixes.patch
fix-typo-in-atmel_spic.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
clean-up-duplicate-includes-in-drivers-spi.patch
spi-driver-runtime-footprint-shrinkage.patch
rtc-periodic-irq-fix.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
