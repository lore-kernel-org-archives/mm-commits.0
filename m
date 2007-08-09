From: akpm@linux-foundation.org
Subject: - drivers-i2c-i2c-corec-make-code-static.patch removed from -mm tree
Date: Thu, 09 Aug 2007 02:47:22 -0700
Message-ID: <200708090947.l799lMW1025111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765113AbXHIJrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 05:47:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     drivers/i2c/i2c-core.c: make code static
has been removed from the -mm tree.  Its filename was
     drivers-i2c-i2c-corec-make-code-static.patch

This patch was dropped because Jean is handling it

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

slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
git-alsa.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
drivers-i2c-i2c-corec-make-code-static.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
git-mmc.patch
mmc-make-it-build.patch
git-mtd.patch
remove-fs-jffs2-ioctlc.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
fore200e_param_bs_queue-must-be-__devinit.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
parisc-extern-inline-static-inline.patch
cpqphp_ctrlc-remove-dead-code.patch
kernel-schedc-make-code-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
git-unionfs.patch
git-v9fs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
git-cryptodev.patch
kernel-auditscc-fix-an-off-by-one.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
