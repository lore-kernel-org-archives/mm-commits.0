From: akpm@linux-foundation.org
Subject: + writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch added to -mm tree
Date: Sun, 13 May 2007 03:34:49 -0700
Message-ID: <200705131034.l4DAYnE4026842@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757336AbXEMKe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 06:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mikew@google.com


The patch titled
     writeback: fix time ordering of the per superblock dirty inode lists 7
has been added to the -mm tree.  Its filename is
     writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: writeback: fix time ordering of the per superblock dirty inode lists 7
From: Andrew Morton <akpm@linux-foundation.org>

This one fixes four bugs.

There are a few situation in there where writeback decides it is going to skip
over a blockdev inode on the kernel-internal blockdev superblock.  It
presently does this by moving the blockdev inode onto the tail of the blockdev
superblock's s_dirty. But

a) this screws up s_dirty's reverse-time-orderedness and

b) refiling the blockdev for writeback in another 30 second is rude.  We
   should try again sooner than that.

Fix all this up by using redirty_head(): move the blockdev inode onto the head
of the blockdev superblock's s_dirty list for prompt writeback.

Cc: Mike Waychison <mikew@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7 fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7
+++ a/fs/fs-writeback.c
@@ -479,7 +479,7 @@ int generic_sync_sb_inodes(struct super_
 			if (!sb_is_blkdev_sb(sb))
 				break;		/* Skip a congested fs */
 			check_dirty_inode(inode);
-			list_move(&inode->i_list, &sb->s_dirty);
+			redirty_head(inode);
 			check_dirty_inode(inode);
 			continue;		/* Skip a congested blockdev */
 		}
@@ -488,7 +488,7 @@ int generic_sync_sb_inodes(struct super_
 			if (!sb_is_blkdev_sb(sb))
 				break;		/* fs has the wrong queue */
 			check_dirty_inode(inode);
-			list_move(&inode->i_list, &sb->s_dirty);
+			redirty_head(inode);
 			check_dirty_inode(inode);
 			continue;		/* blockdev has wrong queue */
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
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
git-ubi.patch
git-ubi-fix.patch
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
git-gccbug-fixup.patch
w1-build-fix.patch
check_dirty_inode_list.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
