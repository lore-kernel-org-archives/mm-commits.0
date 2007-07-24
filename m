From: akpm@linux-foundation.org
Subject: + lguest-documentation-vii-fixmes.patch added to -mm tree
Date: Mon, 23 Jul 2007 20:18:28 -0700
Message-ID: <200707240318.l6O3ISkB025685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756182AbXGXDSj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 23:18:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: documentation VII: FIXMEs
has been added to the -mm tree.  Its filename is
     lguest-documentation-vii-fixmes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: documentation VII: FIXMEs
From: Rusty Russell <rusty@rustcorp.com.au>

Documentation: The FIXMEs

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.c         |   12 ++++++++++++
 drivers/char/hvc_lguest.c             |    3 +++
 drivers/lguest/interrupts_and_traps.c |   14 ++++++++++++++
 drivers/lguest/io.c                   |   10 ++++++++++
 drivers/lguest/lguest.c               |    8 ++++++++
 drivers/lguest/lguest_asm.S           |   14 ++++++++++++++
 drivers/lguest/page_tables.c          |    5 +++++
 drivers/lguest/segments.c             |    4 ++++
 drivers/net/lguest_net.c              |   19 +++++++++++++++++++
 9 files changed, 89 insertions(+)

diff -puN Documentation/lguest/lguest.c~lguest-documentation-vii-fixmes Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-documentation-vii-fixmes
+++ a/Documentation/lguest/lguest.c
@@ -1510,3 +1510,15 @@ int main(int argc, char *argv[])
 	/* Finally, run the Guest.  This doesn't return. */
 	run_guest(lguest_fd, &device_list);
 }
+/*:*/
+
+/*M:999
+ * Mastery is done: you now know everything I do.
+ *
+ * But surely you have seen code, features and bugs in your wanderings which
+ * you now yearn to attack?  That is the real game, and I look forward to you
+ * patching and forking lguest into the Your-Name-Here-visor.
+ *
+ * Farewell, and good coding!
+ * Rusty Russell.
+ */
diff -puN drivers/char/hvc_lguest.c~lguest-documentation-vii-fixmes drivers/char/hvc_lguest.c
--- a/drivers/char/hvc_lguest.c~lguest-documentation-vii-fixmes
+++ a/drivers/char/hvc_lguest.c
@@ -13,6 +13,9 @@
  * functions.
  :*/
 
+/*M:002 The console can be flooded: while the Guest is processing input the
+ * Host can send more.  Buffering in the Host could alleviate this, but it is a
+ * difficult problem in general. :*/
 /* Copyright (C) 2006 Rusty Russell, IBM Corporation
  *
  * This program is free software; you can redistribute it and/or modify
diff -puN drivers/lguest/interrupts_and_traps.c~lguest-documentation-vii-fixmes drivers/lguest/interrupts_and_traps.c
--- a/drivers/lguest/interrupts_and_traps.c~lguest-documentation-vii-fixmes
+++ a/drivers/lguest/interrupts_and_traps.c
@@ -231,6 +231,20 @@ static int direct_trap(const struct lgue
 	 * go direct, of course 8) */
 	return idt_type(trap->a, trap->b) == 0xF;
 }
