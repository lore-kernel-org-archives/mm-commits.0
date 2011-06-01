From: akpm@linux-foundation.org
Subject: [folded] writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch removed from -mm tree
Date: Wed, 01 Jun 2011 15:27:29 -0700
Message-ID: <201106012227.p51MRTL6013382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500Ab1FAW2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 18:28:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Trond.Myklebust@netapp.com, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, hch@lst.de, hughd@google.com, jack@suse.cz, kitayama@cl.bb4u.ne.jp


The patch titled
     writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch

This patch was dropped because it was folded into writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

repair crappy comment while we're there

Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mel Gorman <mel@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/block_dev.c~writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix fs/block_dev.c
--- a/fs/block_dev.c~writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix
+++ a/fs/block_dev.c
@@ -44,13 +44,12 @@ inline struct block_device *I_BDEV(struc
 {
 	return &BDEV_I(inode)->bdev;
 }
-
 EXPORT_SYMBOL(I_BDEV);
 
 /*
- * move the inode from it's current bdi to the a new bdi. if the inode is dirty
- * we need to move it onto the dirty list of @dst so that the inode is always
- * on the right list.
+ * Move the inode from its current bdi to a new bdi. If the inode is dirty we
+ * need to move it onto the dirty list of @dst so that the inode is always on the
+ * right list.
  */
 static void bdev_inode_switch_bdi(struct inode *inode,
 			struct backing_dev_info *dst)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

