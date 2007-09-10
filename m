From: akpm@linux-foundation.org
Subject: + rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch added to -mm tree
Date: Mon, 10 Sep 2007 00:43:02 -0700
Message-ID: <200709100743.l8A7h2XL013870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43338 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794AbXIJHnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 03:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net, ralf@linux-mips.org


The patch titled
     rtc: make rtc-ds1742 driver hotplug-aware
has been added to the -mm tree.  Its filename is
     rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: make rtc-ds1742 driver hotplug-aware
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The rtc-ds1742 platform driver name doesn't match its module name,
which might prevents it from properly hotplugging.  There is only two
in-tree user of its driver, which are fixed by this patch too.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/jmr3927/rbhma3100/setup.c                        |    2 +-
 arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c |    2 +-
 drivers/rtc/rtc-ds1742.c                                   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/mips/jmr3927/rbhma3100/setup.c~rtc-make-rtc-ds1742-driver-hotplug-aware-take-2 arch/mips/jmr3927/rbhma3100/setup.c
--- a/arch/mips/jmr3927/rbhma3100/setup.c~rtc-make-rtc-ds1742-driver-hotplug-aware-take-2
+++ a/arch/mips/jmr3927/rbhma3100/setup.c
@@ -427,7 +427,7 @@ static int __init jmr3927_rtc_init(void)
 		.flags	= IORESOURCE_MEM,
 	};
 	struct platform_device *dev;
-	dev = platform_device_register_simple("ds1742", -1, &res, 1);
+	dev = platform_device_register_simple("rtc-ds1742", -1, &res, 1);
 	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
 }
 device_initcall(jmr3927_rtc_init);
diff -puN arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c~rtc-make-rtc-ds1742-driver-hotplug-aware-take-2 arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
--- a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c~rtc-make-rtc-ds1742-driver-hotplug-aware-take-2
+++ a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
@@ -969,7 +969,7 @@ static int __init toshiba_rbtx4927_rtc_i
 		.flags	= IORESOURCE_MEM,
 	};
 	struct platform_device *dev =
-		platform_device_register_simple("ds1742", -1, &res, 1);
+		platform_device_register_simple("rtc-ds1742", -1, &res, 1);
 	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
 }
 device_initcall(toshiba_rbtx4927_rtc_init);
diff -puN drivers/rtc/rtc-ds1742.c~rtc-make-rtc-ds1742-driver-hotplug-aware-take-2 drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-make-rtc-ds1742-driver-hotplug-aware-take-2
+++ a/drivers/rtc/rtc-ds1742.c
@@ -251,7 +251,7 @@ static struct platform_driver ds1742_rtc
 	.probe		= ds1742_rtc_probe,
 	.remove		= __devexit_p(ds1742_rtc_remove),
 	.driver		= {
-		.name	= "ds1742",
+		.name	= "rtc-ds1742",
 		.owner	= THIS_MODULE,
 	},
 };
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-mips.patch
serial_txx9-cleanup-includes.patch
rtc-make-rtc-ds1553-driver-hotplug-aware-take-3.patch
rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch
