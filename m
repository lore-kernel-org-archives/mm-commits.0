From: akpm@linux-foundation.org
Subject: + lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch added to -mm tree
Date: Fri, 04 May 2007 14:02:38 -0700
Message-ID: <200705042102.l44L2c7h014079@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031666AbXEDVCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 17:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: remove put_user etc warnings, add bloat
has been added to the -mm tree.  Its filename is
     lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: remove put_user etc warnings, add bloat
From: Rusty Russell <rusty@rustcorp.com.au>

I've long disliked Linux's user access functions.  Nonetheless, let's
stop the warnings.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c                 |    8 +++--
 drivers/lguest/hypercalls.c           |   33 ++++++++++++++++--------
 drivers/lguest/interrupts_and_traps.c |   17 ++++++++----
 3 files changed, 39 insertions(+), 19 deletions(-)

diff -puN drivers/lguest/core.c~lguest-the-host-code-remove-put_user-etc-warnings-add-bloat drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-the-host-code-remove-put_user-etc-warnings-add-bloat
+++ a/drivers/lguest/core.c
@@ -302,8 +302,9 @@ int run_guest(struct lguest *lg, char *_
 		/* Hypercalls first: we might have been out to userspace */
 		do_hypercalls(lg);
 		if (lg->dma_is_pending) {
-			put_user(lg->pending_dma, (unsigned long *)user);
-			put_user(lg->pending_key, (unsigned long *)user+1);
+			if (put_user(lg->pending_dma, (unsigned long *)user) ||
+			    put_user(lg->pending_key, (unsigned long *)user+1))
+				return -EFAULT;
 			return sizeof(unsigned long)*2;
 		}
 
@@ -349,7 +350,8 @@ int run_guest(struct lguest *lg, char *_
 				continue;
 
 			/* If lguest_data is NULL, this won't hurt. */
-			put_user(cr2, &lg->lguest_data->cr2);
+			if (put_user(cr2, &lg->lguest_data->cr2))
+				kill_guest(lg, "Writing cr2");
 			break;
 		case 7: /* We've intercepted a Device Not Available fault. */
 			/* If they don't want to know, just absorb it. */
diff -puN drivers/lguest/hypercalls.c~lguest-the-host-code-remove-put_user-etc-warnings-add-bloat drivers/lguest/hypercalls.c
--- a/drivers/lguest/hypercalls.c~lguest-the-host-code-remove-put_user-etc-warnings-add-bloat
+++ a/drivers/lguest/hypercalls.c
@@ -102,7 +102,9 @@ static void do_async_hcalls(struct lgues
 	unsigned int i;
 	u8 st[LHCALL_RING_SIZE];
 
-	copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st));
+	if (copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st)))
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(st); i++) {
 		struct lguest_regs regs;
 		unsigned int n = lg->next_hcall;
@@ -113,12 +115,20 @@ static void do_async_hcalls(struct lgues
 		if (++lg->next_hcall == LHCALL_RING_SIZE)
 			lg->next_hcall = 0;
 
-		get_user(regs.eax, &lg->lguest_data->hcalls[n].eax);
-		get_user(regs.edx, &lg->lguest_data->hcalls[n].edx);
-		get_user(regs.ecx, &lg->lguest_data->hcalls[n].ecx);
-		get_user(regs.ebx, &lg->lguest_data->hcalls[n].ebx);
+		if (get_user(regs.eax, &lg->lguest_data->hcalls[n].eax)
+		    || get_user(regs.edx, &lg->lguest_data->hcalls[n].edx)
+		    || get_user(regs.ecx, &lg->lguest_data->hcalls[n].ecx)
+		    || get_user(regs.ebx, &lg->lguest_data->hcalls[n].ebx)) {
+			kill_guest(lg, "Fetching async hypercalls");
+			break;
+		}
+
 		do_hcall(lg, &regs);
-		put_user(0xFF, &lg->lguest_data->hcall_status[n]);
+		if (put_user(0xFF, &lg->lguest_data->hcall_status[n])) {
+			kill_guest(lg, "Writing result for async hypercall");
+			break;
+		}
+
 		if (lg->dma_is_pending)
 			break;
 	}
@@ -139,11 +149,12 @@ static void initialize(struct lguest *lg
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 		return;
 	}
-	get_user(lg->noirq_start, &lg->lguest_data->noirq_start);
-	get_user(lg->noirq_end, &lg->lguest_data->noirq_end);
-	/* We reserve the top pgd entry. */
-	put_user(4U*1024*1024, &lg->lguest_data->reserve_mem);
-	put_user(lg->guestid, &lg->lguest_data->guestid);
+	if (get_user(lg->noirq_start, &lg->lguest_data->noirq_start)
+	    || get_user(lg->noirq_end, &lg->lguest_data->noirq_end)
+	    /* We reserve the top pgd entry. */
+	    || put_user(4U*1024*1024, &lg->lguest_data->reserve_mem)
+	    || put_user(lg->guestid, &lg->lguest_data->guestid))
+		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 }
 
 /* Even if we go out to userspace and come back, we don't want to do
diff -puN drivers/lguest/interrupts_and_traps.c~lguest-the-host-code-remove-put_user-etc-warnings-add-bloat drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c~lguest-the-host-code-remove-put_user-etc-warnings-add-bloat
+++ a/drivers/lguest/interrupts_and_traps.c
@@ -40,7 +40,8 @@ static void set_guest_interrupt(struct l
 	/* We use IF bit in eflags to indicate whether irqs were disabled
 	   (it's always 0, since irqs are enabled when guest is running). */
 	eflags = lg->regs->eflags;
