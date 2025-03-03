Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F00E1EEA2A;
	Mon,  3 Mar 2025 23:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741043400; cv=none; b=ApmdkiiG2dUUozSDS1PTLp7QHoezvJtKS2dx67kf4k1Nm52CvRoj6HdIEKHeHjpy8PgmiHEYXvkF8d4Sh/mJUqLYS2eA2h+1dLUzwlnmoWXY3dGHSeXiNmKjJQ4TsLFIMIZ/cyVFTIsRIOSquIROa/+pEWB5Ew1eerMNEZ9dQzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741043400; c=relaxed/simple;
	bh=MAz/x+KHtUREKMB+Fol7xfDD7n7h6jaU1MsBejAp9xQ=;
	h=Date:To:From:Subject:Message-Id; b=jssO7otckeEVuzLpqNzYnN8SxaipXL74+uewheeZuvE7d2N5bnWkURDdtHbQsoE5PgU+iqvj/4iKn/hK2GtJfA+k6FvJ0yU58xUsNZypSeH5MD+jPxJjucMGnTae9z4JhVcHxHogIiMjWcYbHzSXqi2ToZi2n458Z0c43xW2FwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZjnKnN+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZjnKnN+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9117DC4CEE8;
	Mon,  3 Mar 2025 23:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741043399;
	bh=MAz/x+KHtUREKMB+Fol7xfDD7n7h6jaU1MsBejAp9xQ=;
	h=Date:To:From:Subject:From;
	b=ZjnKnN+Cmrplgogk4lllvJwyRdFe+Tf99nsJsv1+Cm6ntrs8CxtrZv82UGX/V+Yek
	 nge62F9jDsGsInqntAo39D92mcbn1nuBlzSHo0z709nkK7BLLDHBOLR5XLNWrhUQe+
	 oIDa5CdJt2h8qA/gmabcWCbW1u6tCf44MK5MjzO0=
Date: Mon, 03 Mar 2025 15:09:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,stable@vger.kernel.org,mingo@redhat.com,jgross@suse.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes.patch added to mm-unstable branch
Message-Id: <20250303230959.9117DC4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc/mm: avoid calling arch_enter/leave_lazy_mmu() in set_ptes
has been added to the -mm mm-unstable branch.  Its filename is
     sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes.patch

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
Subject: sparc/mm: avoid calling arch_enter/leave_lazy_mmu() in set_ptes
Date: Mon, 3 Mar 2025 14:15:38 +0000

With commit 1a10a44dfc1d ("sparc64: implement the new page table range
API") set_ptes was added to the sparc architecture.  The implementation
included calling arch_enter/leave_lazy_mmu() calls.

The patch removes the usage of arch_enter/leave_lazy_mmu() since this
implies nesting of lazy mmu regions which is not supported.  Without this
fix, lazy mmu mode is effectively disabled because we exit the mode after
the first set_ptes:

remap_pte_range()
  -> arch_enter_lazy_mmu()
  -> set_ptes()
      -> arch_enter_lazy_mmu()
      -> arch_leave_lazy_mmu()
  -> arch_leave_lazy_mmu()

Powerpc suffered the same problem and fixed it in a corresponding way with
commit 47b8def9358c ("powerpc/mm: Avoid calling
arch_enter/leave_lazy_mmu() in set_ptes").

Link: https://lkml.kernel.org/r/20250303141542.3371656-5-ryan.roberts@arm.com
Fixes: 1a10a44dfc1d ("sparc64: implement the new page table range API")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>
Cc: <stable@vger.kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h~sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -936,7 +936,6 @@ static inline void __set_pte_at(struct m
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	arch_enter_lazy_mmu_mode();
 	for (;;) {
 		__set_pte_at(mm, addr, ptep, pte, 0);
 		if (--nr == 0)
@@ -945,7 +944,6 @@ static inline void set_ptes(struct mm_st
 		pte_val(pte) += PAGE_SIZE;
 		addr += PAGE_SIZE;
 	}
-	arch_leave_lazy_mmu_mode();
 }
 #define set_ptes set_ptes
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-dont-skip-arch_sync_kernel_mappings-in-error-paths.patch
mm-ioremap-pass-pgprot_t-to-ioremap_prot-instead-of-unsigned-long.patch
mm-fix-lazy-mmu-docs-and-usage.patch
fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region.patch
sparc-mm-disable-preemption-in-lazy-mmu-mode.patch
sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes.patch
revert-x86-xen-allow-nesting-of-same-lazy-mode.patch

