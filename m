Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0D11EEA2A;
	Mon,  3 Mar 2025 23:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741043394; cv=none; b=NMd28lJgU1+giK6I2cE54cMFaMjwQuwaZSPTVqxSokZuLNQFElpapo36vBano4kgYra6p5MnXBQYT9fMk4RUXzdW3op6siYjmV1mCLJ9YWn4pnL/Fj4oKpzH+FyckPjB4VUFT27yzoKyNunpP7GSob+StuEURZQJYvVK7SsEFDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741043394; c=relaxed/simple;
	bh=nV9NS9bgG1wv2Ga7j0U7tPsjsVGtHSsdQkAQbQ80EfU=;
	h=Date:To:From:Subject:Message-Id; b=tW3zwI5p9FI+8opbLHtHPkIOmhYuNGPDaqKrrMN1RnXrzbtnpph3ELqctbxSDNPVbxWwSiBZ+vbrSkd8R2ih2qRYqTyLMZmlTi6dh7rVr1NuzBOksajx2gmw/KFRk3dpBKLigvRlF1Tw9CxeYuHIAP/hPV04qtwpFJ7MVl59Vek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hEJom/r+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hEJom/r+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4ECC4CEE8;
	Mon,  3 Mar 2025 23:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741043393;
	bh=nV9NS9bgG1wv2Ga7j0U7tPsjsVGtHSsdQkAQbQ80EfU=;
	h=Date:To:From:Subject:From;
	b=hEJom/r+kYb1rUA63paO1A3M/77eBbcEimPtpLgBoISEAxixodh42D7igaPNK8JVS
	 NJHk1zzUdpR085d2Hj9DxbJ5KPHhIw1qwlnVZV/Vt4pxV96nzZ5h0WPngwH98tWoSY
	 ykE3zgYu8uJUrXtKsTIsBmGWDv5QJ5iIw9VsC9Ro=
Date: Mon, 03 Mar 2025 15:09:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,stable@vger.kernel.org,mingo@redhat.com,jgross@suse.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-lazy-mmu-docs-and-usage.patch added to mm-unstable branch
Message-Id: <20250303230953.4B4ECC4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix lazy mmu docs and usage
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-lazy-mmu-docs-and-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-lazy-mmu-docs-and-usage.patch

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
Subject: mm: fix lazy mmu docs and usage
Date: Mon, 3 Mar 2025 14:15:35 +0000

Patch series "Fix lazy mmu mode", v2.

I'm planning to implement lazy mmu mode for arm64 to optimize vmalloc.  As
part of that, I will extend lazy mmu mode to cover kernel mappings in
vmalloc table walkers.  While lazy mmu mode is already used for kernel
mappings in a few places, this will extend it's use significantly.

Having reviewed the existing lazy mmu implementations in powerpc, sparc
and x86, it looks like there are a bunch of bugs, some of which may be
more likely to trigger once I extend the use of lazy mmu.  So this series
attempts to clarify the requirements and fix all the bugs in advance of
that series.  See patch #1 commit log for all the details.


This patch (of 5):

The docs, implementations and use of arch_[enter|leave]_lazy_mmu_mode() is
a bit of a mess (to put it politely).  There are a number of issues
related to nesting of lazy mmu regions and confusion over whether the
task, when in a lazy mmu region, is preemptible or not.  Fix all the
issues relating to the core-mm.  Follow up commits will fix the
arch-specific implementations.  3 arches implement lazy mmu; powerpc,
sparc and x86.

When arch_[enter|leave]_lazy_mmu_mode() was first introduced by commit
6606c3e0da53 ("[PATCH] paravirt: lazy mmu mode hooks.patch"), it was
expected that lazy mmu regions would never nest and that the appropriate
page table lock(s) would be held while in the region, thus ensuring the
region is non-preemptible.  Additionally lazy mmu regions were only used
during manipulation of user mappings.

