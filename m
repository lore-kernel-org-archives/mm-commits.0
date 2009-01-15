From: akpm@linux-foundation.org
Subject: + mfd-initialise-wm8350-interrupts-earlier.patch added to -mm tree
Date: Thu, 15 Jan 2009 14:53:11 -0800
Message-ID: <200901152253.n0FMrBih031628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935867AbZAOWxT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 17:53:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com


The patch titled
     mfd: initialise WM8350 interrupts earlier
has been added to the -mm tree.  Its filename is
     mfd-initialise-wm8350-interrupts-earlier.patch

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
Subject: mfd: initialise WM8350 interrupts earlier
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Ensure that the interrupt handling is configured before we do platform
specific init.  This allows the platform specific initialisation to
configure things which use interrupts safely.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/wm8350-core.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/mfd/wm8350-core.c~mfd-initialise-wm8350-interrupts-earlier drivers/mfd/wm8350-core.c
--- a/drivers/mfd/wm8350-core.c~mfd-initialise-wm8350-interrupts-earlier
+++ a/drivers/mfd/wm8350-core.c
@@ -1404,15 +1404,6 @@ int wm8350_device_init(struct wm8350 *wm
 		return ret;
 	}
 
-	if (pdata && pdata->init) {
-		ret = pdata->init(wm8350);
-		if (ret != 0) {
-			dev_err(wm8350->dev, "Platform init() failed: %d\n",
-				ret);
-			goto err;
-		}
-	}
-
 	mutex_init(&wm8350->auxadc_mutex);
 	mutex_init(&wm8350->irq_mutex);
 	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
@@ -1430,6 +1421,15 @@ int wm8350_device_init(struct wm8350 *wm
 	}
 	wm8350->chip_irq = irq;
 
+	if (pdata && pdata->init) {
+		ret = pdata->init(wm8350);
+		if (ret != 0) {
+			dev_err(wm8350->dev, "Platform init() failed: %d\n",
+				ret);
+			goto err;
+		}
+	}
+
 	wm8350_reg_write(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK, 0x0);
 
 	wm8350_client_dev_register(wm8350, "wm8350-codec",
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
mfd-initialise-wm8350-interrupts-earlier.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch

