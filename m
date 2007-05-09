From: akpm@linux-foundation.org
Subject: - integrity-ima-integrity_measure-support-tidy.patch removed from -mm tree
Date: Wed, 09 May 2007 03:01:00 -0700
Message-ID: <200705091001.l49A10qt020678@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756014AbXEIKBc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:01:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kjhall@us.ibm.com, zohar@linux.vnet.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity-ima-integrity_measure-support-tidy
has been removed from the -mm tree.  Its filename was
     integrity-ima-integrity_measure-support-tidy.patch

This patch was dropped because it was folded into integrity-ima-integrity_measure-support.patch

------------------------------------------------------
Subject: integrity-ima-integrity_measure-support-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/evm/evm_secfs.c     |    1 -
 security/evm/ima/ima.h       |    3 +--
 security/evm/ima/ima_fs.c    |   17 ++++++-----------
 security/evm/ima/ima_init.c  |   10 +++++-----
 security/evm/ima/ima_queue.c |   10 +++++-----
 5 files changed, 17 insertions(+), 24 deletions(-)

diff -puN security/evm/evm_secfs.c~integrity-ima-integrity_measure-support-tidy security/evm/evm_secfs.c
--- a/security/evm/evm_secfs.c~integrity-ima-integrity_measure-support-tidy
+++ a/security/evm/evm_secfs.c
@@ -103,7 +103,6 @@ static ssize_t evm_write_secfs(struct fi
 	size_t rc = buflen;
 	char *data;
 	int error;
-
 	struct evm_xattr_config *evm_data = NULL;
 	int evm_datasize;
 
diff -puN security/evm/ima/ima.h~integrity-ima-integrity_measure-support-tidy security/evm/ima/ima.h
--- a/security/evm/ima/ima.h~integrity-ima-integrity_measure-support-tidy
+++ a/security/evm/ima/ima.h
@@ -97,8 +97,7 @@ static inline void ima_pcrread(int idx, 
 	if (!ima_used_chip)
 		return;
 
-	if (tpm_pcr_read(IMA_TPM, idx, pcr, pcr_size) != 0) {
+	if (tpm_pcr_read(IMA_TPM, idx, pcr, pcr_size) != 0)
 		ima_error("Error Communicating to TPM chip\n");
-	}
 }
 #endif
diff -puN security/evm/ima/ima_fs.c~integrity-ima-integrity_measure-support-tidy security/evm/ima/ima_fs.c
--- a/security/evm/ima/ima_fs.c~integrity-ima-integrity_measure-support-tidy
+++ a/security/evm/ima/ima_fs.c
@@ -172,7 +172,6 @@ static struct file_operations ima_measur
 	.release = seq_release,
 };
 
-
 /* print in ascii */
 static int ima_ascii_measurements_show(struct seq_file *m, void *v)
 {
@@ -221,21 +220,18 @@ static struct file_operations ima_ascii_
 	.release = seq_release,
 };
 
-static struct dentry
-		*ima_dir = NULL,
-		*binary_runtime_measurements = NULL,
-    		*ascii_runtime_measurements = NULL,
-		*runtime_measurements_count = NULL,
-		*violations = NULL;
+static struct dentry *ima_dir;
+static struct dentry *binary_runtime_measurements;
+static struct dentry *ascii_runtime_measurements;
+static struct dentry *runtime_measurements_count;
+static struct dentry *violations;
 
 int ima_fs_init(void)
 {
-
 	ima_dir = securityfs_create_dir("ima", NULL);
 	if (!ima_dir || IS_ERR(ima_dir))
 		return -1;
 
-
 	binary_runtime_measurements =
 	    securityfs_create_file("binary_runtime_measurements",
 				   S_IRUSR | S_IRGRP, ima_dir, NULL,
@@ -265,13 +261,12 @@ int ima_fs_init(void)
 		goto out;
 	return 0;
 
-
 out:
 	securityfs_remove(runtime_measurements_count);
 	securityfs_remove(ascii_runtime_measurements);
 	securityfs_remove(binary_runtime_measurements);
 	securityfs_remove(ima_dir);
-    return -1;
+	return -1;
 }
 
 void __exit ima_fs_cleanup(void)
diff -puN security/evm/ima/ima_init.c~integrity-ima-integrity_measure-support-tidy security/evm/ima/ima_init.c
--- a/security/evm/ima/ima_init.c~integrity-ima-integrity_measure-support-tidy
+++ a/security/evm/ima/ima_init.c
@@ -21,9 +21,9 @@
 /* name for boot aggregate entry */
 static char *boot_aggregate_name = "boot_aggregate";
 static const char version[] = "v7.6 02/27/2007";
-static const char illegal_pcr[20] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
+static const char illegal_pcr[20];
 
-int ima_used_chip = 0;
+int ima_used_chip;
 
 static void ima_add_boot_aggregate(void)
 {
@@ -33,8 +33,7 @@ static void ima_add_boot_aggregate(void)
 	int err;
 
 	/* create new entry for boot aggregate */
-	entry = (struct measure_entry *)
-	    kzalloc(sizeof(struct measure_entry), GFP_ATOMIC);
+	entry = kzalloc(sizeof(struct measure_entry), GFP_ATOMIC);
 	if (entry == NULL) {
 		ima_invalidate_pcr("error allocating new measurement entry");
 		return;
@@ -101,7 +100,8 @@ int ima_init(void)
 		ima_used_chip = 1;
 
 	if (!ima_used_chip)
-		ima_info("No TPM chip found(rc = %d), activating TPM-bypass!\n", rc);
+		ima_info("No TPM chip found(rc = %d), activating TPM-bypass!\n",
+			rc);
 
 	create_htable();	/* for measurements */
 
diff -puN security/evm/ima/ima_queue.c~integrity-ima-integrity_measure-support-tidy security/evm/ima/ima_queue.c
--- a/security/evm/ima/ima_queue.c~integrity-ima-integrity_measure-support-tidy
+++ a/security/evm/ima/ima_queue.c
@@ -32,7 +32,7 @@ DEFINE_SPINLOCK(ima_queue_lock);
  * and extending the TPM PCR aggregate. Since tpm_extend can take
  * long (and the tpm driver uses a mutex), we can't use the spinlock.
  */
-static DECLARE_MUTEX(ima_extend_list_mutex);
+static DEFINE_MUTEX(ima_extend_list_mutex);
 
 void create_htable(void)
 {
@@ -49,7 +49,7 @@ void create_htable(void)
 		atomic_set(&ima_htable.queue_len[i], 0);
 	}
 
-	init_MUTEX(&ima_extend_list_mutex);
+	mutex_init(&ima_extend_list_mutex);
 	spin_unlock(&ima_queue_lock);
 }
 
@@ -95,7 +95,7 @@ int ima_add_measure_entry(struct measure
 	struct queue_entry *qe;
 	int error = 0;
 
-	down(&ima_extend_list_mutex);
+	mutex_lock(&ima_extend_list_mutex);
 	spin_lock(&ima_queue_lock);
 	if (ima_lookup_digest_entry(entry->digest)) {
 		error = -EEXIST;
@@ -122,7 +122,7 @@ int ima_add_measure_entry(struct measure
 	}
 	spin_unlock(&ima_queue_lock);
 	ima_extend(entry->digest);
-      out:
-	up(&ima_extend_list_mutex);
+out:
+	mutex_unlock(&ima_extend_list_mutex);
 	return error;
 }
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
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
