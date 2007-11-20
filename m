From: akpm@linux-foundation.org
Subject: + m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch added to -mm tree
Date: Mon, 19 Nov 2007 18:15:09 -0800
Message-ID: <200711200215.lAK2F9lK008964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762166AbXKTCPg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 21:15:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     m68k: kill arch/m68k/mvme16x/mvme16x_ksyms.c
has been added to the -mm tree.  Its filename is
     m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: kill arch/m68k/mvme16x/mvme16x_ksyms.c
From: Adrian Bunk <bunk@kernel.org>

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mvme16x/Makefile        |    2 +-
 arch/m68k/mvme16x/config.c        |    2 ++
 arch/m68k/mvme16x/mvme16x_ksyms.c |    6 ------
 3 files changed, 3 insertions(+), 7 deletions(-)

diff -puN arch/m68k/mvme16x/Makefile~m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc arch/m68k/mvme16x/Makefile
--- a/arch/m68k/mvme16x/Makefile~m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc
+++ a/arch/m68k/mvme16x/Makefile
@@ -2,4 +2,4 @@
 # Makefile for Linux arch/m68k/mvme16x source directory
 #
 
-obj-y		:= config.o rtc.o mvme16x_ksyms.o
+obj-y		:= config.o rtc.o
diff -puN arch/m68k/mvme16x/config.c~m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc arch/m68k/mvme16x/config.c
--- a/arch/m68k/mvme16x/config.c~m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc
+++ a/arch/m68k/mvme16x/config.c
@@ -25,6 +25,7 @@
 #include <linux/genhd.h>
 #include <linux/rtc.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 
 #include <asm/bootinfo.h>
 #include <asm/system.h>
@@ -58,6 +59,7 @@ static irq_handler_t tick_handler;
 
 
 unsigned short mvme16x_config;
+EXPORT_SYMBOL(mvme16x_config);
 
 
 int mvme16x_parse_bootinfo(const struct bi_record *bi)
diff -puN arch/m68k/mvme16x/mvme16x_ksyms.c~m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc /dev/null
--- a/arch/m68k/mvme16x/mvme16x_ksyms.c
+++ /dev/null
@@ -1,6 +0,0 @@
-#include <linux/module.h>
-#include <linux/types.h>
-#include <asm/ptrace.h>
-#include <asm/mvme16xhw.h>
-
-EXPORT_SYMBOL(mvme16x_config);
_

Patches currently in -mm which might be from bunk@kernel.org are

m68k-export-atari_keyb_init.patch
git-avr32.patch
git-dvb.patch
remove-saa7134-oss.patch
git-gfs2-nmw.patch
git-libata-all.patch
git-mtd.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
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
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
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
