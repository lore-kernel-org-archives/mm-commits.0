Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998C2A929
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560109; cv=none; b=p9ZlA3G3yNT+iiz9cFbpxwv2jNoSaVDzrtktyy1iOQ+l4o9tReaSd5GN3UVZWEMyqsSnN0ui89KJCz9GCQwmuFnJAW0S97nVLDaXZb54DqFMgBJaG0GXlXesV32LCUScPfGqr1hilyFqro5zDm7d+7ZQR5Ple7Lo7V6D7/jZcjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560109; c=relaxed/simple;
	bh=e7hmCxHj6CywZQOqgz28yfK6KECTVrdbtidMxzjGzaQ=;
	h=Date:To:From:Subject:Message-Id; b=B9hK4j3Vr4oZTLpnPDxW32+ufMuTE85coDUAPuZ0jMdZdvWfjwlJHblcv7XG/I32z8DCVTd73aE9w6GySvS8pDeRJg2fEaNBIE+4xO5/9+cp1UlLKR5Yzgp4K5B1VHFo7m0RQeUYyE0MkL/g1GIRGcMsewMZJizfCfxVm/ZuD8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BI1ksIAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BI1ksIAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0D5C433C7;
	Thu, 22 Feb 2024 00:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560109;
	bh=e7hmCxHj6CywZQOqgz28yfK6KECTVrdbtidMxzjGzaQ=;
	h=Date:To:From:Subject:From;
	b=BI1ksIAZPqNto77i/15TSJpqWGLeYWlwVki3PdmlPbs6CHB5AK09WE1mlhNRFujlI
	 sCuXVUPy8LzmXhEPgf1BEmJwMYHtT21RjdhUNtOpKlmyk64ND/l2xctbqYRWTnnL38
	 aFHq8TtY/SPAQr16BzJ/CX6n0qAPIS0HhGwuGPyI=
Date: Wed, 21 Feb 2024 16:01:49 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,mingo@redhat.com,luto@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-delete-unused-cpu-argument-to-leave_mm.patch removed from -mm tree
Message-Id: <20240222000149.6D0D5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: delete unused cpu argument to leave_mm()
has been removed from the -mm tree.  Its filename was
     x86-mm-delete-unused-cpu-argument-to-leave_mm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


