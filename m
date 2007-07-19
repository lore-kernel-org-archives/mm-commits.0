From: akpm@linux-foundation.org
Subject: - jprobes-make-jprobes-a-little-safer-for-users.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:39 -0700
Message-ID: <200707192001.l6JK1d39019557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932234AbXGSUa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:30:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, prasanna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     jprobes: make jprobes a little safer for users
has been removed from the -mm tree.  Its filename was
     jprobes-make-jprobes-a-little-safer-for-users.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/kprobes.c    |    7 ++++++-
 arch/powerpc/kernel/kprobes.c |   11 ++++++++---
 include/linux/kprobes.h       |    1 +
 kernel/kprobes.c              |    9 +++++++++
 4 files changed, 24 insertions(+), 4 deletions(-)

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
diff -puN include/linux/kprobes.h~jprobes-make-jprobes-a-little-safer-for-users include/linux/kprobes.h
--- a/include/linux/kprobes.h~jprobes-make-jprobes-a-little-safer-for-users
+++ a/include/linux/kprobes.h
@@ -214,6 +214,7 @@ int longjmp_break_handler(struct kprobe 
 int register_jprobe(struct jprobe *p);
 void unregister_jprobe(struct jprobe *p);
 void jprobe_return(void);
+unsigned long arch_deref_entry_point(void *);
 
 int register_kretprobe(struct kretprobe *rp);
 void unregister_kretprobe(struct kretprobe *rp);
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

origin.patch
