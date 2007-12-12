From: akpm@linux-foundation.org
Subject: - move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 11 Dec 2007 21:39:16 -0800
Message-ID: <200712120539.lBC5dGcM027860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404AbXLLFkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:40:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ananth@in.ibm.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Move kprobes examples to samples/ (checkpatch fixes)
has been removed from the -mm tree.  Its filename was
     move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Move kprobes examples to samples/ (checkpatch fixes)
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

o Modified examples code to build on multiple architectures. Currently,
  the examples code works for x86_64, x86_32 and powerpc
o Cleaned up unneeded #includes

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kprobes/jprobe_example.c    |   11 ++++++-----
 samples/kprobes/kprobe_example.c    |   24 ++++++++++++++----------
 samples/kprobes/kretprobe_example.c |   12 +++++++-----
 3 files changed, 27 insertions(+), 20 deletions(-)

diff -puN samples/kprobes/jprobe_example.c~move-kprobes-examples-to-samples-resend-checkpatch-fixes samples/kprobes/jprobe_example.c
--- a/samples/kprobes/jprobe_example.c~move-kprobes-examples-to-samples-resend-checkpatch-fixes
+++ a/samples/kprobes/jprobe_example.c
@@ -22,9 +22,10 @@
 /* Proxy routine having the same arguments as actual do_fork() routine */
 static long jdo_fork(unsigned long clone_flags, unsigned long stack_start,
 	      struct pt_regs *regs, unsigned long stack_size,
-	      int __user * parent_tidptr, int __user * child_tidptr)
+	      int __user *parent_tidptr, int __user *child_tidptr)
 {
-	printk("jprobe: clone_flags = 0x%lx, stack_size = 0x%lx, regs = 0x%p\n",
+	printk(KERN_INFO "jprobe: clone_flags = 0x%lx, stack_size = 0x%lx,"
+			" regs = 0x%p\n",
 	       clone_flags, stack_size, regs);
 
 	/* Always end with a call to jprobe_return(). */
@@ -45,10 +46,10 @@ static int __init jprobe_init(void)
 
 	ret = register_jprobe(&my_jprobe);
 	if (ret < 0) {
-		printk("register_jprobe failed, returned %d\n", ret);
+		printk(KERN_INFO "register_jprobe failed, returned %d\n", ret);
 		return -1;
 	}
-	printk("Planted jprobe at %p, handler addr %p\n",
+	printk(KERN_INFO "Planted jprobe at %p, handler addr %p\n",
 	       my_jprobe.kp.addr, my_jprobe.entry);
 	return 0;
 }
@@ -56,7 +57,7 @@ static int __init jprobe_init(void)
 static void __exit jprobe_exit(void)
 {
 	unregister_jprobe(&my_jprobe);
-	printk("jprobe at %p unregistered\n", my_jprobe.kp.addr);
+	printk(KERN_INFO "jprobe at %p unregistered\n", my_jprobe.kp.addr);
 }
 
 module_init(jprobe_init)
diff -puN samples/kprobes/kprobe_example.c~move-kprobes-examples-to-samples-resend-checkpatch-fixes samples/kprobes/kprobe_example.c
--- a/samples/kprobes/kprobe_example.c~move-kprobes-examples-to-samples-resend-checkpatch-fixes
+++ a/samples/kprobes/kprobe_example.c
@@ -20,15 +20,18 @@ static struct kprobe kp = {
 static int handler_pre(struct kprobe *p, struct pt_regs *regs)
 {
 #ifdef CONFIG_X86_32
-	printk("pre_handler: p->addr = 0x%p, eip = %lx, eflags = 0x%lx\n",
+	printk(KERN_INFO "pre_handler: p->addr = 0x%p, eip = %lx,"
+			" eflags = 0x%lx\n",
 		p->addr, regs->eip, regs->eflags);
 #endif
 #ifdef CONFIG_X86_64
-	printk("pre_handler: p->addr = 0x%p, rip = %lx, eflags = 0x%lx\n",
+	printk(KERN_INFO "pre_handler: p->addr = 0x%p, rip = %lx,"
+			" eflags = 0x%lx\n",
 		p->addr, regs->rip, regs->eflags);
 #endif
 #ifdef CONFIG_PPC
-	printk("pre_handler: p->addr = 0x%p, nip = 0x%lx, msr = 0x%lx\n",
+	printk(KERN_INFO "pre_handler: p->addr = 0x%p, nip = 0x%lx,"
+			" msr = 0x%lx\n",
 		p->addr, regs->nip, regs->msr);
 #endif
 
@@ -37,14 +40,15 @@ static int handler_pre(struct kprobe *p,
 }
 
 /* kprobe post_handler: called after the probed instruction is executed */
-static void handler_post(struct kprobe *p, struct pt_regs *regs, unsigned long flags)
+static void handler_post(struct kprobe *p, struct pt_regs *regs,
+				unsigned long flags)
 {
 #if defined(CONFIG_X86_32) || defined(CONFIG_X86_64)
-	printk("post_handler: p->addr = 0x%p, eflags = 0x%lx\n",
+	printk(KERN_INFO "post_handler: p->addr = 0x%p, eflags = 0x%lx\n",
 		p->addr, regs->eflags);
 #endif
 #ifdef CONFIG_PPC
-	printk("post_handler: p->addr = 0x%p, msr = 0x%lx\n",
+	printk(KERN_INFO "post_handler: p->addr = 0x%p, msr = 0x%lx\n",
 		p->addr, regs->msr);
 #endif
 }
@@ -56,7 +60,7 @@ static void handler_post(struct kprobe *
  */
 static int handler_fault(struct kprobe *p, struct pt_regs *regs, int trapnr)
 {
-	printk("fault_handler: p->addr = 0x%p, trap #%dn",
+	printk(KERN_INFO "fault_handler: p->addr = 0x%p, trap #%dn",
 		p->addr, trapnr);
 	/* Return 0 because we don't handle the fault. */
 	return 0;
@@ -71,17 +75,17 @@ static int __init kprobe_init(void)
 
 	ret = register_kprobe(&kp);
 	if (ret < 0) {
-		printk("register_kprobe failed, returned %d\n", ret);
+		printk(KERN_INFO "register_kprobe failed, returned %d\n", ret);
 		return ret;
 	}
-	printk("Planted kprobe at %p\n", kp.addr);
+	printk(KERN_INFO "Planted kprobe at %p\n", kp.addr);
 	return 0;
 }
 
 static void __exit kprobe_exit(void)
 {
 	unregister_kprobe(&kp);
-	printk("kprobe at %p unregistered\n", kp.addr);
+	printk(KERN_INFO "kprobe at %p unregistered\n", kp.addr);
 }
 
 module_init(kprobe_init)
diff -puN samples/kprobes/kretprobe_example.c~move-kprobes-examples-to-samples-resend-checkpatch-fixes samples/kprobes/kretprobe_example.c
--- a/samples/kprobes/kretprobe_example.c~move-kprobes-examples-to-samples-resend-checkpatch-fixes
+++ a/samples/kprobes/kretprobe_example.c
@@ -18,7 +18,7 @@ static int ret_handler(struct kretprobe_
 {
 	int retval = regs_return_value(regs);
 
-	printk("do_fork returns %d\n", retval);
+	printk(KERN_INFO "do_fork returns %d\n", retval);
 	return 0;
 }
 
@@ -37,20 +37,22 @@ static int __init kretprobe_init(void)
 
 	ret = register_kretprobe(&my_kretprobe);
 	if (ret < 0) {
-		printk("register_kretprobe failed, returned %d\n", ret);
+		printk(KERN_INFO "register_kretprobe failed, returned %d\n",
+				ret);
 		return -1;
 	}
-	printk("Planted return probe at %p\n", my_kretprobe.kp.addr);
+	printk(KERN_INFO "Planted return probe at %p\n", my_kretprobe.kp.addr);
 	return 0;
 }
 
 static void __exit kretprobe_exit(void)
 {
 	unregister_kretprobe(&my_kretprobe);
-	printk("kretprobe at %p unregistered\n", my_kretprobe.kp.addr);
+	printk(KERN_INFO "kretprobe at %p unregistered\n",
+			my_kretprobe.kp.addr);
 
 	/* nmissed > 0 suggests that maxactive was set too low. */
-	printk("Missed probing %d instances of do_fork()\n",
+	printk(KERN_INFO "Missed probing %d instances of do_fork()\n",
 		my_kretprobe.nmissed);
 }
 
_

Patches currently in -mm which might be from ananth@in.ibm.com are

create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
move-kprobes-examples-to-samples-resend-vs-git-x86.patch
