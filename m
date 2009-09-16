From: akpm@linux-foundation.org
Subject: + mmc-make-sdio-device-driver-struct-accessors-public.patch added to -mm tree
Date: Wed, 16 Sep 2009 16:44:09 -0700
Message-ID: <200909162344.n8GNi9x5021398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933645AbZIPXoh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Sep 2009 19:44:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nico@fluxnic.net, linux-mmc@vger.kernel.org, nico@marvell.com


The patch titled
     mmc: make SDIO device/driver struct accessors public
has been added to the -mm tree.  Its filename is
     mmc-make-sdio-device-driver-struct-accessors-public.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
mmc-core-sdio-suspend-resume-support.patch
mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods.patch
mmc-make-sdio-device-driver-struct-accessors-public.patch

