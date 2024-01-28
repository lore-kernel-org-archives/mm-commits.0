Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCA6DDA2
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 08:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706431145; cv=none; b=QRzdXn93gUfZXtnsi+c8Wyv0YemEuFIL9vsY46naziC3gb9L22u8XD/M337gTPQPUx0lxVXGrKlPKBCwWplvjRUNY0qPEWSqAprgfQ3YMnRcneRlfU4r5/zzXXtiOZiUf+y/6Cv61/7jYnKzpQ2dq6whnIUV6T0+FkEO0a07zN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706431145; c=relaxed/simple;
	bh=nWuatnm8d7fcHNA0nX3Dj1/UU5UpfPb5SnkcAneNoRI=;
	h=Date:To:From:Subject:Message-Id; b=I+OhUcwxYLNnz20/BYH7Vy03gU99frCWo9jDZeiVw6B7EGjkytUjHBOpXvKVW9NlheGIE7DPSefpQa9oF/+wHt6n8DV4/Lyoauf12Gj6BE68hpZGJ4wxPcnBMrXrH0sPkXL9EKE514NYlc2yG4MHkPH7XQh42TRhSfV5eOZtIsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EmpPS32b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EmpPS32b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722A4C433C7;
	Sun, 28 Jan 2024 08:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706431145;
	bh=nWuatnm8d7fcHNA0nX3Dj1/UU5UpfPb5SnkcAneNoRI=;
	h=Date:To:From:Subject:From;
	b=EmpPS32bMqX0PTj65mG1kATKGU+POlrRO8N5gwOhiDogOaaZE1nXQqkEnOIKrWHuW
	 NIy9tdBbuT+ScDpPoenNa1iJE0EuUwWkMyN+m6NhPsfO7LOWZBOyQbZTOiRHwNtQjj
	 rAy5iPkASFeZUyLJ8DEwVxpI0RHpzwA7//tWJ/QE=
Date: Sun, 28 Jan 2024 00:39:01 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,mingo@redhat.com,luto@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-delete-unused-cpu-argument-to-leave_mm.patch added to mm-unstable branch
Message-Id: <20240128083904.722A4C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: delete unused cpu argument to leave_mm()
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-delete-unused-cpu-argument-to-leave_mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-delete-unused-cpu-argument-to-leave_mm.patch

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
Subject: x86/mm: delete unused cpu argument to leave_mm()
Date: Fri, 26 Jan 2024 08:06:43 +0000

The argument is unused since commit 3d28ebceaffa ("x86/mm: Rework lazy
TLB to track the actual loaded mm"), delete it.

Link: https://lkml.kernel.org/r/20240126080644.1714297-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/mmu.h    |    2 +-
 arch/x86/kernel/alternative.c |    2 +-
 arch/x86/mm/tlb.c             |    2 +-
 arch/x86/xen/mmu_pv.c         |    2 +-
 drivers/cpuidle/cpuidle.c     |    2 +-
 include/linux/mmu_context.h   |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/mmu.h~x86-mm-delete-unused-cpu-argument-to-leave_mm
+++ a/arch/x86/include/asm/mmu.h
@@ -75,7 +75,7 @@ typedef struct {
 		.lock = __MUTEX_INITIALIZER(mm.context.lock),		\
 	}
 
-void leave_mm(int cpu);
+void leave_mm(void);
 #define leave_mm leave_mm
 
 #endif /* _ASM_X86_MMU_H */
--- a/arch/x86/kernel/alternative.c~x86-mm-delete-unused-cpu-argument-to-leave_mm
+++ a/arch/x86/kernel/alternative.c
@@ -1805,7 +1805,7 @@ static inline temp_mm_state_t use_tempor
 	 * restoring the previous mm.
 	 */
 	if (this_cpu_read(cpu_tlbstate_shared.is_lazy))
-		leave_mm(smp_processor_id());
+		leave_mm();
 
 	temp_state.mm = this_cpu_read(cpu_tlbstate.loaded_mm);
 	switch_mm_irqs_off(NULL, mm, current);
--- a/arch/x86/mm/tlb.c~x86-mm-delete-unused-cpu-argument-to-leave_mm
+++ a/arch/x86/mm/tlb.c
@@ -299,7 +299,7 @@ static void load_new_mm_cr3(pgd_t *pgdir
 	write_cr3(new_mm_cr3);
 }
 
-void leave_mm(int cpu)
+void leave_mm(void)
 {
 	struct mm_struct *loaded_mm = this_cpu_read(cpu_tlbstate.loaded_mm);
 
--- a/arch/x86/xen/mmu_pv.c~x86-mm-delete-unused-cpu-argument-to-leave_mm
+++ a/arch/x86/xen/mmu_pv.c
@@ -913,7 +913,7 @@ static void drop_mm_ref_this_cpu(void *i
 	struct mm_struct *mm = info;
 
 	if (this_cpu_read(cpu_tlbstate.loaded_mm) == mm)
-		leave_mm(smp_processor_id());
+		leave_mm();
 
 	/*
 	 * If this cpu still has a stale cr3 reference, then make sure
--- a/drivers/cpuidle/cpuidle.c~x86-mm-delete-unused-cpu-argument-to-leave_mm
+++ a/drivers/cpuidle/cpuidle.c
@@ -237,7 +237,7 @@ noinstr int cpuidle_enter_state(struct c
 	}
 
 	if (target_state->flags & CPUIDLE_FLAG_TLB_FLUSHED)
-		leave_mm(dev->cpu);
+		leave_mm();
 
 	/* Take note of the planned idle state. */
 	sched_idle_set_state(target_state);
--- a/include/linux/mmu_context.h~x86-mm-delete-unused-cpu-argument-to-leave_mm
+++ a/include/linux/mmu_context.h
@@ -11,7 +11,7 @@
 #endif
 
 #ifndef leave_mm
-static inline void leave_mm(int cpu) { }
+static inline void leave_mm(void) { }
 #endif
 
 /*
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch
mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free.patch
mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch
mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch
x86-mm-delete-unused-cpu-argument-to-leave_mm.patch
x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch

