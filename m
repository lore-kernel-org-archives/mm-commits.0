Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FFB8F65
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560110; cv=none; b=TRKvbQIHbtbe2bfk8nIAfAFcm6u//X51Eey4HiNa9roKTDMTmWGue1eXgB1BoQUQ/AO7/f4Vqvdt4C+7ZPaCKQnPrtTvNTv69bAj34uyCtdIMzyPpeZgVqzS+GShGOgCfmdU+baEkB1vSELWU/F0XKNPPNd2D+rdVBg2PifxXrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560110; c=relaxed/simple;
	bh=loYIoLvHtqtTWu7dLw3xkFt4foPlLmYNiAn33dvk6ts=;
	h=Date:To:From:Subject:Message-Id; b=AtsuXIAp/PW+0SK5xl2/+pKyN+zHLCZezdqleUedokM0bfVopc8C5NohuAp2tW+7BDX5cJvIAolpu2b1pWxJLuUBTRzKfska9mWacx/r4Yz6w108u8ruTLDKDb2YfEU9fT1pQSa+VWfX4/Io1Fhw/PYQ4sOI3twnF4yqREL4GBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iezTdFW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iezTdFW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575D0C433C7;
	Thu, 22 Feb 2024 00:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560110;
	bh=loYIoLvHtqtTWu7dLw3xkFt4foPlLmYNiAn33dvk6ts=;
	h=Date:To:From:Subject:From;
	b=iezTdFW+5PxWz9v91PIC83Q/LwpJLlqGtrQyeSsRhqXbYkunDY0Q843NM8mKkBUoY
	 2Du+ErQlk8W8b1cjBCDExmzviDLSc4sE38XslM8hiuNJmBxwr24ul3/+J6B7yiXo1h
	 ojgFnz1sEKoM3YnV8xolPJ4e8qPVLidX9j3FKCvU=
Date: Wed, 21 Feb 2024 16:01:49 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,mingo@redhat.com,luto@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch removed from -mm tree
Message-Id: <20240222000150.575D0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: clarify "prev" usage in switch_mm_irqs_off()
has been removed from the -mm tree.  Its filename was
     x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: x86/mm: clarify "prev" usage in switch_mm_irqs_off()
Date: Fri, 26 Jan 2024 08:06:44 +0000

In the x86 implementation of switch_mm_irqs_off(), we do not use the
"prev" argument passed in by the caller, we use exclusively use
"real_prev", which is cpu_tlbstate.loaded_mm.  This is not obvious at the
first sight.

Furthermore, a comment describes a condition that happens when called with
prev == next, but this should not affect the function in any way since
prev is unused.  Apparently, the comment is intended to clarify why we
don't rely on prev == next to decide whether we need to update CR3, but
again, it is not obvious.  The comment also references the fact that
leave_mm() calls with prev == NULL and tsk == NULL, but this also
shouldn't matter because prev is unused and tsk is only used in one
function which has a NULL check.

Clarify things by renaming (prev -> unused) and (real_prev -> prev), also
move and rewrite the comment as an explanation for why we don't rely on
"prev" supplied by the caller in x86 code and use our own.  Hopefully this
makes reading the code easier.

Link: https://lkml.kernel.org/r/20240126080644.1714297-2-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/tlb.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

--- a/arch/x86/mm/tlb.c~x86-mm-clarify-prev-usage-in-switch_mm_irqs_off
+++ a/arch/x86/mm/tlb.c
@@ -492,10 +492,16 @@ void cr4_update_pce(void *ignored)
 static inline void cr4_update_pce_mm(struct mm_struct *mm) { }
 #endif
 
