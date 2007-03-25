From: akpm@linux-foundation.org
Subject: + make-remove_inode_dquot_ref-static.patch added to -mm tree
Date: Sun, 25 Mar 2007 14:27:31 -0800
Message-ID: <200703252227.l2PMRVbc004185@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32915 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbXCYWau (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 18:30:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, jack@suse.cz


The patch titled
     make remove_inode_dquot_ref() static
has been added to the -mm tree.  Its filename is
     make-remove_inode_dquot_ref-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-spi-fix-section-mismatches.patch
dynticks-fix-hrtimer-rounding-error-in.patch
clocksource-fix-thinko-in-watchdog-selection.patch
drivers-eisa-pci_eisacpci_eisa_init-should-be-init.patch
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
make-struct-v9fs_cached_file_operations-static.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages-tidy.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
make-mptspi_target_destroy-static.patch
make-remove_inode_dquot_ref-static.patch
remove-nfs4_acl_add_ace.patch
