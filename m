From: akpm@linux-foundation.org
Subject: - driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix.patch removed from -mm tree
Date: Mon, 07 May 2007 22:10:00 -0700
Message-ID: <200705080510.l485A0at014092@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967867AbXEHFKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 01:10:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mreimer@vpop.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core fix
has been removed from the -mm tree.  Its filename was
     driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix.patch

This patch was dropped because it was folded into driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch

------------------------------------------------------
Subject: driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core fix
From: Matt Reimer <mreimer@vpop.net>

> ERROR: "clk_get" [drivers/w1/masters/ds1wm.ko] undefined!
> ERROR: "clk_put" [drivers/w1/masters/ds1wm.ko] undefined!
> ERROR: "clk_disable" [drivers/w1/masters/ds1wm.ko] undefined!
> ERROR: "clk_enable" [drivers/w1/masters/ds1wm.ko] undefined!
> ERROR: "clk_get_rate" [drivers/w1/masters/ds1wm.ko] undefined!

Attached is a patch to fix this. AFAIK only ARM platforms presently
use DS1WM and implement linux/clk.h.

Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/masters/Kconfig~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix drivers/w1/masters/Kconfig
--- a/drivers/w1/masters/Kconfig~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix
+++ a/drivers/w1/masters/Kconfig
@@ -37,7 +37,7 @@ config W1_MASTER_DS2482
 
 config W1_MASTER_DS1WM
 	tristate "Maxim DS1WM 1-wire busmaster"
-	depends on W1
+	depends on W1 && ARM
 	help
 	  Say Y here to enable the DS1WM 1-wire driver, such as that
 	  in HP iPAQ devices like h5xxx, h2200, and ASIC3-based like
_

Patches currently in -mm which might be from mreimer@vpop.net are

w1-allow-bus-master-to-have-reset-and-byte-ops.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-fix.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-simplify-platform_data.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-ds1wm-disable-interrupts-when-turning-off-ds1wm.patch
