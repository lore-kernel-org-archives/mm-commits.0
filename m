From: akpm@linux-foundation.org
Subject: + amiga-zorro-bus-add-missing-zorro_device_remove.patch added to -mm tree
Date: Mon, 19 Nov 2007 18:11:54 -0800
Message-ID: <200711200211.lAK2BsbG008779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762325AbXKTCME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 21:12:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     Amiga zorro bus: Add missing zorro_device_remove()
has been added to the -mm tree.  Its filename is
     amiga-zorro-bus-add-missing-zorro_device_remove.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Amiga zorro bus: Add missing zorro_device_remove()
From: Geert Uytterhoeven <geert@linux-m68k.org>

Amiga zorro bus: Add missing zorro_device_remove(). Without this ifconfig and
/proc/net/dev oops after unloading a Zorro network device driver module.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/zorro/zorro-driver.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN drivers/zorro/zorro-driver.c~amiga-zorro-bus-add-missing-zorro_device_remove drivers/zorro/zorro-driver.c
--- a/drivers/zorro/zorro-driver.c~amiga-zorro-bus-add-missing-zorro_device_remove
+++ a/drivers/zorro/zorro-driver.c
@@ -60,6 +60,20 @@ static int zorro_device_probe(struct dev
 }
 
 
+static int zorro_device_remove(struct device *dev)
+{
+	struct zorro_dev *z = to_zorro_dev(dev);
+	struct zorro_driver *drv = to_zorro_driver(dev->driver);
+
+	if (drv) {
+		if (drv->remove)
+			drv->remove(z);
+		z->driver = NULL;
+	}
+	return 0;
+}
+
+
     /**
      *  zorro_register_driver - register a new Zorro driver
      *  @drv: the driver structure to register
@@ -128,6 +142,7 @@ struct bus_type zorro_bus_type = {
 	.name	= "zorro",
 	.match	= zorro_bus_match,
 	.probe	= zorro_device_probe,
+	.remove	= zorro_device_remove,
 };
 
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-export-atari_keyb_init.patch
amiga-zorro-bus-add-missing-zorro_device_remove.patch
mac68k-mailing-list-addresss.patch
git-scsi-misc.patch
m68k-use-cc-cross-prefix.patch
uml-borrow-consth-techniques.patch
remove-pointless-casts-from-void-pointers.patch
cleanup-after-apus-removal.patch
add-cmpxchg_local-to-m86k.patch
