From: akpm@linux-foundation.org
Subject: [merged] rtc-kconfig-fix-rtc_intf-defaults-connected-to-rtc_class.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:59:19 -0700
Message-ID: <20121011205919.AE1C8100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:52729 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056Ab2JKU7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:59:20 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so271686yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:59:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khilman@ti.com, vbyravarasu@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: kconfig: fix RTC_INTF defaults connected to RTC_CLASS
has been removed from the -mm tree.  Its filename was
     rtc-kconfig-fix-rtc_intf-defaults-connected-to-rtc_class.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kevin Hilman <khilman@ti.com>
Subject: rtc: kconfig: fix RTC_INTF defaults connected to RTC_CLASS

commit 6b8029fab6416 ("rtc: kconfig: remove unnecessary dependencies")
removed various 'depends on RTC_CLASS' dependencies but also removed a few
'default RTC_CLASS' statements, which actually changed default behavior.

This resulted in the various RTC interfaces (sysfs, proc, dev) all being
disabled by default, even when RTC_CLASS is enabled:

   # CONFIG_RTC_INTF_SYSFS is not set
   # CONFIG_RTC_INTF_PROC is not set
   # CONFIG_RTC_INTF_DEV is not set

which is different from previous behavior (all of these where enabled.)

To fix, add back the 'default RTC_CLASS' statments to each of the
RTC_INTF_* options.

I noticed this because some RTC tests started failing on my TI OMAP
platforms because /dev/rtc0 was not present anymore, even though the
driver was present and RTC_CLASS was enabled.

Signed-off-by: Kevin Hilman <khilman@ti.com>
Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-kconfig-fix-rtc_intf-defaults-connected-to-rtc_class drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-kconfig-fix-rtc_intf-defaults-connected-to-rtc_class
+++ a/drivers/rtc/Kconfig
@@ -59,6 +59,7 @@ comment "RTC interfaces"
 config RTC_INTF_SYSFS
 	boolean "/sys/class/rtc/rtcN (sysfs)"
 	depends on SYSFS
+	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using sysfs interfaces,
 	  /sys/class/rtc/rtc0 through /sys/.../rtcN.
@@ -68,6 +69,7 @@ config RTC_INTF_SYSFS
 config RTC_INTF_PROC
 	boolean "/proc/driver/rtc (procfs for rtcN)"
 	depends on PROC_FS
+	default RTC_CLASS
 	help
 	  Say yes here if you want to use your system clock RTC through
 	  the proc interface, /proc/driver/rtc.
@@ -79,6 +81,7 @@ config RTC_INTF_PROC
 
 config RTC_INTF_DEV
 	boolean "/dev/rtcN (character devices)"
+	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using the /dev
 	  interfaces, which "udev" sets up as /dev/rtc0 through
_

Patches currently in -mm which might be from khilman@ti.com are

origin.patch
linux-next.patch

