Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059D53A8CB
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247667; cv=none; b=af74o0SOFmKWuC+hawu5RPGf49TtYbsdi4Rfi9kYF1nsrI5nGYurDRZWL+wiLA7WKsiyEy9tpbRJAAOB+tty1k0RZDktJybSZ7cGsKdfVI9em6zaWgxA+MNwlGFenGUE031pgEDC6SFiiUAcmdB411X5y5rVDxBRW5YB7y+io38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247667; c=relaxed/simple;
	bh=ddUxWJrWYLS55UfjcrDOliSgLAK0uWlC/5R7pWmTQGM=;
	h=Date:To:From:Subject:Message-Id; b=KZAtqNCwc1MqCLTmra5ihibSGU1eOLGqzkAwzCkiSpVM2Ra+ubKxBlt4BMdoZdrORYPlYpjhzHnfb//oiJlj13YMWHMS8vY8nJ1/uJ6PW1Tg/1HFFo+cRM6CC/8uF8BLPj7lITZqmwZh1dGy2ITwrr2GlYWqHymmsv9VGimfYHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FvnT8rP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FvnT8rP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9D0C4CEC2;
	Mon,  2 Sep 2024 03:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247666;
	bh=ddUxWJrWYLS55UfjcrDOliSgLAK0uWlC/5R7pWmTQGM=;
	h=Date:To:From:Subject:From;
	b=FvnT8rP7HvtWLxmoHtOZPunELYH9W/xhmnbSoBiyBLOzw6V3kxxsRH2ZNX+K7UZsC
	 msFn1fTjvVwx9epey9W3CDyGYBxqnwJ/HF8GoE+Cj8YN7xY3OksLcZRql6QAvk508a
	 2EhPRFXxpsEucGpbC6vS4w/hzH5UbxPKIp8KjHvY=
Date: Sun, 01 Sep 2024 20:27:45 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,muchun.song@linux.dev,mhartmay@linux.ibm.com,frankja@linux.ibm.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch removed from -mm tree
Message-Id: <20240902032746.6E9D0C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_vmemmap: don't synchronize_rcu() without HVO
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/hugetlb_vmemmap: don't synchronize_rcu() without HVO
Date: Thu, 18 Jul 2024 22:25:03 -0600

hugetlb_vmemmap_optimize_folio() and hugetlb_vmemmap_restore_folio() are
wrappers meant to be called regardless of whether HVO is enabled. 
Therefore, they should not call synchronize_rcu().  Otherwise, it
regresses use cases not enabling HVO.

So move synchronize_rcu() to __hugetlb_vmemmap_optimize_folio() and
__hugetlb_vmemmap_restore_folio(), and call it once for each batch of
folios when HVO is enabled.

Link: https://lkml.kernel.org/r/20240719042503.2752316-1-yuzhao@google.com
Fixes: bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative PFN walkers")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407091001.1250ad4a-oliver.sang@intel.com
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Tested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo
+++ a/mm/hugetlb_vmemmap.c
@@ -43,6 +43,8 @@ struct vmemmap_remap_walk {
 #define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
 /* Skip the TLB flush when we remap the PTE */
 #define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
+/* synchronize_rcu() to avoid writes from page_ref_add_unless() */
+#define VMEMMAP_SYNCHRONIZE_RCU		BIT(2)
 	unsigned long		flags;
 };
 
@@ -457,6 +459,9 @@ static int __hugetlb_vmemmap_restore_fol
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
+	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
+		synchronize_rcu();
+
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 	vmemmap_reuse	= vmemmap_start;
 	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
@@ -489,10 +494,7 @@ static int __hugetlb_vmemmap_restore_fol
  */
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
-	/* avoid writes from page_ref_add_unless() while unfolding vmemmap */
-	synchronize_rcu();
-
-	return __hugetlb_vmemmap_restore_folio(h, folio, 0);
+	return __hugetlb_vmemmap_restore_folio(h, folio, VMEMMAP_SYNCHRONIZE_RCU);
 }
 
 /**
@@ -515,14 +517,14 @@ long hugetlb_vmemmap_restore_folios(cons
 	struct folio *folio, *t_folio;
 	long restored = 0;
 	long ret = 0;
-
-	/* avoid writes from page_ref_add_unless() while unfolding vmemmap */
-	synchronize_rcu();
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
-			ret = __hugetlb_vmemmap_restore_folio(h, folio,
-							      VMEMMAP_REMAP_NO_TLB_FLUSH);
+			ret = __hugetlb_vmemmap_restore_folio(h, folio, flags);
+			/* only need to synchronize_rcu() once for each batch */
+			flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
+
 			if (ret)
 				break;
 			restored++;
@@ -570,6 +572,9 @@ static int __hugetlb_vmemmap_optimize_fo
 		return ret;
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
+
+	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
+		synchronize_rcu();
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -617,10 +622,7 @@ void hugetlb_vmemmap_optimize_folio(cons
 {
 	LIST_HEAD(vmemmap_pages);
 
-	/* avoid writes from page_ref_add_unless() while folding vmemmap */
-	synchronize_rcu();
-
-	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
+	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, VMEMMAP_SYNCHRONIZE_RCU);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -647,6 +649,7 @@ void hugetlb_vmemmap_optimize_folios(str
 {
 	struct folio *folio;
 	LIST_HEAD(vmemmap_pages);
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
 
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret = hugetlb_vmemmap_split_folio(h, folio);
@@ -663,14 +666,12 @@ void hugetlb_vmemmap_optimize_folios(str
 
 	flush_tlb_all();
 
-	/* avoid writes from page_ref_add_unless() while folding vmemmap */
-	synchronize_rcu();
-
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
-		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages,
-						       VMEMMAP_REMAP_NO_TLB_FLUSH);
+		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, flags);
+		/* only need to synchronize_rcu() once for each batch */
+		flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
 
 		/*
 		 * Pages to be freed may have been accumulated.  If we
@@ -684,8 +685,7 @@ void hugetlb_vmemmap_optimize_folios(str
 			flush_tlb_all();
 			free_vmemmap_page_list(&vmemmap_pages);
 			INIT_LIST_HEAD(&vmemmap_pages);
-			__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages,
-							 VMEMMAP_REMAP_NO_TLB_FLUSH);
+			__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, flags);
 		}
 	}
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-contig_alloc-support-__gfp_comp.patch
mm-cma-add-cma_allocfree_folio.patch
mm-cma-add-cma_allocfree_folio-fix.patch
mm-hugetlb-use-__gfp_comp-for-gigantic-folios.patch
mm-free-zapped-tail-pages-when-splitting-isolated-thp.patch
mm-remap-unused-subpages-to-shared-zeropage-when-splitting-isolated-thp.patch

