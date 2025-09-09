Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5742236F0
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 02:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757384649; cv=none; b=Jtlm2VhJwHIhG1feueTKtH8/RAnGywxJsbGNGmyjUKZun+EwkSwtbTGrpuPebvHznqNfmEPRVQpALd9f26wESo33dzAYUossIVmI2tDdLJsefdMYhVTbQV4k1DpyyjSdVIGebSWAmA9IOBiT0zzsY8av98t/l/WxdZQYLY5u6Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757384649; c=relaxed/simple;
	bh=CKEkeJbXo66lhYKq73Xms6/83qQ6/fZxICumDq/gHGc=;
	h=Date:To:From:Subject:Message-Id; b=dMcXrVVYbAFZGKew9lA43Y7feHJNLYmgy9Rxakior5V1FaShpuX8RHiAhqRib3Ys0M/gI4VQkIHCRUGioW0GUVmZ/2oIKfBrR5vNMKwDbwlpQd68jFu35lWaBeS7vZxUc1SKQwQJ5mYjvqkgq/uXYr35W9JBZIVfek9/7gxPjW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ygbNx2TM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ygbNx2TM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26002C4CEF1;
	Tue,  9 Sep 2025 02:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757384649;
	bh=CKEkeJbXo66lhYKq73Xms6/83qQ6/fZxICumDq/gHGc=;
	h=Date:To:From:Subject:From;
	b=ygbNx2TM8lQfR1xSRRykSfbQm0dFn0nN5lYe/vJ5kjT2GHB/AlJK+6lT/sIJl2SId
	 1jXBCqxfinPAIijIwtPRMck197mgV7BNW/Mpr4p9hWZ2bHtMY3Fx22hpfdBsmuwbH5
	 WQyon6iVCOm9YBqj1enGxXEhmaUbx+ZAaQeIjKVA=
Date: Mon, 08 Sep 2025 19:24:08 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-support-nested-lazy_mmu-sections.patch added to mm-new branch
Message-Id: <20250909022409.26002C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/mm: support nested lazy_mmu sections
has been added to the -mm mm-new branch.  Its filename is
     powerpc-mm-support-nested-lazy_mmu-sections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-support-nested-lazy_mmu-sections.patch

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
Subject: powerpc/mm: support nested lazy_mmu sections
Date: Mon, 8 Sep 2025 08:39:29 +0100

The lazy_mmu API now allows nested sections to be handled by arch code:
enter() can return a flag if called inside another lazy_mmu section, so
that the matching call to leave() leaves any optimisation enabled.

This patch implements that new logic for powerpc: if there is an active
batch, then enter() returns LAZY_MMU_NESTED and the matching leave()
leaves batch->active set.  The preempt_{enable,disable} calls are left
untouched as they already handle nesting themselves.

TLB flushing is still done in leave() regardless of the nesting level, as
the caller may rely on it whether nesting is occurring or not.

Link: https://lkml.kernel.org/r/20250908073931.4159362-6-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
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
Cc: levi.yun <yeoreum.yun@arm.com>
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

 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h |   13 ++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h~powerpc-mm-support-nested-lazy_mmu-sections
+++ a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -39,9 +39,13 @@ static inline lazy_mmu_state_t arch_ente
 	 */
 	preempt_disable();
 	batch = this_cpu_ptr(&ppc64_tlb_batch);
-	batch->active = 1;
 
-	return LAZY_MMU_DEFAULT;
+	if (!batch->active) {
+		batch->active = 1;
+		return LAZY_MMU_DEFAULT;
+	} else {
+		return LAZY_MMU_NESTED;
+	}
 }
 
 static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
@@ -54,7 +58,10 @@ static inline void arch_leave_lazy_mmu_m
 
 	if (batch->index)
 		__flush_tlb_pending(batch);
-	batch->active = 0;
+
+	if (state != LAZY_MMU_NESTED)
+		batch->active = 0;
+
 	preempt_enable();
 }
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

mm-remove-arch_flush_lazy_mmu_mode.patch
mm-introduce-local-state-for-lazy_mmu-sections.patch
arm64-mm-fully-support-nested-lazy_mmu-sections.patch
x86-xen-support-nested-lazy_mmu-sections-again.patch
powerpc-mm-support-nested-lazy_mmu-sections.patch
sparc-mm-support-nested-lazy_mmu-sections.patch
mm-update-lazy_mmu-documentation.patch

