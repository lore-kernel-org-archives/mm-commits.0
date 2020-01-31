From: akpm@linux-foundation.org
Subject: [merged] iwlwifi-use-linux-unitsh-helpers.patch removed
 from -mm tree
Date: Fri, 31 Jan 2020 15:20:10 -0800
Message-ID: <20200131232010.ytfHFd-Lb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXUO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, amit.kucheria@verdurent.com, andy.shevchenko@gmail.com, andy@infradead.org, axboe@fb.com, daniel.lezcano@linaro.org, dvhart@infradead.org, emmanuel.grumbach@intel.com, hch@lst.de, jdelvare@suse.com, jic23@kernel.org, johannes.berg@intel.com, Jonathan.Cameron@huawei.com, kbusch@kernel.org, knaack.h@gmx.de, kvalo@codeaurora.org, lars@metafoo.de, linux@roeck-us.net, luciano.coelho@intel.com, mm-commits@vger.kernel.org, pmeerw@pmeerw.net, rui.zhang@intel.com, sagi@grimberg.me, sgruszka@redhat.com, sujith.thomas@intel.com


The patch titled
     Subject: iwlwifi: use <linux/units.h> helpers
has been removed from the -mm tree.  Its filename was
     iwlwifi-use-linux-unitsh-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: iwlwifi: use <linux/units.h> helpers

This switches the iwlwifi driver to use celsius_to_kelvin() and
kelvin_to_celsius() in <linux/units.h>.

Link: http://lkml.kernel.org/r/1576386975-7941-11-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Luca Coelho <luciano.coelho@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Andy Shevchenko <andy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/intel/iwlwifi/dvm/dev.h     |    5 -----
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c |    6 ++++--
 2 files changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h~iwlwifi-use-linux-unitsh-helpers
+++ a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
@@ -237,11 +237,6 @@ struct iwl_sensitivity_ranges {
 	u16 nrg_th_cca;
 };
 
-
-#define KELVIN_TO_CELSIUS(x) ((x)-273)
-#define CELSIUS_TO_KELVIN(x) ((x)+273)
-
-
 /******************************************************************************
  *
  * Functions implemented in core module which are forward declared here
--- a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c~iwlwifi-use-linux-unitsh-helpers
+++ a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
@@ -10,6 +10,8 @@
  *
  *****************************************************************************/
 
+#include <linux/units.h>
+
 /*
  * DVM device-specific data & functions
  */
@@ -345,7 +347,7 @@ static s32 iwl_temp_calib_to_offset(stru
 static void iwl5150_set_ct_threshold(struct iwl_priv *priv)
 {
 	const s32 volt2temp_coef = IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF;
-	s32 threshold = (s32)CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD_LEGACY) -
+	s32 threshold = (s32)celsius_to_kelvin(CT_KILL_THRESHOLD_LEGACY) -
 			iwl_temp_calib_to_offset(priv);
 
 	priv->hw_params.ct_kill_threshold = threshold * volt2temp_coef;
@@ -381,7 +383,7 @@ static void iwl5150_temperature(struct i
 	vt = le32_to_cpu(priv->statistics.common.temperature);
 	vt = vt / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF + offset;
 	/* now vt hold the temperature in Kelvin */
-	priv->temperature = KELVIN_TO_CELSIUS(vt);
+	priv->temperature = kelvin_to_celsius(vt);
 	iwl_tt_handler(priv);
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are
