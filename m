From: akpm@linux-foundation.org
Subject: [merged] blacklight-remove-redundant-spi-driver-bus-initialization.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:23 -0700
Message-ID: <20120531191823.462F6A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:32900 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933037Ab2EaTSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:24 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so154442qab.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lars@metafoo.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: blacklight: remove redundant spi driver bus initialization
has been removed from the -mm tree.  Its filename was
     blacklight-remove-redundant-spi-driver-bus-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from lars@metafoo.de are

origin.patch

