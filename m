From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 088/118] thermal: remove kelvin to/from Celsius
 conversion helpers from <linux/thermal.h>
Date: Thu, 30 Jan 2020 22:15:57 -0800
Message-ID: <20200131061557.lTQ2AvRix%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgAaGP7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:15:59 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, akpm@linux-foundation.org, amit.kucheria@verdurent.com, andy.shevchenko@gmail.com, andy@infradead.org, axboe@fb.com, daniel.lezcano@linaro.org, dvhart@infradead.org, emmanuel.grumbach@intel.com, hch@lst.de, jdelvare@suse.com, jic23@kernel.org, johannes.berg@intel.com, Jonathan.Cameron@huawei.com, kbusch@kernel.org, knaack.h@gmx.de, kvalo@codeaurora.org, lars@metafoo.de, linux-mm@kvack.org, linux@roeck-us.net, luciano.coelho@intel.com, mm-commits@vger.kernel.org, pmeerw@pmeerw.net, rui.zhang@intel.com, sagi@grimberg.me, sgruszka@redhat.com, sujith.thomas@intel.com, torvalds@linux-foundation.org

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: thermal: remove kelvin to/from Celsius conversion helpers from <linux/thermal.h>

This removes the kelvin to/from Celsius conversion helper macros in
<linux/thermal.h> which were switched to the inline helper functions in
<linux/units.h>.

Link: http://lkml.kernel.org/r/1576386975-7941-9-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Andy Shevchenko <andy@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/thermal.h |   11 -----------
 1 file changed, 11 deletions(-)

--- a/include/linux/thermal.h~thermal-remove-kelvin-to-from-celsius-conversion-helpers-from-linux-thermalh
+++ a/include/linux/thermal.h
@@ -32,17 +32,6 @@
 /* use value, which < 0K, to indicate an invalid/uninitialized temperature */
 #define THERMAL_TEMP_INVALID	-274000
 
-/* Unit conversion macros */
-#define DECI_KELVIN_TO_CELSIUS(t)	({			\
-	long _t = (t);						\
-	((_t-2732 >= 0) ? (_t-2732+5)/10 : (_t-2732-5)/10);	\
-})
-#define CELSIUS_TO_DECI_KELVIN(t)	((t)*10+2732)
-#define DECI_KELVIN_TO_MILLICELSIUS_WITH_OFFSET(t, off) (((t) - (off)) * 100)
-#define DECI_KELVIN_TO_MILLICELSIUS(t) DECI_KELVIN_TO_MILLICELSIUS_WITH_OFFSET(t, 2732)
-#define MILLICELSIUS_TO_DECI_KELVIN_WITH_OFFSET(t, off) (((t) / 100) + (off))
-#define MILLICELSIUS_TO_DECI_KELVIN(t) MILLICELSIUS_TO_DECI_KELVIN_WITH_OFFSET(t, 2732)
