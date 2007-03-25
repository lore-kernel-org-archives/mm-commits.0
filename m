From: akpm@linux-foundation.org
Subject: + integrity-ima-integrity_measure-support-tidy.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:24:28 -0800
Message-ID: <200703250824.l2P8OS59023687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36141 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773AbXCYIYg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:24:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kjhall@us.ibm.com, zohar@linux.vnet.ibm.com, zohar@us.ibm.com


The patch titled
     integrity-ima-integrity_measure-support-tidy
has been added to the -mm tree.  Its filename is
     integrity-ima-integrity_measure-support-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
mm-only-free-swap-space-of-reactivated-pages-debug.patch
