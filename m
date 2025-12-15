Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318B4337B8D
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765819013; cv=none; b=LU8ZVPLGid7QmtuxrOVlX6TUZ1aysXg5A7X1BPir2Pn8RyEmlCF0K/VdHvk6lJRdBsCB/JmTVwOAwtO0kt749HosO9UyArjVOL9MtrU+/VVrsFzcQ8tODgZvOrPx5JN5t2HDFch6yChBvTPLNIB/jmQpBuNpBqtnOp6A3iEgsyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765819013; c=relaxed/simple;
	bh=nBMunvZN9nfF2ZI83xCefG1kCDFKWWnFlIG5y0J+ml4=;
	h=Date:To:From:Subject:Message-Id; b=Cbv72aUMspyknmiwe4JYyOezJB15aqhRKAKRIzpvu5Xgx9P+4XNf7bEjS+yfW9YAybZI3TvKssX9HBHTI9Sdh1zcjnm3+HNWLMqvwoAd00dhqp2f8QmN+42N5O4l9ToKrHchT3DtMRyNBXJUMczqRbSWLj4x3J76JZS3FbXxsco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZMaRggem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZMaRggem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9DEC4CEF5;
	Mon, 15 Dec 2025 17:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765819012;
	bh=nBMunvZN9nfF2ZI83xCefG1kCDFKWWnFlIG5y0J+ml4=;
	h=Date:To:From:Subject:From;
	b=ZMaRggemdqphz1VsVwq3WqSr8VP/qeZ9zs5hn6gzYEeWvT3nAw7e25p5bT3AOn0hh
	 hrxrWhJFl2FbeFUKfI7IwNV+L+62ATiRsgib1iUmULcDIveUU8Q95aTPuh2WH5p3+i
	 yRHNEu/S1iPNZvs0PYEfoZvsmasiBM85H9zpA2jQ=
Date: Mon, 15 Dec 2025 09:16:51 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch added to mm-new branch
Message-Id: <20251215171652.7A9DEC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: bail out of lazy_mmu_mode_* in interrupt context
has been added to the -mm mm-new branch.  Its filename is
     mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch

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

