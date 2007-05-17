From: akpm@linux-foundation.org
Subject: - ext3-add-first-fit-inode-allocator.patch removed from -mm tree
Date: Thu, 17 May 2007 00:08:51 -0700
Message-ID: <200705170708.l4H78ruP019468@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755570AbXEQHJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 03:09:33 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l4H7B3gO030486
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 17 May 2007 00:11:39 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     ext3-add-first-fit-inode-allocator
has been removed from the -mm tree.  Its filename was
     ext3-add-first-fit-inode-allocator.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: ext3-add-first-fit-inode-allocator
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/ialloc.c        |   45 +++++++++++++++++++++++++++++++++++++-
 fs/ext3/super.c         |    5 ++++
 include/linux/ext3_fs.h |    1 
 3 files changed, 50 insertions(+), 1 deletion(-)

diff -puN fs/ext3/ialloc.c~ext3-add-first-fit-inode-allocator fs/ext3/ialloc.c
--- a/fs/ext3/ialloc.c~ext3-add-first-fit-inode-allocator
+++ a/fs/ext3/ialloc.c
@@ -411,6 +411,47 @@ static int find_group_other(struct super
 	return -1;
 }
 
+static int find_group_first_fit(struct super_block *sb, struct inode *parent)
+{
+	int parent_group = EXT3_I(parent)->i_block_group;
+	int ngroups = EXT3_SB(sb)->s_groups_count;
+	struct ext3_group_desc *desc;
+	struct buffer_head *bh;
+	int group, i;
+
+	/*
+	 * Try to place the inode in its parent directory
+	 */
+	group = parent_group;
+	desc = ext3_get_group_desc(sb, group, &bh);
+	if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
+			le16_to_cpu(desc->bg_free_blocks_count))
+		return group;
+
+	for (i = 0; i < ngroups; i++) {
+		if (++group >= ngroups)
+			group = 0;
+		desc = ext3_get_group_desc(sb, group, &bh);
+		if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
+				le16_to_cpu(desc->bg_free_blocks_count))
+			return group;
+	}
+
+	/*
+	 * That failed: try linear search for a free inode, even if that group
+	 * has no free blocks.
+	 */
+	group = parent_group;
+	for (i = 0; i < ngroups; i++) {
+		if (++group >= ngroups)
+			group = 0;
+		desc = ext3_get_group_desc(sb, group, &bh);
+		if (desc && le16_to_cpu(desc->bg_free_inodes_count))
+			return group;
+	}
+	return -1;
+}
+
 /*
  * There are two policies for allocating an inode.  If the new inode is
  * a directory, then a forward search is made for a block group with both
@@ -449,7 +490,9 @@ struct inode *ext3_new_inode(handle_t *h
 
 	sbi = EXT3_SB(sb);
 	es = sbi->s_es;
-	if (S_ISDIR(mode)) {
+	if (test_opt(sb, FIRSTFIT)) {
+		group = find_group_first_fit(sb, dir);
+	} else if (S_ISDIR(mode)) {
 		if (test_opt (sb, OLDALLOC))
 			group = find_group_dir(sb, dir);
 		else
diff -puN fs/ext3/super.c~ext3-add-first-fit-inode-allocator fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-add-first-fit-inode-allocator
+++ a/fs/ext3/super.c
@@ -667,6 +667,7 @@ enum {
 	Opt_bsd_df, Opt_minix_df, Opt_grpid, Opt_nogrpid,
 	Opt_resgid, Opt_resuid, Opt_sb, Opt_err_cont, Opt_err_panic, Opt_err_ro,
 	Opt_nouid32, Opt_nocheck, Opt_debug, Opt_oldalloc, Opt_orlov,
+	Opt_firstfit,
 	Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
 	Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
 	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
@@ -696,6 +697,7 @@ static match_table_t tokens = {
 	{Opt_debug, "debug"},
 	{Opt_oldalloc, "oldalloc"},
 	{Opt_orlov, "orlov"},
+	{Opt_firstfit, "firstfit"},
 	{Opt_user_xattr, "user_xattr"},
 	{Opt_nouser_xattr, "nouser_xattr"},
 	{Opt_acl, "acl"},
@@ -829,6 +831,9 @@ static int parse_options (char *options,
 		case Opt_orlov:
 			clear_opt (sbi->s_mount_opt, OLDALLOC);
 			break;
+		case Opt_firstfit:
+			set_opt(sbi->s_mount_opt, FIRSTFIT);
+			break;
 #ifdef CONFIG_EXT3_FS_XATTR
 		case Opt_user_xattr:
 			set_opt (sbi->s_mount_opt, XATTR_USER);
diff -puN include/linux/ext3_fs.h~ext3-add-first-fit-inode-allocator include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~ext3-add-first-fit-inode-allocator
+++ a/include/linux/ext3_fs.h
@@ -384,6 +384,7 @@ struct ext3_inode {
 #define EXT3_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT3_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
+#define EXT3_MOUNT_FIRSTFIT		0x400000 /* first-fit inode allocator */
 
 /* Compatibility, for having both ext2_fs.h and ext3_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-fix-handling-of-oversized-slabs.patch
parport_pc-needs-dma-mappingh.patch
let-smp_call_function_single-return-ebusy-on-up.patch
ext3-add-first-fit-inode-allocator.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
fix-agk-dm-dm-io-fix-panic-on-large-request.patch
8xx-mpc885ads-pcmcia-support-fix.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
git-dvb.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver-fix.patch
ide-warning-fixes.patch
git-mips-fixup.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
git-ubi.patch
git-battery.patch
git-battery-warning-fix.patch
ds2760_battery-warning-fix.patch
git-nfs.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-fix-machine-rebooting-fix.patch
xfs-clean-up-shrinker-games.patch
pci-x-pci-express-read-control-interfaces-fix.patch
compat_core_sys_select-avoid-kmalloc0.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
reiser4.patch
reiser4-fix.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
check_dirty_inode_list.patch
git-gccbug-fixup.patch
w1-build-fix.patch
