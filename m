From: akpm@linux-foundation.org
Subject: + hack-to-make-wireless-work.patch added to -mm tree
Date: Mon, 19 Mar 2007 18:56:55 -0800
Message-ID: <200703200256.l2K2ut6w024042@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42487 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966075AbXCTC5i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 22:57:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jbenc@suse.cz, jeff@garzik.org, johannes@sipsolutions.net, linville@tuxdriver.com


The patch titled
     hack-to-make-wireless-work
has been added to the -mm tree.  Its filename is
     hack-to-make-wireless-work.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hack-to-make-wireless-work
From: Andrew Morton <akpm@linux-foundation.org>

Workaround for this:

[  178.096000] fw_register_device: device_register failed
[  178.096000] ipw2200: ipw2200-bss.fw request_firmware failed: Reason -19
[  178.096000] ipw2200: Unable to load firmware: -19
[  178.096000] ipw2200: failed to register network device
[  178.096000] ipw2200: probe of 0000:06:0b.0 failed with error -5

John W. Linville" <linville@tuxdriver.com>
Cc: <jeff@garzik.org>
Cc: <jbenc@suse.cz>
Cc: <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/firmware_class.c~hack-to-make-wireless-work drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~hack-to-make-wireless-work
+++ a/drivers/base/firmware_class.c
@@ -96,8 +96,8 @@ static int firmware_uevent(struct device
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 	int i = 0, len = 0;
 
-	if (!test_bit(FW_STATUS_READY, &fw_priv->status))
-		return -ENODEV;
+//	if (!test_bit(FW_STATUS_READY, &fw_priv->status))
+//		return -ENODEV;
 
 	if (add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &len,
 			   "FIRMWARE=%s", fw_priv->fw_id))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
hack-to-make-wireless-work.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lists-add-list-splice-tail.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
