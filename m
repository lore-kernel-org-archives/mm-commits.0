From: akpm@linux-foundation.org
Subject: - amiga-zorro-bus-add-missing-zorro_device_remove.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:33:04 -0800
Message-ID: <200711272033.lARKX4sN028955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56236 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755283AbXK0UdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:33:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Amiga zorro bus: Add missing zorro_device_remove()
has been removed from the -mm tree.  Its filename was
     amiga-zorro-bus-add-missing-zorro_device_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
m68k-zorro7xx-needs-asm-amigahwh.patch
git-scsi-misc.patch
m68k-use-cc-cross-prefix.patch
m68k-array_size-cleanup.patch
dio-array_size-cleanup.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
mac68k-macii-adb-comment-correction.patch
mac68k-remove-dead-code.patch
mac68k-add-nubus-card-definitions-and-a-typo-fix.patch
mac68k-remove-dead-mac_adbkeycodes.patch
uml-borrow-consth-techniques.patch
remove-pointless-casts-from-void-pointers.patch
cleanup-after-apus-removal.patch
add-cmpxchg_local-to-m86k.patch
