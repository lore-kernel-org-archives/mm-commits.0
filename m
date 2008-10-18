From: akpm@linux-foundation.org
Subject: - drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:40 -0700
Message-ID: <200810182319.m9INJeaV029528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbYJRXTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, danielm77@spray.se, debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     drivers/char/tpm/tpm.c: fix error-path memory leak
has been removed from the -mm tree.  Its filename was
     drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/tpm/tpm.c: fix error-path memory leak
From: Andrew Morton <akpm@linux-foundation.org>

tpm_register_hardware() leaks devname on an error path.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11425

Reported-by: Daniel Marjamki <danielm77@spray.se>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/char/tpm/tpm.c~drivers-char-tpm-tpmc-fix-error-patch-memory-leak drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~drivers-char-tpm-tpmc-fix-error-patch-memory-leak
+++ a/drivers/char/tpm/tpm.c
@@ -1187,11 +1187,8 @@ struct tpm_chip *tpm_register_hardware(s
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
 
-	if (chip == NULL || devname == NULL) {
-		kfree(chip);
-		kfree(devname);
-		return NULL;
-	}
+	if (chip == NULL || devname == NULL)
+		goto out_free;
 
 	mutex_init(&chip->buffer_mutex);
 	mutex_init(&chip->tpm_mutex);
@@ -1208,8 +1205,7 @@ struct tpm_chip *tpm_register_hardware(s
 
 	if (chip->dev_num >= TPM_NUM_DEVICES) {
 		dev_err(dev, "No available tpm device numbers\n");
-		kfree(chip);
-		return NULL;
+		goto out_free;
 	} else if (chip->dev_num == 0)
 		chip->vendor.miscdev.minor = TPM_MINOR;
 	else
@@ -1250,6 +1246,11 @@ struct tpm_chip *tpm_register_hardware(s
 	spin_unlock(&driver_lock);
 
 	return chip;
+
+out_free:
+	kfree(chip);
+	kfree(devname);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(tpm_register_hardware);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

