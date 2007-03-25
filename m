From: akpm@linux-foundation.org
Subject: + integrity-evm-as-an-integrity-service-provider-tidy.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:14:58 -0800
Message-ID: <200703250814.l2P8EwRW023533@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35990 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbXCYIPL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:15:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kjhall@us.ibm.com, zohar@linux.vnet.ibm.com, zohar@us.ibm.com


The patch titled
     integrity-evm-as-an-integrity-service-provider-tidy
has been added to the -mm tree.  Its filename is
     integrity-evm-as-an-integrity-service-provider-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: integrity-evm-as-an-integrity-service-provider-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/mount.c          |    3 ---
 include/linux/magic.h     |    1 +
 security/evm/evm.h        |    2 --
 security/evm/evm_config.c |   19 ++++++++++---------
 security/evm/evm_crypto.c |    8 +++-----
 security/evm/evm_main.c   |   10 ++++------
 6 files changed, 18 insertions(+), 25 deletions(-)

diff -puN fs/sysfs/mount.c~integrity-evm-as-an-integrity-service-provider-tidy fs/sysfs/mount.c
--- a/fs/sysfs/mount.c~integrity-evm-as-an-integrity-service-provider-tidy
+++ a/fs/sysfs/mount.c
@@ -12,9 +12,6 @@
 
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
@@ -20,6 +20,7 @@
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
mm-only-free-swap-space-of-reactivated-pages-debug.patch
