From: akpm@linux-foundation.org
Subject: [merged] iwlegacy-use-linux-unitsh-helpers.patch removed
 from -mm tree
Date: Fri, 31 Jan 2020 15:20:07 -0800
Message-ID: <20200131232007.UdF7MQSbF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXUJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, amit.kucheria@verdurent.com, andy.shevchenko@gmail.com, andy@infradead.org, axboe@fb.com, daniel.lezcano@linaro.org, dvhart@infradead.org, emmanuel.grumbach@intel.com, hch@lst.de, jdelvare@suse.com, jic23@kernel.org, johannes.berg@intel.com, kbusch@kernel.org, knaack.h@gmx.de, kvalo@codeaurora.org, lars@metafoo.de, linux@roeck-us.net, luciano.coelho@intel.com, mm-commits@vger.kernel.org, pmeerw@pmeerw.net, rui.zhang@intel.com, sagi@grimberg.me, sfr@canb.auug.org.au, sgruszka@redhat.com, sujith.thomas@intel.com


The patch titled
     Subject: iwlegacy: use <linux/units.h> helpers
has been removed from the -mm tree.  Its filename was
     iwlegacy-use-linux-unitsh-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: iwlegacy: use <linux/units.h> helpers

This switches the iwlegacy driver to use celsius_to_kelvin() and
kelvin_to_celsius() in <linux/units.h>.

[akinobu.mita@gmail.com: fix build warnings with format string]
  Link: http://lkml.kernel.org/r/1579014483-9226-1-git-send-email-akinobu.mita@gmail.com
  Link: https://lore.kernel.org/r/20200106171452.201c3b4c@canb.auug.org.au
Link: http://lkml.kernel.org/r/1576386975-7941-10-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Andy Shevchenko <andy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/intel/iwlegacy/4965-mac.c |    3 +-
 drivers/net/wireless/intel/iwlegacy/4965.c     |   17 +++++++--------
 drivers/net/wireless/intel/iwlegacy/common.h   |    3 --
 3 files changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/net/wireless/intel/iwlegacy/4965.c~iwlegacy-use-linux-unitsh-helpers
+++ a/drivers/net/wireless/intel/iwlegacy/4965.c
@@ -17,6 +17,7 @@
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/units.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
@@ -1104,7 +1105,7 @@ il4965_fill_txpower_tbl(struct il_priv *
 	/* get current temperature (Celsius) */
 	current_temp = max(il->temperature, IL_TX_POWER_TEMPERATURE_MIN);
 	current_temp = min(il->temperature, IL_TX_POWER_TEMPERATURE_MAX);
-	current_temp = KELVIN_TO_CELSIUS(current_temp);
+	current_temp = kelvin_to_celsius(current_temp);
 
 	/* select thermal txpower adjustment params, based on channel group
 	 *   (same frequency group used for mimo txatten adjustment) */
@@ -1610,8 +1611,8 @@ il4965_hw_get_temperature(struct il_priv
 	temperature =
 	    (temperature * 97) / 100 + TEMPERATURE_CALIB_KELVIN_OFFSET;
 
-	D_TEMP("Calibrated temperature: %dK, %dC\n", temperature,
-	       KELVIN_TO_CELSIUS(temperature));
+	D_TEMP("Calibrated temperature: %dK, %ldC\n", temperature,
+	       kelvin_to_celsius(temperature));
 
 	return temperature;
 }
@@ -1670,12 +1671,12 @@ il4965_temperature_calib(struct il_priv
 
 	if (il->temperature != temp) {
 		if (il->temperature)
-			D_TEMP("Temperature changed " "from %dC to %dC\n",
-			       KELVIN_TO_CELSIUS(il->temperature),
-			       KELVIN_TO_CELSIUS(temp));
+			D_TEMP("Temperature changed " "from %ldC to %ldC\n",
+			       kelvin_to_celsius(il->temperature),
+			       kelvin_to_celsius(temp));
 		else
-			D_TEMP("Temperature " "initialized to %dC\n",
-			       KELVIN_TO_CELSIUS(temp));
+			D_TEMP("Temperature " "initialized to %ldC\n",
+			       kelvin_to_celsius(temp));
 	}
 
 	il->temperature = temp;
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c~iwlegacy-use-linux-unitsh-helpers
+++ a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -27,6 +27,7 @@
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
+#include <linux/units.h>
 
 #include <net/mac80211.h>
 
@@ -6468,7 +6469,7 @@ il4965_set_hw_params(struct il_priv *il)
 	il->hw_params.valid_rx_ant = il->cfg->valid_rx_ant;
 
 	il->hw_params.ct_kill_threshold =
-	   CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD_LEGACY);
+	   celsius_to_kelvin(CT_KILL_THRESHOLD_LEGACY);
 
 	il->hw_params.sens = &il4965_sensitivity;
 	il->hw_params.beacon_time_tsf_bits = IL4965_EXT_BEACON_TIME_POS;
--- a/drivers/net/wireless/intel/iwlegacy/common.h~iwlegacy-use-linux-unitsh-helpers
+++ a/drivers/net/wireless/intel/iwlegacy/common.h
@@ -779,9 +779,6 @@ struct il_sensitivity_ranges {
 	u16 nrg_th_cca;
 };
 
-#define KELVIN_TO_CELSIUS(x) ((x)-273)
-#define CELSIUS_TO_KELVIN(x) ((x)+273)
