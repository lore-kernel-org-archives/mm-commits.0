Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D571EEA2A;
	Mon,  3 Mar 2025 23:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741043397; cv=none; b=feFk0XEoqNdG/hJx2bfJQJaPr7aFCCHSsM4xALjOSjazYFKw/tQ5+6BTHJRuBDah8Oll9wJx4kG/hsz/j3/lrYtqjrQFWlAx95qtGg1QZGuTlFJN17G73mEQKph6a0SlZI6iF/NFhEsQawpmfk/w7rSYn05N2r97SvH6hDybC5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741043397; c=relaxed/simple;
	bh=DbCWElGiT03hiHOEbK2AKLPnfp+2YbjYBqhAXquAlcM=;
	h=Date:To:From:Subject:Message-Id; b=WK6ZxC+hyi1feMQudbzTaioLvKExI6GSBP60TDu6Qf1G5MPFpLU2n3WHng4ixvjnmT049/biV9UBIUEMKqQ6lef00XKwQaWAKyB0rQ2d7S4bX/DoxuzMOth308Hlw4c08OL81fZJ8PYokzPVZ/DnS+h8PuEpsVwKlkgT1/BhZJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I1Sc0S+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I1Sc0S+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A184C4CEE8;
	Mon,  3 Mar 2025 23:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741043397;
	bh=DbCWElGiT03hiHOEbK2AKLPnfp+2YbjYBqhAXquAlcM=;
	h=Date:To:From:Subject:From;
	b=I1Sc0S+fVuz12hWb1Ld9Ebz8GUWk7eXng6wuix6H7KpiJYsdYsn3uX4jnL8n7YJl1
	 MZh8q/tRri6uRMXx725PsibJfuZjaT+iqHfFvF2nnnDbhjScTP8GZzx6Jf5/jo9T6U
	 WUhR7A/DXXTfCw7uItEPvsqAwr9Q6r1uj8OPvWk0=
Date: Mon, 03 Mar 2025 15:09:56 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,stable@vger.kernel.org,mingo@redhat.com,jgross@suse.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-disable-preemption-in-lazy-mmu-mode.patch added to mm-unstable branch
Message-Id: <20250303230957.7A184C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc/mm: disable preemption in lazy mmu mode
has been added to the -mm mm-unstable branch.  Its filename is
     sparc-mm-disable-preemption-in-lazy-mmu-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-mm-disable-preemption-in-lazy-mmu-mode.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: sparc/mm: disable preemption in lazy mmu mode
Date: Mon, 3 Mar 2025 14:15:37 +0000

Since commit 38e0edb15bd0 ("mm/apply_to_range: call pte function with lazy
updates") it's been possible for arch_[enter|leave]_lazy_mmu_mode() to be
called without holding a page table lock (for the kernel mappings case),
and therefore it is possible that preemption may occur while in the lazy
mmu mode.  The Sparc lazy mmu implementation is not robust to preemption
since it stores the lazy mode state in a per-cpu structure and does not
attempt to manage that state on task switch.

Powerpc had the same issue and fixed it by explicitly disabling preemption
in arch_enter_lazy_mmu_mode() and re-enabling in
arch_leave_lazy_mmu_mode().  See commit b9ef323ea168 ("powerpc/64s:
Disable preemption in hash lazy mmu mode").

Given Sparc's lazy mmu mode is based on powerpc's, let's fix it in the
same way here.

Link: https://lkml.kernel.org/r/20250303141542.3371656-4-ryan.roberts@arm.com
Fixes: 38e0edb15bd0 ("mm/apply_to_range: call pte function with lazy updates")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/tlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/sparc/mm/tlb.c~sparc-mm-disable-preemption-in-lazy-mmu-mode
+++ a/arch/sparc/mm/tlb.c
@@ -52,8 +52,10 @@ out:
 
 void arch_enter_lazy_mmu_mode(void)
 {
-	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
+	struct tlb_batch *tb;
 
+	preempt_disable();
+	tb = this_cpu_ptr(&tlb_batch);
 	tb->active = 1;
 }
 
@@ -64,6 +66,7 @@ void arch_leave_lazy_mmu_mode(void)
 	if (tb->tlb_nr)
 		flush_tlb_pending();
 	tb->active = 0;
+	preempt_enable();
 }
 
 static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-dont-skip-arch_sync_kernel_mappings-in-error-paths.patch
mm-ioremap-pass-pgprot_t-to-ioremap_prot-instead-of-unsigned-long.patch
mm-fix-lazy-mmu-docs-and-usage.patch
fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region.patch
sparc-mm-disable-preemption-in-lazy-mmu-mode.patch
sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes.patch
revert-x86-xen-allow-nesting-of-same-lazy-mode.patch

