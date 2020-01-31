From: akpm@linux-foundation.org
Subject: [merged]
 platform-x86-asus-wmi-switch-to-use-linux-unitsh-helpers.patch removed from
 -mm tree
Date: Fri, 31 Jan 2020 15:19:49 -0800
Message-ID: <20200131231949.8QUVIPmHb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXTw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, amit.kucheria@verdurent.com, andy.shevchenko@gmail.com, andy@infradead.org, axboe@fb.com, daniel.lezcano@linaro.org, dvhart@infradead.org, emmanuel.grumbach@intel.com, hch@lst.de, jdelvare@suse.com, jic23@kernel.org, johannes.berg@intel.com, Jonathan.Cameron@huawei.com, kbusch@kernel.org, knaack.h@gmx.de, kvalo@codeaurora.org, lars@metafoo.de, linux@roeck-us.net, luciano.coelho@intel.com, mm-commits@vger.kernel.org, pmeerw@pmeerw.net, rui.zhang@intel.com, sagi@grimberg.me, sgruszka@redhat.com, sujith.thomas@intel.com


The patch titled
     Subject: platform/x86: asus-wmi: switch to use <linux/units.h> helpers
has been removed from the -mm tree.  Its filename was
     platform-x86-asus-wmi-switch-to-use-linux-unitsh-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: platform/x86: asus-wmi: switch to use <linux/units.h> helpers

The asus-wmi driver doesn't implement the thermal device functionality
directly, so including <linux/thermal.h> just for DECI_KELVIN_TO_CELSIUS()
is a bit odd.

This switches the asus-wmi driver to use deci_kelvin_to_millicelsius() in
<linux/units.h>.

The format string is changed from %d to %ld due to function returned type.

Link: http://lkml.kernel.org/r/1576386975-7941-4-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
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

 drivers/platform/x86/asus-wmi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/asus-wmi.c~platform-x86-asus-wmi-switch-to-use-linux-unitsh-helpers
+++ a/drivers/platform/x86/asus-wmi.c
@@ -33,9 +33,9 @@
 #include <linux/seq_file.h>
 #include <linux/platform_data/x86/asus-wmi.h>
 #include <linux/platform_device.h>
-#include <linux/thermal.h>
 #include <linux/acpi.h>
 #include <linux/dmi.h>
+#include <linux/units.h>
 
 #include <acpi/battery.h>
 #include <acpi/video.h>
@@ -1514,9 +1514,8 @@ static ssize_t asus_hwmon_temp1(struct d
 	if (err < 0)
 		return err;
 
-	value = DECI_KELVIN_TO_CELSIUS((value & 0xFFFF)) * 1000;
