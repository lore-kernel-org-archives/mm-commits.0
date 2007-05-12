From: akpm@linux-foundation.org
Subject: + writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch added to -mm tree
Date: Sat, 12 May 2007 01:29:04 -0700
Message-ID: <200705120829.l4C8T4Bd004781@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756881AbXELI3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 04:29:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mikew@google.com


The patch titled
     writeback: fix time ordering of the per superblock dirty inode lists 4
has been added to the -mm tree.  Its filename is
     writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: writeback: fix time ordering of the per superblock dirty inode lists 4
From: Andrew Morton <akpm@linux-foundation.org>

When the kupdate function has tried to write back an expired inode it will
then check to see whether some of the inode's pages are still dirty.

This can happen when the filesystem decided to not write a page for some
reason.  But it does _not_ occur due to redirtyings: a redirtying will set
I_DIRTY_PAGES.

What we need to do here is to set I_DIRTY_PAGES to reflect reality and to then
put the inode onto the _head_ of s_dirty for consideration on the next kupdate
pass, in five seconds time.

Problem is, the code failed to modify the inode's timestamp when pushing the
inode onto thehead of s_dirty.

The patch:

If there are no other inodes on s_dirty then we leave the inode's timestamp
alone: it is already expired.

If there _are_ other inodes on s_dirty then we arrange for this inode to get
the same timestamp as the inode which is at the head of s_dirty, thus
preserving the s_dirty ordering.  But we only need to do this if this inode
purports to have been dirtied before the one at head-of-list.

Cc: Mike Waychison <mikew@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4 fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4
+++ a/fs/fs-writeback.c
@@ -211,6 +211,28 @@ static void redirty_tail(struct inode *i
 }
 
 /*
+ * Redirty an inode, but mark it as the very next-to-be-written inode on its
+ * superblock's dirty-inode list.
+ * We need to preserve s_dirty's reverse-time-orderedness, so we cheat by
+ * setting this inode's dirtied_when to the same value as that of the inode
+ * which is presently head-of-list, if present head-of-list is newer than this
+ * inode. (head-of-list is the least-recently-dirtied inode: the oldest one).
+ */
+static void redirty_head(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	if (!list_empty(&sb->s_dirty)) {
+		struct inode *head_inode;
+
+		head_inode = list_entry(sb->s_dirty.prev, struct inode, i_list);
+		if (time_after(inode->dirtied_when, head_inode->dirtied_when))
+			inode->dirtied_when = head_inode->dirtied_when;
+	}
+	list_move_tail(&inode->i_list, &sb->s_dirty);
+}
+
+/*
  * Write a single inode's dirty pages and inode data out to disk.
  * If `wait' is set, wait on the writeout.
  *
@@ -272,7 +294,7 @@ __sync_single_inode(struct inode *inode,
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
 				check_dirty_inode(inode);
-				list_move_tail(&inode->i_list, &sb->s_dirty);
+				redirty_head(inode);
 				check_dirty_inode(inode);
 			} else {
 				/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ntfs-use-zero_user_page.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-arm.patch
git-avr32.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mips-fixup.patch
fix-race-condition-about-network-device-name-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
git-wireless-fixup.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
git-newsetup-fixup.patch
xfs-clean-up-shrinker-games.patch
remove-slab_ctor_constructor-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
crc7-support-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
check_dirty_inode_list.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
