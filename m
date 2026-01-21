Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB6235C180
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966010; cv=none; b=WV/xOL8YhkiB6Ta+41orbGpPO37KgZyXYbyXw1+hlEX1th7zo2cLYC8Hw4oQqu6ddVKQJMJydX4/2yC4MbPMBfq0eY6/fVNp2DypK+goqdlLkVzylmqxmGRouWNnxxQb1JhZ1tSs3j1NbptdY2wR4y5zh+smOjALdKVC84zOquM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966010; c=relaxed/simple;
	bh=QYyvNzlyr6SaTE37QYuySMiauOZ9Cf3gq1IXzoQfyj8=;
	h=Date:To:From:Subject:Message-Id; b=tw1DwXWY/Kc0fjZIP3rODVAArPu4wekhnbituQ9LGFrATmiHIhn5KHFpNceuq6sXf4N7sKgt3sXQHEurcI/lOR9KpJOmRQVwBlZSZZTLY3kbaL+I4FPf+5seCzxlUD00ZPiITTmEcZ8/0OoB9sQeCABDcdWOLRTQGwbcE5e+DBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HVY7YE2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HVY7YE2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19766C19423;
	Wed, 21 Jan 2026 03:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966010;
	bh=QYyvNzlyr6SaTE37QYuySMiauOZ9Cf3gq1IXzoQfyj8=;
	h=Date:To:From:Subject:From;
	b=HVY7YE2Hh2ip1gYsbAIZY1JIMLjXKu3oAGgkTkNszzxRVVw1uo2M6f7Bq1fzl8jhf
	 rczCJr9pjW8XWfbNMhsWsyQYOozHa7ys30zvhfoiwkVGCRU3vWcSmzuwIIL6xEueMo
	 vIbucyigwbX3q517rO0AssSpND5LYXRboMUp+KfU=
Date: Tue, 20 Jan 2026 19:26:49 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch removed from -mm tree
Message-Id: <20260121032650.19766C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/mm: replace batch->active with is_lazy_mmu_mode_active()
has been removed from the -mm tree.  Its filename was
     powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

