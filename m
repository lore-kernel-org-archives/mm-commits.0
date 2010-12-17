From: akpm@linux-foundation.org
Subject: [merged] arch-x86-kernel-apic-io_apicc-fix-warning.patch removed from -mm tree
Date: Fri, 17 Dec 2010 14:30:10 -0800
Message-ID: <201012172233.oBHMX8tB032669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756015Ab0LQWd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Dec 2010 17:33:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/apic/io_apic.c: fix warning
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-apic-io_apicc-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/apic/io_apic.c: fix warning
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/kernel/apic/io_apic.c: In function 'ack_apic_level':
arch/x86/kernel/apic/io_apic.c:2433: warning: unused variable 'desc'

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic/io_apic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/kernel/apic/io_apic.c~arch-x86-kernel-apic-io_apicc-fix-warning arch/x86/kernel/apic/io_apic.c
--- a/arch/x86/kernel/apic/io_apic.c~arch-x86-kernel-apic-io_apicc-fix-warning
+++ a/arch/x86/kernel/apic/io_apic.c
@@ -2457,13 +2457,12 @@ static void ack_apic_level(struct irq_da
 {
 	struct irq_cfg *cfg = data->chip_data;
 	int i, do_unmask_irq = 0, irq = data->irq;
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long v;
 
 	irq_complete_move(cfg);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
+	if (unlikely(irq_to_desc(irq)->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_ioapic(cfg);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
delayacct-fix-iotop-on-x86_64-fix.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
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
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-async-pps-event-handler-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

