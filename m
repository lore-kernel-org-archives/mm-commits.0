From: akpm@linux-foundation.org
Subject: [merged] mmc-make-sdio-device-driver-struct-accessors-public.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:24 -0700
Message-ID: <200909231956.n8NJuOJW004811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753563AbZIWT4v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:56:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nico@fluxnic.net, linux-mmc@vger.kernel.org, nico@marvell.com, mm-commits@vger.kernel.org


The patch titled
     mmc: make SDIO device/driver struct accessors public
has been removed from the -mm tree.  Its filename was
     mmc-make-sdio-device-driver-struct-accessors-public.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: make SDIO device/driver struct accessors public
From: Nicolas Pitre <nico@fluxnic.net>

Especially with the PM framework, those are quite handy to have in driver
code too.

Signed-off-by: Nicolas Pitre <nico@marvell.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio_bus.c   |    3 ---
 include/linux/mmc/sdio_func.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/core/sdio_bus.c~mmc-make-sdio-device-driver-struct-accessors-public drivers/mmc/core/sdio_bus.c
--- a/drivers/mmc/core/sdio_bus.c~mmc-make-sdio-device-driver-struct-accessors-public
+++ a/drivers/mmc/core/sdio_bus.c
@@ -20,9 +20,6 @@
 #include "sdio_cis.h"
 #include "sdio_bus.h"
 
-#define dev_to_sdio_func(d)	container_of(d, struct sdio_func, dev)
-#define to_sdio_driver(d)      container_of(d, struct sdio_driver, drv)
-
 /* show configuration fields */
 #define sdio_config_attr(field, format_string)				\
 static ssize_t								\
diff -puN include/linux/mmc/sdio_func.h~mmc-make-sdio-device-driver-struct-accessors-public include/linux/mmc/sdio_func.h
--- a/include/linux/mmc/sdio_func.h~mmc-make-sdio-device-driver-struct-accessors-public
+++ a/include/linux/mmc/sdio_func.h
@@ -67,6 +67,7 @@ struct sdio_func {
 
 #define sdio_get_drvdata(f)	dev_get_drvdata(&(f)->dev)
 #define sdio_set_drvdata(f,d)	dev_set_drvdata(&(f)->dev, d)
+#define dev_to_sdio_func(d)	container_of(d, struct sdio_func, dev)
 
 /*
  * SDIO function device driver
@@ -81,6 +82,8 @@ struct sdio_driver {
 	struct device_driver drv;
 };
 
+#define to_sdio_driver(d)	container_of(d, struct sdio_driver, drv)
+
 /**
  * SDIO_DEVICE - macro used to describe a specific SDIO device
  * @vend: the 16 bit manufacturer code
_

Patches currently in -mm which might be from nico@fluxnic.net are

origin.patch
linux-next.patch

