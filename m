From: akpm@linux-foundation.org
Subject: - media-common-ir-functionsc-make-a-function-static.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:12:58 -0800
Message-ID: <200711091912.lA9JCwu1027965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742AbXKITNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:13:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     media/common/ir-functions.c: make a function static
has been removed from the -mm tree.  Its filename was
     media-common-ir-functionsc-make-a-function-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: media/common/ir-functions.c: make a function static
From: Adrian Bunk <bunk@kernel.org>

ir_rc5_decode() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/ir-functions.c |    3 +--
 include/media/ir-common.h           |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/media/common/ir-functions.c~media-common-ir-functionsc-make-a-function-static drivers/media/common/ir-functions.c
--- a/drivers/media/common/ir-functions.c~media-common-ir-functionsc-make-a-function-static
+++ a/drivers/media/common/ir-functions.c
@@ -258,7 +258,7 @@ int ir_decode_biphase(u32 *samples, int 
  * saa7134 */
 
 /* decode raw bit pattern to RC5 code */
-u32 ir_rc5_decode(unsigned int code)
+static u32 ir_rc5_decode(unsigned int code)
 {
 	unsigned int org_code = code;
 	unsigned int pair;
@@ -371,7 +371,6 @@ EXPORT_SYMBOL_GPL(ir_dump_samples);
 EXPORT_SYMBOL_GPL(ir_decode_biphase);
 EXPORT_SYMBOL_GPL(ir_decode_pulsedistance);
 
-EXPORT_SYMBOL_GPL(ir_rc5_decode);
 EXPORT_SYMBOL_GPL(ir_rc5_timer_end);
 EXPORT_SYMBOL_GPL(ir_rc5_timer_keyup);
 
diff -puN include/media/ir-common.h~media-common-ir-functionsc-make-a-function-static include/media/ir-common.h
--- a/include/media/ir-common.h~media-common-ir-functionsc-make-a-function-static
+++ a/include/media/ir-common.h
@@ -97,7 +97,6 @@ int  ir_dump_samples(u32 *samples, int c
 int  ir_decode_biphase(u32 *samples, int count, int low, int high);
 int  ir_decode_pulsedistance(u32 *samples, int count, int low, int high);
 
-u32 ir_rc5_decode(unsigned int code);
 void ir_rc5_timer_end(unsigned long data);
 void ir_rc5_timer_keyup(unsigned long data);
 
_

Patches currently in -mm which might be from bunk@kernel.org are

lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
git-avr32.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-mtd.patch
git-net.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
git-ocfs2.patch
proper-prototype-for-kernel-schedcmigration_init.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
power_supply_ledssysfsc-should-include-power_supplyh.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
