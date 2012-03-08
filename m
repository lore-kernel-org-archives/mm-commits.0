From: akpm@linux-foundation.org
Subject: [merged] platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:27 -0800
Message-ID: <20120308191727.7147DA06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:53412 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab2CHTR3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:29 -0500
Received: by wgbdt11 with SMTP id dt11so29153wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mika.westerberg@linux.intel.com, alan@linux.intel.com, durgadoss.r@intel.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: platform-x86: intel_mid_thermal: turn off thermistor voltage by default
has been removed from the -mm tree.  Its filename was
     platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: platform-x86: intel_mid_thermal: turn off thermistor voltage by default

Instead of complaining that the voltage is on, we can just ask the MSIC to
turn the voltage off.  This should save some power.

Voltage for thermistors is turned on when ADC conversion is initiated.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Durgadoss R <durgadoss.r@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_mid_thermal.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/intel_mid_thermal.c~platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default drivers/platform/x86/intel_mid_thermal.c
--- a/drivers/platform/x86/intel_mid_thermal.c~platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default
+++ a/drivers/platform/x86/intel_mid_thermal.c
@@ -360,8 +360,10 @@ static int mid_initialize_adc(struct dev
 	if (ret)
 		return ret;
 
-	if (data & MSIC_ADCTHERM_MASK)
-		dev_warn(dev, "ADCTHERM already set");
+	data &= ~MSIC_ADCTHERM_MASK;
+	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, data);
+	if (ret)
+		return ret;
 
 	/* Index of the first channel in which the stop bit is set */
 	channel_index = find_free_channel();
_

Patches currently in -mm which might be from mika.westerberg@linux.intel.com are

linux-next.patch

