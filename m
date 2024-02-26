Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E982C12E1FA
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 17:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969884; cv=none; b=KmbDwt4KQEz98lxrNNUlVtY9IaWP1ErsTrGD4XTPsuZxpVOqOkCuVquhhrtCoEaqz70Bt1r6VoF+2FeaySTM8MapRxhDUbp61oEewdNXwJq21V94CZGKbgttFR5zejMO7EQyVo2ZF5SfypdCfhV6pVDRtgcbaHA5ktDuF9xBCcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969884; c=relaxed/simple;
	bh=ziQKfbzTn6p02SKDIbFSclWG1D/1fqjMGXhUVBXIq2w=;
	h=Date:To:From:Subject:Message-Id; b=NUsvjR1d0AkavJgNXcgNMQbqR2BRkVnZunPmkCirdVEzVjKeZk5lAGiwcA6euBPdELAdGqSMXhRO7X8guyL5by8v835R4pDIeXAIcxFOvgscdNfKv3HR07h7jUgir4DAaCftwgQDMk6XG0QW+pBe03dmsPimZwVwQMXz1eGFVOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kJUF9Vr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kJUF9Vr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55027C433F1;
	Mon, 26 Feb 2024 17:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708969883;
	bh=ziQKfbzTn6p02SKDIbFSclWG1D/1fqjMGXhUVBXIq2w=;
	h=Date:To:From:Subject:From;
	b=kJUF9Vr0nC6L2mU73nG0K3kiNts0heB8WiE5c5EuohEfXxb1I2NoyKZlVpnotE08/
	 Dcdiy9ySdEqah4dVlcub3Ik5qax7cFLn6yskZbgYBiIsARrncbG4NnsbVpggcnDCWh
	 lyaIFN79Lwk6QtPCYq/qjKvgu9qQ08+m7+ufxz6o=
Date: Mon, 26 Feb 2024 09:51:22 -0800
To: mm-commits@vger.kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,david@redhat.com,catalin.marinas@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-export-contpte-symbols-only-to-gpl-users.patch added to mm-unstable branch
Message-Id: <20240226175123.55027C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: export contpte symbols only to GPL users
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-export-contpte-symbols-only-to-gpl-users.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-export-contpte-symbols-only-to-gpl-users.patch

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
Subject: arm64/mm: export contpte symbols only to GPL users
Date: Mon, 26 Feb 2024 12:03:20 +0000

Patch series "Address some contpte nits".

These 2 patches address some nits raised by Catalin late in the review cycle for
my contpte series [1].

[1] https://lore.kernel.org/linux-mm/20240215103205.2607016-1-ryan.roberts@arm.com/

This patch (of 2):

The contpte symbols must be exported since some of the public inline
ptep_* APIs are called from modules and these inlines now call the contpte
functions.  Originally they were exported as EXPORT_SYMBOL() for fear of
breaking out-of-tree modules.  But we subsequently concluded that
EXPORT_SYMBOL_GPL() should be safe since these functions are deeply core
mm routines, and any module operating at this level is not going to be
able to survive on EXPORT_SYMBOL alone.

Link: https://lkml.kernel.org/r/20240226120321.1055731-1-ryan.roberts@arm.com
Link: https://lore.kernel.org/linux-mm/f9fc2b31-11cb-4969-8961-9c89fea41b74@nvidia.com/
Link: https://lkml.kernel.org/r/20240226120321.1055731-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/contpte.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/arch/arm64/mm/contpte.c~arm64-mm-export-contpte-symbols-only-to-gpl-users
+++ a/arch/arm64/mm/contpte.c
@@ -135,7 +135,7 @@ void __contpte_try_fold(struct mm_struct
 	pte = pte_mkcont(pte);
 	contpte_convert(mm, addr, orig_ptep, pte);
 }
-EXPORT_SYMBOL(__contpte_try_fold);
+EXPORT_SYMBOL_GPL(__contpte_try_fold);
 
 void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 			pte_t *ptep, pte_t pte)
@@ -150,7 +150,7 @@ void __contpte_try_unfold(struct mm_stru
 	pte = pte_mknoncont(pte);
 	contpte_convert(mm, addr, ptep, pte);
 }
-EXPORT_SYMBOL(__contpte_try_unfold);
+EXPORT_SYMBOL_GPL(__contpte_try_unfold);
 
 pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte)
 {
@@ -178,7 +178,7 @@ pte_t contpte_ptep_get(pte_t *ptep, pte_
 
 	return orig_pte;
 }
-EXPORT_SYMBOL(contpte_ptep_get);
+EXPORT_SYMBOL_GPL(contpte_ptep_get);
 
 pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
 {
@@ -231,7 +231,7 @@ retry:
 
 	return orig_pte;
 }
-EXPORT_SYMBOL(contpte_ptep_get_lockless);
+EXPORT_SYMBOL_GPL(contpte_ptep_get_lockless);
 
 void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep, pte_t pte, unsigned int nr)
@@ -274,7 +274,7 @@ void contpte_set_ptes(struct mm_struct *
 
 	} while (addr != end);
 }
-EXPORT_SYMBOL(contpte_set_ptes);
+EXPORT_SYMBOL_GPL(contpte_set_ptes);
 
 void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, unsigned int nr, int full)
@@ -282,7 +282,7 @@ void contpte_clear_full_ptes(struct mm_s
 	contpte_try_unfold_partial(mm, addr, ptep, nr);
 	__clear_full_ptes(mm, addr, ptep, nr, full);
 }
-EXPORT_SYMBOL(contpte_clear_full_ptes);
+EXPORT_SYMBOL_GPL(contpte_clear_full_ptes);
 
 pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep,
@@ -291,7 +291,7 @@ pte_t contpte_get_and_clear_full_ptes(st
 	contpte_try_unfold_partial(mm, addr, ptep, nr);
 	return __get_and_clear_full_ptes(mm, addr, ptep, nr, full);
 }
-EXPORT_SYMBOL(contpte_get_and_clear_full_ptes);
+EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
 
 int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep)
@@ -316,7 +316,7 @@ int contpte_ptep_test_and_clear_young(st
 
 	return young;
 }
-EXPORT_SYMBOL(contpte_ptep_test_and_clear_young);
+EXPORT_SYMBOL_GPL(contpte_ptep_test_and_clear_young);
 
 int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep)
@@ -337,7 +337,7 @@ int contpte_ptep_clear_flush_young(struc
 
 	return young;
 }
-EXPORT_SYMBOL(contpte_ptep_clear_flush_young);
+EXPORT_SYMBOL_GPL(contpte_ptep_clear_flush_young);
 
 void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep, unsigned int nr)
@@ -355,7 +355,7 @@ void contpte_wrprotect_ptes(struct mm_st
 	contpte_try_unfold_partial(mm, addr, ptep, nr);
 	__wrprotect_ptes(mm, addr, ptep, nr);
 }
-EXPORT_SYMBOL(contpte_wrprotect_ptes);
+EXPORT_SYMBOL_GPL(contpte_wrprotect_ptes);
 
 int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep,
@@ -401,4 +401,4 @@ int contpte_ptep_set_access_flags(struct
 
 	return 1;
 }
-EXPORT_SYMBOL(contpte_ptep_set_access_flags);
+EXPORT_SYMBOL_GPL(contpte_ptep_set_access_flags);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

arm64-mm-export-contpte-symbols-only-to-gpl-users.patch
arm64-mm-improve-comment-in-contpte_ptep_get_lockless.patch

