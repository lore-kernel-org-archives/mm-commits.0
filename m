Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5252ECE80
	for <mm-commits@vger.kernel.org>; Thu, 25 Sep 2025 23:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758841771; cv=none; b=XP6+xShOikycJOl/Tn7Ulh+YdmzhqnhoXCb35pB6+fieWrKwFB/5rKp93FrvoiCVcoFbUliwPgdAWSnu79kjpN2cUcc0WzR4JvnFHxGqeQW4RoGqjCRuKILiHBUXyoUd05sL3tpK6gpiV7bhV0AcNYwl6jCP2PSEqeUitvadkxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758841771; c=relaxed/simple;
	bh=N8OZldmmq94lgl33iSPmYS+RTNGs8+SSC/FfpFiVtc4=;
	h=Date:To:From:Subject:Message-Id; b=BMnmC95Vbf0HQFhyrpgBjgb/+USeRhQie6wpRuLaRv4JtQEZ7E2egYpoh0aP/PLmR8s+5S3iqIQ/S1PFpYchDFZElKfkqzIvMYXdzIYfpHwvBTuPsoy0IZZuc/w3UdHJ0ZD3wV8aUsI9erbcQxk8dDkUqBNPK5LhHRQo2rwOmT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AHVqPuOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AHVqPuOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13F6C4CEF0;
	Thu, 25 Sep 2025 23:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758841770;
	bh=N8OZldmmq94lgl33iSPmYS+RTNGs8+SSC/FfpFiVtc4=;
	h=Date:To:From:Subject:From;
	b=AHVqPuOOGzOWkf6b+6HVrOYZ+VjopkSxzTeJEzamMHPyZf17qwCdmoDMSENx3Od25
	 +w491mfPEMI9yhPDXFAddN+fnenSEeCt4yFJwhrBKxZS+pWDkjSVGnL1Nk7Tr7wzDE
	 QoGfpYK8ERWv9bn9TdbZX0CNGs77ETPrAt94eB/s=
Date: Thu, 25 Sep 2025 16:09:30 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,balbirs@nvidia.com,agordeev@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch added to mm-hotfixes-unstable branch
Message-Id: <20250925230930.C13F6C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and friends to static inlines
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and friends to static inlines
Date: Sat Sep 13 05:03:39 PM PDT 2025

commit c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards") introduced
the use of arch_enter_lazy_mmu_mode(), which results in the compiler
complaining about "statement has no effect", when
__HAVE_ARCH_LAZY_MMU_MODE is not defined in include/linux/pgtable.h

The exact warning/error is:

In file included from ./include/linux/kasan.h:37,
                 from mm/kasan/shadow.c:14:
mm/kasan/shadow.c: In function kasan_populate_vmalloc_pte:
./include/linux/pgtable.h:247:41: error: statement with no effect [-Werror=unused-value]
  247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
      |                                         ^
mm/kasan/shadow.c:322:9: note: in expansion of macro arch_enter_lazy_mmu_mode>   322 |         arch_enter_lazy_mmu_mode();
     |         ^~~~~~~~~~~~~~~~~~~~~~~~

switching these "functions" to static inlines fixes this up.

Fixes: c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards") 
Reported-by: Balbir Singh <balbirs@nvidia.com>
Closes: https://lkml.kernel.org/r/20250912235515.367061-1-balbirs@nvidia.com
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/pgtable.h~include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines
+++ a/include/linux/pgtable.h
@@ -232,9 +232,9 @@ static inline int pmd_dirty(pmd_t pmd)
  * and the mode cannot be used in interrupt context.
  */
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
+static inline void arch_enter_lazy_mmu_mode(void) {}
+static inline void arch_leave_lazy_mmu_mode(void) {}
+static inline void arch_flush_lazy_mmu_mode(void) {}
 #endif
 
 #ifndef pte_batch_hint
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one-fix.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

