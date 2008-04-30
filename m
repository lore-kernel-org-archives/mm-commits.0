From: akpm@linux-foundation.org
Subject: - s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:27 -0700
Message-ID: <200804300550.m3U5oRDJ030115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759094AbYD3Fuk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc update
has been removed from the -mm tree.  Its filename was
     s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc update
From: Christoph Lameter <clameter@sgi.com>

New version that does not preserve the marker. Arch maintainers indicate
that the marker functionality is is not needed anymore.

Note you may simplify the s390 asm-offsets.c code further if you use the
OFFSET() macro instead of the DEFINE. See kbuild.h

Subject: Use kbuild.h instead of defining macros in asm-offsets.c

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/asm-offsets.c |   51 +++++++++++++------------------
 1 file changed, 23 insertions(+), 28 deletions(-)

diff -puN arch/s390/kernel/asm-offsets.c~s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update arch/s390/kernel/asm-offsets.c
--- a/arch/s390/kernel/asm-offsets.c~s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update
+++ a/arch/s390/kernel/asm-offsets.c
@@ -7,41 +7,36 @@
 #include <linux/sched.h>
 #include <linux/kbuild.h>
 
-/* Use marker if you need to separate the values later */
-#undef DEFINE
-#define DEFINE(sym, val, marker) \
-	asm volatile("\n->" #sym " %0 " #val " " #marker : : "i" (val))
-
 int main(void)
 {
-	DEFINE(__THREAD_info, offsetof(struct task_struct, stack),);
-	DEFINE(__THREAD_ksp, offsetof(struct task_struct, thread.ksp),);
-	DEFINE(__THREAD_per, offsetof(struct task_struct, thread.per_info),);
+	DEFINE(__THREAD_info, offsetof(struct task_struct, stack));
+	DEFINE(__THREAD_ksp, offsetof(struct task_struct, thread.ksp));
+	DEFINE(__THREAD_per, offsetof(struct task_struct, thread.per_info));
 	DEFINE(__THREAD_mm_segment,
-	       offsetof(struct task_struct, thread.mm_segment),);
+	       offsetof(struct task_struct, thread.mm_segment));
 	BLANK();
-	DEFINE(__TASK_pid, offsetof(struct task_struct, pid),);
+	DEFINE(__TASK_pid, offsetof(struct task_struct, pid));
 	BLANK();
-	DEFINE(__PER_atmid, offsetof(per_struct, lowcore.words.perc_atmid),);
-	DEFINE(__PER_address, offsetof(per_struct, lowcore.words.address),);
-	DEFINE(__PER_access_id, offsetof(per_struct, lowcore.words.access_id),);
+	DEFINE(__PER_atmid, offsetof(per_struct, lowcore.words.perc_atmid));
+	DEFINE(__PER_address, offsetof(per_struct, lowcore.words.address));
+	DEFINE(__PER_access_id, offsetof(per_struct, lowcore.words.access_id));
 	BLANK();
-	DEFINE(__TI_task, offsetof(struct thread_info, task),);
-	DEFINE(__TI_domain, offsetof(struct thread_info, exec_domain),);
-	DEFINE(__TI_flags, offsetof(struct thread_info, flags),);
-	DEFINE(__TI_cpu, offsetof(struct thread_info, cpu),);
-	DEFINE(__TI_precount, offsetof(struct thread_info, preempt_count),);
+	DEFINE(__TI_task, offsetof(struct thread_info, task));
+	DEFINE(__TI_domain, offsetof(struct thread_info, exec_domain));
+	DEFINE(__TI_flags, offsetof(struct thread_info, flags));
+	DEFINE(__TI_cpu, offsetof(struct thread_info, cpu));
+	DEFINE(__TI_precount, offsetof(struct thread_info, preempt_count));
 	BLANK();
-	DEFINE(__PT_ARGS, offsetof(struct pt_regs, args),);
-	DEFINE(__PT_PSW, offsetof(struct pt_regs, psw),);
-	DEFINE(__PT_GPRS, offsetof(struct pt_regs, gprs),);
-	DEFINE(__PT_ORIG_GPR2, offsetof(struct pt_regs, orig_gpr2),);
-	DEFINE(__PT_ILC, offsetof(struct pt_regs, ilc),);
-	DEFINE(__PT_TRAP, offsetof(struct pt_regs, trap),);
-	DEFINE(__PT_SIZE, sizeof(struct pt_regs),);
+	DEFINE(__PT_ARGS, offsetof(struct pt_regs, args));
+	DEFINE(__PT_PSW, offsetof(struct pt_regs, psw));
+	DEFINE(__PT_GPRS, offsetof(struct pt_regs, gprs));
+	DEFINE(__PT_ORIG_GPR2, offsetof(struct pt_regs, orig_gpr2));
+	DEFINE(__PT_ILC, offsetof(struct pt_regs, ilc));
+	DEFINE(__PT_TRAP, offsetof(struct pt_regs, trap));
+	DEFINE(__PT_SIZE, sizeof(struct pt_regs));
 	BLANK();
-	DEFINE(__SF_BACKCHAIN, offsetof(struct stack_frame, back_chain),);
-	DEFINE(__SF_GPRS, offsetof(struct stack_frame, gprs),);
-	DEFINE(__SF_EMPTY, offsetof(struct stack_frame, empty1),);
+	DEFINE(__SF_BACKCHAIN, offsetof(struct stack_frame, back_chain));
+	DEFINE(__SF_GPRS, offsetof(struct stack_frame, gprs));
+	DEFINE(__SF_EMPTY, offsetof(struct stack_frame, empty1));
 	return 0;
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-slub.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
x86-ioremap-add-checks-for-virtual-addresses.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch

