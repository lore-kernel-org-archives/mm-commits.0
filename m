Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276C12236F0
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 02:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757384644; cv=none; b=nfR8DzWZVMRrnlBfgClfWgqExHFuO1xI8vOJgIDbBuFDK6GTYAlmHktO++pH9UxyBZK87EkylqfR7IGuYwv/G/wOkfku2EpSf8OImumrRarNN+8akzA0cCD7eWQUUBKnrlFod9JJSeZpbCVn/TrqVIVtHmqOWpCVeRateRjlT/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757384644; c=relaxed/simple;
	bh=w/coNQbRvQVcBglb9bj+Wbq17gw887vjfjdjL9NNz3A=;
	h=Date:To:From:Subject:Message-Id; b=IoL+K3eAN8m4ySicKp6+X/7oCfL9PHnki7aDKjUMxgT15RwAhFnRc1jjnhiR3Ve3M7ODOnwPC1O0KtWpzGApsNG39IihioT4V6n56LLkIZIblLFOQMM05sEEbONERF6zSOBCKjgv8oyfICtIA9xEZj8VIAt5nSU98ssKEC2jAvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JFilGfvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JFilGfvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF11AC4CEF1;
	Tue,  9 Sep 2025 02:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757384643;
	bh=w/coNQbRvQVcBglb9bj+Wbq17gw887vjfjdjL9NNz3A=;
	h=Date:To:From:Subject:From;
	b=JFilGfvEySwxffrP6hZKqEu26XAj0E8v2beeF5VSj/+mQwCs6Rj6bGpg3gNf9k4D0
	 Pu86XLCIFr+SAX19OcLPEFqgUqlHC9JNo3EaDk/viPKLqd/sksPlRHtfe8GGE4NHk8
	 dnVxeyni9jKm4NJOS/SeRo9DaIewU7mYIQxo3Jew=
Date: Mon, 08 Sep 2025 19:24:03 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-fully-support-nested-lazy_mmu-sections.patch added to mm-new branch
Message-Id: <20250909022403.CF11AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: fully support nested lazy_mmu sections
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-fully-support-nested-lazy_mmu-sections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-fully-support-nested-lazy_mmu-sections.patch

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
Subject: arm64: mm: fully support nested lazy_mmu sections
Date: Mon, 8 Sep 2025 08:39:27 +0100

Despite recent efforts to prevent lazy_mmu sections from nesting, it
remains difficult to ensure that it never occurs - and in fact it does
occur on arm64 in certain situations (CONFIG_DEBUG_PAGEALLOC).  Commit
1ef3095b1405 ("arm64/mm: Permit lazy_mmu_mode to be nested") made nesting
tolerable on arm64, but without truly supporting it: the inner leave()
call clears TIF_LAZY_MMU, disabling the batching optimisation before the
outer section ends.

Now that the lazy_mmu API allows enter() to pass through a state to the
matching leave() call, we can actually support nesting.  If enter() is
called inside an active lazy_mmu section, TIF_LAZY_MMU will already be
set, and we can then return LAZY_MMU_NESTED to instruct the matching
leave() call not to clear TIF_LAZY_MMU.

The only effect of this patch is to ensure that TIF_LAZY_MMU (and
therefore the batching optimisation) remains set until the outermost
lazy_mmu section ends.  leave() still emits barriers if needed, regardless
of the nesting level, as the caller may expect any page table changes to
become visible when leave() returns.

Link: https://lkml.kernel.org/r/20250908073931.4159362-4-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-fully-support-nested-lazy_mmu-sections
+++ a/arch/arm64/include/asm/pgtable.h
@@ -85,24 +85,14 @@ typedef int lazy_mmu_state_t;
 
 static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
 {
-	/*
-	 * lazy_mmu_mode is not supposed to permit nesting. But in practice this
-	 * does happen with CONFIG_DEBUG_PAGEALLOC, where a page allocation
-	 * inside a lazy_mmu_mode section (such as zap_pte_range()) will change
-	 * permissions on the linear map with apply_to_page_range(), which
-	 * re-enters lazy_mmu_mode. So we tolerate nesting in our
-	 * implementation. The first call to arch_leave_lazy_mmu_mode() will
-	 * flush and clear the flag such that the remainder of the work in the
-	 * outer nest behaves as if outside of lazy mmu mode. This is safe and
-	 * keeps tracking simple.
-	 */
+	int lazy_mmu_nested;
 
 	if (in_interrupt())
 		return LAZY_MMU_DEFAULT;
 
-	set_thread_flag(TIF_LAZY_MMU);
+	lazy_mmu_nested = test_and_set_thread_flag(TIF_LAZY_MMU);
 
-	return LAZY_MMU_DEFAULT;
+	return lazy_mmu_nested ? LAZY_MMU_NESTED : LAZY_MMU_DEFAULT;
 }
 
 static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
@@ -113,7 +103,8 @@ static inline void arch_leave_lazy_mmu_m
 	if (test_and_clear_thread_flag(TIF_LAZY_MMU_PENDING))
 		emit_pte_barriers();
 
-	clear_thread_flag(TIF_LAZY_MMU);
+	if (state != LAZY_MMU_NESTED)
+		clear_thread_flag(TIF_LAZY_MMU);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

mm-remove-arch_flush_lazy_mmu_mode.patch
mm-introduce-local-state-for-lazy_mmu-sections.patch
arm64-mm-fully-support-nested-lazy_mmu-sections.patch
x86-xen-support-nested-lazy_mmu-sections-again.patch
powerpc-mm-support-nested-lazy_mmu-sections.patch
sparc-mm-support-nested-lazy_mmu-sections.patch
mm-update-lazy_mmu-documentation.patch

