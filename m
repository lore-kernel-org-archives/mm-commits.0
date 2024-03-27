Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F5715216E
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 19:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567328; cv=none; b=cAVaTrhoCsyeZbhWjY4mdkBvE7BlpBVOrfFCKXZUBp13AMGdx5l68tDJ3Cf7udJmCLqS5W/Wcg6xqqQc9B2q3eZ3XoUikvu/614XsRPBi5EfEYFlZiWMMjEtLN4cBEH2BJeMF5DAywgMnPDfuYzp8bl1b2JqOpmHSYEUy8IpCd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567328; c=relaxed/simple;
	bh=KnofGCd7n8ME+pCcAUKnkZGIjtfpCvHQgkYiNb7S14I=;
	h=Date:To:From:Subject:Message-Id; b=Z5kz7cpfHkMotmN2n5W+p+t/ZweMdhywdKDIu2wAira7/7YVPaJprOH3PTQt4sVAiNOniOUE9eE4FFKd3qCiS9mHi6Va6u14osUaXZxFuMitNt6MYhGdEKYzuQYZt2CYLaH6z/ZEZwE8vnaRnMg/704nr7ChJpsE4+vwMJPbrG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ff/aYcFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ff/aYcFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74339C433F1;
	Wed, 27 Mar 2024 19:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711567328;
	bh=KnofGCd7n8ME+pCcAUKnkZGIjtfpCvHQgkYiNb7S14I=;
	h=Date:To:From:Subject:From;
	b=ff/aYcFCD/RtJYnCi4o8yEWmUTCkQgxMApCAr5VOuC2C4ITy1q7wbAXzYGmvrFiDr
	 zMpPl4Gm14En3UpgmQc5q8YoMTBfHreLM9CeMTnH34CWOYn0PSZ3gkmXZo7MZpWONV
	 jdCx8PgruFH5Kc/2RYRct2TEhseHgUbeJyCwb+2w=
Date: Wed, 27 Mar 2024 12:22:07 -0700
To: mm-commits@vger.kernel.org,davem@davemloft.net,andreas@gaisler.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-prot-parameter-from-move_pte.patch added to mm-unstable branch
Message-Id: <20240327192208.74339C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove "prot" parameter from move_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-prot-parameter-from-move_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-prot-parameter-from-move_pte.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove "prot" parameter from move_pte()
Date: Wed, 27 Mar 2024 15:33:01 +0100

The "prot" parameter is unused, and using it instead of what's stored in
that particular PTE would very likely be wrong.  Let's simply remove it.

Link: https://lkml.kernel.org/r/20240327143301.741807-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |    2 +-
 include/linux/pgtable.h             |    2 +-
 mm/mremap.c                         |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h~mm-remove-prot-parameter-from-move_pte
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -957,7 +957,7 @@ static inline void set_ptes(struct mm_st
 
 #ifdef DCACHE_ALIASING_POSSIBLE
 #define __HAVE_ARCH_MOVE_PTE
-#define move_pte(pte, prot, old_addr, new_addr)				\
+#define move_pte(pte, old_addr, new_addr)				\
 ({									\
 	pte_t newpte = (pte);						\
 	if (tlb_type != hypervisor && pte_present(pte)) {		\
--- a/include/linux/pgtable.h~mm-remove-prot-parameter-from-move_pte
+++ a/include/linux/pgtable.h
@@ -1137,7 +1137,7 @@ static inline void arch_swap_restore(swp
 #endif
 
 #ifndef __HAVE_ARCH_MOVE_PTE
-#define move_pte(pte, prot, old_addr, new_addr)	(pte)
+#define move_pte(pte, old_addr, new_addr)	(pte)
 #endif
 
 #ifndef pte_accessible
--- a/mm/mremap.c~mm-remove-prot-parameter-from-move_pte
+++ a/mm/mremap.c
@@ -205,7 +205,7 @@ static int move_ptes(struct vm_area_stru
 		 */
 		if (pte_present(pte))
 			force_flush = true;
-		pte = move_pte(pte, new_vma->vm_page_prot, old_addr, new_addr);
+		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
 		set_pte_at(mm, new_addr, new_pte, pte);
 	}
_

Patches currently in -mm which might be from david@redhat.com are

mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch
mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch

