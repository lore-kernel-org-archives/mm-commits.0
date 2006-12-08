From: akpm@osdl.org
Subject: - backlight-do-not-power-off-backlight-when-unregistering-try-3.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:27 -0800
Message-ID: <200612082014.kB8KERO9003179@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59922 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946974AbWLHUPM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hmh@hmh.eng.br, jsimmons@infradead.org, pavel@ucw.cz, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight: do not power off backlight when unregistering
has been removed from the -mm tree.  Its filename was
     backlight-do-not-power-off-backlight-when-unregistering-try-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: backlight: do not power off backlight when unregistering
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

ACPI drivers like ibm-acpi are moving to the backlight sysfs
infrastructure.  During ibm-acpi testing, I have noticed that
backlight_device_unregister() sets the display brightness and power to
zero.

This causes the display to be dimmed on ibm-acpi module removal.  It will
affect all other ACPI drivers that are being converted to use the backlight
class, as well.  It also affects a number of framebuffer devices that are
used on desktops and laptops which might also not want such behaviour.

Since working around this behaviour requires undesireable hacks, Richard
Purdie decided that we would be better off reverting the changes in the
sysfs class, and adding the code to dim and power off the backlight device
to the drivers that want it.  This patch is my attempt to do so.

Patch against latest linux-2.6.git.  Changes untested, as I lack the
required hardware.  Still, they are trivial enough that, apart from typos,
there is little chance of getting them wrong.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/backlight/backlight.c |    6 ------
 drivers/video/backlight/corgi_bl.c  |    4 ++++
 drivers/video/backlight/hp680_bl.c  |    4 ++++
 drivers/video/backlight/locomolcd.c |    4 ++++
 4 files changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-do-not-power-off-backlight-when-unregistering-try-3 drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-do-not-power-off-backlight-when-unregistering-try-3
+++ a/drivers/video/backlight/backlight.c
@@ -282,12 +282,6 @@ void backlight_device_unregister(struct 
 					 &bl_class_device_attributes[i]);
 
 	down(&bd->sem);
-	if (likely(bd->props && bd->props->update_status)) {
-		bd->props->brightness = 0;
-		bd->props->power = 0;
-		bd->props->update_status(bd);
-	}
-
 	bd->props = NULL;
 	up(&bd->sem);
 
diff -puN drivers/video/backlight/corgi_bl.c~backlight-do-not-power-off-backlight-when-unregistering-try-3 drivers/video/backlight/corgi_bl.c
--- a/drivers/video/backlight/corgi_bl.c~backlight-do-not-power-off-backlight-when-unregistering-try-3
+++ a/drivers/video/backlight/corgi_bl.c
@@ -135,6 +135,10 @@ static int corgibl_probe(struct platform
 
 static int corgibl_remove(struct platform_device *dev)
 {
+	corgibl_data.power = 0;
+	corgibl_data.brightness = 0;
+	corgibl_send_intensity(corgi_backlight_device);
+
 	backlight_device_unregister(corgi_backlight_device);
 
 	printk("Corgi Backlight Driver Unloaded\n");
diff -puN drivers/video/backlight/hp680_bl.c~backlight-do-not-power-off-backlight-when-unregistering-try-3 drivers/video/backlight/hp680_bl.c
--- a/drivers/video/backlight/hp680_bl.c~backlight-do-not-power-off-backlight-when-unregistering-try-3
+++ a/drivers/video/backlight/hp680_bl.c
@@ -117,6 +117,10 @@ static int __init hp680bl_probe(struct p
 
 static int hp680bl_remove(struct platform_device *dev)
 {
+	hp680bl_data.brightness = 0;
+	hp680bl_data.power = 0;
+	hp680bl_send_intensity(hp680_backlight_device);
+
 	backlight_device_unregister(hp680_backlight_device);
 
 	return 0;
diff -puN drivers/video/backlight/locomolcd.c~backlight-do-not-power-off-backlight-when-unregistering-try-3 drivers/video/backlight/locomolcd.c
--- a/drivers/video/backlight/locomolcd.c~backlight-do-not-power-off-backlight-when-unregistering-try-3
+++ a/drivers/video/backlight/locomolcd.c
@@ -200,6 +200,10 @@ static int locomolcd_remove(struct locom
 {
 	unsigned long flags;
 
+	locomobl_data.brightness = 0;
+	locomobl_data.power = 0;
+	locomolcd_set_intensity(locomolcd_bl_device);
+
 	backlight_device_unregister(locomolcd_bl_device);
 	local_irq_save(flags);
 	locomolcd_dev = NULL;
_

Patches currently in -mm which might be from hmh@hmh.eng.br are

backlight-do-not-power-off-backlight-when-unregistering-try-3.patch
git-acpi.patch

