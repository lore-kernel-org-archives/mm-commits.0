Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFC335A943
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768965994; cv=none; b=AOt1cm/c8aqJEyhFKgdAuDRM9PNE+tWuDSGLS+d4FyXp5akCGxSuY3NSkVp+A8B5y0GvnkEzyGaJWeOSw5tqXHaehwWOxEqF2IeMK2xLo3537hxXF8U8IwzbisQSUt9x+0RYHJ5fDgLNUVu+j02RR0kfdGWj4K8NB8HIyV0lPwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768965994; c=relaxed/simple;
	bh=EQzp67qD91YDfC5Vsndu4ff5zLtCUTN7CQxw5YwADNQ=;
	h=Date:To:From:Subject:Message-Id; b=d7rtBnU786SbzLaRFbIZ1leuIPoH9L4KT7sC1qe9xZuxJdnUN0Nz2jHmyZEaKVwNekKPioQa1MVxcnCkNetwSY+2eVUQduBevkvYzEikfsDbcmRKIgCQ7/0ozVCozT+fadBKfzxV889pEXnxUJR7Ndnbe2qhrWF8KU3zNzqtGZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LT3EsGK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LT3EsGK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92121C16AAE;
	Wed, 21 Jan 2026 03:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768965993;
	bh=EQzp67qD91YDfC5Vsndu4ff5zLtCUTN7CQxw5YwADNQ=;
	h=Date:To:From:Subject:From;
	b=LT3EsGK2jFQ4xnP9g3wj8kob1lWRjnLtVFNLXx61SNz5vzzJ5hlwJca0HsegMpaph
	 xoLRvgvdlVpdqbhjz6d71CpHxLV+V65Ma1jHJvs3JodeKI7bUOfE0HSxU0wrBh26s+
	 wChIPa7F35L4q7EKJLZj1VjzcRsfgixzqgsGeU1g=
Date: Tue, 20 Jan 2026 19:26:32 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-64s-do-not-re-activate-batched-tlb-flush.patch removed from -mm tree
Message-Id: <20260121032633.92121C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/64s: do not re-activate batched TLB flush
has been removed from the -mm tree.  Its filename was
     powerpc-64s-do-not-re-activate-batched-tlb-flush.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: powerpc/64s: do not re-activate batched TLB flush
Date: Mon, 15 Dec 2025 15:03:10 +0000

Patch series "Nesting support for lazy MMU mode", v6.

When the lazy MMU mode was introduced eons ago, it wasn't made clear
whether such a sequence was legal:

	arch_enter_lazy_mmu_mode()
	...
		arch_enter_lazy_mmu_mode()
		...
		arch_leave_lazy_mmu_mode()
	...
	arch_leave_lazy_mmu_mode()

It seems fair to say that nested calls to
arch_{enter,leave}_lazy_mmu_mode() were not expected, and most
architectures never explicitly supported it.

Nesting does in fact occur in certain configurations, and avoiding it has
proved difficult.  This series therefore enables lazy_mmu sections to
nest, on all architectures.

Nesting is handled using a counter in task_struct (patch 8), like other
stateless APIs such as pagefault_{disable,enable}().  This is fully
handled in a new generic layer in <linux/pgtable.h>; the arch_* API
remains unchanged.  A new pair of calls, lazy_mmu_mode_{pause,resume}(),
is also introduced to allow functions that are called with the lazy MMU
mode enabled to temporarily pause it, regardless of nesting.

An arch now opts in to using the lazy MMU mode by selecting
CONFIG_ARCH_LAZY_MMU; this is more appropriate now that we have a generic
API, especially with state conditionally added to task_struct.


This patch (of 14):

Since commit b9ef323ea168 ("powerpc/64s: Disable preemption in hash lazy
mmu mode") a task can not be preempted while in lazy MMU mode.  Therefore,
the batch re-activation code is never called, so remove it.

Link: https://lkml.kernel.org/r/20251215150323.2218608-1-kevin.brodsky@arm.com
Link: https://lkml.kernel.org/r/20251215150323.2218608-2-kevin.brodsky@arm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: levi.yun <yeoreum.yun@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/thread_info.h |    2 -
 arch/powerpc/kernel/process.c          |   25 -----------------------
 2 files changed, 27 deletions(-)

--- a/arch/powerpc/include/asm/thread_info.h~powerpc-64s-do-not-re-activate-batched-tlb-flush
+++ a/arch/powerpc/include/asm/thread_info.h
@@ -154,12 +154,10 @@ void arch_setup_new_exec(void);
 /* Don't move TLF_NAPPING without adjusting the code in entry_32.S */
 #define TLF_NAPPING		0	/* idle thread enabled NAP mode */
 #define TLF_SLEEPING		1	/* suspend code enabled SLEEP mode */
-#define TLF_LAZY_MMU		3	/* tlb_batch is active */
 #define TLF_RUNLATCH		4	/* Is the runlatch enabled? */
 
 #define _TLF_NAPPING		(1 << TLF_NAPPING)
 #define _TLF_SLEEPING		(1 << TLF_SLEEPING)
-#define _TLF_LAZY_MMU		(1 << TLF_LAZY_MMU)
 #define _TLF_RUNLATCH		(1 << TLF_RUNLATCH)
 
 #ifndef __ASSEMBLER__
--- a/arch/powerpc/kernel/process.c~powerpc-64s-do-not-re-activate-batched-tlb-flush
+++ a/arch/powerpc/kernel/process.c
@@ -1281,9 +1281,6 @@ struct task_struct *__switch_to(struct t
 {
 	struct thread_struct *new_thread, *old_thread;
 	struct task_struct *last;
-#ifdef CONFIG_PPC_64S_HASH_MMU
-	struct ppc64_tlb_batch *batch;
-#endif
 
 	new_thread = &new->thread;
 	old_thread = &current->thread;
@@ -1291,14 +1288,6 @@ struct task_struct *__switch_to(struct t
 	WARN_ON(!irqs_disabled());
 
 #ifdef CONFIG_PPC_64S_HASH_MMU
-	batch = this_cpu_ptr(&ppc64_tlb_batch);
-	if (batch->active) {
-		current_thread_info()->local_flags |= _TLF_LAZY_MMU;
-		if (batch->index)
-			__flush_tlb_pending(batch);
-		batch->active = 0;
-	}
-
 	/*
 	 * On POWER9 the copy-paste buffer can only paste into
 	 * foreign real addresses, so unprivileged processes can not
@@ -1369,20 +1358,6 @@ struct task_struct *__switch_to(struct t
 	 */
 
 #ifdef CONFIG_PPC_BOOK3S_64
-#ifdef CONFIG_PPC_64S_HASH_MMU
-	/*
-	 * This applies to a process that was context switched while inside
-	 * arch_enter_lazy_mmu_mode(), to re-activate the batch that was
-	 * deactivated above, before _switch(). This will never be the case
-	 * for new tasks.
-	 */
-	if (current_thread_info()->local_flags & _TLF_LAZY_MMU) {
-		current_thread_info()->local_flags &= ~_TLF_LAZY_MMU;
-		batch = this_cpu_ptr(&ppc64_tlb_batch);
-		batch->active = 1;
-	}
-#endif
-
 	/*
 	 * Math facilities are masked out of the child MSR in copy_thread.
 	 * A new task does not need to restore_math because it will
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are


