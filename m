From: akpm@linux-foundation.org
Subject: - integrity-evm-as-an-integrity-service-provider-tidy.patch removed from -mm tree
Date: Wed, 09 May 2007 03:00:12 -0700
Message-ID: <200705091000.l49A0CRP020659@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756382AbXEIKAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:00:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kjhall@us.ibm.com, zohar@linux.vnet.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity-evm-as-an-integrity-service-provider-tidy
has been removed from the -mm tree.  Its filename was
     integrity-evm-as-an-integrity-service-provider-tidy.patch

This patch was dropped because it was folded into integrity-evm-as-an-integrity-service-provider.patch

------------------------------------------------------
Subject: integrity-evm-as-an-integrity-service-provider-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/mount.c          |    4 +---
 include/linux/magic.h     |    1 +
 security/evm/evm.h        |    2 --
 security/evm/evm_config.c |   19 ++++++++++---------
 security/evm/evm_crypto.c |    8 +++-----
 security/evm/evm_main.c   |   10 ++++------
 6 files changed, 19 insertions(+), 25 deletions(-)

diff -puN fs/sysfs/mount.c~integrity-evm-as-an-integrity-service-provider-tidy fs/sysfs/mount.c
--- a/fs/sysfs/mount.c~integrity-evm-as-an-integrity-service-provider-tidy
+++ a/fs/sysfs/mount.c
@@ -6,15 +6,13 @@
 
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/magic.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <asm/semaphore.h>
 
 #include "sysfs.h"
 
-/* Random magic number */
-#define SYSFS_MAGIC 0x62656572
-
 struct vfsmount *sysfs_mount;
 struct super_block * sysfs_sb = NULL;
 struct kmem_cache *sysfs_dir_cachep;
diff -puN include/linux/magic.h~integrity-evm-as-an-integrity-service-provider-tidy include/linux/magic.h
--- a/include/linux/magic.h~integrity-evm-as-an-integrity-service-provider-tidy
+++ a/include/linux/magic.h
@@ -21,6 +21,7 @@
 #define MINIX2_SUPER_MAGIC	0x2468		/* minix V2 fs */
 #define MINIX2_SUPER_MAGIC2	0x2478		/* minix V2 fs, 30 char names */
 #define MINIX3_SUPER_MAGIC	0x4d5a		/* minix V3 fs */
+#define SYSFS_MAGIC		0x62656572
 
 #define MSDOS_SUPER_MAGIC	0x4d44		/* MD */
 #define NCP_SUPER_MAGIC		0x564c		/* Guess, what 0x564c is :-) */
diff -puN security/evm/evm.h~integrity-evm-as-an-integrity-service-provider-tidy security/evm/evm.h
--- a/security/evm/evm.h~integrity-evm-as-an-integrity-service-provider-tidy
+++ a/security/evm/evm.h
@@ -8,7 +8,6 @@
 #include <linux/spinlock_types.h>
 #include <linux/integrity.h>
 
-#define DEVFS_SUPER_MAGIC	0x1373
 #define MAX_DIGEST_SIZE 	20	/* 160-bits */
 
 extern char *evm_hmac, *evm_hash;
@@ -48,7 +47,6 @@ struct evm_iint_cache {
 	struct mutex mutex;
 };
 
-extern void display_config(const char *);
 extern struct evm_xattr_config *evm_parse_config(char *data,
 						 unsigned long datalen,
 						 int *datasize);
diff -puN security/evm/evm_config.c~integrity-evm-as-an-integrity-service-provider-tidy security/evm/evm_config.c
--- a/security/evm/evm_config.c~integrity-evm-as-an-integrity-service-provider-tidy
+++ a/security/evm/evm_config.c
@@ -18,17 +18,17 @@
  * Configuration data
  */
 struct evm_xattr_config *evm_config_xattrdata;
-int evm_config_xattrnum = 0;	/* number of extended attributes */
+int evm_config_xattrnum;	/* number of extended attributes */
 
 /*
  * inode->i_integrity information
  */
