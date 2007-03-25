From: akpm@linux-foundation.org
Subject: + integrity-tpm-internal-kernel-interface-tidy.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:29:02 -0800
Message-ID: <200703250829.l2P8T2OB023754@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36216 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933215AbXCYI3H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:29:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kjhall@us.ibm.com, zohar@linux.vnet.ibm.com


The patch titled
     integrity-tpm-internal-kernel-interface-tidy
has been added to the -mm tree.  Its filename is
     integrity-tpm-internal-kernel-interface-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: integrity-tpm-internal-kernel-interface-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   24 ------------------------
 1 file changed, 24 deletions(-)

diff -puN drivers/char/tpm/tpm.c~integrity-tpm-internal-kernel-interface-tidy drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~integrity-tpm-internal-kernel-interface-tidy
+++ a/drivers/char/tpm/tpm.c
@@ -365,7 +365,6 @@ unsigned long tpm_calc_ordinal_duration(
 	else
 		return duration;
 }
-
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
 /*
@@ -427,7 +426,6 @@ out:
 	up(&chip->tpm_mutex);
 	return rc;
 }
-
 EXPORT_SYMBOL_GPL(tpm_transmit);
 
 #define TPM_DIGEST_SIZE 20
@@ -504,7 +502,6 @@ void tpm_gen_interrupt(struct tpm_chip *
 	rc = transmit_cmd(chip, data, sizeof(data),
 			  "attempting to determine the timeouts");
 }
-
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
 void tpm_get_timeouts(struct tpm_chip *chip)
@@ -571,7 +568,6 @@ duration:
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_3_IDX))));
 }
-
 EXPORT_SYMBOL_GPL(tpm_get_timeouts);
 
 void tpm_continue_selftest(struct tpm_chip *chip)
@@ -584,7 +580,6 @@ void tpm_continue_selftest(struct tpm_ch
 
 	tpm_transmit(chip, data, sizeof(data));
 }
-
 EXPORT_SYMBOL_GPL(tpm_continue_selftest);
 
 /*
@@ -610,7 +605,6 @@ ssize_t tpm_show_enabled(struct device *
 		return 0;
 	return sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_DISABLE_IDX]);
 }
-
 EXPORT_SYMBOL_GPL(tpm_show_enabled);
 
 /*
@@ -636,7 +630,6 @@ ssize_t tpm_show_active(struct device * 
 		return 0;
 	return sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_INACTIVE_IDX]);
 }
-
 EXPORT_SYMBOL_GPL(tpm_show_active);
 
 /*
@@ -662,7 +655,6 @@ ssize_t tpm_show_owned(struct device * d
 		return 0;
 	return sprintf(buf, "%d\n", data[TPM_GET_CAP_RET_BOOL_1_IDX]);
 }
-
 EXPORT_SYMBOL_GPL(tpm_show_owned);
 
 /*
@@ -688,7 +680,6 @@ ssize_t tpm_show_temp_deactivated(struct
 		return 0;
 	return sprintf(buf, "%d\n", data[TPM_GET_CAP_TEMP_INACTIVE_IDX]);
 }
-
 EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
 
 #define READ_PCR_RESULT_SIZE 30
@@ -739,7 +730,6 @@ ssize_t tpm_show_pcrs(struct device *dev
 out:
 	return str - buf;
 }
-
 EXPORT_SYMBOL_GPL(tpm_show_pcrs);
 
 /*
@@ -798,7 +788,6 @@ int tpm_pcr_read(u32 chip_id, int pcr_id
 	return rc;
 
 }
-
 EXPORT_SYMBOL_GPL(tpm_pcr_read);
 
 #define EXTEND_PCR_SIZE 34
@@ -837,7 +826,6 @@ int tpm_pcr_extend(u32 chip_id, int pcr_
 		rc = be32_to_cpu(*((u32 *) (data + 6)));
 	return rc;
 }
-
 EXPORT_SYMBOL_GPL(tpm_pcr_extend);
 
 #define  READ_PUBEK_RESULT_SIZE 314
@@ -905,7 +893,6 @@ out:
 	kfree(data);
 	return rc;
 }
-
 EXPORT_SYMBOL_GPL(tpm_show_pubek);
 
 #define CAP_VERSION_1_1 6
@@ -962,7 +949,6 @@ ssize_t tpm_show_caps(struct device *dev
 out:
 	return str - buf;
 }
-
 EXPORT_SYMBOL_GPL(tpm_show_caps);
 
 /*
@@ -1011,7 +997,6 @@ ssize_t tpm_show_caps_1_2(struct device 
 out:
 	return str - buf;
 }
-
 EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
 
 /*
@@ -1027,7 +1012,6 @@ ssize_t tpm_store_cancel(struct device *
 	chip->vendor.cancel(chip);
 	return count;
 }
-
 EXPORT_SYMBOL_GPL(tpm_store_cancel);
 
 /*
@@ -1079,7 +1063,6 @@ err_out:
 	spin_unlock(&driver_lock);
 	return rc;
 }
-
 EXPORT_SYMBOL_GPL(tpm_open);
 
 int tpm_release(struct inode *inode, struct file *file)
@@ -1097,7 +1080,6 @@ int tpm_release(struct inode *inode, str
 	kfree(chip->data_buffer);
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(tpm_release);
 
 ssize_t tpm_write(struct file * file, const char __user * buf,
@@ -1132,7 +1114,6 @@ ssize_t tpm_write(struct file * file, co
 
 	return in_size;
 }
-
 EXPORT_SYMBOL_GPL(tpm_write);
 
 ssize_t tpm_read(struct file * file, char __user * buf,
@@ -1157,7 +1138,6 @@ ssize_t tpm_read(struct file * file, cha
 
 	return ret_size;
 }
-
 EXPORT_SYMBOL_GPL(tpm_read);
 
 void tpm_remove_hardware(struct device *dev)
@@ -1188,7 +1168,6 @@ void tpm_remove_hardware(struct device *
 
 	put_device(dev);
 }
-
 EXPORT_SYMBOL_GPL(tpm_remove_hardware);
 
 static u8 savestate[] = {
@@ -1210,7 +1189,6 @@ int tpm_pm_suspend(struct device *dev, p
 	tpm_transmit(chip, savestate, sizeof(savestate));
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(tpm_pm_suspend);
 
 /*
@@ -1226,7 +1204,6 @@ int tpm_pm_resume(struct device *dev)
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
 /*
@@ -1313,7 +1290,6 @@ struct tpm_chip *tpm_register_hardware(s
 
 	return chip;
 }
-
 EXPORT_SYMBOL_GPL(tpm_register_hardware);
 
 MODULE_AUTHOR("Leendert van Doorn (leendert@watson.ibm.com)");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ext-ea-block-reference-count-racing-fix-performance-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
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
git-net.patch
git-net-fixup.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
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
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
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
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-tpm-internal-kernel-interface-tidy.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
