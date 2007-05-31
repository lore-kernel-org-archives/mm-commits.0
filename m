From: akpm@linux-foundation.org
Subject: + serial-convert-early_uart-to-earlycon-for-8250-fix-2.patch added to -mm tree
Date: Wed, 30 May 2007 18:37:17 -0700
Message-ID: <200705310140.l4V1efK0009804@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbXEaBkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 21:40:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, hpa@zytor.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM


The patch titled
     serial-convert-early_uart-to-earlycon-for-8250-fix-2
has been added to the -mm tree.  Its filename is
     serial-convert-early_uart-to-earlycon-for-8250-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial-convert-early_uart-to-earlycon-for-8250-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

I ended up fixing it instead.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Gerd Hoffmann <kraxel@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/ioremap.c   |   11 +++++++++++
 arch/x86_64/mm/ioremap.c |   11 +++++++++++
 include/asm-i386/io.h    |   14 +-------------
 include/asm-x86_64/io.h  |   14 +-------------
 4 files changed, 24 insertions(+), 26 deletions(-)

diff -puN arch/i386/mm/ioremap.c~serial-convert-early_uart-to-earlycon-for-8250-fix-2 arch/i386/mm/ioremap.c
--- a/arch/i386/mm/ioremap.c~serial-convert-early_uart-to-earlycon-for-8250-fix-2
+++ a/arch/i386/mm/ioremap.c
@@ -94,6 +94,17 @@ void __iomem * __ioremap(unsigned long p
 }
 EXPORT_SYMBOL(__ioremap);
 
+void __iomem *fix_ioremap(unsigned idx, unsigned long phys)
+{
+	void __iomem * vaddr;
+	set_fixmap_nocache(idx, phys & PAGE_MASK);
+	vaddr = (void __iomem *)__fix_to_virt(idx);
+	vaddr += phys & ~PAGE_MASK;
+
+	return vaddr;
+}
+EXPORT_SYMBOL(fix_ioremap);
+
 /**
  * ioremap_nocache     -   map bus memory into CPU space
  * @offset:    bus address of the memory
diff -puN arch/x86_64/mm/ioremap.c~serial-convert-early_uart-to-earlycon-for-8250-fix-2 arch/x86_64/mm/ioremap.c
--- a/arch/x86_64/mm/ioremap.c~serial-convert-early_uart-to-earlycon-for-8250-fix-2
+++ a/arch/x86_64/mm/ioremap.c
@@ -134,6 +134,17 @@ void __iomem * __ioremap(unsigned long p
 }
 EXPORT_SYMBOL(__ioremap);
 
+void __iomem *fix_ioremap(unsigned idx, unsigned long phys)
+{
+	void __iomem * vaddr;
+	set_fixmap_nocache(idx, phys & PAGE_MASK);
+	vaddr = (void __iomem *)__fix_to_virt(idx);
+	vaddr += phys & ~PAGE_MASK;
+
+	return vaddr;
+}
+EXPORT_SYMBOL(fix_ioremap);
+
 /**
  * ioremap_nocache     -   map bus memory into CPU space
  * @offset:    bus address of the memory
diff -puN include/asm-i386/io.h~serial-convert-early_uart-to-earlycon-for-8250-fix-2 include/asm-i386/io.h
--- a/include/asm-i386/io.h~serial-convert-early_uart-to-earlycon-for-8250-fix-2
+++ a/include/asm-i386/io.h
@@ -129,19 +129,7 @@ extern void iounmap(volatile void __iome
  */
 extern void *bt_ioremap(unsigned long offset, unsigned long size);
 extern void bt_iounmap(void *addr, unsigned long size);
-
-#include <asm/pgtable.h>
-#include <asm/fixmap.h>
-
-static inline void __iomem * fix_ioremap (unsigned idx, unsigned long phys)
-{
-	void __iomem * vaddr;
-	set_fixmap_nocache(idx, phys & PAGE_MASK);
-	vaddr = (void __iomem *)__fix_to_virt(idx);
-	vaddr += phys & ~PAGE_MASK;
-
-	return vaddr;
-}
+extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
 /* Use early IO mappings for DMI because it's initialized early */
 #define dmi_ioremap bt_ioremap
diff -puN include/asm-x86_64/io.h~serial-convert-early_uart-to-earlycon-for-8250-fix-2 include/asm-x86_64/io.h
--- a/include/asm-x86_64/io.h~serial-convert-early_uart-to-earlycon-for-8250-fix-2
+++ a/include/asm-x86_64/io.h
@@ -144,19 +144,7 @@ extern void early_iounmap(void *addr, un
  */
 extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
 extern void iounmap(volatile void __iomem *addr);
-
-#include <asm/pgtable.h>
-#include <asm/fixmap.h>
-
-static inline void __iomem * fix_ioremap (unsigned idx, unsigned long phys)
-{
-	void __iomem * vaddr;
-	set_fixmap_nocache(idx, phys & PAGE_MASK);
-	vaddr = (void __iomem *)__fix_to_virt(idx);
-	vaddr += phys & ~PAGE_MASK;
-
-	return vaddr;
-}
+extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
 /*
  * ISA I/O bus memory addresses are 1:1 with the physical address.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-more-documentation-fix.patch
ntfs_init_locked_inode-fix-array-indexing.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-avr32.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
git-mips-fixup.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
serial-convert-early_uart-to-earlycon-for-8250-fix-2.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
sh-support-older-gccs.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
git-xfs.patch
git-cryptodev.patch
fix-possible-leakage-of-blocks-in-udf-tidy.patch
potential-parse-error-in-ifdef.patch
potential-parse-error-in-ifdef-fix.patch
potential-parse-error-in-ifdef-update.patch
aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
nick-broke-stuff.patch
nick-broke-more-stuff.patch
nick-broke-even-more-stuff.patch
nick-really-did-it-this-time.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix-2.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
reiser4.patch
reiser4-fix.patch
nick-broke-reiser4-too.patch
check_dirty_inode_list.patch
w1-build-fix.patch