-	get_user(irq_enable, &lg->lguest_data->irq_enabled);
+	if (get_user(irq_enable, &lg->lguest_data->irq_enabled))
+		irq_enable = 0;
 	eflags |= (irq_enable & X86_EFLAGS_IF);
 
 	push_guest_stack(lg, &gstack, eflags);
@@ -58,7 +59,8 @@ static void set_guest_interrupt(struct l
 
 	/* Disable interrupts for an interrupt gate. */
 	if (idt_type(lo, hi) == 0xE)
-		put_user(0, &lg->lguest_data->irq_enabled);
+		if (put_user(0, &lg->lguest_data->irq_enabled))
+			kill_guest(lg, "Disabling interrupts");
 }
 
 void maybe_do_interrupt(struct lguest *lg)
@@ -75,7 +77,10 @@ void maybe_do_interrupt(struct lguest *l
 		set_bit(0, lg->irqs_pending);
 
 	/* Mask out any interrupts they have blocked. */
-	copy_from_user(&blk, lg->lguest_data->blocked_interrupts, sizeof(blk));
+	if (copy_from_user(&blk, lg->lguest_data->blocked_interrupts,
+			   sizeof(blk)))
+		return;
+
 	bitmap_andnot(blk, lg->irqs_pending, blk, LGUEST_IRQS);
 
 	irq = find_first_bit(blk, LGUEST_IRQS);
@@ -88,12 +93,14 @@ void maybe_do_interrupt(struct lguest *l
 	/* If they're halted, we re-enable interrupts. */
 	if (lg->halted) {
 		/* Re-enable interrupts. */
-		put_user(X86_EFLAGS_IF, &lg->lguest_data->irq_enabled);
+		if (put_user(X86_EFLAGS_IF, &lg->lguest_data->irq_enabled))
+			kill_guest(lg, "Re-enabling interrupts");
 		lg->halted = 0;
 	} else {
 		/* Maybe they have interrupts disabled? */
 		u32 irq_enabled;
-		get_user(irq_enabled, &lg->lguest_data->irq_enabled);
+		if (get_user(irq_enabled, &lg->lguest_data->irq_enabled))
+			irq_enabled = 0;
 		if (!irq_enabled)
 			return;
 	}
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
array_size-check-for-type.patch
git-kbuild.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
module-use-krealloc.patch
get_futex_key-get_key_refs-and-drop_key_refs.patch
futex-restartable-futex_wait.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
lguest-the-guest-code.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
