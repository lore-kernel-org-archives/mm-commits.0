Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A7DDDAB
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706431150; cv=none; b=gL7o+eEPlahrO1bNv8GPtbk36roF69c/VMm4ryO2cZ4UGXWLtshs31An5gpB90HscBy7qDeF4no4POinVZMUdSswSum/8+tItto0tNhXW1lPB9D9hiTJ/6s0NqHpQCyjA9xNPg7PoVN+g7inpPuUG4dki2rrPFcnOwyD6w9flTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706431150; c=relaxed/simple;
	bh=kDrOhDV0VyipzT4tpzbiFi3HFqdrPAv4s7XWozu5vQA=;
	h=Date:To:From:Subject:Message-Id; b=awAEJPFHpaQ6IlELVOSx8a2qzGDJK1j2xQM5y0H37iJS/G334sYNfq0N87SrZ2oiEMDBccbz5NSz6+3nB2FLPtE6gisb8ZX9iKbNmFFqXuM/lKmV8+mEnd3d4acj6No8D7DUCNimr1ANkSQKaXDlc3YRbQsEFsNyddpUqo27Sw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yWGbpXPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yWGbpXPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464A8C433F1;
	Sun, 28 Jan 2024 08:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706431149;
	bh=kDrOhDV0VyipzT4tpzbiFi3HFqdrPAv4s7XWozu5vQA=;
	h=Date:To:From:Subject:From;
	b=yWGbpXPfPrwh+o/dWu6BP0NU9BcbNKtDGBe3wQv1gFGFTdNIWqBGgFzmiN4UOmbxc
	 Ga2szUKOJpSvLKrG8IjZ5Re3bO5+AIXLNVZwtbelZoboPUnTaAe1Gy2yrGTaFWTqB6
	 xKmLUGq5HnCVOvUH5IvNKmW0FxxQBOxD/N/xOk/Y=
Date: Sun, 28 Jan 2024 00:39:06 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,mingo@redhat.com,luto@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch added to mm-unstable branch
Message-Id: <20240128083909.464A8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: clarify "prev" usage in switch_mm_irqs_off()
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch
mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free.patch
mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch
mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch
x86-mm-delete-unused-cpu-argument-to-leave_mm.patch
x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch

