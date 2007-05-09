From: akpm@linux-foundation.org
Subject: - make-remove_inode_dquot_ref-static.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:42 -0700
Message-ID: <200705090247.l492lgxc009006@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934738AbXEICry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:47:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     make remove_inode_dquot_ref() static
has been removed from the -mm tree.  Its filename was
     make-remove_inode_dquot_ref-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make remove_inode_dquot_ref() static
From: Adrian Bunk <bunk@stusta.de>

remove_inode_dquot_ref() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c               |    3 ++-
 include/linux/quotaops.h |    3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/dquot.c~make-remove_inode_dquot_ref-static fs/dquot.c
--- a/fs/dquot.c~make-remove_inode_dquot_ref-static
+++ a/fs/dquot.c
@@ -721,7 +721,8 @@ static inline int dqput_blocks(struct dq
 
 /* Remove references to dquots from inode - add dquot to list for freeing if needed */
 /* We can't race with anybody because we hold dqptr_sem for writing... */
-int remove_inode_dquot_ref(struct inode *inode, int type, struct list_head *tofree_head)
+static int remove_inode_dquot_ref(struct inode *inode, int type,
+				  struct list_head *tofree_head)
 {
 	struct dquot *dquot = inode->i_dquot[type];
 
diff -puN include/linux/quotaops.h~make-remove_inode_dquot_ref-static include/linux/quotaops.h
--- a/include/linux/quotaops.h~make-remove_inode_dquot_ref-static
+++ a/include/linux/quotaops.h
@@ -37,9 +37,6 @@ extern int dquot_release(struct dquot *d
 extern int dquot_commit_info(struct super_block *sb, int type);
 extern int dquot_mark_dquot_dirty(struct dquot *dquot);
 
-int remove_inode_dquot_ref(struct inode *inode, int type,
-			   struct list_head *tofree_head);
-
 extern int vfs_quota_on(struct super_block *sb, int type, int format_id, char *path);
 extern int vfs_quota_on_mount(struct super_block *sb, char *qf_name,
 		int format_id, int type);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-dvb.patch
git-ieee1394.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
ibmtr_cs-fix-hang-on-eject.patch
git-battery.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
unexport-pci_proc_attach_device.patch
ext2-reservations.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
compiler-introduce-__used-and-__maybe_unused.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
