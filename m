From: akpm@linux-foundation.org
Subject: [merged] mtd-maps-fix-accidental-removal-in-makefile.patch removed from -mm tree
Date: Thu, 12 Nov 2009 12:13:29 -0800
Message-ID: <200911122013.nACKDTqE017515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019AbZKLUOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 15:14:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, cooloney@kernel.org, dwmw2@infradead.org, rjw@sisk.pl, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     mtd/maps: fix accidental removal in Makefile
has been removed from the -mm tree.  Its filename was
     mtd-maps-fix-accidental-removal-in-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd/maps: fix accidental removal in Makefile
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The commit d79c326 ("gpio-addr-flash: new driver for GPIO assisted
flash addressing") removed two lines from the Makefile by accident.
Though I'm not sure how this accident happened, this patch reverts the
removal.

This patch fixes a regression from 2.6.31

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/mtd/maps/Makefile~mtd-maps-fix-accidental-removal-in-makefile drivers/mtd/maps/Makefile
--- a/drivers/mtd/maps/Makefile~mtd-maps-fix-accidental-removal-in-makefile
+++ a/drivers/mtd/maps/Makefile
@@ -56,4 +56,6 @@ obj-$(CONFIG_MTD_PLATRAM)	+= plat-ram.o
 obj-$(CONFIG_MTD_OMAP_NOR)	+= omap_nor.o
 obj-$(CONFIG_MTD_INTEL_VR_NOR)	+= intel_vr_nor.o
 obj-$(CONFIG_MTD_BFIN_ASYNC)	+= bfin-async-flash.o
+obj-$(CONFIG_MTD_RBTX4939)	+= rbtx4939-flash.o
+obj-$(CONFIG_MTD_VMU)		+= vmu-flash.o
 obj-$(CONFIG_MTD_GPIO_ADDR)	+= gpio-addr-flash.o
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch
rtc-fix-driver-data-issues-in-several-rtc-drivers.patch
rtc-ds1511-fix-races-around-device-registration.patch
rtc-tx4939-fix-races-around-device-registration.patch
rtc-ds1553-fix-races-around-device-registration.patch
rtc-ds1742-fix-races-around-device-registration.patch
rtc-stk17ta8-fix-races-around-device-registration.patch
rtc-do-not-use-container_of-macro-as-an-argument-for-to_platform_device.patch