+/*:*/
+
+/*M:005 The Guest has the ability to turn its interrupt gates into trap gates,
+ * if it is careful.  The Host will let trap gates can go directly to the
+ * Guest, but the Guest needs the interrupts atomically disabled for an
+ * interrupt gate.  It can do this by pointing the trap gate at instructions
+ * within noirq_start and noirq_end, where it can safely disable interrupts. */
+
+/*M:006 The Guests do not use the sysenter (fast system call) instruction,
+ * because it's hardcoded to enter privilege level 0 and so can't go direct.
+ * It's about twice as fast as the older "int 0x80" system call, so it might
+ * still be worthwhile to handle it in the Switcher and lcall down to the
+ * Guest.  The sysenter semantics are hairy tho: search for that keyword in
+ * entry.S :*/
 
 /*H:260 When we make traps go directly into the Guest, we need to make sure
  * the kernel stack is valid (ie. mapped in the page tables).  Otherwise, the
diff -puN drivers/lguest/io.c~lguest-documentation-vii-fixmes drivers/lguest/io.c
--- a/drivers/lguest/io.c~lguest-documentation-vii-fixmes
+++ a/drivers/lguest/io.c
@@ -553,6 +553,16 @@ void release_all_dma(struct lguest *lg)
 	up_read(&lg->mm->mmap_sem);
 }
 
+/*M:007 We only return a single DMA buffer to the Launcher, but it would be
+ * more efficient to return a pointer to the entire array of DMA buffers, which
+ * it can cache and choose one whenever it wants.
+ *
+ * Currently the Launcher uses a write to /dev/lguest, and the return value is
+ * the address of the DMA structure with the interrupt number placed in
+ * dma->used_len.  If we wanted to return the entire array, we need to return
+ * the address, array size and interrupt number: this seems to require an
+ * ioctl(). :*/
+
 /*L:320 This routine looks for a DMA buffer registered by the Guest on the
  * given key (using the BIND_DMA hypercall). */
 unsigned long get_dma_buffer(struct lguest *lg,
diff -puN drivers/lguest/lguest.c~lguest-documentation-vii-fixmes drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-documentation-vii-fixmes
+++ a/drivers/lguest/lguest.c
@@ -250,6 +250,14 @@ static void irq_enable(void)
 {
 	lguest_data.irq_enabled = X86_EFLAGS_IF;
 }
+/*:*/
+/*M:003 Note that we don't check for outstanding interrupts when we re-enable
+ * them (or when we unmask an interrupt).  This seems to work for the moment,
+ * since interrupts are rare and we'll just get the interrupt on the next timer
+ * tick, but when we turn on CONFIG_NO_HZ, we should revisit this.  One way
+ * would be to put the "irq_enabled" field in a page by itself, and have the
+ * Host write-protect it when an interrupt comes in when irqs are disabled.
+ * There will then be a page fault as soon as interrupts are re-enabled. :*/
 
 /*G:034
  * The Interrupt Descriptor Table (IDT).
diff -puN drivers/lguest/lguest_asm.S~lguest-documentation-vii-fixmes drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S~lguest-documentation-vii-fixmes
+++ a/drivers/lguest/lguest_asm.S
@@ -39,6 +39,20 @@ LGUEST_PATCH(pushf, movl lguest_data+LGU
 .global lguest_noirq_start
 .global lguest_noirq_end
 
+/*M:004 When the Host reflects a trap or injects an interrupt into the Guest,
+ * it sets the eflags interrupt bit on the stack based on
+ * lguest_data.irq_enabled, so the Guest iret logic does the right thing when
+ * restoring it.  However, when the Host sets the Guest up for direct traps,
+ * such as system calls, the processor is the one to push eflags onto the
+ * stack, and the interrupt bit will be 1 (in reality, interrupts are always
+ * enabled in the Guest).
+ *
+ * This turns out to be harmless: the only trap which should happen under Linux
+ * with interrupts disabled is Page Fault (due to our lazy mapping of vmalloc
+ * regions), which has to be reflected through the Host anyway.  If another
+ * trap *does* go off when interrupts are disabled, the Guest will panic, and
+ * we'll never get to this iret! :*/
+
 /*G:045 There is one final paravirt_op that the Guest implements, and glancing
  * at it you can see why I left it to last.  It's *cool*!  It's in *assembler*!
  *
diff -puN drivers/lguest/page_tables.c~lguest-documentation-vii-fixmes drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c~lguest-documentation-vii-fixmes
+++ a/drivers/lguest/page_tables.c
@@ -15,6 +15,11 @@
 #include <asm/tlbflush.h>
 #include "lg.h"
 
+/*M:008 We hold reference to pages, which prevents them from being swapped.
+ * It'd be nice to have a callback in the "struct mm_struct" when Linux wants
+ * to swap out.  If we had this, and a shrinker callback to trim PTE pages, we
+ * could probably consider launching Guests as non-root. :*/
+
 /*H:300
  * The Page Table Code
  *
diff -puN drivers/lguest/segments.c~lguest-documentation-vii-fixmes drivers/lguest/segments.c
--- a/drivers/lguest/segments.c~lguest-documentation-vii-fixmes
+++ a/drivers/lguest/segments.c
@@ -94,6 +94,10 @@ static void check_segment_use(struct lgu
 	    || lg->regs->ss / 8 == desc)
 		kill_guest(lg, "Removed live GDT entry %u", desc);
 }
+/*:*/
+/*M:009 We wouldn't need to check for removal of in-use segments if we handled
+ * faults in the Switcher.  However, it's probably not a worthwhile
+ * optimization. :*/
 
 /*H:610 Once the GDT has been changed, we look through the changed entries and
  * see if they're OK.  If not, we'll call kill_guest() and the Guest will never
diff -puN drivers/net/lguest_net.c~lguest-documentation-vii-fixmes drivers/net/lguest_net.c
--- a/drivers/net/lguest_net.c~lguest-documentation-vii-fixmes
+++ a/drivers/net/lguest_net.c
@@ -35,6 +35,25 @@
 #define MAX_LANS		4
 #define NUM_SKBS		8
 
+/*M:011 Network code master Jeff Garzik points out numerous shortcomings in
+ * this driver if it aspires to greatness.
+ *
+ * Firstly, it doesn't use "NAPI": the networking's New API, and is poorer for
+ * it.  As he says "NAPI means system-wide load leveling, across multiple
+ * network interfaces.  Lack of NAPI can mean competition at higher loads."
+ *
+ * He also points out that we don't implement set_mac_address, so users cannot
+ * change the devices hardware address.  When I asked why one would want to:
+ * "Bonding, and situations where you /do/ want the MAC address to "leak" out
+ * of the host onto the wider net."
+ *
+ * Finally, he would like module unloading: "It is not unrealistic to think of
+ * [un|re|]loading the net support module in an lguest guest.  And, adding
+ * module support makes the programmer more responsible, because they now have
+ * to learn to clean up after themselves.  Any driver that cannot clean up
+ * after itself is an incomplete driver in my book."
+ :*/
+
 /*D:530 The "struct lguestnet_info" contains all the information we need to
  * know about the network device. */
 struct lguestnet_info
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

resend-link-lguest-example-launcher-non-static.patch
lguest-documentation-i-preparation.patch
lguest-documentation-ii-guest.patch
lguest-documentation-iii-drivers.patch
lguest-documentation-iv-launcher.patch
lguest-documentation-v-host.patch
lguest-documentation-vi-switcher.patch
lguest-documentation-vii-fixmes.patch
git-kvm.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
