From: akpm@linux-foundation.org
Subject: - i386-call-free_init_pages-with-irqs-enabled-in-alternative_instructions.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:33 -0700
Message-ID: <200710051958.l95JwXYt022554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49554 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763589AbXJEUB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, Laurent.Vivier@bull.net, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: call free_init_pages() with irqs enabled in alternative_instructions()
has been removed from the -mm tree.  Its filename was
     i386-call-free_init_pages-with-irqs-enabled-in-alternative_instructions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: call free_init_pages() with irqs enabled in alternative_instructions()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

It fixes the warning message in smp_call_function*(), which should be called
with irqs disabled.

[    0.310000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.310000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.310000] CPU 0/0 -> Node 0
[    0.310000] SMP alternatives: switching to UP code
[    0.310000] Freeing SMP alternatives: 25k freed
[    0.310000] WARNING: at arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
[    0.310000]
[    0.310000] Call Trace:
[    0.310000]  [<ffffffff8100dbde>] dump_trace+0x3ee/0x4a0
[    0.310000]  [<ffffffff8100dcd3>] show_trace+0x43/0x70
[    0.310000]  [<ffffffff8100dd15>] dump_stack+0x15/0x20
[    0.310000]  [<ffffffff8101cd44>] smp_call_function_mask+0x94/0xa0
[    0.310000]  [<ffffffff8101d0b2>] smp_call_function+0x32/0x40
[    0.310000]  [<ffffffff8104277f>] on_each_cpu+0x1f/0x50
[    0.310000]  [<ffffffff81026eac>] global_flush_tlb+0x8c/0x110
[    0.310000]  [<ffffffff81025c85>] free_init_pages+0xe5/0xf0
[    0.310000]  [<ffffffff81549b5e>] alternative_instructions+0x7e/0x150
[    0.310000]  [<ffffffff8154a2ea>] check_bugs+0x1a/0x20
[    0.310000]  [<ffffffff81540c4a>] start_kernel+0x2da/0x380
[    0.310000]  [<ffffffff81540132>] _sinittext+0x132/0x140
[    0.310000]
[    0.320000] ACPI: Core revision 20070126
[    0.560000] Using local APIC timer interrupts.
[    0.590000] Detected 62.496 MHz APIC timer.
[    0.590000] Brought up 1 CPUs

Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/i386/kernel/alternative.c~i386-call-free_init_pages-with-irqs-enabled-in-alternative_instructions arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~i386-call-free_init_pages-with-irqs-enabled-in-alternative_instructions
+++ a/arch/i386/kernel/alternative.c
@@ -435,9 +435,6 @@ void __init alternative_instructions(voi
 			alternatives_smp_unlock(__smp_locks, __smp_locks_end,
 						_text, _etext);
 		}
-		free_init_pages("SMP alternatives",
-				(unsigned long)__smp_locks,
-				(unsigned long)__smp_locks_end);
 	} else {
 		alternatives_smp_module_add(NULL, "core kernel",
 					    __smp_locks, __smp_locks_end,
@@ -448,6 +445,11 @@ void __init alternative_instructions(voi
  	apply_paravirt(__parainstructions, __parainstructions_end);
 	local_irq_restore(flags);
 
+	if (smp_alt_once)
+		free_init_pages("SMP alternatives",
+				(unsigned long)__smp_locks,
+				(unsigned long)__smp_locks_end);
+
 	restart_nmi();
 #ifdef CONFIG_X86_MCE
 	restart_mce();
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
make-swappiness-safer-to-use.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
convert-ill-defined-log2-to-ilog2.patch
seqfile-merge-duplite-code-to-seq_open_private.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-fix-ntfs-with-sb_has_dirty_inodes.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page.patch
writeback-introduce-writeback_controlmore_io-to-indicate-more-io.patch
writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch
