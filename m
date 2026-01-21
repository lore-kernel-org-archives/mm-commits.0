Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ADD3587BC
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966005; cv=none; b=NcB6KA5N0mdbHAwa5GL7yPP7qpJ3vGooLu+jiK/tv+KH/1ep6dSIJ/0al3PMQqQBhMTaDwm/cznlTOVOAt+/DVQWtEQWsLHKFd2+qknXQUe88485gXyjyFjXDLMcMp0/bIOHkS2ZyJjze4aXF0L7Rxa58M7B8IH3+HRC3IuRwNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966005; c=relaxed/simple;
	bh=XurQPQgKFM9Agz+HZGyx+Zcjmg3llmj6wTnLbgQo5IQ=;
	h=Date:To:From:Subject:Message-Id; b=mzTdB5n2lBdNwOVjCJzv7WB03ozF6/FP8sMmp0q68Q3OA29EaPLFlXHR2yGwWTw3PBXcsIfPT6XNRLsmDMbMzK4s/yG/cW/FY8oTmup8zzrWSnCkK3RmvoPmlf302xwdMoOi4IvMw9zuyuI9rkEvKvnxAdCur2gLzksEH/jfGXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oht46eJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oht46eJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFF9C16AAE;
	Wed, 21 Jan 2026 03:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966005;
	bh=XurQPQgKFM9Agz+HZGyx+Zcjmg3llmj6wTnLbgQo5IQ=;
	h=Date:To:From:Subject:From;
	b=oht46eJeG5eeK/3670IXujBfJQLx2Vj52DT3BH0aF7al3P0r/3HqQj3S1wtR1ILDF
	 g852t2lYYHyOCBNYK8MoWm9GIeQYUEXHDK++3InTwZkoNnrK9Yp3GCjz8M9vULC3nC
	 dqiTpnuwictuDT8N4a8jEXeliiDAPRnpAsYh6ub8=
Date: Tue, 20 Jan 2026 19:26:44 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch removed from -mm tree
Message-Id: <20260121032645.2DFF9C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: bail out of lazy_mmu_mode_* in interrupt context
has been removed from the -mm tree.  Its filename was
     mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm: bail out of lazy_mmu_mode_* in interrupt context
Date: Mon, 15 Dec 2025 15:03:17 +0000

The lazy MMU mode cannot be used in interrupt context.  This is documented
in <linux/pgtable.h>, but isn't consistently handled across architectures.

arm64 ensures that calls to lazy_mmu_mode_* have no effect in interrupt
context, because such calls do occur in certain configurations - see
commit b81c688426a9 ("arm64/mm: Disable barrier batching in interrupt
contexts").  Other architectures do not check this situation, most likely
because it hasn't occurred so far.

Let's handle this in the new generic lazy_mmu layer, in the same fashion
as arm64: bail out of lazy_mmu_mode_* if in_interrupt().  Also remove the
arm64 handling that is now redundant.

Both arm64 and x86/Xen also ensure that any lazy MMU optimisation is
disabled while in interrupt (see queue_pte_barriers() and
xen_get_lazy_mode() respectively).  This will be handled in the generic
layer in a subsequent patch.

Link: https://lkml.kernel.org/r/20251215150323.2218608-9-kevin.brodsky@arm.com
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

 arch/arm64/include/asm/pgtable.h |    9 ---------
 include/linux/pgtable.h          |   17 ++++++++++++++++-
 2 files changed, 16 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context
+++ a/arch/arm64/include/asm/pgtable.h
@@ -94,26 +94,17 @@ static inline void arch_enter_lazy_mmu_m
 	 * keeps tracking simple.
 	 */
 
-	if (in_interrupt())
-		return;
-
 	set_thread_flag(TIF_LAZY_MMU);
 }
 
 static inline void arch_flush_lazy_mmu_mode(void)
 {
-	if (in_interrupt())
-		return;
-
 	if (test_and_clear_thread_flag(TIF_LAZY_MMU_PENDING))
 		emit_pte_barriers();
 }
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
-	if (in_interrupt())
-		return;
-
 	arch_flush_lazy_mmu_mode();
 	clear_thread_flag(TIF_LAZY_MMU);
 }
--- a/include/linux/pgtable.h~mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context
+++ a/include/linux/pgtable.h
@@ -233,26 +233,41 @@ static inline int pmd_dirty(pmd_t pmd)
  * preemption, as a consequence generic code may not sleep while the lazy MMU
  * mode is active.
  *
- * Nesting is not permitted and the mode cannot be used in interrupt context.
+ * The mode is disabled in interrupt context and calls to the lazy_mmu API have
+ * no effect.
+ *
+ * Nesting is not permitted.
  */
 #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
 static inline void lazy_mmu_mode_enable(void)
 {
+	if (in_interrupt())
+		return;
+
 	arch_enter_lazy_mmu_mode();
 }
 
 static inline void lazy_mmu_mode_disable(void)
 {
+	if (in_interrupt())
+		return;
+
 	arch_leave_lazy_mmu_mode();
 }
 
 static inline void lazy_mmu_mode_pause(void)
 {
+	if (in_interrupt())
+		return;
+
 	arch_leave_lazy_mmu_mode();
 }
 
 static inline void lazy_mmu_mode_resume(void)
 {
+	if (in_interrupt())
+		return;
+
 	arch_enter_lazy_mmu_mode();
 }
 #else
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

