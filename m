From: akpm@linux-foundation.org
Subject: + mpc8xxx_wdt-fix-modular-build.patch added to -mm tree
Date: Mon, 18 Aug 2008 14:33:43 -0700
Message-ID: <200808182133.m7ILXhnn013832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbYHRVeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 17:34:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, bunk@kernel.org, davej@redhat.com, wim@iguana.be


The patch titled
     mpc8xxx_wdt: fix modular build
has been added to the -mm tree.  Its filename is
     mpc8xxx_wdt-fix-modular-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mpc8xxx_wdt: fix modular build
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Fix the following build error when mpc8xxx_wdt is selected to build as a
module:

drivers/watchdog/mpc8xxx_wdt.c:304: error: redefinition of '__inittest'
drivers/watchdog/mpc8xxx_wdt.c:298: error: previous definition of '__inittest' was here
drivers/watchdog/mpc8xxx_wdt.c:304: error: redefinition of 'init_module'
drivers/watchdog/mpc8xxx_wdt.c:298: error: previous definition of 'init_module' was here

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/mpc8xxx_wdt.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/watchdog/mpc8xxx_wdt.c~mpc8xxx_wdt-fix-modular-build drivers/watchdog/mpc8xxx_wdt.c
--- a/drivers/watchdog/mpc8xxx_wdt.c~mpc8xxx_wdt-fix-modular-build
+++ a/drivers/watchdog/mpc8xxx_wdt.c
@@ -48,6 +48,7 @@ struct mpc8xxx_wdt_type {
 };
 
 static struct mpc8xxx_wdt __iomem *wd_base;
+static int mpc8xxx_wdt_init_late(void);
 
 static u16 timeout = 0xffff;
 module_param(timeout, ushort, 0);
@@ -213,6 +214,12 @@ static int __devinit mpc8xxx_wdt_probe(s
 	else
 		timeout_sec = timeout / freq;
 
+#ifdef MODULE
+	ret = mpc8xxx_wdt_init_late();
+	if (ret)
+		goto err_unmap;
+#endif
+
 	pr_info("WDT driver for MPC8xxx initialized. mode:%s timeout=%d "
 		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
 		timeout_sec);
@@ -280,7 +287,7 @@ static struct of_platform_driver mpc8xxx
  * very early to start pinging the watchdog (misc devices are not yet
  * available), and later module_init() just registers the misc device.
  */
-static int __init mpc8xxx_wdt_init_late(void)
+static int mpc8xxx_wdt_init_late(void)
 {
 	int ret;
 
@@ -295,7 +302,9 @@ static int __init mpc8xxx_wdt_init_late(
 	}
 	return 0;
 }
+#ifndef MODULE
 module_init(mpc8xxx_wdt_init_late);
+#endif
 
 static int __init mpc8xxx_wdt_init(void)
 {
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

rtc-rtc-ds1374-fix-no-irq-case-handling.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
mpc8xxx_wdt-fix-modular-build.patch

