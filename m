From: akpm@linux-foundation.org
Subject: [merged] backlight-new-driver-for-the-adp8860-backlight-parts-fix-adp8860_bl-build-errors.patch removed from -mm tree
Date: Wed, 19 May 2010 10:30:58 -0400
Message-ID: <201005191732.o4JHWOau025736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807Ab0ESRcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:32:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, michael.hennerich@analog.com, rpurdie@rpsys.net, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     backlight: fix adp8860_bl build errors
has been removed from the -mm tree.  Its filename was
     backlight-new-driver-for-the-adp8860-backlight-parts-fix-adp8860_bl-build-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: fix adp8860_bl build errors
From: Randy Dunlap <randy.dunlap@oracle.com>

Add slab.h to fix part of build.
Add a parameter in backlight_device_register() call to fix part of build.

drivers/video/backlight/adp8860_bl.c:215: error: implicit declaration of function 'kzalloc'
drivers/video/backlight/adp8860_bl.c:215: warning: assignment makes pointer from integer without a cast
drivers/video/backlight/adp8860_bl.c:285: error: implicit declaration of function 'kfree'
drivers/video/backlight/adp8860_bl.c:673: warning: assignment makes pointer from integer without a cast
drivers/video/backlight/adp8860_bl.c:689: error: too few arguments to function 'backlight_device_register'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8860_bl.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/adp8860_bl.c~backlight-new-driver-for-the-adp8860-backlight-parts-fix-adp8860_bl-build-errors drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~backlight-new-driver-for-the-adp8860-backlight-parts-fix-adp8860_bl-build-errors
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -16,6 +16,7 @@
 #include <linux/fb.h>
 #include <linux/backlight.h>
 #include <linux/leds.h>
+#include <linux/slab.h>
 #include <linux/workqueue.h>
 
 #include <linux/i2c/adp8860.h>
@@ -647,6 +648,7 @@ static int __devinit adp8860_probe(struc
 	struct adp8860_bl *data;
 	struct adp8860_backlight_platform_data *pdata =
 		client->dev.platform_data;
+	struct backlight_properties props;
 	uint8_t reg_val;
 	int ret;
 
@@ -683,10 +685,13 @@ static int __devinit adp8860_probe(struc
 	data->current_brightness = 0;
 	i2c_set_clientdata(client, data);
 
+	memset(&props, 0, sizeof(props));
+	props.max_brightness = ADP8860_MAX_BRIGHTNESS;
+
 	mutex_init(&data->lock);
 
 	bl = backlight_device_register(dev_driver_string(&client->dev),
-			&client->dev, data, &adp8860_bl_ops);
+			&client->dev, data, &adp8860_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&client->dev, "failed to register backlight\n");
 		ret = PTR_ERR(bl);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
dib3000mc-reduce-large-stack-usage-fix.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
ad525x_dpot-add-support-for-spi-parts-fix-ad525x_dpot-build.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
aio-fix-the-compat-vectored-operations-fix.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

