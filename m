From: akpm@linux-foundation.org
Subject: - integrity-tpm-internal-kernel-interface-tidy.patch removed from -mm tree
Date: Wed, 09 May 2007 03:02:12 -0700
Message-ID: <200705091002.l49A2DXs020719@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754819AbXEIKCg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:02:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kjhall@us.ibm.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity-tpm-internal-kernel-interface-tidy
has been removed from the -mm tree.  Its filename was
     integrity-tpm-internal-kernel-interface-tidy.patch

This patch was dropped because it was folded into integrity-tpm-internal-kernel-interface.patch

------------------------------------------------------
Subject: integrity-tpm-internal-kernel-interface-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   23 -----------------------
 1 file changed, 23 deletions(-)

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
@@ -1131,7 +1114,6 @@ ssize_t tpm_write(struct file *file, con
 
 	return in_size;
 }
-
 EXPORT_SYMBOL_GPL(tpm_write);
 
 ssize_t tpm_read(struct file * file, char __user * buf,
@@ -1156,7 +1138,6 @@ ssize_t tpm_read(struct file * file, cha
 
 	return ret_size;
 }
-
 EXPORT_SYMBOL_GPL(tpm_read);
 
 void tpm_remove_hardware(struct device *dev)
@@ -1187,7 +1168,6 @@ void tpm_remove_hardware(struct device *
 
 	put_device(dev);
 }
-
 EXPORT_SYMBOL_GPL(tpm_remove_hardware);
 
 static u8 savestate[] = {
@@ -1209,7 +1189,6 @@ int tpm_pm_suspend(struct device *dev, p
 	tpm_transmit(chip, savestate, sizeof(savestate));
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(tpm_pm_suspend);
 
 /*
@@ -1225,7 +1204,6 @@ int tpm_pm_resume(struct device *dev)
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
 /*
@@ -1316,7 +1294,6 @@ struct tpm_chip *tpm_register_hardware(s
 
 	return chip;
 }
-
 EXPORT_SYMBOL_GPL(tpm_register_hardware);
 
 MODULE_AUTHOR("Leendert van Doorn (leendert@watson.ibm.com)");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmc-build-fix.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
mutex_lock_interruptible-add-__must_check.patch
afs-implement-basic-file-write-support.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
fs-convert-core-functions-to-zero_user_page.patch
rename-thread_info-to-stack.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
git-ia64-sa_interrupt-is-deprecated.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mtd.patch
git-battery-fix.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
upper-32-bits.patch
lib-hexdump-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
ntfs-use-zero_user_page.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
