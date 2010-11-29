From: akpm@linux-foundation.org
Subject: [merged] arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:51:35 -0800
Message-ID: <201011291952.oATJq4ZT007359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684Ab0K2T5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:57:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, feng.tang@intel.com, hpa@zytor.com, mingo@redhat.com, randy.dunlap@oracle.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/include/asm/fixmap.h: mark __set_fixmap_offset as __always_inline
has been removed from the -mm tree.  Its filename was
     arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/include/asm/fixmap.h: mark __set_fixmap_offset as __always_inline
From: Andrew Morton <akpm@linux-foundation.org>

When compiling arch/x86/kernel/early_printk_mrst.c with i386 allmodconfig,
gcc-4.1.0 generates an out-of-line copy of __set_fixmap_offset() which
contains a reference to __this_fixmap_does_not_exist which the compiler cannot
elide.

Marking __set_fixmap_offset() as __always_inline prevents this.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Feng Tang <feng.tang@intel.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/fixmap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/include/asm/fixmap.h~arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline arch/x86/include/asm/fixmap.h
--- a/arch/x86/include/asm/fixmap.h~arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline
+++ a/arch/x86/include/asm/fixmap.h
@@ -216,8 +216,8 @@ static inline unsigned long virt_to_fix(
 }
 
 /* Return an pointer with offset calculated */
-static inline unsigned long __set_fixmap_offset(enum fixed_addresses idx,
-				phys_addr_t phys, pgprot_t flags)
+static __always_inline unsigned long
+__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
 {
 	__set_fixmap(idx, phys, flags);
 	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

