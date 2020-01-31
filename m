From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 092/118] iio: adc: qcom-vadc-common: use
 <linux/units.h> helpers
Date: Thu, 30 Jan 2020 22:16:13 -0800
Message-ID: <20200131061613.irMHzjdbN%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgAaGQP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:16:15 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, akpm@linux-foundation.org, amit.kucheria@verdurent.com, andy.shevchenko@gmail.com, andy@infradead.org, axboe@fb.com, daniel.lezcano@linaro.org, dvhart@infradead.org, emmanuel.grumbach@intel.com, hch@lst.de, jdelvare@suse.com, jic23@kernel.org, johannes.berg@intel.com, Jonathan.Cameron@huawei.com, kbusch@kernel.org, knaack.h@gmx.de, kvalo@codeaurora.org, lars@metafoo.de, linux-mm@kvack.org, linux@roeck-us.net, luciano.coelho@intel.com, mm-commits@vger.kernel.org, pmeerw@pmeerw.net, rui.zhang@intel.com, sagi@grimberg.me, sgruszka@redhat.com, sujith.thomas@intel.com, torvalds@linux-foundation.org

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: iio: adc: qcom-vadc-common: use <linux/units.h> helpers

This switches the qcom-vadc-common to use milli_kelvin_to_millicelsius()
in <linux/units.h>.

Link: http://lkml.kernel.org/r/1576386975-7941-13-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Andy Shevchenko <andy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iio/adc/qcom-vadc-common.c |    6 +++---
 drivers/iio/adc/qcom-vadc-common.h |    1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/qcom-vadc-common.c~iio-adc-qcom-vadc-common-use-linux-unitsh-helpers
+++ a/drivers/iio/adc/qcom-vadc-common.c
@@ -6,6 +6,7 @@
 #include <linux/log2.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/units.h>
 
 #include "qcom-vadc-common.h"
 
@@ -236,8 +237,7 @@ static int qcom_vadc_scale_die_temp(cons
 		voltage = 0;
 	}
 
-	voltage -= KELVINMIL_CELSIUSMIL;
-	*result_mdec = voltage;
+	*result_mdec = milli_kelvin_to_millicelsius(voltage);
 
 	return 0;
 }
@@ -325,7 +325,7 @@ static int qcom_vadc_scale_hw_calib_die_
 {
 	*result_mdec = qcom_vadc_scale_code_voltage_factor(adc_code,
 				prescale, data, 2);
-	*result_mdec -= KELVINMIL_CELSIUSMIL;
+	*result_mdec = milli_kelvin_to_millicelsius(*result_mdec);
 
 	return 0;
 }
--- a/drivers/iio/adc/qcom-vadc-common.h~iio-adc-qcom-vadc-common-use-linux-unitsh-helpers
+++ a/drivers/iio/adc/qcom-vadc-common.h
@@ -38,7 +38,6 @@
 #define VADC_AVG_SAMPLES_MAX			512
 #define ADC5_AVG_SAMPLES_MAX			16
 
-#define KELVINMIL_CELSIUSMIL			273150
 #define PMIC5_CHG_TEMP_SCALE_FACTOR		377500
 #define PMIC5_SMB_TEMP_CONSTANT			419400
 #define PMIC5_SMB_TEMP_SCALE_FACTOR		356
_
