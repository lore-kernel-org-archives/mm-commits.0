From: akpm@linux-foundation.org
Subject: [merged] of-add-vendor-prefix-for-abracon-corporation.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:19:16 -0800
Message-ID: <54e250c4.NLUBCb56jZZwxYgS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbbBPUhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:37:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, arnd@arndb.de, broonie@kernel.org, galak@codeaurora.org, grant.likely@linaro.org, ijc+devicetree@hellion.org.uk, jason@lakedaemon.net, jgunthorpe@obsidianresearch.com, linus.walleij@linaro.org, linux@roeck-us.net, mark.rutland@arm.com, pawel.moll@arm.com, peter.huewe@infineon.com, rob@landley.net, robherring2@gmail.com, swarren@wwwdotorg.org, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: of: add vendor prefix for Abracon Corporation
has been removed from the -mm tree.  Its filename was
     of-add-vendor-prefix-for-abracon-corporation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnaud Ebalard <arno@natisbad.org>
Subject: of: add vendor prefix for Abracon Corporation

This series adds support for Abracon AB-RTCMC-32.768kHz-B5ZE-S3 I2C RTC
chip. Unlike many RTC chips, it includes an internal oscillator which
spares room on the PCB. It also has some interesting features, like
battery low detection (which the driver in this series supports). The
only small "limitation" (mainly due to what RTC subsystem expects from
RTC chips) is the fact that its alarm is accurate to the second. This
series provides a solution (described below) for that limitation using
another mechanism of the chip.

I decided to split support between three different patches for
this v0:

- Patch 1/3: it simply references Abracon Corporation in vendor-prefixes
  documentation file. As Abracon has no NASDAQ ticker symbol; I have
  decided to use "abcn" (I initially started my work w/ "ab" but later
  changed for "abcn" which looked more meaningful)
- Patch 2/3: it adds initial support for the chip and provides the
  ability to read/write time and also read/write alarm. As the alarm
  the chip provides is accurate to the minute, the support provided
  by this patch also has this limitation (e.g. UIE mode is not
  supported).
- Patch 3/3: the chip supports a watchdog timer which can be used to
  extend the alarm mechanism in patch 2/3 in order to provide support
  for alarms under one minute (e.g. support UIE mode). In practice,
  the logic I implemented is to use the watchdog timer for alarms which
  are at most 4 minutes in the future and use the common alarm mechanism
  for alarms which are set to larger values. With that additional patch
  the device fully passes the rtctest.c program.

I decided to split the driver between two patches (2 and 3 of 3) in
order to ease review: patch 2 should be pretty straightforward to read
for someone familiar w/ RTC subsystem. Patch 3 only extends what is in
patch 2 regarding alarms.


This patch (of 3):

Documentation/devicetree/bindings/vendor-prefixes.txt: add vendor prefix
for Abracon Corporation

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Landley <rob@landley.net>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/vendor-prefixes.txt |    1 +
 1 file changed, 1 insertion(+)

diff -puN Documentation/devicetree/bindings/vendor-prefixes.txt~of-add-vendor-prefix-for-abracon-corporation Documentation/devicetree/bindings/vendor-prefixes.txt
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt~of-add-vendor-prefix-for-abracon-corporation
+++ a/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -4,6 +4,7 @@ This isn't an exhaustive list, but you s
 using them to avoid name-space collisions.
 
 abilis	Abilis Systems
+abcn	Abracon Corporation
 active-semi	Active-Semi International Inc
 ad	Avionic Design GmbH
 adapteva	Adapteva, Inc.
_

Patches currently in -mm which might be from arno@natisbad.org are

origin.patch
linux-next.patch
rtc-isl12022-deprecate-use-of-isl-in-compatible-string-for-isil.patch
rtc-isl12057-deprecate-use-of-isl-in-compatible-string-for-isil.patch
staging-iio-isl29028-deprecate-use-of-isl-in-compatible-string-for-isil.patch
arm-dts-zynq-update-isl9305-compatible-string-to-use-isil-vendor-prefix.patch

