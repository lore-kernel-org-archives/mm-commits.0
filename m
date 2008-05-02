From: akpm@linux-foundation.org
Subject: - x86-ioremap-add-checks-for-virtual-addresses-fix.patch removed from -mm tree
Date: Fri, 02 May 2008 12:41:32 -0700
Message-ID: <200805021941.m42JfWHe011097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762285AbYEBTmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, clameter@sgi.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86-ioremap-add-checks-for-virtual-addresses-fix
has been removed from the -mm tree.  Its filename was
     x86-ioremap-add-checks-for-virtual-addresses-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-ioremap-add-checks-for-virtual-addresses-fix
From: Andrew Morton <akpm@linux-foundation.org>

- I've been bitten by impulsively-added BUG_ONs way too often.  Use
  WARN_ON_ONCE()

- Add missing include.

Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c     |    2 +-
 include/asm-x86/page_32.h |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/ioremap.c~x86-ioremap-add-checks-for-virtual-addresses-fix arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-ioremap-add-checks-for-virtual-addresses-fix
+++ a/arch/x86/mm/ioremap.c
@@ -25,7 +25,7 @@
 
 unsigned long __phys_addr(unsigned long x)
 {
-	VM_BUG_ON(is_vmalloc_addr((void *)x));
+	WARN_ON_ONCE(is_vmalloc_addr((void *)x));
 	if (x >= __START_KERNEL_map)
 		return x - __START_KERNEL_map + phys_base;
 	return x - PAGE_OFFSET;
diff -puN include/asm-x86/page_32.h~x86-ioremap-add-checks-for-virtual-addresses-fix include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h~x86-ioremap-add-checks-for-virtual-addresses-fix
+++ a/include/asm-x86/page_32.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_PAGE_32_H
 #define _ASM_X86_PAGE_32_H
 
+#include <linux/bug.h>
+
 /*
  * This handles the memory map.
  *
@@ -66,7 +68,7 @@ typedef struct page *pgtable_t;
 #ifndef __ASSEMBLY__
 static inline unsigned long __phys_addr(unsigned long x)
 {
-	VM_BUG_ON(is_vmalloc_addr((void *)x));
+	WARN_ON_ONCE(is_vmalloc_addr((void *)x));
 	return x - PAGE_OFFSET;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix-checkpatch-fixes.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

