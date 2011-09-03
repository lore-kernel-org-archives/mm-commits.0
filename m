From: akpm@linux-foundation.org
Subject: + x86mrst-add-mapping-for-bma023.patch added to -mm tree
Date: Fri, 02 Sep 2011 17:31:33 -0700
Message-ID: <201109030031.p830VXSc019444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab1ICAbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 20:31:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: william.douglas@intel.com, alan@linux.intel.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86,mrst: add mapping for bma023
has been added to the -mm tree.  Its filename is
     x86mrst-add-mapping-for-bma023.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86,mrst: add mapping for bma023
From: William Douglas <william.douglas@intel.com>

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
@@ -485,6 +485,7 @@ static void __init *no_platform_data(voi
 }
 
 static const struct devs_id __initconst device_ids[] = {
+	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data},
 	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
 	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data},
 	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
_

Patches currently in -mm which might be from william.douglas@intel.com are

x86mrst-add-mapping-for-bma023.patch
printk-fix-bounds-checking-for-log_prefix.patch
printk-remove-bounds-checking-for-log_prefix.patch

