From: akpm@linux-foundation.org
Subject: [obsolete] arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch removed from -mm tree
Date: Mon, 29 Nov 2010 14:12:06 -0800
Message-ID: <201011292212.oATMC6Ta014045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214Ab0K2WNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 17:13:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, heukelum@fastmail.fm, hpa@zytor.com, jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/entry_64.S: fix build with gas 2.16.1
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/entry_64.S: fix build with gas 2.16.1
From: Andrew Morton <akpm@linux-foundation.org>

arch/x86/kernel/entry_64.S: Assembler messages:
arch/x86/kernel/entry_64.S:1181: Error: too many positional arguments
arch/x86/kernel/entry_64.S:1181: Error: too many positional arguments

NFI what's happening here.

Cc: Jan Beulich <jbeulich@novell.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/entry_64.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/entry_64.S~arch-x86-kernel-entry_64s-fix-build-with-gas-2161 arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S~arch-x86-kernel-entry_64s-fix-build-with-gas-2161
+++ a/arch/x86/kernel/entry_64.S
@@ -213,13 +213,13 @@ ENDPROC(native_usergs_sysret64)
 	.macro FAKE_STACK_FRAME child_rip
 	/* push in order ss, rsp, eflags, cs, rip */
 	xorl %eax, %eax
-	pushq_cfi $__KERNEL_DS /* ss */
+	pushq $__KERNEL_DS /* ss */
 	/*CFI_REL_OFFSET	ss,0*/
 	pushq_cfi %rax /* rsp */
 	CFI_REL_OFFSET	rsp,0
 	pushq_cfi $X86_EFLAGS_IF /* eflags - interrupts on */
 	/*CFI_REL_OFFSET	rflags,0*/
-	pushq_cfi $__KERNEL_CS /* cs */
+	pushq $__KERNEL_CS /* cs */
 	/*CFI_REL_OFFSET	cs,0*/
 	pushq_cfi \child_rip /* rip */
 	CFI_REL_OFFSET	rip,0
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
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

