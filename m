From: akpm@linux-foundation.org
Subject: + fix-several-memory-leaks-in-cr_backlight_probe-take2.patch added to -mm tree
Date: Tue, 07 Aug 2007 15:09:28 -0700
Message-ID: <200708072209.l77M9TNi007289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964837AbXHGWJp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:09:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, rpurdie@rpsys.net


The patch titled
     Fix several memory leaks in cr_backlight_probe() - take2
has been added to the -mm tree.  Its filename is
     fix-several-memory-leaks-in-cr_backlight_probe-take2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix several memory leaks in cr_backlight_probe() - take2
From: Jesper Juhl <jesper.juhl@gmail.com>

After fixing the too small memory allocation in cr_backlight_probe()
from drivers/video/backlight/cr_bllcd.c
(commit e3bbb3f05339de438faf54124f25c92e6fe4ac2e) I noticed that the
Coverity checker also thought there were a few memory leaks in there.
I took a closer look and confirmed that there were indeed several
leaks.

At the start of the function we allocate storage for a
'struct cr_panel' and store the pointer in a variable named 'crp'.

Then we call pci_get_device() and pci_read_config_byte() and if
either of them fail we return without freeing the memory allocated
for the 'struct cr_panel'. These two leaks are easy to fix since we
don't even use 'crp' for anything up to this point, so I simply
moved the allocation further down in the function so it only happens
just before we actually need it.

A bit further down we call backlight_device_register() and store the
result in 'crp->cr_backlight_device'. In case of error we return
'crp->cr_backlight_device' from the function, thus leaking 'crp'
itself. The same thing happens with the call to lcd_device_register().
To fix these two leaks I declare two new pointers to hold the return
values, so that in case of error we can return the pointer (as before)
but without leaking 'crp'.

This version of the patch also adds missing
backlight_device_unregister() / lcd_device_unregister() / pci_dev_put()
calls to error paths.
  Thanks to Richard Purdie <rpurdie@rpsys.net> for noticing.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/cr_bllcd.c |   35 +++++++++++++++------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff -puN drivers/video/backlight/cr_bllcd.c~fix-several-memory-leaks-in-cr_backlight_probe-take2 drivers/video/backlight/cr_bllcd.c
--- a/drivers/video/backlight/cr_bllcd.c~fix-several-memory-leaks-in-cr_backlight_probe-take2
+++ a/drivers/video/backlight/cr_bllcd.c
@@ -171,13 +171,11 @@ static struct lcd_ops cr_lcd_ops = {
 
 static int cr_backlight_probe(struct platform_device *pdev)
 {
+	struct backlight_device *bdp;
+	struct lcd_device *ldp;
 	struct cr_panel *crp;
 	u8 dev_en;
 
-	crp = kzalloc(sizeof(*crp), GFP_KERNEL);
-	if (crp == NULL)
-		return -ENOMEM;
-
 	lpc_dev = pci_get_device(PCI_VENDOR_ID_INTEL,
 					CRVML_DEVICE_LPC, NULL);
 	if (!lpc_dev) {
@@ -193,27 +191,34 @@ static int cr_backlight_probe(struct pla
 		return -ENODEV;
 	}
 
-	crp->cr_backlight_device = backlight_device_register("cr-backlight",
-							     &pdev->dev, NULL,
-							     &cr_backlight_ops);
-	if (IS_ERR(crp->cr_backlight_device)) {
+	bdp = backlight_device_register("cr-backlight",
+					&pdev->dev, NULL, &cr_backlight_ops);
+	if (IS_ERR(bdp)) {
 		pci_dev_put(lpc_dev);
-		return PTR_ERR(crp->cr_backlight_device);
+		return PTR_ERR(bdp);
 	}
 
-	crp->cr_lcd_device = lcd_device_register("cr-lcd",
-							&pdev->dev, NULL,
-							&cr_lcd_ops);
-
-	if (IS_ERR(crp->cr_lcd_device)) {
+	ldp = lcd_device_register("cr-lcd", &pdev->dev, NULL, &cr_lcd_ops);
+	if (IS_ERR(ldp)) {
+		backlight_device_unregister(bdp);
 		pci_dev_put(lpc_dev);
-		return PTR_ERR(crp->cr_backlight_device);
+		return PTR_ERR(bdp);
 	}
 
 	pci_read_config_dword(lpc_dev, CRVML_REG_GPIOBAR,
 			      &gpio_bar);
 	gpio_bar &= ~0x3F;
 
+	crp = kzalloc(sizeof(*crp), GFP_KERNEL);
+	if (!crp) {
+		lcd_device_unregister(ldp);
+		backlight_device_unregister(bdp);
+		pci_dev_put(lpc_dev);
+		return -ENOMEM;
+	}
+
+	crp->cr_backlight_device = bdp;
+	crp->cr_lcd_device = ldp;
 	crp->cr_backlight_device->props.power = FB_BLANK_UNBLANK;
 	crp->cr_backlight_device->props.brightness = 0;
 	crp->cr_backlight_device->props.max_brightness = 0;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-acpi.patch
git-alsa.patch
au88x0-mem-leak-fix-in-snd_vortex_create.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
git-mtd.patch
git-ubi.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
fix-several-memory-leaks-in-cr_backlight_probe-take2.patch
fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
documentation-sysrq-description-of-h-slightly-inaccurate.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