-void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
+/*
+ * The "prev" argument passed by the caller does not always match CR3. For
+ * example, the scheduler passes in active_mm when switching from lazy TLB mode
+ * to normal mode, but switch_mm_irqs_off() can be called from x86 code without
+ * updating active_mm. Use cpu_tlbstate.loaded_mm instead.
+ */
+void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
 			struct task_struct *tsk)
 {
-	struct mm_struct *real_prev = this_cpu_read(cpu_tlbstate.loaded_mm);
+	struct mm_struct *prev = this_cpu_read(cpu_tlbstate.loaded_mm);
 	u16 prev_asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
 	unsigned long new_lam = mm_lam_cr3_mask(next);
 	bool was_lazy = this_cpu_read(cpu_tlbstate_shared.is_lazy);
@@ -504,15 +510,6 @@ void switch_mm_irqs_off(struct mm_struct
 	bool need_flush;
 	u16 new_asid;
 
-	/*
-	 * NB: The scheduler will call us with prev == next when switching
-	 * from lazy TLB mode to normal mode if active_mm isn't changing.
-	 * When this happens, we don't assume that CR3 (and hence
-	 * cpu_tlbstate.loaded_mm) matches next.
-	 *
-	 * NB: leave_mm() calls us with prev == NULL and tsk == NULL.
-	 */
-
 	/* We don't want flush_tlb_func() to run concurrently with us. */
 	if (IS_ENABLED(CONFIG_PROVE_LOCKING))
 		WARN_ON_ONCE(!irqs_disabled());
@@ -527,7 +524,7 @@ void switch_mm_irqs_off(struct mm_struct
 	 * isn't free.
 	 */
 #ifdef CONFIG_DEBUG_VM
-	if (WARN_ON_ONCE(__read_cr3() != build_cr3(real_prev->pgd, prev_asid,
+	if (WARN_ON_ONCE(__read_cr3() != build_cr3(prev->pgd, prev_asid,
 						   tlbstate_lam_cr3_mask()))) {
 		/*
 		 * If we were to BUG here, we'd be very likely to kill
@@ -559,7 +556,7 @@ void switch_mm_irqs_off(struct mm_struct
 	 * provides that full memory barrier and core serializing
 	 * instruction.
 	 */
-	if (real_prev == next) {
+	if (prev == next) {
 		/* Not actually switching mm's */
 		VM_WARN_ON(this_cpu_read(cpu_tlbstate.ctxs[prev_asid].ctx_id) !=
 			   next->context.ctx_id);
@@ -574,7 +571,7 @@ void switch_mm_irqs_off(struct mm_struct
 		 * mm_cpumask. The TLB shootdown code can figure out from
 		 * cpu_tlbstate_shared.is_lazy whether or not to send an IPI.
 		 */
-		if (WARN_ON_ONCE(real_prev != &init_mm &&
+		if (WARN_ON_ONCE(prev != &init_mm &&
 				 !cpumask_test_cpu(cpu, mm_cpumask(next))))
 			cpumask_set_cpu(cpu, mm_cpumask(next));
 
@@ -616,10 +613,10 @@ void switch_mm_irqs_off(struct mm_struct
 		 * Skip kernel threads; we never send init_mm TLB flushing IPIs,
 		 * but the bitmap manipulation can cause cache line contention.
 		 */
-		if (real_prev != &init_mm) {
+		if (prev != &init_mm) {
 			VM_WARN_ON_ONCE(!cpumask_test_cpu(cpu,
-						mm_cpumask(real_prev)));
-			cpumask_clear_cpu(cpu, mm_cpumask(real_prev));
+						mm_cpumask(prev)));
+			cpumask_clear_cpu(cpu, mm_cpumask(prev));
 		}
 
 		/*
@@ -656,9 +653,9 @@ void switch_mm_irqs_off(struct mm_struct
 	this_cpu_write(cpu_tlbstate.loaded_mm, next);
 	this_cpu_write(cpu_tlbstate.loaded_mm_asid, new_asid);
 
-	if (next != real_prev) {
+	if (next != prev) {
 		cr4_update_pce_mm(next);
-		switch_ldt(real_prev, next);
+		switch_ldt(prev, next);
 	}
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are


