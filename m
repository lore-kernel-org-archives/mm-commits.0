From: akpm@linux-foundation.org
Subject: + it8712f_wdtc-add-support-for-the-it8716f-watchdog.patch added to -mm tree
Date: Tue, 20 Nov 2007 00:11:12 -0800
Message-ID: <200711200811.lAK8BCaW026501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43643 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755688AbXKTILo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 03:11:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike@secnet.net.au, mike@mtgambier.net, wim@iguana.be


The patch titled
     it8712f_wdt.c: add support for the IT8716F watchdog
has been added to the -mm tree.  Its filename is
     it8712f_wdtc-add-support-for-the-it8716f-watchdog.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: it8712f_wdt.c: add support for the IT8716F watchdog
From: Mike Lampard <mike@secnet.net.au>

Add support for the IT8716F watchdog, which appears to be essentially the same
as the IT8712F in all but name.

Signed-off-by: Mike Lampard <mike@mtgambier.net>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/it8712f_wdt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/watchdog/it8712f_wdt.c~it8712f_wdtc-add-support-for-the-it8716f-watchdog drivers/watchdog/it8712f_wdt.c
--- a/drivers/watchdog/it8712f_wdt.c~it8712f_wdtc-add-support-for-the-it8716f-watchdog
+++ a/drivers/watchdog/it8712f_wdt.c
@@ -36,7 +36,7 @@
 #define NAME "it8712f_wdt"
 
 MODULE_AUTHOR("Jorge Boncompte - DTI2 <jorge@dti2.net>");
-MODULE_DESCRIPTION("IT8712F Watchdog Driver");
+MODULE_DESCRIPTION("IT8712F/IT8716F Watchdog Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
@@ -65,6 +65,7 @@ static unsigned short address;
 #define BASE_REG	0x60	/* LDN Register: Base address */
 
 #define IT8712F_DEVID	0x8712
+#define IT8716F_DEVID	0x8716
 
 #define LDN_GPIO	0x07	/* GPIO and Watch Dog Timer */
 #define LDN_GAME 	0x09	/* Game Port */
@@ -319,7 +320,7 @@ it8712f_wdt_find(unsigned short *address
 
 	superio_enter();
 	chip_type = superio_inw(DEVID);
-	if (chip_type != IT8712F_DEVID)
+	if (chip_type != IT8712F_DEVID && chip_type != IT8716F_DEVID)
 		goto exit;
 
 	superio_select(LDN_GAME);
_

Patches currently in -mm which might be from mike@secnet.net.au are

it8712f_wdtc-add-support-for-the-it8716f-watchdog.patch
