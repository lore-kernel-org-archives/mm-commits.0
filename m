Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D1D13F000
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706875970; cv=none; b=kodMkwVcK8MV5ppKh1VF7BsL15ewB3Is33ffRsYNd1rYkrGH0s2ejkleLp2EhgC6Mojed7V9m4/dJ9onNyYeuoixU4QLjXEA3lhjccbGOjscQGA7ASNhuBOdJgSSTI+wFN52UHJMneZJO2lyw9CZTCxIYLonZwkAL6D7PkkWny8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706875970; c=relaxed/simple;
	bh=RN5VS8Kh+TtiMEPu53AqFnfHuU/y32c3kKTq0wwI8rI=;
	h=Date:To:From:Subject:Message-Id; b=gM1ByBO4RXIC5rVs6h8gD+Y/Ym2vE+QRpW/W5HVkB2oBq3kg6xcDSjDa2b667G3evyCpj5lQQh5jfh6jSLKlEIBLbnYEw9+2O7ccS8IViTHApub2vYeDVnIfmITtk+lwh2be14XerOmtHpm4MYgMS96IJCwOdIQ59B9Psk5xDBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yUY3z2f3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yUY3z2f3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833A2C43390;
	Fri,  2 Feb 2024 12:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706875969;
	bh=RN5VS8Kh+TtiMEPu53AqFnfHuU/y32c3kKTq0wwI8rI=;
	h=Date:To:From:Subject:From;
	b=yUY3z2f3wMyLrBK7MX16PEqViRyL+K3I6QTA7hWicg1v7+A5pkcLRwvx/yuuVSh7b
	 Q3Xgtk+pHfT+Ned+P/4pIGCo3wWq90pYTl95s76zi2Y5xq76mtA2C1Uh2NUmHUvxhs
	 y5SCalydnF1aj19Z1NpeKA/Ao1+6IFvFP3Bf+txY=
Date: Fri, 02 Feb 2024 04:12:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-remove-unnecessary-split-ptlock-for-kernel-pmd-page.patch added to mm-unstable branch
Message-Id: <20240202121249.833A2C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pgtable: remove unnecessary split ptlock for kernel PMD page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-remove-unnecessary-split-ptlock-for-kernel-pmd-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-remove-unnecessary-split-ptlock-for-kernel-pmd-page.patch

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
Subject: mm: pgtable: remove unnecessary split ptlock for kernel PMD page
Date: Thu, 1 Feb 2024 16:05:41 +0800

For kernel PMD entry, we use init_mm.page_table_lock to protect it, so
there is no need to allocate and initialize the split ptlock for kernel
PMD page.

Link: https://lkml.kernel.org/r/63f0b3d2f9124ae5076963fb5505bd36daba0393.1706774109.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgalloc.h |   10 ++++++++--
 include/linux/mm.h            |   21 ++++++++++++++++-----
 2 files changed, 24 insertions(+), 7 deletions(-)

--- a/include/asm-generic/pgalloc.h~mm-pgtable-remove-unnecessary-split-ptlock-for-kernel-pmd-page
+++ a/include/asm-generic/pgalloc.h
@@ -139,7 +139,10 @@ static inline pmd_t *pmd_alloc_one(struc
 	ptdesc = pagetable_alloc(gfp, 0);
 	if (!ptdesc)
 		return NULL;
-	if (!pagetable_pmd_ctor(ptdesc)) {
+
+	if (mm == &init_mm) {
+		__pagetable_pmd_ctor(ptdesc);
+	} else if (!pagetable_pmd_ctor(ptdesc)) {
 		pagetable_free(ptdesc);
 		return NULL;
 	}
@@ -153,7 +156,10 @@ static inline void pmd_free(struct mm_st
 	struct ptdesc *ptdesc = virt_to_ptdesc(pmd);
 
 	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	pagetable_pmd_dtor(ptdesc);
+	if (mm == &init_mm)
+		__pagetable_pmd_dtor(ptdesc);
+	else
+		pagetable_pmd_dtor(ptdesc);
 	pagetable_free(ptdesc);
 }
 #endif
--- a/include/linux/mm.h~mm-pgtable-remove-unnecessary-split-ptlock-for-kernel-pmd-page
+++ a/include/linux/mm.h
@@ -3048,26 +3048,37 @@ static inline spinlock_t *pmd_lock(struc
 	return ptl;
 }
 
-static inline bool pagetable_pmd_ctor(struct ptdesc *ptdesc)
+static inline void __pagetable_pmd_ctor(struct ptdesc *ptdesc)
 {
 	struct folio *folio = ptdesc_folio(ptdesc);
 
-	if (!pmd_ptlock_init(ptdesc))
-		return false;
 	__folio_set_pgtable(folio);
 	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+}
+
+static inline bool pagetable_pmd_ctor(struct ptdesc *ptdesc)
+{
+	if (!pmd_ptlock_init(ptdesc))
+		return false;
+
+	__pagetable_pmd_ctor(ptdesc);
 	return true;
 }
 
-static inline void pagetable_pmd_dtor(struct ptdesc *ptdesc)
+static inline void __pagetable_pmd_dtor(struct ptdesc *ptdesc)
 {
 	struct folio *folio = ptdesc_folio(ptdesc);
 
-	pmd_ptlock_free(ptdesc);
 	__folio_clear_pgtable(folio);
 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
+static inline void pagetable_pmd_dtor(struct ptdesc *ptdesc)
+{
+	pmd_ptlock_free(ptdesc);
+	__pagetable_pmd_dtor(ptdesc);
+}
+
 /*
  * No scalability reason to split PUD locks yet, but follow the same pattern
  * as the PMD locks to make it easier if we decide to.  The VM should not be
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-pgtable-add-missing-flag-and-statistics-for-kernel-pte-page.patch
mm-pgtable-remove-unnecessary-split-ptlock-for-kernel-pmd-page.patch

