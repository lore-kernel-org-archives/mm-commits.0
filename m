From: akpm@linux-foundation.org
Subject: - x86-e820_64c-make-2-functions-static.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:07:50 -0800
Message-ID: <200711130407.lAD47nj5025255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756656AbXKMERb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:17:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86 e820_64.c: make 2 functions static
has been removed from the -mm tree.  Its filename was
     x86-e820_64c-make-2-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86 e820_64.c: make 2 functions static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global functions static:

- e820_print_map()
- early_panic()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820_64.c |    4 ++--
 include/asm-x86/e820_64.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/e820_64.c~x86-e820_64c-make-2-functions-static arch/x86/kernel/e820_64.c
--- a/arch/x86/kernel/e820_64.c~x86-e820_64c-make-2-functions-static
+++ a/arch/x86/kernel/e820_64.c
@@ -372,7 +372,7 @@ unsigned long __init e820_hole_size(unsi
 	return end - start - (ram << PAGE_SHIFT);
 }
 
-void __init e820_print_map(char *who)
+static void __init e820_print_map(char *who)
 {
 	int i;
 
@@ -632,7 +632,7 @@ static int __init copy_e820_map(struct e
 	return 0;
 }
 
-void early_panic(char *msg)
+static void early_panic(char *msg)
 {
 	early_printk(msg);
 	panic(msg);
diff -puN include/asm-x86/e820_64.h~x86-e820_64c-make-2-functions-static include/asm-x86/e820_64.h
--- a/include/asm-x86/e820_64.h~x86-e820_64c-make-2-functions-static
+++ a/include/asm-x86/e820_64.h
@@ -24,7 +24,6 @@ extern unsigned long e820_end_of_ram(voi
 extern void e820_reserve_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
 extern void e820_mark_nosave_regions(void);
-extern void e820_print_map(char *who);
 extern int e820_any_mapped(unsigned long start, unsigned long end, unsigned type);
 extern int e820_all_mapped(unsigned long start, unsigned long end, unsigned type);
 extern unsigned long e820_hole_size(unsigned long start, unsigned long end);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
mm-hugetlbc-make-a-function-static.patch
git-avr32.patch
git-dvb.patch
remove-saa7134-oss.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-libata-all.patch
blk_dev_idecd-help-remove-outdated-note.patch
git-mtd.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
remove-references-to-net-modulestxt.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
always-export-pci_scan_single_device.patch
remove-additional-pci_scan_child_bus-prototype.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
git-x86.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
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
