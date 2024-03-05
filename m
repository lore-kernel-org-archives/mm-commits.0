Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D26EEDC
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600538; cv=none; b=Ww8FhXAcRovfTkVFyTBIdIKD3e96yoT/5Lii1KjHkVwEHoj2EiAtThnGEKmo5djRiuMzqFhUZ4kKVJwKS2bZijVoHkfGTNb2jgSFkJj34TEFVxll/hgVPhvRZtVzk7cwal/LNUii/9bioVR445EydPN+qEiVeX9ujX99ASozeT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600538; c=relaxed/simple;
	bh=YlN5ZAxngrGKRLyqKzDGl24tIa4lMWWScSo+z6uqZmM=;
	h=Date:To:From:Subject:Message-Id; b=ae2lgGqZ06pM09soPtrAPq0BisCCpjDCSpH57+0QFCUsORoZSacLe+EFe9HP2TdaIUIMcd4gJc4o7aHITYP5NvCwH1ryFw+NW9odg/riHZdaI5oNzFsCvYPnRLX964P4akh2PUcsUpA+KsRXAW31jUmL/ZyYiQMBXW0T1zdu1bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NJPAsF2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NJPAsF2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673A9C433F1;
	Tue,  5 Mar 2024 01:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600538;
	bh=YlN5ZAxngrGKRLyqKzDGl24tIa4lMWWScSo+z6uqZmM=;
	h=Date:To:From:Subject:From;
	b=NJPAsF2Sz6e8fRB8OFdUHKT4LOR2Wd8cDIHj9qLTWPZ1Lmtpm1ZpKGN6YdgH9ZDLq
	 gm+JNF14rI9V3H4wGCQrmfV0HTmG0VBWKNhurEMupaLqpVVVJu219EYTp1i8e0Xkk7
	 Bv4v1LyMXJKhDw0dAcxpM7PHDwfg9IQq5wcYo5Nk=
Date: Mon, 04 Mar 2024 17:02:17 -0800
To: mm-commits@vger.kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,david@redhat.com,catalin.marinas@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-export-contpte-symbols-only-to-gpl-users.patch removed from -mm tree
Message-Id: <20240305010218.673A9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: export contpte symbols only to GPL users
has been removed from the -mm tree.  Its filename was
     arm64-mm-export-contpte-symbols-only-to-gpl-users.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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


