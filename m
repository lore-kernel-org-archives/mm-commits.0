Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12A522D7A1
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 02:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757384652; cv=none; b=KHXQs6TdvY40V2/nWWOyWVXoBfVSr2qMuJhEctdjB3Exy4pRqerNIBtK3LK7Gu1uTjEQeDV/KwcjCco0STnkPmfYxxTEbU2KwolxXVnIlTCD08laoYRw5sV7YaiXFYncV16bpB2qSOw0DGGw2mb2IPk4nKqssqLkV8wL96eJ+6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757384652; c=relaxed/simple;
	bh=mydyxdgvjDDZv2xaJGw77ro0bvs1RRPetRSi1GcMHuc=;
	h=Date:To:From:Subject:Message-Id; b=Xhu9d4Nz+1PxuyMmPJphQH82pSPr4cOA9W/hQNgw5sK+HlP/uMpbzwUIBLlS01byNMDo7MV3YK4JyXeCZIdwvYyBkkRM9T1HLC76XimYS4oHpGjReGBlcwpPotW+bwfh8xSQ+WRuLkrcv3azqJpgLRTstNHUxugczwUg5nyHPXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qGK25HML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qGK25HML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630DEC4CEF1;
	Tue,  9 Sep 2025 02:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757384651;
	bh=mydyxdgvjDDZv2xaJGw77ro0bvs1RRPetRSi1GcMHuc=;
	h=Date:To:From:Subject:From;
	b=qGK25HMLbCPtxVYyeBMxzFqdYEbXOg/6K5SMdlfLFYeBlu8Do2Zxj6Oh0gqMNaVvM
	 NSQoTCxzaTEAwBl9zaeVnuEJ0L+SB4K2dM54oMA29Tlv8Lh0w/fcXhs1s3PAwpRF0c
	 73+6DnU7YwaFzx2psZ+XLsyeXjZTHqGi9xut+neU=
Date: Mon, 08 Sep 2025 19:24:10 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-support-nested-lazy_mmu-sections.patch added to mm-new branch
Message-Id: <20250909022411.630DEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc/mm: support nested lazy_mmu sections
has been added to the -mm mm-new branch.  Its filename is
     sparc-mm-support-nested-lazy_mmu-sections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-mm-support-nested-lazy_mmu-sections.patch

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
Subject: sparc/mm: support nested lazy_mmu sections
Date: Mon, 8 Sep 2025 08:39:30 +0100

The lazy_mmu API now allows nested sections to be handled by arch code:
enter() can return a flag if called inside another lazy_mmu section, so
that the matching call to leave() leaves any optimisation enabled.

This patch implements that new logic for sparc: if there is an active
batch, then enter() returns LAZY_MMU_NESTED and the matching leave()
leaves batch->active set.  The preempt_{enable,disable} calls are left
untouched as they already handle nesting themselves.

TLB flushing is still done in leave() regardless of the nesting level, as
the caller may rely on it whether nesting is occurring or not.

Link: https://lkml.kernel.org/r/20250908073931.4159362-7-kevin.brodsky@arm.com
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

 arch/sparc/mm/tlb.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/arch/sparc/mm/tlb.c~sparc-mm-support-nested-lazy_mmu-sections
+++ a/arch/sparc/mm/tlb.c
@@ -56,9 +56,13 @@ lazy_mmu_state_t arch_enter_lazy_mmu_mod
 
 	preempt_disable();
 	tb = this_cpu_ptr(&tlb_batch);
-	tb->active = 1;
 
-	return LAZY_MMU_DEFAULT;
+	if (!tb->active) {
+		tb->active = 1;
+		return LAZY_MMU_DEFAULT;
+	} else {
+		return LAZY_MMU_NESTED;
+	}
 }
 
 void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
@@ -67,7 +71,10 @@ void arch_leave_lazy_mmu_mode(lazy_mmu_s
 
 	if (tb->tlb_nr)
 		flush_tlb_pending();
-	tb->active = 0;
+
+	if (state != LAZY_MMU_NESTED)
+		tb->active = 0;
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

