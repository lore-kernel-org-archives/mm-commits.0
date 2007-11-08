From: akpm@linux-foundation.org
Subject: + spi-fix-double-free-on-spi_unregister_master.patch added to -mm tree
Date: Thu, 08 Nov 2007 09:20:04 -0800
Message-ID: <200711081720.lA8HK7X9005756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40305 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760351AbXKHRUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 12:20:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, david-b@pacbell.net


The patch titled
     spi: fix double-free on spi_unregister_master
has been added to the -mm tree.  Its filename is
     spi-fix-double-free-on-spi_unregister_master.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: fix double-free on spi_unregister_master
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

After 49dce689ad4ef0fd1f970ef762168e4bd46f69a3, device_for_each_child
iteration hits the master device itself.  Do not call spi_unregister_device()
for the master device.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spi.c~spi-fix-double-free-on-spi_unregister_master drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-fix-double-free-on-spi_unregister_master
+++ a/drivers/spi/spi.c
@@ -457,10 +457,11 @@ done:
 EXPORT_SYMBOL_GPL(spi_register_master);
 
 
-static int __unregister(struct device *dev, void *unused)
+static int __unregister(struct device *dev, void *master_dev)
 {
 	/* note: before about 2.6.14-rc1 this would corrupt memory: */
-	spi_unregister_device(to_spi_device(dev));
+	if (dev != master_dev)
+		spi_unregister_device(to_spi_device(dev));
 	return 0;
 }
 
@@ -478,7 +479,8 @@ void spi_unregister_master(struct spi_ma
 {
 	int dummy;
 
-	dummy = device_for_each_child(master->dev.parent, NULL, __unregister);
+	dummy = device_for_each_child(master->dev.parent, &master->dev,
+					__unregister);
 	device_unregister(&master->dev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
rtcs-handle-nvram-better.patch
spi-fix-double-free-on-spi_unregister_master.patch
spi-fix-error-paths-on-txx9spi_probe.patch
clocksource-make-clocksource_mask-bullet-proof.patch
