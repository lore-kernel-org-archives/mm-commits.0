From: akpm@linux-foundation.org
Subject: + platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch added to -mm tree
Date: Mon, 06 Feb 2012 13:01:10 -0800
Message-ID: <20120206210111.15FE4A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36590 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2BFVBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 16:01:11 -0500
Received: by mail-yw0-f74.google.com with SMTP id m50so686673yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 13:01:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mika.westerberg@linux.intel.com, alan@linux.intel.com, durgadoss.r@intel.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de


The patch titled
     Subject: platform-x86: intel_mid_thermal: turn off thermistor voltage by default
has been added to the -mm tree.  Its filename is
     platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: platform-x86: intel_mid_thermal: turn off thermistor voltage by default

Patches currently in -mm which might be from mika.westerberg@linux.intel.com are

linux-next.patch
platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch
platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api.patch
platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch
intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu.patch

