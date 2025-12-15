Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7F415E97
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 17:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765819021; cv=none; b=n9R6ef44OBuX4pFXXySJS69rcgQ94m4KcnydllSzyatjC+WVxiQ/T9jRIYS4Y3trjJ2d5r0O2pP56hiSyOeyUi/sdZixnUqMEvNcN4Lq491qg/clWxlU8k5J6oQ9AYMXRAuHGd2QJi7VJJa3gtbQ8v2ozIq9VI/JNlbYKwKebrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765819021; c=relaxed/simple;
	bh=bNyfqICqc8yfFszx49L+FtLmF3Xv2LBy1jtJg9Nbyp4=;
	h=Date:To:From:Subject:Message-Id; b=Z3u1V34PxvJri6Oq0CBW2NkNtRWxUNpVgCJvnlZLunB2BNOa0+D8nqtldjO0XCq9l5ILw3oIbdpwnUXVErXofh8sou0KZMs7zgJznoDuWsBncP4aQVSgY38TzEvW53lWoWglJJsByQsLO9A/DWwjCFQxNLWPASG7D1o3wd1IX6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QFM6D8wC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QFM6D8wC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6926EC4CEF5;
	Mon, 15 Dec 2025 17:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765819019;
	bh=bNyfqICqc8yfFszx49L+FtLmF3Xv2LBy1jtJg9Nbyp4=;
	h=Date:To:From:Subject:From;
	b=QFM6D8wCHJhAVxC4UYA8WaLAB+K+zzCv+/6jKsHraUAwZr4rJ/jv2KRHDQ7wpWUrw
	 ngyPhrxBru7go1ovOwptsT9mMA/ziwzr4QB+Tl11dSvzQeCTaIOXYSTEPRkGkiZfHi
	 2CtJBYBHbmQ73RBdm66JDKrtpwUo2Riw5MkecRUM=
Date: Mon, 15 Dec 2025 09:16:58 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch added to mm-new branch
Message-Id: <20251215171659.6926EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: replace TIF_LAZY_MMU with is_lazy_mmu_mode_active()
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch

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
Subject: arm64: mm: replace TIF_LAZY_MMU with is_lazy_mmu_mode_active()
Date: Mon, 15 Dec 2025 15:03:19 +0000

The generic lazy_mmu layer now tracks whether a task is in lazy MMU mode. 
As a result we no longer need a TIF flag for that purpose - let's use the
new is_lazy_mmu_mode_active() helper instead.

The explicit check for in_interrupt() is no longer necessary either as
is_lazy_mmu_mode_active() always returns false in interrupt context.

Link: https://lkml.kernel.org/r/20251215150323.2218608-11-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
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
Cc: Juegren Gross <jgross@suse.com>
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

 arch/arm64/include/asm/pgtable.h     |   19 +++----------------
 arch/arm64/include/asm/thread_info.h |    3 +--
 2 files changed, 4 insertions(+), 18 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active
+++ a/arch/arm64/include/asm/pgtable.h
@@ -62,28 +62,16 @@ static inline void emit_pte_barriers(voi
 
 static inline void queue_pte_barriers(void)
 {
-	unsigned long flags;
-
-	if (in_interrupt()) {
-		emit_pte_barriers();
-		return;
-	}
-
-	flags = read_thread_flags();
-
-	if (flags & BIT(TIF_LAZY_MMU)) {
+	if (is_lazy_mmu_mode_active()) {
 		/* Avoid the atomic op if already set. */
-		if (!(flags & BIT(TIF_LAZY_MMU_PENDING)))
+		if (!test_thread_flag(TIF_LAZY_MMU_PENDING))
 			set_thread_flag(TIF_LAZY_MMU_PENDING);
 	} else {
 		emit_pte_barriers();
 	}
 }
 
-static inline void arch_enter_lazy_mmu_mode(void)
-{
-	set_thread_flag(TIF_LAZY_MMU);
-}
+static inline void arch_enter_lazy_mmu_mode(void) {}
 
 static inline void arch_flush_lazy_mmu_mode(void)
 {
@@ -94,7 +82,6 @@ static inline void arch_flush_lazy_mmu_m
 static inline void arch_leave_lazy_mmu_mode(void)
 {
 	arch_flush_lazy_mmu_mode();
-	clear_thread_flag(TIF_LAZY_MMU);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
--- a/arch/arm64/include/asm/thread_info.h~arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active
+++ a/arch/arm64/include/asm/thread_info.h
@@ -84,8 +84,7 @@ void arch_setup_new_exec(void);
 #define TIF_SME_VL_INHERIT	28	/* Inherit SME vl_onexec across exec */
 #define TIF_KERNEL_FPSTATE	29	/* Task is in a kernel mode FPSIMD section */
 #define TIF_TSC_SIGSEGV		30	/* SIGSEGV on counter-timer access */
-#define TIF_LAZY_MMU		31	/* Task in lazy mmu mode */
-#define TIF_LAZY_MMU_PENDING	32	/* Ops pending for lazy mmu mode exit */
+#define TIF_LAZY_MMU_PENDING	31	/* Ops pending for lazy mmu mode exit */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
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

