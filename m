Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B20487BF
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175638; cv=none; b=WcITQwL56Tx3CWjYfNpAaULNKdyYmKUZ1c9xBB/cpr4LiZIwIlNkLic9qb6FQDu2e323Wf/SVKKQmFn+iSsAAeoRT7uRWzp8FxqZySqW2mJD5oplZtGN1BIpTssEILrgjMmlj0Wju6XsI/QkWECjY0fIKh55/TZrfVWHNIp+jGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175638; c=relaxed/simple;
	bh=sIy7USjZB/Owob1JIiCRSXJeM3YHL5PrROZsmuOOLG4=;
	h=Date:To:From:Subject:Message-Id; b=Mue1/+pMTpgvD1tx2rILW0V/ItRQU6xzce2SYmRn8rnFuGZzGf5RwapN5S33l90kPDJbVQYlALJN6EHyG7I92YzP0WHdf72mwYaQMxkBR5CCF5lq97eP2292U6FUgtn4lQabzZYYXTT6Fs10BqLY1ItV6f/pB4bM7yOhhY3wdy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f77lbZ1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f77lbZ1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8B0C433C7;
	Mon,  5 Feb 2024 23:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707175638;
	bh=sIy7USjZB/Owob1JIiCRSXJeM3YHL5PrROZsmuOOLG4=;
	h=Date:To:From:Subject:From;
	b=f77lbZ1Dy56nVRKbCjKfFD5+fAcnye0a1mwzBFfj9nBFpfHWHh+weec0lJcHpJJwC
	 K7KILUYqLsmCZLQ38L3xbA3HDM9LeCN40+tddDIfQKKHHG3yeXIxct8NINEDemlmml
	 FrEv2vfYZISi/cFGYd9b0H2sHBoIa782RrISuKr0=
Date: Mon, 05 Feb 2024 15:27:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-pgtable-remove-unnecessary-split-ptlock-for-kernel-pmd-page.patch removed from -mm tree
Message-Id: <20240205232717.EB8B0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: remove unnecessary split ptlock for kernel PMD page
has been removed from the -mm tree.  Its filename was
     mm-pgtable-remove-unnecessary-split-ptlock-for-kernel-pmd-page.patch

This patch was dropped because it was nacked

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


