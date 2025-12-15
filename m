Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C750B32D0DE
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 17:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765819022; cv=none; b=Ojw35h8+E6QwSJtElVIMP1us4lmbpzm73ESH647eNi9rH7pwUoheuAu1O0ZI93idO7+InwGTz+/DfRkUTTnsvK2SFyeynjsEWqSPSa+LbH37rBRdrZpQ13jXB980DFVg1zBn6fh4v78HChxG9GraSajTRNrGVKhmPGMdFrGhTmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765819022; c=relaxed/simple;
	bh=W5ldfUuB6UENFYogX0OxS1ivQm8IoLAGQ0mCuzGiY4w=;
	h=Date:To:From:Subject:Message-Id; b=EIs4rwV11/KAWjxGSt96H9Or1VFe8XUJvXhpT9nDXmSTKnz4FDI/LD26OFDQWNj2UbSOfLVrw4SDywlWM7thNpt3q343axgm+XdCF5jHMakcDZFf/sy5g9ZajWNpasyaij63DcEME64zkQTdzKG0Aa7DXkL3mS9STg5eYZUPRcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iiM7MHjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iiM7MHjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DB8C4CEF5;
	Mon, 15 Dec 2025 17:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765819022;
	bh=W5ldfUuB6UENFYogX0OxS1ivQm8IoLAGQ0mCuzGiY4w=;
	h=Date:To:From:Subject:From;
	b=iiM7MHjMcPEZpG2OvKkqGWcPkAzR+yW/3dpypX56DtAktS99BO351ISahOgA5z2k/
	 mlGH41No4m+Yw9O82rloAdmfcCd2ZgvPB5Y5euUTh+vYrBwUMsem79MsXJG+iJs/J5
	 kJWdSgZ+EkYIHrY8CbBGg9NjPtoDswTOzSG/aoF0=
Date: Mon, 15 Dec 2025 09:17:01 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch added to mm-new branch
Message-Id: <20251215171702.47DB8C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/mm: replace batch->active with is_lazy_mmu_mode_active()
has been added to the -mm mm-new branch.  Its filename is
     powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch

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
Subject: powerpc/mm: replace batch->active with is_lazy_mmu_mode_active()
Date: Mon, 15 Dec 2025 15:03:20 +0000

A per-CPU batch struct is activated when entering lazy MMU mode; its
lifetime is the same as the lazy MMU section (it is deactivated when
leaving the mode).  Preemption is disabled in that interval to ensure that
the per-CPU reference remains valid.

The generic lazy_mmu layer now tracks whether a task is in lazy MMU mode. 
We can therefore use the generic helper is_lazy_mmu_mode_active() to tell
whether a batch struct is active instead of tracking it explicitly.

Link: https://lkml.kernel.org/r/20251215150323.2218608-12-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h |    9 ---------
 arch/powerpc/mm/book3s64/hash_tlb.c                |    2 +-
 2 files changed, 1 insertion(+), 10 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h~powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active
+++ a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -12,7 +12,6 @@
 #define PPC64_TLB_BATCH_NR 192
 
 struct ppc64_tlb_batch {
-	int			active;
 	unsigned long		index;
 	struct mm_struct	*mm;
 	real_pte_t		pte[PPC64_TLB_BATCH_NR];
@@ -26,8 +25,6 @@ extern void __flush_tlb_pending(struct p
 
 static inline void arch_enter_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch;
-
 	if (radix_enabled())
 		return;
 	/*
@@ -35,8 +32,6 @@ static inline void arch_enter_lazy_mmu_m
 	 * operating on kernel page tables.
 	 */
 	preempt_disable();
-	batch = this_cpu_ptr(&ppc64_tlb_batch);
-	batch->active = 1;
 }
 
 static inline void arch_flush_lazy_mmu_mode(void)
@@ -53,14 +48,10 @@ static inline void arch_flush_lazy_mmu_m
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch;
-
 	if (radix_enabled())
 		return;
-	batch = this_cpu_ptr(&ppc64_tlb_batch);
 
 	arch_flush_lazy_mmu_mode();
-	batch->active = 0;
 	preempt_enable();
 }
 
--- a/arch/powerpc/mm/book3s64/hash_tlb.c~powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active
+++ a/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -100,7 +100,7 @@ void hpte_need_flush(struct mm_struct *m
 	 * Check if we have an active batch on this CPU. If not, just
 	 * flush now and return.
 	 */
-	if (!batch->active) {
+	if (!is_lazy_mmu_mode_active()) {
 		flush_hash_page(vpn, rpte, psize, ssize, mm_is_thread_local(mm));
 		put_cpu_var(ppc64_tlb_batch);
 		return;
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

