From: akpm@linux-foundation.org
Subject: - fix-modules-oopsing-in-lguest-guests.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:42:48 -0700
Message-ID: <200709270142.l8R1gmuA013902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbXI0Bmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:42:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     fix modules oopsing in lguest guests
has been removed from the -mm tree.  Its filename was
     fix-modules-oopsing-in-lguest-guests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix modules oopsing in lguest guests
From: Rusty Russell <rusty@rustcorp.com.au>

The assembly templates for lguest guest patching are in the .init.text
section.  This means that modules get patched with "cc cc cc cc" or similar
junk.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest_asm.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/lguest/lguest_asm.S~fix-modules-oopsing-in-lguest-guests drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S~fix-modules-oopsing-in-lguest-guests
+++ a/drivers/lguest/lguest_asm.S
@@ -22,8 +22,9 @@
 	jmp lguest_init
 
 /*G:055 We create a macro which puts the assembler code between lgstart_ and
- * lgend_ markers.  These templates end up in the .init.text section, so they
- * are discarded after boot. */
+ * lgend_ markers.  These templates are put in the .text section: they can't be
+ * discarded after boot as we may need to patch modules, too. */
+.text
 #define LGUEST_PATCH(name, insns...)			\
 	lgstart_##name:	insns; lgend_##name:;		\
 	.globl lgstart_##name; .globl lgend_##name
@@ -34,7 +35,6 @@ LGUEST_PATCH(popf, movl %eax, lguest_dat
 LGUEST_PATCH(pushf, movl lguest_data+LGUEST_DATA_irq_enabled, %eax)
 /*:*/
 
-.text
 /* These demark the EIP range where host should never deliver interrupts. */
 .global lguest_noirq_start
 .global lguest_noirq_end
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kbuild.patch
git-kvm.patch
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
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
move-kasprintfo-to-obj-y.patch
delay-creation-of-khcvd-thread.patch
hvc-console-is-also-used-by-iseries-so-add-that-to-hvc_driver-help.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