Commit 38e0edb15bd0 ("mm/apply_to_range: call pte function with lazy
updates") started invoking the lazy mmu mode in apply_to_pte_range(),
which is used for both user and kernel mappings.  For kernel mappings the
region is no longer protected by any lock so there is no longer any
guarantee about non-preemptibility.  Additionally, for RT configs, the
holding the PTL only implies no CPU migration, it doesn't prevent
preemption.

Commit bcc6cc832573 ("mm: add default definition of set_ptes()") added
arch_[enter|leave]_lazy_mmu_mode() to the default implementation of
set_ptes(), used by x86.  So after this commit, lazy mmu regions can be
nested.  Additionally commit 1a10a44dfc1d ("sparc64: implement the new
page table range API") and commit 9fee28baa601 ("powerpc: implement the
new page table range API") did the same for the sparc and powerpc
set_ptes() overrides.

powerpc couldn't deal with preemption so avoids it in commit b9ef323ea168
("powerpc/64s: Disable preemption in hash lazy mmu mode"), which
explicitly disables preemption for the whole region in its implementation.
x86 can support preemption (or at least it could until it tried to add
support nesting; more on this below).  Sparc looks to be totally broken in
the face of preemption, as far as I can tell.

powerpc can't deal with nesting, so avoids it in commit 47b8def9358c
("powerpc/mm: Avoid calling arch_enter/leave_lazy_mmu() in set_ptes"),
which removes the lazy mmu calls from its implementation of set_ptes(). 
x86 attempted to support nesting in commit 49147beb0ccb ("x86/xen: allow
nesting of same lazy mode") but as far as I can tell, this breaks its
support for preemption.

In short, it's all a mess; the semantics for
arch_[enter|leave]_lazy_mmu_mode() are not clearly defined and as a result
the implementations all have different expectations, sticking plasters and
bugs.

arm64 is aiming to start using these hooks, so let's clean everything up
before adding an arm64 implementation.  Update the documentation to state
that lazy mmu regions can never be nested, must not be called in interrupt
context and preemption may or may not be enabled for the duration of the
region.  And fix the generic implementation of set_ptes() to avoid
nesting.

arch-specific fixes to conform to the new spec will proceed this one.

These issues were spotted by code review and I have no evidence of issues
being reported in the wild.

Link: https://lkml.kernel.org/r/20250303141542.3371656-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20250303141542.3371656-2-ryan.roberts@arm.com
Fixes: bcc6cc832573 ("mm: add default definition of set_ptes()")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andreas Larsson <andreas@gaisler.com>
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

 include/linux/pgtable.h |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/pgtable.h~mm-fix-lazy-mmu-docs-and-usage
+++ a/include/linux/pgtable.h
@@ -222,10 +222,14 @@ static inline int pmd_dirty(pmd_t pmd)
  * hazard could result in the direct mode hypervisor case, since the actual
  * write to the page tables may not yet have taken place, so reads though
  * a raw PTE pointer after it has been modified are not guaranteed to be
- * up to date.  This mode can only be entered and left under the protection of
- * the page table locks for all page tables which may be modified.  In the UP
- * case, this is required so that preemption is disabled, and in the SMP case,
- * it must synchronize the delayed page table writes properly on other CPUs.
+ * up to date.
+ *
+ * In the general case, no lock is guaranteed to be held between entry and exit
+ * of the lazy mode. So the implementation must assume preemption may be enabled
+ * and cpu migration is possible; it must take steps to be robust against this.
+ * (In practice, for user PTE updates, the appropriate page table lock(s) are
+ * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
+ * and the mode cannot be used in interrupt context.
  */
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 #define arch_enter_lazy_mmu_mode()	do {} while (0)
@@ -287,7 +291,6 @@ static inline void set_ptes(struct mm_st
 {
 	page_table_check_ptes_set(mm, ptep, pte, nr);
 
-	arch_enter_lazy_mmu_mode();
 	for (;;) {
 		set_pte(ptep, pte);
 		if (--nr == 0)
@@ -295,7 +298,6 @@ static inline void set_ptes(struct mm_st
 		ptep++;
 		pte = pte_next_pfn(pte);
 	}
-	arch_leave_lazy_mmu_mode();
 }
 #endif
 #define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte, 1)
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-dont-skip-arch_sync_kernel_mappings-in-error-paths.patch
mm-ioremap-pass-pgprot_t-to-ioremap_prot-instead-of-unsigned-long.patch
mm-fix-lazy-mmu-docs-and-usage.patch
fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region.patch
sparc-mm-disable-preemption-in-lazy-mmu-mode.patch
sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes.patch
revert-x86-xen-allow-nesting-of-same-lazy-mode.patch

