From: akpm@linux-foundation.org
Subject: + blacklight-remove-redundant-spi-driver-bus-initialization.patch added to -mm tree
Date: Wed, 11 Apr 2012 16:27:41 -0700
Message-ID: <20120411232742.D918FA00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57137 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933526Ab2DKX1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Apr 2012 19:27:44 -0400
Received: by qcsp5 with SMTP id p5so190006qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Apr 2012 16:27:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lars@metafoo.de, rpurdie@rpsys.net


The patch titled
     Subject: blacklight: remove redundant spi driver bus initialization
has been added to the -mm tree.  Its filename is
     blacklight-remove-redundant-spi-driver-bus-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lars-Peter Clausen <lars@metafoo.de>
Subject: blacklight: remove redundant spi driver bus initialization

In ancient times it was necessary to manually initialize the bus field of
an spi_driver to spi_bus_type.  These days this is done in
spi_driver_register() so we can drop the manual assignment.

The patch was generated using the following coccinelle semantic patch:
// <smpl>
@@
identifier _driver;
@@
struct spi_driver _driver = {
	.driver = {
-		.bus = &spi_bus_type,
	},
};
// </smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    1 -
 drivers/video/backlight/ld9040.c     |    1 -
 drivers/video/backlight/ltv350qv.c   |    1 -
 drivers/video/backlight/s6e63m0.c    |    1 -
 4 files changed, 4 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~blacklight-remove-redundant-spi-driver-bus-initialization drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~blacklight-remove-redundant-spi-driver-bus-initialization
+++ a/drivers/video/backlight/ams369fg06.c
@@ -619,7 +619,6 @@ static void ams369fg06_shutdown(struct s
 static struct spi_driver ams369fg06_driver = {
 	.driver = {
 		.name	= "ams369fg06",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= ams369fg06_probe,
diff -puN drivers/video/backlight/ld9040.c~blacklight-remove-redundant-spi-driver-bus-initialization drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~blacklight-remove-redundant-spi-driver-bus-initialization
+++ a/drivers/video/backlight/ld9040.c
@@ -846,7 +846,6 @@ static void ld9040_shutdown(struct spi_d
 static struct spi_driver ld9040_driver = {
 	.driver = {
 		.name	= "ld9040",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= ld9040_probe,
diff -puN drivers/video/backlight/ltv350qv.c~blacklight-remove-redundant-spi-driver-bus-initialization drivers/video/backlight/ltv350qv.c
--- a/drivers/video/backlight/ltv350qv.c~blacklight-remove-redundant-spi-driver-bus-initialization
+++ a/drivers/video/backlight/ltv350qv.c
@@ -310,7 +310,6 @@ static void ltv350qv_shutdown(struct spi
 static struct spi_driver ltv350qv_driver = {
 	.driver = {
 		.name		= "ltv350qv",
-		.bus		= &spi_bus_type,
 		.owner		= THIS_MODULE,
 	},
 
diff -puN drivers/video/backlight/s6e63m0.c~blacklight-remove-redundant-spi-driver-bus-initialization drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~blacklight-remove-redundant-spi-driver-bus-initialization
+++ a/drivers/video/backlight/s6e63m0.c
@@ -899,7 +899,6 @@ static void s6e63m0_shutdown(struct spi_
 static struct spi_driver s6e63m0_driver = {
 	.driver = {
 		.name	= "s6e63m0",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= s6e63m0_probe,
_
Subject: Subject: blacklight: remove redundant spi driver bus initialization

Patches currently in -mm which might be from lars@metafoo.de are

linux-next.patch
blacklight-remove-redundant-spi-driver-bus-initialization.patch
leds-led-module-for-da9052-53-pmic-v2.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch

