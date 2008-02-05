From: akpm@linux-foundation.org
Subject: - uml-implement-get_wchan.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:23 -0800
Message-ID: <200802052235.m15MZ4Zd012582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762391AbYBEWlc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: implement get_wchan
has been removed from the -mm tree.  Its filename was
     uml-implement-get_wchan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: implement get_wchan
From: Jeff Dike <jdike@addtoit.com>

Implement get_wchan - the algorithm is similar to x86.  It starts with the
stack pointer of the process in question and looks above that for addresses
that are kernel text.  The second one which isn't in the scheduler is the one
that's returned.  The first one is ignored because that will be UML's own
context switching routine.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/process.c           |   35 +++++++++++++++++++++++++++
 include/asm-um/processor-generic.h |    2 -
 2 files changed, 36 insertions(+), 1 deletion(-)

diff -puN arch/um/kernel/process.c~uml-implement-get_wchan arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-implement-get_wchan
+++ a/arch/um/kernel/process.c
@@ -459,3 +459,38 @@ unsigned long arch_align_stack(unsigned 
 	return sp & ~0xf;
 }
 #endif
+
+unsigned long get_wchan(struct task_struct *p)
+{
+	unsigned long stack_page, sp, ip;
+	bool seen_sched = 0;
+
+	if ((p == NULL) || (p == current) || (p->state == TASK_RUNNING))
+		return 0;
+
+	stack_page = (unsigned long) task_stack_page(p);
+	/* Bail if the process has no kernel stack for some reason */
+	if (stack_page == 0)
+		return 0;
+
+	sp = p->thread.switch_buf->JB_SP;
+	/*
+	 * Bail if the stack pointer is below the bottom of the kernel
+	 * stack for some reason
+	 */
+	if (sp < stack_page)
+		return 0;
+
+	while (sp < stack_page + THREAD_SIZE) {
+		ip = *((unsigned long *) sp);
+		if (in_sched_functions(ip))
+			/* Ignore everything until we're above the scheduler */
+			seen_sched = 1;
+		else if (kernel_text_address(ip) && seen_sched)
+			return ip;
+
+		sp += sizeof(unsigned long);
+	}
+
+	return 0;
+}
diff -puN include/asm-um/processor-generic.h~uml-implement-get_wchan include/asm-um/processor-generic.h
--- a/include/asm-um/processor-generic.h~uml-implement-get_wchan
+++ a/include/asm-um/processor-generic.h
@@ -128,6 +128,6 @@ extern struct cpuinfo_um cpu_data[];
 
 
 #define KSTK_REG(tsk, reg) get_thread_reg(reg, &tsk->thread.switch_buf)
-#define get_wchan(p) (0)
+extern unsigned long get_wchan(struct task_struct *p);
 
 #endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
