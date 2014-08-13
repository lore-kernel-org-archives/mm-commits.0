From: akpm@linux-foundation.org
Subject: + remove-non-existent-files-from-maintainers.patch added to -mm
 tree
Date: Wed, 13 Aug 2014 16:00:45 -0700
Message-ID: <53ebee1d.KNRqCOknWSI8lSQp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:43465 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaHMXAq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 19:00:46 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so116311oac.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 16:00:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lists@nerdbynature.de, cesarb@cesarb.eti.br, horms@verge.net.au, kyungmin.park@samsung.com, magnus.damm@gmail.com, peter.griffin@linaro.org, sbkim73@samsung.com, t.figa@samsung.com, ulf.hansson@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove non-existent files
has been added to the -mm tree.  Its filename is
     remove-non-existent-files-from-maintainers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/remove-non-existent-files-from-maintainers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/remove-non-existent-files-from-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christian Kujau <lists@nerdbynature.de>
Subject: MAINTAINERS: remove non-existent files

Inspired by some recent cleanups in MAINTAINERS the following
files (F:) cannot be found any more in the tree:

    * arch/arm/mach-s5pv210/mach-aquila.c
    * arch/arm/mach-s5pv210/mach-goni.c

      Those two got removed in 28c8331 ("ARM: S5PV210: Remove support for board files").
      Cc: Tomasz Figa <t.figa@samsung.com>
      Cc: Kyungmin Park <kyungmin.park@samsung.com>

    * arch/arm/configs/genmai_defconfig

      This one got removed in 3ed27bd9 ("ARM: shmobile: genmai: remove defconfig").
      Cc: Simon Horman <horms@verge.net.au>
      Cc: Magnus Damm <magnus.damm@gmail.com>

    * drivers/mmc/host/sdhci-st.c

      This one was sent to be included in June 2014 but got dropped shortly after:
      "mmc: sdhci-st: Intial support for ST SDHCI controller"
      https://lkml.org/lkml/2014/6/4/446
      https://lkml.org/lkml/2014/7/9/340
      Cc: Peter Griffin <peter.griffin@linaro.org>
      Cc: Ulf Hansson <ulf.hansson@linaro.org>

    * drivers/rtc/rtc-sec.c

      A MAINTAINERS fix was attempted in November 2012, but dismissed as rtc-sec.c
      was still being worked on. Alas, it's still not there.
      "MAINTAINERS: fix drivers/rtc/rtc-sec.c"
      http://lkml.iu.edu/hypermail/linux/kernel/1211.2/04820.html
      Cc: Sangbeom Kim <sbkim73@samsung.com>
      Cc: Cesar Eduardo Barros <cesarb@cesarb.eti.br>

Signed-off-by: Christian Kujau <lists@nerdbynature.de>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Peter Griffin <peter.griffin@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN MAINTAINERS~remove-non-existent-files-from-maintainers MAINTAINERS
--- a/MAINTAINERS~remove-non-existent-files-from-maintainers
+++ a/MAINTAINERS
@@ -1303,8 +1303,7 @@ ARM/SAMSUNG MOBILE MACHINE SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-F:	arch/arm/mach-s5pv210/mach-aquila.c
-F:	arch/arm/mach-s5pv210/mach-goni.c
+F:	arch/arm/mach-s5pv210/
 
 ARM/SAMSUNG S5P SERIES 2D GRAPHICS ACCELERATION (G2D) SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
@@ -1347,7 +1346,6 @@ F:	arch/arm/boot/dts/sh*
 F:	arch/arm/configs/ape6evm_defconfig
 F:	arch/arm/configs/armadillo800eva_defconfig
 F:	arch/arm/configs/bockw_defconfig
-F:	arch/arm/configs/genmai_defconfig
 F:	arch/arm/configs/koelsch_defconfig
 F:	arch/arm/configs/kzm9g_defconfig
 F:	arch/arm/configs/lager_defconfig
@@ -1383,7 +1381,6 @@ F:	drivers/pinctrl/pinctrl-st.c
 F:	drivers/media/rc/st_rc.c
 F:	drivers/i2c/busses/i2c-st.c
 F:	drivers/tty/serial/st-asc.c
-F:	drivers/mmc/host/sdhci-st.c
 
 ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
@@ -7808,7 +7805,6 @@ S:	Supported
 F:	drivers/mfd/sec*.c
 F:	drivers/regulator/s2m*.c
 F:	drivers/regulator/s5m*.c
-F:	drivers/rtc/rtc-sec.c
 F:	include/linux/mfd/samsung/
 
 SAMSUNG S5P/EXYNOS4 SOC SERIES CAMERA SUBSYSTEM DRIVERS
_

Patches currently in -mm which might be from lists@nerdbynature.de are

remove-non-existent-files-from-maintainers.patch

