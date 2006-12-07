From: akpm@osdl.org
Subject: - proper-prototype-for-remove_inode_dquot_ref.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:15:57 -0800
Message-ID: <200612072315.kB7NFv94030766@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54089 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163961AbWLGXTO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:19:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     proper prototype for remove_inode_dquot_ref()
has been removed from the -mm tree.  Its filename was
     proper-prototype-for-remove_inode_dquot_ref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: proper prototype for remove_inode_dquot_ref()
From: Adrian Bunk <bunk@stusta.de>

Add a proper prototype for remove_inode_dquot_ref() in
include/linux/quotaops.h

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/inode.c               |    3 ---
 include/linux/quotaops.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/inode.c~proper-prototype-for-remove_inode_dquot_ref fs/inode.c
--- a/fs/inode.c~proper-prototype-for-remove_inode_dquot_ref
+++ a/fs/inode.c
@@ -1242,9 +1242,6 @@ EXPORT_SYMBOL(inode_needs_sync);
  */
 #ifdef CONFIG_QUOTA
 
-/* Function back in dquot.c */
-int remove_inode_dquot_ref(struct inode *, int, struct list_head *);
-
 void remove_dquot_ref(struct super_block *sb, int type,
 			struct list_head *tofree_head)
 {
diff -puN include/linux/quotaops.h~proper-prototype-for-remove_inode_dquot_ref include/linux/quotaops.h
--- a/include/linux/quotaops.h~proper-prototype-for-remove_inode_dquot_ref
+++ a/include/linux/quotaops.h
@@ -37,6 +37,9 @@ extern int dquot_release(struct dquot *d
 extern int dquot_commit_info(struct super_block *sb, int type);
 extern int dquot_mark_dquot_dirty(struct dquot *dquot);
 
+int remove_inode_dquot_ref(struct inode *inode, int type,
+			   struct list_head *tofree_head);
+
 extern int vfs_quota_on(struct super_block *sb, int type, int format_id, char *path);
 extern int vfs_quota_on_mount(struct super_block *sb, char *qf_name,
 		int format_id, int type);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

