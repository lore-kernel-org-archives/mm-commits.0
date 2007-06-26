From: akpm@linux-foundation.org
Subject: + jprobes-make-jprobes-a-little-safer-for-users.patch added to -mm tree
Date: Mon, 25 Jun 2007 19:04:35 -0700
Message-ID: <200706260204.l5Q24Zf6016164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43398 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbXFZCEu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 22:04:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@ellerman.id.au, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, prasanna@in.ibm.com


The patch titled
     jprobes: make jprobes a little safer for users
has been added to the -mm tree.  Its filename is
     jprobes-make-jprobes-a-little-safer-for-users.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jprobes: make jprobes a little safer for users
From: Michael Ellerman <michael@ellerman.id.au>

I realise jprobes are a razor-blades-included type of interface, but that
doesn't mean we can't try and make them safer to use.  This guy I know once
wrote code like this:

struct jprobe jp = { .kp.symbol_name = "foo", .entry = "jprobe_foo" };

And then his kernel exploded. Oops.

This patch adds an arch hook, arch_deref_entry_point() (I don't like it
either) which takes the void * in a struct jprobe, and gives back the text
address that it represents.

We can then use that in register_jprobe() to check that the entry point we're
passed is actually in the kernel text, rather than just some random value.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/kprobes.c    |    7 ++++++-
 arch/powerpc/kernel/kprobes.c |   11 ++++++++---
 kernel/kprobes.c              |    9 +++++++++
 3 files changed, 23 insertions(+), 4 deletions(-)

diff -puN arch/ia64/kernel/kprobes.c~jprobes-make-jprobes-a-little-safer-for-users arch/ia64/kernel/kprobes.c
--- a/arch/ia64/kernel/kprobes.c~jprobes-make-jprobes-a-little-safer-for-users
+++ a/arch/ia64/kernel/kprobes.c
@@ -936,10 +936,15 @@ static void ia64_get_bsp_cfm(struct unw_
 	return;
 }
 
+unsigned long arch_deref_entry_point(void *entry)
+{
+	return ((struct fnptr *)entry)->ip;
+}
+
 int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
-	unsigned long addr = ((struct fnptr *)(jp->entry))->ip;
+	unsigned long addr = arch_deref_entry_point(jp->entry);
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	struct param_bsp_cfm pa;
 	int bytes;
diff -puN arch/powerpc/kernel/kprobes.c~jprobes-make-jprobes-a-little-safer-for-users arch/powerpc/kernel/kprobes.c
--- a/arch/powerpc/kernel/kprobes.c~jprobes-make-jprobes-a-little-safer-for-users
+++ a/arch/powerpc/kernel/kprobes.c
@@ -492,6 +492,13 @@ int __kprobes kprobe_exceptions_notify(s
 	return ret;
 }
 
+#ifdef CONFIG_PPC64
+unsigned long arch_deref_entry_point(void *entry)
+{
+	return (unsigned long)(((func_descr_t *)entry)->entry);
+}
+#endif
+
 int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
@@ -500,11 +507,9 @@ int __kprobes setjmp_pre_handler(struct 
 	memcpy(&kcb->jprobe_saved_regs, regs, sizeof(struct pt_regs));
 
 	/* setup return addr to the jprobe handler routine */
+	regs->nip = arch_deref_entry_point(jp->entry);
 #ifdef CONFIG_PPC64
-	regs->nip = (unsigned long)(((func_descr_t *)jp->entry)->entry);
 	regs->gpr[2] = (unsigned long)(((func_descr_t *)jp->entry)->toc);
-#else
-	regs->nip = (unsigned long)jp->entry;
 #endif
 
 	return 1;
diff -puN kernel/kprobes.c~jprobes-make-jprobes-a-little-safer-for-users kernel/kprobes.c
--- a/kernel/kprobes.c~jprobes-make-jprobes-a-little-safer-for-users
+++ a/kernel/kprobes.c
@@ -675,9 +675,18 @@ static struct notifier_block kprobe_exce
 	.priority = 0x7fffffff /* we need to be notified first */
 };
 
+unsigned long __weak arch_deref_entry_point(void *entry)
+{
+	return (unsigned long)entry;
+}
 
 int __kprobes register_jprobe(struct jprobe *jp)
 {
+	unsigned long addr = arch_deref_entry_point(jp->entry);
+
+	if (!kernel_text_address(addr))
+		return -EINVAL;
+
 	/* Todo: Verify probepoint is a function entry point */
 	jp->kp.pre_handler = setjmp_pre_handler;
 	jp->kp.break_handler = longjmp_break_handler;
_

Patches currently in -mm which might be from michael@ellerman.id.au are

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
