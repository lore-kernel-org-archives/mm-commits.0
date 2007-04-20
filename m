From: akpm@linux-foundation.org
Subject: + lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch added to -mm tree
Date: Fri, 20 Apr 2007 15:45:13 -0700
Message-ID: <200704202245.l3KMjD7p025605@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767298AbXDTWpw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 18:45:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     Update lguest's patch code for new paravirt patch architecture
has been added to the -mm tree.  Its filename is
     lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -388,7 +388,6 @@ static const struct lguest_insns
 	[PARAVIRT_PATCH(irq_enable)] = { lgstart_sti, lgend_sti },
 	[PARAVIRT_PATCH(restore_fl)] = { lgstart_popf, lgend_popf },
 	[PARAVIRT_PATCH(save_fl)] = { lgstart_pushf, lgend_pushf },
-	[PARAVIRT_PATCH(iret)] = { lgstart_iret, lgend_iret },
 };
 static unsigned lguest_patch(u8 type, u16 clobber, void *insns, unsigned len)
 {
@@ -396,20 +395,15 @@ static unsigned lguest_patch(u8 type, u1
 
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

git-kbuild.patch
git-net.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
extend-print_symbol-capability-fix-fix.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
expose-range-checking-functions-from-arch-specific.patch
expose-range-checking-functions-from-arch-specific-update.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
lguest-the-guest-code.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
