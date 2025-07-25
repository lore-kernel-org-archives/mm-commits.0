Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB5B20D4E9
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409683; cv=none; b=UlCSc9SNCQ8AVp0pUipOLtlqoxU1AXISv7JfdqsAe9WUrpwKUeIXaiFVP95QrBJWhZh7rexg1FIM9VqjlFw08evcC+Jd8DqzR+ZNgb42t5wmEDrtf0WqGKnpRjhNiy0+HwbS9XG9Fgqq2sazjpOnC72+SCJuspm3G46or7H3zkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409683; c=relaxed/simple;
	bh=ufMXFJxMItcqSpEj4pfuiPyuRWZeje6j238HkX33jCc=;
	h=Date:To:From:Subject:Message-Id; b=NfAn935PIUTFmCBp2tM3Ad7lSHaI2TL3Hqn5HfchQTQe9moh1NyY+W6C4oju7CH6mQo8VtS9N9vGI7pNOEZbQ23Bgq7LZywScLlr2lvB1r/HtXujDnKDOUWNvcvX270MaVLcRCWoED9mp6MuSCxGaxQVFI9PNv57XYld6+1ML7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CtMxyvsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CtMxyvsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34012C4CEED;
	Fri, 25 Jul 2025 02:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409683;
	bh=ufMXFJxMItcqSpEj4pfuiPyuRWZeje6j238HkX33jCc=;
	h=Date:To:From:Subject:From;
	b=CtMxyvsiJpoEW6fFhgZZ926SIKl86JrMMxiW4wIpZL+Vh8qNjtb1s/51dOCND0Yrt
	 lFxgSV0l9VUIlj4zngDS/hptjDjLeF5mdDI8KPbkfTY81EMqkwZjpNBWFMwocJRScW
	 EOONZrjD/72qpofQTj/el8wDexLvPqzQEnx/k/9A=
Date: Thu, 24 Jul 2025 19:14:42 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,arnd@arndb.de,anshuman.khandual@arm.com,andreas@gaisler.com,alexghiti@rivosinc.com,agordeev@linux.ibm.com,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-hugetlb_free_pgd_range.patch removed from -mm tree
Message-Id: <20250725021443.34012C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: drop hugetlb_free_pgd_range()
has been removed from the -mm tree.  Its filename was
     mm-drop-hugetlb_free_pgd_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


