From: akpm@linux-foundation.org
Subject: - rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:23 -0700
Message-ID: <200710162041.l9GKfNCQ015788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934012AbXJPVcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:32:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     rtc: make rtc-ds1742 driver hotplug-aware
has been removed from the -mm tree.  Its filename was
     rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -425,7 +425,7 @@ static int __init jmr3927_rtc_init(void)
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
@@ -963,7 +963,7 @@ static int __init toshiba_rbtx4927_rtc_i
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

origin.patch