-void display_config(const char *name)
+static void display_config(const char *name)
 {
 	struct evm_xattr_config *config_p;
 
 	for_each_xattr(config_p, evm_config_xattrdata, evm_config_xattrnum)
-	    printk(KERN_INFO "%s: %s\n", name, config_p->xattr_name);
+		printk(KERN_INFO "%s: %s\n", name, config_p->xattr_name);
 }
 
 /*
@@ -42,7 +42,6 @@ int evm_init_config(struct evm_xattr_con
 		evm_config_xattrdata = evm_data;
 		evm_config_xattrnum = evm_datasize;
 		display_config(__FUNCTION__);
-
 	} else {
 		printk(KERN_INFO "%s: config file definition missing\n",
 		       __FUNCTION__);
@@ -60,9 +59,11 @@ static char *get_tag(char *buf_start, ch
 	/* Get start of tag */
 	while (bufp < buf_end) {
 		if (*bufp == ' ')	/* skip blanks */
-			while ((*bufp == ' ') && (bufp++ < buf_end)) ;
+			while ((*bufp == ' ') && (bufp++ < buf_end))
+				;
 		else if (*bufp == '#') {	/* skip comment */
-			while ((*bufp != '\n') && (bufp++ < buf_end)) ;
+			while ((*bufp != '\n') && (bufp++ < buf_end))
+				;
 			bufp++;
 		} else if (*bufp == '\n')	/* skip newline */
 			bufp++;
@@ -107,8 +108,8 @@ struct evm_xattr_config *evm_parse_confi
 	*xattrnum = num_xattr;
 
 	datap = data;
-	config_xattrdata =
-	    kmalloc(num_xattr * sizeof(struct evm_xattr_config), GFP_KERNEL);
+	config_xattrdata = kmalloc(num_xattr * sizeof(struct evm_xattr_config),
+				GFP_KERNEL);
 	if (!config_xattrdata)
 		return NULL;
 
@@ -123,7 +124,7 @@ struct evm_xattr_config *evm_parse_confi
 	return config_xattrdata;
 }
 
-inline void evm_cleanup_config(void)
+void evm_cleanup_config(void)
 {
 	kfree(evm_config_xattrdata);
 }
diff -puN security/evm/evm_crypto.c~integrity-evm-as-an-integrity-service-provider-tidy security/evm/evm_crypto.c
--- a/security/evm/evm_crypto.c~integrity-evm-as-an-integrity-service-provider-tidy
+++ a/security/evm/evm_crypto.c
@@ -33,7 +33,7 @@
 static unsigned char tpm_key[MAX_TPMKEY];
 static int tpm_keylen = MAX_TPMKEY;
 
-int update_file_hash(struct dentry *dentry, struct file *f,
+static int update_file_hash(struct dentry *dentry, struct file *f,
 		     struct hash_desc *desc)
 {
 	struct file *file = f;
@@ -217,11 +217,9 @@ int evm_calc_hmac(struct dentry *dentry,
 	struct scatterlist sg[1];
 	char *fname;
 	int error = 0;
-
 	struct evm_xattr_config *config_p;
 	int xattr_size = 0;
 	char *xattr_value = NULL;
-
 	struct h_misc {
 		unsigned long ino;
 		__u32 generation;
@@ -278,7 +276,7 @@ int evm_calc_hmac(struct dentry *dentry,
 					__FUNCTION__, fname,
 					config_p->xattr_name);
 		}
-	};
+	}
 	kfree(xattr_value);
 	memset(hmac_misc, 0, sizeof misc);
 	hmac_misc->ino = inode->i_ino;
@@ -331,7 +329,7 @@ int evm_init_tpmkernkey(void)
 
 	kmk = request_key(&key_type_user, TPMKEY, NULL);
 	if (IS_ERR(kmk)) {
-		return (-1);
+		return -1;
 	} else {
 		down_read(&kmk->sem);
 		ukp = kmk->payload.data;
diff -puN security/evm/evm_main.c~integrity-evm-as-an-integrity-service-provider-tidy security/evm/evm_main.c
--- a/security/evm/evm_main.c~integrity-evm-as-an-integrity-service-provider-tidy
+++ a/security/evm/evm_main.c
@@ -24,6 +24,7 @@
 #include <linux/proc_fs.h>
 #include <linux/xattr.h>
 #include <linux/file.h>
+#include <linux/magic.h>
 #include <linux/writeback.h>
 #include "evm_integrity.h"
 #include "evm.h"
@@ -363,10 +364,7 @@ static int evm_verify_data(struct dentry
  */
 static int skip_measurement(struct inode *inode, int mask)
 {
-#define SYSFS_MAGIC 0x62656572
-
-	if ((inode->i_sb->s_magic == DEVFS_SUPER_MAGIC) ||
-	    (inode->i_sb->s_magic == PROC_SUPER_MAGIC) ||
+	if ((inode->i_sb->s_magic == PROC_SUPER_MAGIC) ||
 	    (inode->i_sb->s_magic == SYSFS_MAGIC)) {
 		return 1;	/*can't measure */
 	}
@@ -877,9 +875,9 @@ static void evm_enable_integrity(void)
 
 static void evm_cleanup_integrity(void)
 {
-	if (evm_install) {
+	if (evm_install)
 		unregister_integrity(&evm_install_ops);
-	} else
+	else
 		unregister_integrity(&evm_integrity_ops);
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
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
