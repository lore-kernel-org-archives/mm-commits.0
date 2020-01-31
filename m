From: akpm@linux-foundation.org
Subject: [folded-merged]
 iwlegacy-use-linux-unitsh-helpers-fix.patch removed from -mm tree
Date: Thu, 30 Jan 2020 21:51:12 -0800
Message-ID: <20200131055112.38iV8NAkL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgAaFvO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 00:51:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, kvalo@codeaurora.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, stf_xl@wp.pl


The patch titled
     Subject: iwlegacy: fix build warnings with format string
has been removed from the -mm tree.  Its filename was
     iwlegacy-use-linux-unitsh-helpers-fix.patch

This patch was dropped because it was folded into iwlegacy-use-linux-unitsh-helpers.patch

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: iwlegacy: fix build warnings with format string

This fixes build warnings introduced by commit "iwlegacy: use
<linux/units.h> helpers" (iwlegacy-use-linux-unitsh-helpers.patch in -mm)

The format '%d' has to be changed to '%ld' because the return type of
kelvin_to_celsius() is 'long'.

Link: http://lkml.kernel.org/r/1579014483-9226-1-git-send-email-akinobu.mita@gmail.com
Link: https://lore.kernel.org/r/20200106171452.201c3b4c@canb.auug.org.au
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/intel/iwlegacy/4965.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/iwlegacy/4965.c~iwlegacy-use-linux-unitsh-helpers-fix
+++ a/drivers/net/wireless/intel/iwlegacy/4965.c
@@ -1611,7 +1611,7 @@ il4965_hw_get_temperature(struct il_priv
 	temperature =
 	    (temperature * 97) / 100 + TEMPERATURE_CALIB_KELVIN_OFFSET;
 
-	D_TEMP("Calibrated temperature: %dK, %dC\n", temperature,
+	D_TEMP("Calibrated temperature: %dK, %ldC\n", temperature,
 	       kelvin_to_celsius(temperature));
 
 	return temperature;
@@ -1671,11 +1671,11 @@ il4965_temperature_calib(struct il_priv
 
 	if (il->temperature != temp) {
 		if (il->temperature)
-			D_TEMP("Temperature changed " "from %dC to %dC\n",
+			D_TEMP("Temperature changed " "from %ldC to %ldC\n",
 			       kelvin_to_celsius(il->temperature),
 			       kelvin_to_celsius(temp));
 		else
-			D_TEMP("Temperature " "initialized to %dC\n",
+			D_TEMP("Temperature " "initialized to %ldC\n",
 			       kelvin_to_celsius(temp));
 	}
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

add-helpers-for-kelvin-to-from-celsius-conversion.patch
acpi-thermal-switch-to-use-linux-unitsh-helpers.patch
platform-x86-asus-wmi-switch-to-use-linux-unitsh-helpers.patch
platform-x86-intel_menlow-switch-to-use-linux-unitsh-helpers.patch
thermal-int340x-switch-to-use-linux-unitsh-helpers.patch
thermal-intel_pch-switch-to-use-linux-unitsh-helpers.patch
nvme-hwmon-switch-to-use-linux-unitsh-helpers.patch
thermal-remove-kelvin-to-from-celsius-conversion-helpers-from-linux-thermalh.patch
iwlegacy-use-linux-unitsh-helpers.patch
iwlwifi-use-linux-unitsh-helpers.patch
thermal-armada-remove-unused-to_mcelsius-macro.patch
iio-adc-qcom-vadc-common-use-linux-unitsh-helpers.patch
