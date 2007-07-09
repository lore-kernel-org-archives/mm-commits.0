From: akpm@linux-foundation.org
Subject: - mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:52:49 -0700
Message-ID: <200707092352.l69NqnYw021605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760026AbXGIXxF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, kernel@kolivas.org, mm-commits@vger.kernel.org


The patch titled
     make mm/swap_prefetch.c:remove_from_swapped_list() static
has been removed from the -mm tree.  Its filename was
     mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch

This patch was dropped because it was folded into mm-implement-swap-prefetching.patch

------------------------------------------------------
Subject: make mm/swap_prefetch.c:remove_from_swapped_list() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap-prefetch.h |    5 -----
 mm/swap_prefetch.c            |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN include/linux/swap-prefetch.h~mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list include/linux/swap-prefetch.h
--- a/include/linux/swap-prefetch.h~mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list
+++ a/include/linux/swap-prefetch.h
@@ -30,7 +30,6 @@ static inline int get_swap_entry_node(st
 }
 
 extern void add_to_swapped_list(struct page *page);
-extern void remove_from_swapped_list(const unsigned long index);
 extern void delay_swap_prefetch(void);
 extern void prepare_swap_prefetch(void);
 
@@ -43,10 +42,6 @@ static inline void prepare_swap_prefetch
 {
 }
 
-static inline void remove_from_swapped_list(const unsigned long __unused)
-{
-}
-
 static inline void delay_swap_prefetch(void)
 {
 }
diff -puN mm/swap_prefetch.c~mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list mm/swap_prefetch.c
--- a/mm/swap_prefetch.c~mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list
+++ a/mm/swap_prefetch.c
@@ -128,7 +128,7 @@ out_locked:
  * look up the entry from the index without having to iterate over the whole
  * list.
  */
-void remove_from_swapped_list(const unsigned long index)
+static void remove_from_swapped_list(const unsigned long index)
 {
 	struct swapped_entry *entry;
 	unsigned long flags;
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-md-accel.patch
git-mmc.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
bonding-bond_mainc-make-2-functions-static.patch
net-make-struct-dccp_li_cachep-static.patch
git-battery.patch
git-selinux.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
remove-the-dead-cyberstormiii_scsi-option.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-xen-xen-event-channels.patch
arch-i386-xen-mmuc-must-include-linux-schedh.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
xen-cant-support-numa-yet.patch
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=-generic.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
mm-slubc-make-code-static.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
more-scheduled-oss-driver-removal.patch
init-wait-for-asynchronously-scanned-block-devices.patch
kernel-utf-8-handling.patch
remove-sonypi_camera_command.patch
fs-namespacec-should-include-internalh.patch
proper-prototype-for-proc_nr_files.patch
fs-reiserfs-cleanups.patch
remove-mm-backing-devccongestion_wait_interruptible.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
fbdev-move-arch-specific-bits-to-their-respective.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
intel-iommu-intel-iommu-driver.patch
mm-variable-length-argument-support.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
kernel-relayc-make-functions-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
