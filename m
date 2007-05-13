From: akpm@linux-foundation.org
Subject: + writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch added to -mm tree
Date: Sun, 13 May 2007 03:34:45 -0700
Message-ID: <200705131034.l4DAYjDc026839@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757303AbXEMKe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 06:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mikew@google.com


The patch titled
     writebackL fix time ordering of the per superblock dirty inode lists 6
has been added to the -mm tree.  Its filename is
     writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: writebackL fix time ordering of the per superblock dirty inode lists 6
From: Andrew Morton <akpm@linux-foundation.org>

Recycling the previous changelog:

  When the writeback function is operating in writeback-for-flushing mode
  (as opposed to writeback-for-integrity) and it encounters an I_LOCKed inode,
  it will skip writing that inode.  This is done for throughput and latency:
  move on to another inode rather than blocking for this one.

  Writeback skips this inode my moving it off s_io and onto s_dirty, so that
  writeback can proceed with the other inodes on s_io.

  However that inode movement can corrupt s_dirty's
  reverse-time-orderedness.  Fix that by using the new redirty_tail(), which
  will update the refiled inode's dirtied_when field.

  Note: the behaaviour in here is a bit rude: if kupdate happens to come
  across a locked inode then it will defer writeback of that inode for another
  30 seconds.  We'll address that in the next patch.

Address that here.  What we do is to move the skipped inode to the _head_ of
s_dirty, immediately eligible for writeout again.  Instead of deferring that
writeout for another 30 seconds.

One would think that this might cause a livelock: we keep on trying to write
the same locked inode.  But it won't because:

a) if that was the case, it would _already_ be happening on the
   balance_dirty_pages codepath.  Because balance_dirty_pages() doesn't care
   about inode timestamps.

b) if we skipped this inode then we won't have done any writeback.  The
   higher-level writeback paths will see that wbc.nr_to_write dodn't change
   and they'll then back off and take a nap.

Cc: Mike Waychison <mikew@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6 fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6
+++ a/fs/fs-writeback.c
@@ -366,8 +366,15 @@ __writeback_single_inode(struct inode *i
 		struct address_space *mapping = inode->i_mapping;
 		int ret;
 
+		/*
+		 * We're skipping this inode because it's locked, and we're not
+		 * doing writeback-for-data-integrity.  Move it to the head of
+		 * s_dirty so that writeback can proceed with the other inodes
+		 * on s_io.  We'll have another go at writing back this inode
+		 * when the s_dirty iodes get moved back onto s_io.
+		 */
 		check_dirty_inode(inode);
-		redirty_tail(inode);
+		redirty_head(inode);
 		check_dirty_inode(inode);
 
 		/*
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
