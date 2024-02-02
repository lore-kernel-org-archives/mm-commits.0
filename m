Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EA218B15
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706875967; cv=none; b=BBA7QE2Yg1vK180WSVRLx0GfQ1Z16eIP2daR2zOpLg06IgfIHOblK90ie/mNsl4S+4/lv5em1gzodr4X5Log7PjlXX6Qxjn39B1JH8Iy8Td2XMtPCVe4GuLMyHG1sDoCKfG5PVXPfM9USOst0GmDKSKfpZikrvp9GxlYh9w/i6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706875967; c=relaxed/simple;
	bh=phbhP/Os31YN5z1gZdMT2XF5dpyWs76fzfqxPNskYKo=;
	h=Date:To:From:Subject:Message-Id; b=FBGMV6Q58956DOpGNz7sv9/Uom9fVRJnlYJ5LqUhx3FAcs+dfirNCb9xudxeE0lmJ1ef7naqzNQ1g1XzB4/hbr4EBfof1MshQKyzdL/ly58Pv1Kc03BO6sfHk82ItBS4Olj7x/XQTPszVzpuEemxCunflIpUnLFalgR7mtOgSs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lr6cz6um; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lr6cz6um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E3BC43394;
	Fri,  2 Feb 2024 12:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706875966;
	bh=phbhP/Os31YN5z1gZdMT2XF5dpyWs76fzfqxPNskYKo=;
	h=Date:To:From:Subject:From;
	b=lr6cz6umX9jU4opmx9nkVXI/Q65pXDVec7vENC0y1GaTYWG2OdCn2vDlogbJTH53x
	 p+4ZQ48I3WSKtATJcXBqS92N0EARWEvkOb1GA0XF6jYuiwq1zc5RyAChoO0kSe+Ydx
	 o0HwAm7VyT8Wg/Ca6rhO1STuml9MgVuxrRWJ6HMs=
Date: Fri, 02 Feb 2024 04:12:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-add-missing-flag-and-statistics-for-kernel-pte-page.patch added to mm-unstable branch
Message-Id: <20240202121246.66E3BC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: add missing flag and statistics for kernel PTE page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-add-missing-flag-and-statistics-for-kernel-pte-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-add-missing-flag-and-statistics-for-kernel-pte-page.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: add missing flag and statistics for kernel PTE page
Date: Thu, 1 Feb 2024 16:05:40 +0800

For kernel PTE page, we do not need to allocate and initialize its split
ptlock, but as a page table page, it's still necessary to add PG_table
flag and NR_PAGETABLE statistics for it.

Link: https://lkml.kernel.org/r/f023a6687b9f2109401e7522b727aa4708dc05f1.1706774109.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgalloc.h |    7 ++++++-
 include/linux/mm.h            |   21 ++++++++++++++++-----
 2 files changed, 22 insertions(+), 6 deletions(-)

--- a/include/asm-generic/pgalloc.h~mm-pgtable-add-missing-flag-and-statistics-for-kernel-pte-page
+++ a/include/asm-generic/pgalloc.h
@@ -23,6 +23,8 @@ static inline pte_t *__pte_alloc_one_ker
 
 	if (!ptdesc)
 		return NULL;
+
+	__pagetable_pte_ctor(ptdesc);
 	return ptdesc_address(ptdesc);
 }
 
@@ -46,7 +48,10 @@ static inline pte_t *pte_alloc_one_kerne
  */
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	pagetable_free(virt_to_ptdesc(pte));
+	struct ptdesc *ptdesc = virt_to_ptdesc(pte);
+
+	__pagetable_pte_dtor(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 /**
--- a/include/linux/mm.h~mm-pgtable-add-missing-flag-and-statistics-for-kernel-pte-page
+++ a/include/linux/mm.h
@@ -2922,26 +2922,37 @@ static inline bool ptlock_init(struct pt
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* USE_SPLIT_PTE_PTLOCKS */
 
-static inline bool pagetable_pte_ctor(struct ptdesc *ptdesc)
+static inline void __pagetable_pte_ctor(struct ptdesc *ptdesc)
 {
 	struct folio *folio = ptdesc_folio(ptdesc);
 
-	if (!ptlock_init(ptdesc))
-		return false;
 	__folio_set_pgtable(folio);
 	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+}
+
+static inline bool pagetable_pte_ctor(struct ptdesc *ptdesc)
+{
+	if (!ptlock_init(ptdesc))
+		return false;
+
+	__pagetable_pte_ctor(ptdesc);
 	return true;
 }
 
-static inline void pagetable_pte_dtor(struct ptdesc *ptdesc)
+static inline void __pagetable_pte_dtor(struct ptdesc *ptdesc)
 {
 	struct folio *folio = ptdesc_folio(ptdesc);
 
-	ptlock_free(ptdesc);
 	__folio_clear_pgtable(folio);
 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
+static inline void pagetable_pte_dtor(struct ptdesc *ptdesc)
+{
+	ptlock_free(ptdesc);
+	__pagetable_pte_dtor(ptdesc);
+}
+
 pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
 static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
 {
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-add-missing-flag-and-statistics-for-kernel-pte-page.patch
mm-pgtable-remove-unnecessary-split-ptlock-for-kernel-pmd-page.patch

