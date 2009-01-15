From: akpm@linux-foundation.org
Subject: [merged] kernel-upc-omit-it-if-smp=y-use_generic_smp_helpers=n.patch removed from -mm tree
Date: Thu, 15 Jan 2009 11:57:34 -0800
Message-ID: <200901151957.n0FJvYmS007527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753893AbZAOT61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 14:58:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, mingo@elte.hu, reif@earthlink.net, mm-commits@vger.kernel.org


The patch titled
     kernel/up.c: omit it if SMP=y, USE_GENERIC_SMP_HELPERS=n
has been removed from the -mm tree.  Its filename was
     kernel-upc-omit-it-if-smp=y-use_generic_smp_helpers=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/up.c: omit it if SMP=y, USE_GENERIC_SMP_HELPERS=n
From: Andrew Morton <akpm@linux-foundation.org>

Fix the sparc build - we were including `up.o' on SMP builds, when
CONFIG_USE_GENERIC_SMP_HELPERS=n.

Tested-by: Robert Reif <reif@earthlink.net>
Fixed-by: Robert Reif <reif@earthlink.net>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/Makefile~kernel-upc-omit-it-if-smp=y-use_generic_smp_helpers=n kernel/Makefile
--- a/kernel/Makefile~kernel-upc-omit-it-if-smp=y-use_generic_smp_helpers=n
+++ a/kernel/Makefile
@@ -40,9 +40,8 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
-ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
-obj-y += smp.o
-else
+obj-$(CONFIG_USE_GENERIC_SMP_HELPERS) += smp.o
+ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
 obj-$(CONFIG_SMP) += spinlock.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
alpha-fix-vmalloc-breakage-fix.patch
revert-mm-vmalloc-use-mutex-for-purge.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch
hp_accel-do-not-call-acpi-from-invalid-context-fix.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-ia64-kernel-ia64_ksymsc-dont-export-copy_page-twice.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-ata-pata_alic-s-isa_bridge-ali_isa_bridge-to-fix-alpha-build.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

