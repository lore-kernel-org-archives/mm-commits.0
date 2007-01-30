From: akpm@osdl.org
Subject: + ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch added to -mm tree
Date: Mon, 29 Jan 2007 17:25:38 -0800
Message-ID: <200701300125.l0U1Pc9x005550@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36759 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbXA3B3B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 20:29:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, mhalcrow@us.ibm.com


The patch titled
     fs/ecryptfs/: make code static
has been added to the -mm tree.  Its filename is
     ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/ecryptfs/: make code static
From: Adrian Bunk <bunk@stusta.de>

This patch makes some needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ecryptfs/crypto.c          |   24 ++++++++++++------------
 fs/ecryptfs/ecryptfs_kernel.h |   18 ------------------
 fs/ecryptfs/messaging.c       |   20 +++++++++++---------
 3 files changed, 23 insertions(+), 39 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static
+++ a/fs/ecryptfs/crypto.c
@@ -1024,7 +1024,7 @@ int ecryptfs_new_file_context(struct den
  *
  * Returns one if marker found; zero if not found
  */
-int contains_ecryptfs_marker(char *data)
+static int contains_ecryptfs_marker(char *data)
 {
 	u32 m_1, m_2;
 
@@ -1211,8 +1211,8 @@ int ecryptfs_cipher_code_to_string(char 
  *
  * Returns zero on success; non-zero otherwise
  */
-int ecryptfs_read_header_region(char *data, struct dentry *dentry,
-				struct vfsmount *mnt)
+static int ecryptfs_read_header_region(char *data, struct dentry *dentry,
+				       struct vfsmount *mnt)
 {
 	struct file *lower_file;
 	mm_segment_t oldfs;
@@ -1307,9 +1307,9 @@ struct kmem_cache *ecryptfs_header_cache
  *
  * Returns zero on success
  */
-int ecryptfs_write_headers_virt(char *page_virt, size_t *size,
-				struct ecryptfs_crypt_stat *crypt_stat,
-				struct dentry *ecryptfs_dentry)
+static int ecryptfs_write_headers_virt(char *page_virt, size_t *size,
+				       struct ecryptfs_crypt_stat *crypt_stat,
+				       struct dentry *ecryptfs_dentry)
 {
 	int rc;
 	size_t written;
@@ -1335,9 +1335,9 @@ int ecryptfs_write_headers_virt(char *pa
 	return rc;
 }
 
-int ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
-					struct file *lower_file,
-					char *page_virt)
+static int ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
+					       struct file *lower_file,
+					       char *page_virt)
 {
 	mm_segment_t oldfs;
 	int current_header_page;
@@ -1362,9 +1362,9 @@ int ecryptfs_write_metadata_to_contents(
 	return 0;
 }
 
-int ecryptfs_write_metadata_to_xattr(struct dentry *ecryptfs_dentry,
-				     struct ecryptfs_crypt_stat *crypt_stat,
-				     char *page_virt, size_t size)
+static int ecryptfs_write_metadata_to_xattr(struct dentry *ecryptfs_dentry,
+					    struct ecryptfs_crypt_stat *crypt_stat,
+					    char *page_virt, size_t size)
 {
 	int rc;
 
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -328,18 +328,6 @@ struct ecryptfs_msg_ctx {
 	struct mutex mux;
 };
 
-extern struct list_head ecryptfs_msg_ctx_free_list;
-extern struct list_head ecryptfs_msg_ctx_alloc_list;
-extern struct mutex ecryptfs_msg_ctx_lists_mux;
-
-#define ecryptfs_uid_hash(uid) \
-        hash_long((unsigned long)uid, ecryptfs_hash_buckets)
-extern struct hlist_head *ecryptfs_daemon_id_hash;
-extern struct mutex ecryptfs_daemon_id_hash_mux;
-extern int ecryptfs_hash_buckets;
-
-extern unsigned int ecryptfs_msg_counter;
-extern struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
 extern unsigned int ecryptfs_transport;
 
 struct ecryptfs_daemon_id {
@@ -537,15 +525,9 @@ int ecryptfs_encrypt_page(struct ecryptf
 int ecryptfs_decrypt_page(struct file *file, struct page *page);
 int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry,
 			    struct file *lower_file);
-int ecryptfs_write_headers_virt(char *page_virt, size_t *size,
-				struct ecryptfs_crypt_stat *crypt_stat,
-				struct dentry *ecryptfs_dentry);
 int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry,
 			   struct file *lower_file);
 int ecryptfs_new_file_context(struct dentry *ecryptfs_dentry);
-int contains_ecryptfs_marker(char *data);
-int ecryptfs_read_header_region(char *data, struct dentry *dentry,
-				struct vfsmount *mnt);
 int ecryptfs_read_and_validate_header_region(char *data, struct dentry *dentry,
 					     struct vfsmount *mnt);
 int ecryptfs_read_and_validate_xattr_region(char *page_virt,
diff -puN fs/ecryptfs/messaging.c~ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static
+++ a/fs/ecryptfs/messaging.c
@@ -22,16 +22,18 @@
 
 #include "ecryptfs_kernel.h"
 
-LIST_HEAD(ecryptfs_msg_ctx_free_list);
-LIST_HEAD(ecryptfs_msg_ctx_alloc_list);
-struct mutex ecryptfs_msg_ctx_lists_mux;
-
-struct hlist_head *ecryptfs_daemon_id_hash;
-struct mutex ecryptfs_daemon_id_hash_mux;
-int ecryptfs_hash_buckets;
+static LIST_HEAD(ecryptfs_msg_ctx_free_list);
+static LIST_HEAD(ecryptfs_msg_ctx_alloc_list);
+static struct mutex ecryptfs_msg_ctx_lists_mux;
+
+static struct hlist_head *ecryptfs_daemon_id_hash;
+static struct mutex ecryptfs_daemon_id_hash_mux;
+static int ecryptfs_hash_buckets;
+#define ecryptfs_uid_hash(uid) \
+        hash_long((unsigned long)uid, ecryptfs_hash_buckets)
 
-unsigned int ecryptfs_msg_counter;
-struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
+static unsigned int ecryptfs_msg_counter;
+static struct ecryptfs_msg_ctx *ecryptfs_msg_ctx_arr;
 
 /**
  * ecryptfs_acquire_free_msg_ctx
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
fs-lockd-clntlockc-add-missing-newlines-to-dprintks.patch
git-acpi.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
git-powerpc.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
drivers-media-dvb-frontends-make-4-functions-static.patch
cx88-videoc-remove-struct-radionorms.patch
git-gfs2-nmw.patch
ia64-add-pci_get_legacy_ide_irq.patch
git-ieee1394.patch
git-libata-all.patch
fix-config_sata_sis=y-compile-error.patch
mips-remove-smp_tune_scheduling.patch
git-mmc.patch
mtd_ck804xrom-must-depend-on-pci.patch
git-ubi.patch
git-netdev-all.patch
remove-one-remaining-define-bcm_tso-1.patch
net-irda-proper-prototypes.patch
net-wanrouter-wanmainc-cleanups.patch
nf_conntrack_h323-must-depend-on-ipv6-ipv6=n.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
cleanup-x86_64-mm-vmi-timer.patch
x86_64-re-add-a-newline-to-restore_context.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
cleanup-linux-byteorder-swabbh.patch
cleanup-include-linux-xattrh.patch
cleanup-include-linux-reiserfs_xattrh.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
fbdev-driver-for-s3-trio-virge-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
