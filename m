From: akpm@osdl.org
Subject: - md-conditionalize-some-code.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:59 -0800
Message-ID: <200612130654.kBD6sxMn030595@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57729 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965026AbWLMGzL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     MD: conditionalize some code
has been removed from the -mm tree.  Its filename was
     md-conditionalize-some-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MD: conditionalize some code
From: Jeff Garzik <jeff@garzik.org>

The autorun code is only used if this module is built into the static
kernel image.  Adjust #ifdefs accordingly.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-conditionalize-some-code drivers/md/md.c
--- a/drivers/md/md.c~md-conditionalize-some-code
+++ a/drivers/md/md.c
@@ -3371,6 +3371,7 @@ out:
 	return err;
 }
 
+#ifndef MODULE
 static void autorun_array(mddev_t *mddev)
 {
 	mdk_rdev_t *rdev;
@@ -3485,6 +3486,7 @@ static void autorun_devices(int part)
 	}
 	printk(KERN_INFO "md: ... autorun DONE.\n");
 }
+#endif /* !MODULE */
 
 static int get_version(void __user * arg)
 {
@@ -5593,7 +5595,7 @@ static void autostart_arrays(int part)
 	autorun_devices(part);
 }
 
-#endif
+#endif /* !MODULE */
 
 static __exit void md_exit(void)
 {
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-acpi.patch
git-drm.patch
git-libata-all.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_sil680-suspend-resume-tidy.patch
initializer-entry-defined-twice-in-pata_rz1000.patch
user-of-the-jiffies-rounding-patch-ata-subsystem.patch
libata-fix-oops-with-sparsemem.patch
git-mtd.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
8139too-force-media-setting-fix.patch
remove-the-broken-skmc-driver.patch
tulip-fix-shutdown-dma-irq-race.patch
git-ioat.patch
via-sb600-sata-quirk.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
fix-numerous-kcalloc-calls-convert-to-kzalloc.patch
getting-rid-of-all-casts-of-kalloc-calls.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch

