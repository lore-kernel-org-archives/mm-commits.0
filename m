From: akpm@linux-foundation.org
Subject: [merged] drbd-fix-warning.patch removed from -mm tree
Date: Wed, 25 May 2011 13:33:03 -0700
Message-ID: <201105252031.p4PKVQc1015063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751885Ab1EYUcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, mm-commits@vger.kernel.org


The patch titled
     drbd: fix warning
has been removed from the -mm tree.  Its filename was
     drbd-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drbd: fix warning
From: Andrew Morton <akpm@linux-foundation.org>

In file included from drivers/block/drbd/drbd_main.c:54:                        drivers/block/drbd/drbd_int.h:1190: warning: parameter has incomplete type

Forward declarations of enums do not work.

Fix it unpleasantly by moving the prototype.

Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_int.h |    2 --
 drivers/block/drbd/drbd_req.h |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/block/drbd/drbd_int.h~drbd-fix-warning drivers/block/drbd/drbd_int.h
--- a/drivers/block/drbd/drbd_int.h~drbd-fix-warning
+++ a/drivers/block/drbd/drbd_int.h
@@ -1218,8 +1218,6 @@ extern void drbd_free_resources(struct d
 extern void tl_release(struct drbd_conf *mdev, unsigned int barrier_nr,
 		       unsigned int set_size);
 extern void tl_clear(struct drbd_conf *mdev);
-enum drbd_req_event;
-extern void tl_restart(struct drbd_conf *mdev, enum drbd_req_event what);
 extern void _tl_add_barrier(struct drbd_conf *, struct drbd_tl_epoch *);
 extern void drbd_free_sock(struct drbd_conf *mdev);
 extern int drbd_send(struct drbd_conf *mdev, struct socket *sock,
diff -puN drivers/block/drbd/drbd_req.h~drbd-fix-warning drivers/block/drbd/drbd_req.h
--- a/drivers/block/drbd/drbd_req.h~drbd-fix-warning
+++ a/drivers/block/drbd/drbd_req.h
@@ -323,6 +323,7 @@ extern int __req_mod(struct drbd_request
 extern void complete_master_bio(struct drbd_conf *mdev,
 		struct bio_and_error *m);
 extern void request_timer_fn(unsigned long data);
+extern void tl_restart(struct drbd_conf *mdev, enum drbd_req_event what);
 
 /* use this if you don't want to deal with calling complete_master_bio()
  * outside the spinlock, e.g. when walking some list on cleanup. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-m68k-merge-mmu-and-non-mmu-bitopsh.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
mtd-convert-to-seq_file-interface.patch
rfcomm-corec-avoid-dangling-pointer-check-session-exists-checkpatch-fixes.patch
drivers-bcma-host_pcic-needs-slabh.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

