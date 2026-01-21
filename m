Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB8727FB28
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966008; cv=none; b=CUtkIF5P5qKc5jxz5js3RqwQfxdRghgWt7RL3symjjSCwjChE405ryakrKjLnSdOGAYCAJc1fA48Ruc2hJkprZEwCs4kU2FMsN7ehPViYQbfR6gASqHLa/s4S1PjNgyNWwvseoqlTQM1U29Z4x/jyf9iRVBpVv1YsXmSdkcM21Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966008; c=relaxed/simple;
	bh=3mMJJYGeUgkHhkbK7trNh2bH6MF7kkrib6yQ/Sex6Z4=;
	h=Date:To:From:Subject:Message-Id; b=FrjIeK/h+2d11LvwsBBJCNzM6Ov6wMio4NnVCR20CeccRrXlENN7pFqy0c40po9hzjf3R4DkQp0YYgwqQXnW/GPKSKQDvG4MwGI6EOyxCSzTpHhDCj80CCokL07ApYb2Iph9JSNtZzVy6CxfjZ183+sDsFE2Rct9EWwy0ND9Eic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M81CYHwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M81CYHwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA23C16AAE;
	Wed, 21 Jan 2026 03:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966008;
	bh=3mMJJYGeUgkHhkbK7trNh2bH6MF7kkrib6yQ/Sex6Z4=;
	h=Date:To:From:Subject:From;
	b=M81CYHwCMcxe+ZUprBD0QGko3QWn+fNl51p9gzt2QltT1bS2kVNX8EaKS4//4qX/S
	 hGRgUyajnV3udY8Tskv9O/ERk5ujEPgLIQv2ei30BTiisA6OWkBRerECX+/ZD+8bpU
	 qD35milRA3zzkdH3DuOVLZ94OtM4CCdJoEIFmi5U=
Date: Tue, 20 Jan 2026 19:26:48 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch removed from -mm tree
Message-Id: <20260121032648.7EA23C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: replace TIF_LAZY_MMU with is_lazy_mmu_mode_active()
has been removed from the -mm tree.  Its filename was
     arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

