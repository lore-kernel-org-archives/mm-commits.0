From: akpm@linux-foundation.org
Subject: - lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch removed from -mm tree
Date: Wed, 09 May 2007 02:41:57 -0700
Message-ID: <200705090941.l499fv6p020172@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbXEIJma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:42:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Update lguest's patch code for new paravirt patch architecture
has been removed from the -mm tree.  Its filename was
     lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch

This patch was dropped because it was folded into lguest-the-guest-code.patch

------------------------------------------------------
Subject: Update lguest's patch code for new paravirt patch architecture
From: Rusty Russell <rusty@rustcorp.com.au>

The new patching code means that we don't actually have to do as much
work in lguest's patcher.

We use paravirt_patch_default() for cases we don't want to patch
inline, which automatically handles the "patch iret to use a direct
jump" case.

There's no measurable effect on lguest's virtbench scores tho.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c     |   10 ++--------
 drivers/lguest/lguest_asm.S |    1 -
 2 files changed, 2 insertions(+), 9 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch
+++ a/drivers/lguest/lguest.c
@@ -387,7 +387,6 @@ static const struct lguest_insns
 	[PARAVIRT_PATCH(irq_enable)] = { lgstart_sti, lgend_sti },
 	[PARAVIRT_PATCH(restore_fl)] = { lgstart_popf, lgend_popf },
 	[PARAVIRT_PATCH(save_fl)] = { lgstart_pushf, lgend_pushf },
-	[PARAVIRT_PATCH(iret)] = { lgstart_iret, lgend_iret },
 };
 static unsigned lguest_patch(u8 type, u16 clobber, void *insns, unsigned len)
 {
@@ -395,20 +394,15 @@ static unsigned lguest_patch(u8 type, u1
 
 	/* Don't touch it if we don't have a replacement */
 	if (type >= ARRAY_SIZE(lguest_insns) || !lguest_insns[type].start)
-		return len;
+		return paravirt_patch_default(type, clobber, insns, len);
 
 	insn_len = lguest_insns[type].end - lguest_insns[type].start;
 
 	/* Similarly if we can't fit replacement. */
 	if (len < insn_len)
-		return len;
+		return paravirt_patch_default(type, clobber, insns, len);
 
 	memcpy(insns, lguest_insns[type].start, insn_len);
-	if (type == PARAVIRT_PATCH(iret)) {
-		/* Jumps are relative. */
-		u32 off = (u32)lguest_iret - ((u32)insns + insn_len);
-		memcpy(insns+1, &off, sizeof(off));
-	}
 	return insn_len;
 }
 
diff -puN drivers/lguest/lguest_asm.S~lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S~lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch
+++ a/drivers/lguest/lguest_asm.S
@@ -34,7 +34,6 @@ LGUEST_PATCH(cli, movl $0, lguest_data+L
 LGUEST_PATCH(sti, movl $X86_EFLAGS_IF, lguest_data+LGUEST_DATA_irq_enabled)
 LGUEST_PATCH(popf, movl %eax, lguest_data+LGUEST_DATA_irq_enabled)
 LGUEST_PATCH(pushf, movl lguest_data+LGUEST_DATA_irq_enabled, %eax)
-LGUEST_PATCH(iret, .byte 0xE9,0,0,0,0) /* jmp <to-be-patched> */
 
 .text
 /* These demark the EIP range where host should never deliver interrupts. */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
lguest-the-guest-code-dont-use-paravirt_probe-its-dying.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch
lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
lguest-the-net-driver-two-net-bugfixes.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
lguest-two-net-bugfixes-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
