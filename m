From: akpm@linux-foundation.org
Subject: + it87_wdt-add-support-for-it8720f-watchdog.patch added to -mm tree
Date: Tue, 21 Sep 2010 16:43:59 -0700
Message-ID: <201009212343.o8LNhx9M009861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab0IUXoF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 19:44:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santiago@crfreenet.org, wim@iguana.be


The patch titled
     it87_wdt: add support for IT8720F watchdog
has been added to the -mm tree.  Its filename is
     it87_wdt-add-support-for-it8720f-watchdog.patch

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
Subject: it87_wdt: add support for IT8720F watchdog
From: Ondrej Zajicek <santiago@crfreenet.org>

Add support for a watchdog in IT8720F Super IO chip to it87_wdt driver.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig    |    9 +++++----
 drivers/watchdog/it87_wdt.c |   17 +++++++++++------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff -puN drivers/watchdog/Kconfig~it87_wdt-add-support-for-it8720f-watchdog drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~it87_wdt-add-support-for-it8720f-watchdog
+++ a/drivers/watchdog/Kconfig
@@ -565,10 +565,11 @@ config IT87_WDT
 	tristate "IT87 Watchdog Timer"
 	depends on X86 && EXPERIMENTAL
 	---help---
-	  This is the driver for the hardware watchdog on the ITE IT8716,
-	  IT8718, IT8726, IT8712(Version J,K) Super I/O chips. This watchdog
-	  simply watches your kernel to make sure it doesn't freeze, and if
-	  it does, it reboots your computer after a certain amount of time.
+	  This is the driver for the hardware watchdog on the ITE
+	  IT8716, IT8718, IT8720, IT8726, IT8712(Version J,K) Super I/O
+	  chips. This watchdog simply watches your kernel to make sure
+	  it doesn't freeze, and if it does, it reboots your computer
+	  after a certain amount of time.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called it87_wdt.
diff -puN drivers/watchdog/it87_wdt.c~it87_wdt-add-support-for-it8720f-watchdog drivers/watchdog/it87_wdt.c
--- a/drivers/watchdog/it87_wdt.c~it87_wdt-add-support-for-it8720f-watchdog
+++ a/drivers/watchdog/it87_wdt.c
@@ -12,7 +12,7 @@
  *		    http://www.ite.com.tw/
  *
  *	Support of the watchdog timers, which are available on
- *	IT8716, IT8718, IT8726 and IT8712 (J,K version).
+ *	IT8716, IT8718, IT8720, IT8726 and IT8712 (J,K version).
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -45,7 +45,7 @@
 
 #include <asm/system.h>
 
-#define WATCHDOG_VERSION	"1.12"
+#define WATCHDOG_VERSION	"1.13"
 #define WATCHDOG_NAME		"IT87 WDT"
 #define PFX			WATCHDOG_NAME ": "
 #define DRIVER_VERSION		WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
@@ -80,6 +80,7 @@
 #define IT8712_ID	0x8712
 #define IT8716_ID	0x8716
 #define IT8718_ID	0x8718
+#define IT8720_ID	0x8720
 #define IT8726_ID	0x8726	/* the data sheet suggest wrongly 0x8716 */
 
 /* GPIO Configuration Registers LDN=0x07 */
@@ -92,7 +93,7 @@
 #define WDT_CIRINT	0x80
 #define WDT_MOUSEINT	0x40
 #define WDT_KYBINT	0x20
-#define WDT_GAMEPORT	0x10 /* not it8718 */
+#define WDT_GAMEPORT	0x10 /* not in it8718, it8720 */
 #define WDT_FORCE	0x02
 #define WDT_ZERO	0x01
 
@@ -529,6 +530,7 @@ static struct notifier_block wdt_notifie
 static int __init it87_wdt_init(void)
 {
 	int rc = 0;
+	int try_gameport = !nogameport;
 	u16 chip_type;
 	u8  chip_rev;
 	unsigned long flags;
@@ -542,9 +544,12 @@ static int __init it87_wdt_init(void)
 
 	switch (chip_type) {
 	case IT8716_ID:
-	case IT8718_ID:
 	case IT8726_ID:
 		break;
+	case IT8718_ID:
+	case IT8720_ID:
+		try_gameport = 0;
+		break;
 	case IT8712_ID:
 		if (chip_rev > 7)
 			break;
@@ -571,7 +576,7 @@ static int __init it87_wdt_init(void)
 	superio_outb(0x00, WDTCTRL);
 
 	/* First try to get Gameport support */
-	if (chip_type != IT8718_ID && !nogameport) {
+	if (try_gameport) {
 		superio_select(GAMEPORT);
 		base = superio_inw(BASEREG);
 		if (!base) {
@@ -676,7 +681,7 @@ err_out_region:
 		spin_unlock_irqrestore(&spinlock, flags);
 	}
 err_out:
-	if (chip_type != IT8718_ID && !nogameport) {
+	if (try_gameport) {
 		spin_lock_irqsave(&spinlock, flags);
 		superio_enter();
 		superio_select(GAMEPORT);
_

Patches currently in -mm which might be from santiago@crfreenet.org are

it87_wdt-add-support-for-it8720f-watchdog.patch
it87_wdt-add-support-for-watchdogs-with-8b-timers.patch

