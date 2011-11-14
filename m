From: akpm@linux-foundation.org
Subject: [merged] x86mrst-add-mapping-for-bma023.patch removed from -mm tree
Date: Mon, 14 Nov 2011 13:26:31 -0800
Message-ID: <201111142126.pAELQVUw006401@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:44661 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab1KNVuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 16:50:13 -0500
Received: by ggnp4 with SMTP id p4so85141ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 13:50:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: william.douglas@intel.com, alan@linux.intel.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86,mrst: add mapping for bma023
has been removed from the -mm tree.  Its filename was
     x86mrst-add-mapping-for-bma023.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: William Douglas <william.douglas@intel.com>
Subject: x86,mrst: add mapping for bma023

There is now an upstream bma023 driver so instead of submitting ours we
use that one.  The defaults are just fine so it's a simple mapping entry.

(Thanks go to Erik Andersson for incorporating the changes we needed into his
 version)

Signed-off-by: William Douglas <william.douglas@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/mrst/mrst.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/platform/mrst/mrst.c~x86mrst-add-mapping-for-bma023 arch/x86/platform/mrst/mrst.c
--- a/arch/x86/platform/mrst/mrst.c~x86mrst-add-mapping-for-bma023
+++ a/arch/x86/platform/mrst/mrst.c
@@ -608,6 +608,7 @@ static void *msic_ocd_platform_data(void
 }
 
 static const struct devs_id __initconst device_ids[] = {
+	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data},
 	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
 	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data},
 	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
_

Patches currently in -mm which might be from william.douglas@intel.com are

origin.patch

