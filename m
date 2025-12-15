Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EC130FC1F
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765819028; cv=none; b=KenYgWCYp0ZD+qBAHVLT9NK8RzTRtHPyh4lMLWNBPeipSZJtl0mqUtjMyJJVohhE+FZD61PFHU3IkQ3ggCbQgZZElaR2D4lJT2uVgUNebAYy5xCE/qrK5bgrKM94X2zi/HKoTlHFJiTGbSp35Ju/eif4tzxBJRxdByV9eXBRrsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765819028; c=relaxed/simple;
	bh=/SsivJkcM77PjWSKeZRdKNFx3ce0kgk/4sv2UTIrePU=;
	h=Date:To:From:Subject:Message-Id; b=TzX/krJFY3Z/TwgHhSXfHtuY9XymQNBVIcsUePXPWq4cmDFpmdSspgzxW6wTXUTCf5fJsC2dOp7sof4tkHChtwaZ/lTf/UpS6xUngHU5F9riN/T1ZSu+UI0WZZoq6QBQHmlXhArm+vGjoTu9+HHfqoEAU1ikc7JJdUk/ld8GgbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sFegzwYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sFegzwYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D321CC4CEF5;
	Mon, 15 Dec 2025 17:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765819027;
	bh=/SsivJkcM77PjWSKeZRdKNFx3ce0kgk/4sv2UTIrePU=;
	h=Date:To:From:Subject:From;
	b=sFegzwYSopDXjPuLPR+MQbjRvkwNWUtmyT+1epDGujPP/dbYWoX7e0/5sBeiYeHGG
	 7ZF/8QRP2o1mCIFCS01qCGb7nNtb5lftaNnm9nFfTSqeVEhIBnFe+iy2lmYee2XPTK
	 1oWpQ5HrJSYB9mqbi1pxkQdETWN2RwWwSydQUYxM=
Date: Mon, 15 Dec 2025 09:17:07 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-xen-use-lazy_mmu_state-when-context-switching.patch added to mm-new branch
Message-Id: <20251215171707.D321CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/xen: use lazy_mmu_state when context-switching
has been added to the -mm mm-new branch.  Its filename is
     x86-xen-use-lazy_mmu_state-when-context-switching.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-xen-use-lazy_mmu_state-when-context-switching.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: x86/xen: use lazy_mmu_state when context-switching
Date: Mon, 15 Dec 2025 15:03:22 +0000

We currently set a TIF flag when scheduling out a task that is in lazy MMU
mode, in order to restore it when the task is scheduled again.

The generic lazy_mmu layer now tracks whether a task is in lazy MMU mode
in task_struct::lazy_mmu_state.  We can therefore check that state when
switching to the new task, instead of using a separate TIF flag.

Link: https://lkml.kernel.org/r/20251215150323.2218608-14-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/thread_info.h |    4 +---
 arch/x86/xen/enlighten_pv.c        |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/thread_info.h~x86-xen-use-lazy_mmu_state-when-context-switching
+++ a/arch/x86/include/asm/thread_info.h
@@ -100,8 +100,7 @@ struct thread_info {
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_SINGLESTEP		25	/* reenable singlestep on user return*/
 #define TIF_BLOCKSTEP		26	/* set when we want DEBUGCTLMSR_BTF */
-#define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
-#define TIF_ADDR32		28	/* 32-bit address space on 64 bits */
+#define TIF_ADDR32		27	/* 32-bit address space on 64 bits */
 
 #define _TIF_SSBD		BIT(TIF_SSBD)
 #define _TIF_SPEC_IB		BIT(TIF_SPEC_IB)
@@ -114,7 +113,6 @@ struct thread_info {
 #define _TIF_FORCED_TF		BIT(TIF_FORCED_TF)
 #define _TIF_BLOCKSTEP		BIT(TIF_BLOCKSTEP)
 #define _TIF_SINGLESTEP		BIT(TIF_SINGLESTEP)
-#define _TIF_LAZY_MMU_UPDATES	BIT(TIF_LAZY_MMU_UPDATES)
 #define _TIF_ADDR32		BIT(TIF_ADDR32)
 
 /* flags to check in __switch_to() */
--- a/arch/x86/xen/enlighten_pv.c~x86-xen-use-lazy_mmu_state-when-context-switching
+++ a/arch/x86/xen/enlighten_pv.c
@@ -426,7 +426,6 @@ static void xen_start_context_switch(str
 
 	if (this_cpu_read(xen_lazy_mode) == XEN_LAZY_MMU) {
 		arch_leave_lazy_mmu_mode();
-		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU_UPDATES);
 	}
 	enter_lazy(XEN_LAZY_CPU);
 }
@@ -437,7 +436,7 @@ static void xen_end_context_switch(struc
 
 	xen_mc_flush();
 	leave_lazy(XEN_LAZY_CPU);
-	if (test_and_clear_ti_thread_flag(task_thread_info(next), TIF_LAZY_MMU_UPDATES))
+	if (__task_lazy_mmu_mode_active(next))
 		arch_enter_lazy_mmu_mode();
 }
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

x86-xen-simplify-flush_lazy_mmu.patch
powerpc-mm-implement-arch_flush_lazy_mmu_mode.patch
sparc-mm-implement-arch_flush_lazy_mmu_mode.patch
mm-clarify-lazy_mmu-sleeping-constraints.patch
mm-introduce-config_arch_has_lazy_mmu_mode.patch
mm-introduce-generic-lazy_mmu-helpers.patch
mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch
mm-enable-lazy_mmu-sections-to-nest.patch
arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch
powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
sparc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
x86-xen-use-lazy_mmu_state-when-context-switching.patch
mm-add-basic-tests-for-lazy_mmu.patch

