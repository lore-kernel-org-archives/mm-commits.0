From: akpm@linux-foundation.org
Subject: + drivers-i2c-i2c-corec-make-code-static.patch added to -mm tree
Date: Mon, 30 Jul 2007 14:59:02 -0700
Message-ID: <200707302159.l6ULx23S032575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43237 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968563AbXG3V7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 17:59:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     drivers/i2c/i2c-core.c: make code static
has been added to the -mm tree.  Its filename is
     drivers-i2c-i2c-corec-make-code-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/i2c/i2c-core.c: make code static
From: Adrian Bunk <bunk@stusta.de>

After the i2c-isa removal some code can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/i2c-core.c |    7 +++----
 include/linux/i2c.h    |    2 --
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/i2c/i2c-core.c~drivers-i2c-i2c-corec-make-code-static drivers/i2c/i2c-core.c
--- a/drivers/i2c/i2c-core.c~drivers-i2c-i2c-corec-make-code-static
+++ a/drivers/i2c/i2c-core.c
@@ -190,7 +190,7 @@ static struct device_attribute i2c_dev_a
 	{ },
 };
 
-struct bus_type i2c_bus_type = {
+static struct bus_type i2c_bus_type = {
 	.name		= "i2c",
 	.dev_attrs	= i2c_dev_attrs,
 	.match		= i2c_device_match,
@@ -201,7 +201,6 @@ struct bus_type i2c_bus_type = {
 	.suspend	= i2c_device_suspend,
 	.resume		= i2c_device_resume,
 };
-EXPORT_SYMBOL_GPL(i2c_bus_type);
 
 /**
  * i2c_new_device - instantiate an i2c device for use with a new style driver
@@ -285,7 +284,7 @@ EXPORT_SYMBOL_GPL(i2c_unregister_device)
 
 /* I2C bus adapters -- one roots each I2C or SMBUS segment */
 
-void i2c_adapter_dev_release(struct device *dev)
+static void i2c_adapter_dev_release(struct device *dev)
 {
 	struct i2c_adapter *adap = to_i2c_adapter(dev);
 	complete(&adap->dev_released);
@@ -303,7 +302,7 @@ static struct device_attribute i2c_adapt
 	{ },
 };
 
-struct class i2c_adapter_class = {
+static struct class i2c_adapter_class = {
 	.owner			= THIS_MODULE,
 	.name			= "i2c-adapter",
 	.dev_attrs		= i2c_adapter_attrs,
diff -puN include/linux/i2c.h~drivers-i2c-i2c-corec-make-code-static include/linux/i2c.h
--- a/include/linux/i2c.h~drivers-i2c-i2c-corec-make-code-static
+++ a/include/linux/i2c.h
@@ -35,8 +35,6 @@
 #include <linux/sched.h>	/* for completion */
 #include <linux/mutex.h>
 
-extern struct bus_type i2c_bus_type;
-
 /* --- General options ------------------------------------------------	*/
 
 struct i2c_msg;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
drivers-base-power-make-2-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
drivers-i2c-i2c-corec-make-code-static.patch
