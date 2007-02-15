From: akpm@linux-foundation.org
Subject: - pcmcia-some-class_device-fallout.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:51:08 -0800
Message-ID: <200702150851.l1F8p8hx025278@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40274 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965531AbXBOIvS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:51:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, greg@kroah.com, linux@dominikbrodowski.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pcmcia: some class_device fallout
has been removed from the -mm tree.  Its filename was
     pcmcia-some-class_device-fallout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pcmcia: some class_device fallout
From: Alexey Dobriyan <adobriyan@gmail.com>

As found on some arm defconfigs.

I only looked at how original patch changes things and other patches fix
compilation. ;-)

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/at91_cf.c    |    2 +-
 drivers/pcmcia/soc_common.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/pcmcia/at91_cf.c~pcmcia-some-class_device-fallout drivers/pcmcia/at91_cf.c
--- a/drivers/pcmcia/at91_cf.c~pcmcia-some-class_device-fallout
+++ a/drivers/pcmcia/at91_cf.c
@@ -278,7 +278,7 @@ static int __init at91_cf_probe(struct p
 		board->det_pin, board->irq_pin);
 
 	cf->socket.owner = THIS_MODULE;
-	cf->socket.dev.dev = &pdev->dev;
+	cf->socket.dev.parent = &pdev->dev;
 	cf->socket.ops = &at91_cf_ops;
 	cf->socket.resource_ops = &pccard_static_ops;
 	cf->socket.features = SS_CAP_PCCARD | SS_CAP_STATIC_MAP
diff -puN drivers/pcmcia/soc_common.c~pcmcia-some-class_device-fallout drivers/pcmcia/soc_common.c
--- a/drivers/pcmcia/soc_common.c~pcmcia-some-class_device-fallout
+++ a/drivers/pcmcia/soc_common.c
@@ -478,7 +478,7 @@ dump_bits(char **p, const char *prefix, 
  *
  * Returns: the number of characters added to the buffer
  */
-static ssize_t show_status(struct device *dev, char *buf)
+static ssize_t show_status(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct soc_pcmcia_socket *skt =
 		container_of(dev, struct soc_pcmcia_socket, socket.dev);
@@ -501,7 +501,7 @@ static ssize_t show_status(struct device
 
 	return p-buf;
 }
-static CLASS_DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
+static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
 
 
 static struct pccard_operations soc_common_pcmcia_operations = {
@@ -660,7 +660,7 @@ int soc_common_drv_pcmcia_probe(struct d
 
 		skt->socket.ops = &soc_common_pcmcia_operations;
 		skt->socket.owner = ops->owner;
-		skt->socket.dev.dev = dev;
+		skt->socket.dev.parent = dev;
 
 		init_timer(&skt->poll_timer);
 		skt->poll_timer.function = soc_common_pcmcia_poll_event;
@@ -747,7 +747,7 @@ int soc_common_drv_pcmcia_probe(struct d
 
 		add_timer(&skt->poll_timer);
 
-		device_create_file(&skt->socket.dev, &device_attr_status);
+		device_create_file(&skt->socket.dev, &dev_attr_status);
 	}
 
 	dev_set_drvdata(dev, sinfo);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-dvb.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
mwave-interesting-flags-savings.patch
