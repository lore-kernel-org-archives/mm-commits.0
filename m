From: akpm@linux-foundation.org
Subject: + iwlegacy-use-linux-unitsh-helpers-fix.patch added to
 -mm tree
Date: Tue, 14 Jan 2020 16:13:45 -0800
Message-ID: <20200115001345.hHunQQbpF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgAOANr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Jan 2020 19:13:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, kvalo@codeaurora.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, stf_xl@wp.pl


The patch titled
     Subject: iwlegacy: fix build warnings with format string
has been added to the -mm tree.  Its filename is
     iwlegacy-use-linux-unitsh-helpers-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/iwlegacy-use-linux-unitsh-helpers-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/iwlegacy-use-linux-unitsh-helpers-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
iwlegacy-use-linux-unitsh-helpers-fix.patch
iwlwifi-use-linux-unitsh-helpers.patch
thermal-armada-remove-unused-to_mcelsius-macro.patch
iio-adc-qcom-vadc-common-use-linux-unitsh-helpers.patch
