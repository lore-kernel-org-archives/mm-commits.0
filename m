Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB132EF295
	for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2025 22:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752706768; cv=none; b=RvAHfGS5/quwBkuPs6qXjQKeFeYCOXHVY/MP01tzH7uoSA79O61SbI+hH0NZ2mLbyEkDwaNUMYSe5B1WmtgECu93O2EG4ZydqybdT56qD7mD7Xrsw3AM3L/hIDWtRscuNqhUIE+KTTs8RBcjfgF9T1/SZtHGIYLVgSEm283ki7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752706768; c=relaxed/simple;
	bh=0AVijhCXffKLCmCbggr/NK0/J+CPslNKMm3u8xKjDZI=;
	h=Date:To:From:Subject:Message-Id; b=HRvwtrpcPcz6l1i8bYr9fElFa/X7IGASOpjl66XYEOoeOonv6a3R/JzAIAvhxeWI0nkIsQNk1eOkp37N6jKFtmK733+RH8di85S9pJZ8UHLGTo9W1snbeFes5jDKvhrqbncOGsUzn4zMY24hGwwokzsY7gB+KfUWfwyG2CVXQuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UKKebKwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UKKebKwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09593C4CEE7;
	Wed, 16 Jul 2025 22:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752706768;
	bh=0AVijhCXffKLCmCbggr/NK0/J+CPslNKMm3u8xKjDZI=;
	h=Date:To:From:Subject:From;
	b=UKKebKwvR4LXw7uiwEkuGDPaSZ4ZdsSnf7a3UT0NNnbTQDgsxvdKT6YbY5SZs7SQS
	 sddiGC9mohp8yb57emJ+Yycw4OydvzJwaU9OYyELN1uRuI236DeaLII/3UjZDArqCC
	 /9sQXD7gMdIxVf18QXtTmjP5GLoOX/XC4ny5GfxM=
Date: Wed, 16 Jul 2025 15:59:27 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,arnd@arndb.de,anshuman.khandual@arm.com,andreas@gaisler.com,alexghiti@rivosinc.com,agordeev@linux.ibm.com,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-hugetlb_free_pgd_range.patch added to mm-new branch
Message-Id: <20250716225928.09593C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: drop hugetlb_free_pgd_range()
has been added to the -mm mm-new branch.  Its filename is
     mm-drop-hugetlb_free_pgd_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-hugetlb_free_pgd_range.patch

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
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm: drop hugetlb_free_pgd_range()
Date: Tue, 15 Jul 2025 18:26:11 -0700

There are no longer any callers of hugetlb_free_pgd_range().

Link: https://lkml.kernel.org/r/20250716012611.10369-4-anthony.yznaga@oracle.com
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/hugetlb.h |    9 ---------
 include/linux/hugetlb.h       |    7 -------
 2 files changed, 16 deletions(-)

--- a/include/asm-generic/hugetlb.h~mm-drop-hugetlb_free_pgd_range
+++ a/include/asm-generic/hugetlb.h
@@ -66,15 +66,6 @@ static inline void huge_pte_clear(struct
 }
 #endif
 
-#ifndef __HAVE_ARCH_HUGETLB_FREE_PGD_RANGE
-static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
-		unsigned long addr, unsigned long end,
-		unsigned long floor, unsigned long ceiling)
-{
-	free_pgd_range(tlb, addr, end, floor, ceiling);
-}
-#endif
-
 #ifndef __HAVE_ARCH_HUGE_SET_HUGE_PTE_AT
 static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pte, unsigned long sz)
--- a/include/linux/hugetlb.h~mm-drop-hugetlb_free_pgd_range
+++ a/include/linux/hugetlb.h
@@ -390,13 +390,6 @@ static inline int is_hugepage_only_range
 	return 0;
 }
 
-static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
-				unsigned long addr, unsigned long end,
-				unsigned long floor, unsigned long ceiling)
-{
-	BUG();
-}
-
 #ifdef CONFIG_USERFAULTFD
 static inline int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 					   struct vm_area_struct *dst_vma,
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

sparc64-remove-hugetlb_free_pgd_range.patch
mm-remove-call-to-hugetlb_free_pgd_range.patch
mm-drop-hugetlb_free_pgd_range.patch

