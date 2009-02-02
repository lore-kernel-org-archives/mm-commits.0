From: akpm@linux-foundation.org
Subject: + mfd-ensure-all-wm8350-irqs-are-masked-at-startup.patch added to -mm tree
Date: Mon, 02 Feb 2009 13:48:02 -0800
Message-ID: <200902022148.n12Lm223027532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758106AbZBBVsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 16:48:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com


The patch titled
     mfd: ensure all WM8350 IRQs are masked at startup
has been added to the -mm tree.  Its filename is
     mfd-ensure-all-wm8350-irqs-are-masked-at-startup.patch

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
Subject: mfd: ensure all WM8350 IRQs are masked at startup
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

The IRQs might have been left enabled in hardware, generating spurious
IRQs before the drivers have registered.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/wm8350-core.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/mfd/wm8350-core.c~mfd-ensure-all-wm8350-irqs-are-masked-at-startup drivers/mfd/wm8350-core.c
--- a/drivers/mfd/wm8350-core.c~mfd-ensure-all-wm8350-irqs-are-masked-at-startup
+++ a/drivers/mfd/wm8350-core.c
@@ -1428,6 +1428,13 @@ int wm8350_device_init(struct wm8350 *wm
 		}
 	}
 
+	wm8350_reg_write(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_INT_STATUS_1_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_INT_STATUS_2_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_UNDER_VOLTAGE_INT_STATUS_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_GPIO_INT_STATUS_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_COMPARATOR_INT_STATUS_MASK, 0xFFFF);
+
 	mutex_init(&wm8350->auxadc_mutex);
 	mutex_init(&wm8350->irq_mutex);
 	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
mfd-improve-diagnostics-for-wm8350-id-register-probe.patch
mfd-support-active-high-irqs-on-wm835x.patch
mfd-ensure-all-wm8350-irqs-are-masked-at-startup.patch
mfd-initialise-wm8350-interrupts-earlier.patch
mfd-mark-wm835x-usb_slv_500ma-bit-as-accessible.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

