From: akpm@linux-foundation.org
Subject: + rtc-kconfig-fix-rtc_intf-defaults-connected-to-rtc_class.patch added to -mm tree
Date: Wed, 10 Oct 2012 13:57:19 -0700
Message-ID: <20121010205720.455DE5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:42817 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2JJU5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Oct 2012 16:57:22 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so70383wib.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Oct 2012 13:57:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khilman@ti.com, vbyravarasu@nvidia.com


The patch titled
     Subject: rtc: kconfig: fix RTC_INTF defaults connected to RTC_CLASS
has been added to the -mm tree.  Its filename is
     rtc-kconfig-fix-rtc_intf-defaults-connected-to-rtc_class.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
rtc-kconfig-fix-rtc_intf-defaults-connected-to-rtc_class.patch

