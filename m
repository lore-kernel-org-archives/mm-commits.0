Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA3E2D94A9
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966013; cv=none; b=Nmj4OTEfs8IvEG2rL922DqKTZovD4Sa6P8FgjPjHLUv+e8Q93rSZHOm59snVlODYogFljn1YDxS0mtBG6bqEKuVKZrvTIVrjvRQtcpxn3rHy9TayPs2Ls4xspILZrO7rTNW4rsn2on5JEDwSqYq6zUY0HhYC/0gL7E7soq1yxek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966013; c=relaxed/simple;
	bh=GEvTMnCM5azSNWSGRwQEBBNCcTcs6maJ8qJHgogUWLs=;
	h=Date:To:From:Subject:Message-Id; b=Z0Gyx9c54F2digLWRdeAtuBBmXmF0SAueJsKcUfyqYssit5qcBVdwCoJnTBSiRqqcNqVKqpBvQWq5mU+tVf/ynKq9Wrw2s9TMcIizgoheM6X8O9VT+u2zjvUHQGI3mFNUf/e1yG3MKcBhkuJ4AI94oxoWKUc4VCaXxSQfPEjs3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0w7pwTEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0w7pwTEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE6EC16AAE;
	Wed, 21 Jan 2026 03:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966013;
	bh=GEvTMnCM5azSNWSGRwQEBBNCcTcs6maJ8qJHgogUWLs=;
	h=Date:To:From:Subject:From;
	b=0w7pwTEjL/ekXL8WEi0pPdfPibZAsHHpPDeKy+LHxfH4nsKzKZ8WGvr6UhntqXZnH
	 rJF4GhdPfYqtKLBofoBIvvucr+o6siu3byF1v7OCe/HqbF647BKb2wkxUcAB8AhJ1S
	 1WOI54+XtFbWLOEmB7jMv+yFsONX4i4pYccizaOY=
Date: Tue, 20 Jan 2026 19:26:52 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-xen-use-lazy_mmu_state-when-context-switching.patch removed from -mm tree
Message-Id: <20260121032653.4CE6EC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/xen: use lazy_mmu_state when context-switching
has been removed from the -mm tree.  Its filename was
     x86-xen-use-lazy_mmu_state-when-context-switching.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

