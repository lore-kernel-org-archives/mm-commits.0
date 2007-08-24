From: akpm@linux-foundation.org
Subject: + enforce-noreplace-smp-in-alternative_instructions.patch added to -mm tree
Date: Fri, 24 Aug 2007 14:23:54 -0700
Message-ID: <200708242123.l7OLNtXn015384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756034AbXHXVYM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:24:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, ak@suse.de, frederik.deweerdt@gmail.com, jeremy@goop.org, rusty@rustcorp.com.au


The patch titled
     enforce noreplace-smp in alternative_instructions()
has been added to the -mm tree.  Its filename is
     enforce-noreplace-smp-in-alternative_instructions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: enforce noreplace-smp in alternative_instructions()
From: Frederik Deweerdt <deweerdt@free.fr>

arch/i386/kernel/alternative.c:alternative_instructions() doesn't
check for noreplace-smp before setting capability bits and freeing the
__smp_locks section.

Every call to alternatives_smp_unlock() checks for noreplace-smp
beforehand, so remove the check from there.

Without this patch, lguest crashes with

[    0.131000] SMP alternatives: switching to UP code
lguest: bad stack page 0xc057a000

I added a dump_stack on the Host, which gives:
[124320.090946]  [<c01052f8>] dump_trace+0x65/0x1de
[124320.090956]  [<c010548b>] show_trace_log_lvl+0x1a/0x2f
[124320.090970]  [<c0105ea4>] show_trace+0x12/0x14
[124320.090975]  [<c0105fcd>] dump_stack+0x16/0x18
[124320.090980]  [<f888032c>] pin_page+0x5f/0xa3 [lg]
[124320.090993]  [<f8880654>] pin_stack_pages+0x3a/0x4a [lg]
[124320.091004]  [<f888007e>] guest_pagetable_clear_all+0x12/0x15 [lg]
[124320.091013]  [<f887f81a>] do_hcall+0xb1/0x1cb [lg]
[124320.091021]  [<f887fbbe>] do_hypercalls+0x28a/0x2a0 [lg]
[124320.091029]  [<f887f2a2>] run_guest+0x24/0x492 [lg]
[124320.091037]  [<f8881b48>] read+0x83/0x8f [lg]
[124320.091048]  [<c0175a77>] vfs_read+0x8e/0x117
[124320.091054]  [<c0175e99>] sys_read+0x3d/0x61
[124320.091059]  [<c0104166>] sysenter_past_esp+0x6b/0xb5
[124320.091065]  [<ffffe410>] 0xffffe410
[124320.091069]  =======================

(akpm: it's unclear to me why this happens, and how the patch fixed it)

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN arch/i386/kernel/alternative.c~enforce-noreplace-smp-in-alternative_instructions arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~enforce-noreplace-smp-in-alternative_instructions
+++ a/arch/i386/kernel/alternative.c
@@ -221,9 +221,6 @@ static void alternatives_smp_unlock(u8 *
 	u8 **ptr;
 	char insn[1];
 
-	if (noreplace_smp)
-		return;
-
 	add_nops(insn, 1);
 	for (ptr = start; ptr < end; ptr++) {
 		if (*ptr < text)
@@ -404,7 +401,7 @@ void __init alternative_instructions(voi
 #endif
 
 #ifdef CONFIG_SMP
-	if (smp_alt_once) {
+	if (smp_alt_once && !noreplace_smp) {
 		if (1 == num_possible_cpus()) {
 			printk(KERN_INFO "SMP alternatives: switching to UP code\n");
 			set_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
_

Patches currently in -mm which might be from deweerdt@free.fr are

xtensa-consolec-remove-duplicate-include.patch
enforce-noreplace-smp-in-alternative_instructions.patch
revoke-core-code.patch
reiser4-sb_sync_inodes.patch
