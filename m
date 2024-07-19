Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40AF1B86F8
	for <mm-commits@vger.kernel.org>; Fri, 19 Jul 2024 04:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721364869; cv=none; b=CPjR+peTORwdBmeBHjIvILo2c/WXVcCUIfIpa2l/m5Xmr4KkM/nhDlnRXp1p5W9TYEPvPINdUNiqVsSFp0iu48vFWno0LDA2K/mWfLJYHocFq3o72Mx2D1IcL3s94QgcFnNpg08gH+L84tmYAqYrbpBInthHfUMvVEjQqAZdnao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721364869; c=relaxed/simple;
	bh=A14lc8m0Bx1EG7X6UGC5YUSBQv9+qMkltT6Kanx3WfY=;
	h=Date:To:From:Subject:Message-Id; b=svsQlpAInTG+eXMFcfKf5FNJdQjNkqyxxVuJqfCNd1o15pceb/8VtYoizwiSrQHSUU2rLBenkLyzYvW2drGAvVdEIUYnWN2cvGkqYuLsUjVRf4mbBv2EZTPlPlPvLc1gkQb/8J0zpCh5iHYS2I2OQQJKUaqY17rE9GnFdTLvdV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZVGzif2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZVGzif2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D56C32782;
	Fri, 19 Jul 2024 04:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721364869;
	bh=A14lc8m0Bx1EG7X6UGC5YUSBQv9+qMkltT6Kanx3WfY=;
	h=Date:To:From:Subject:From;
	b=ZVGzif2bESF9Blbkrt7MWJOG7cocpGRDVWVb14/09DBfs2V+lwKTra0NY7315G9md
	 wxe1v1fXy9yc0ChfWtqmpzvKBG6uWwaRH4wbfVJ1DitS8KUYjt+TETPbbsiY2suxJL
	 mEP105w42dK0qo5+rkxD7X/zyXrRc49jDHQ2Hszw=
Date: Thu, 18 Jul 2024 21:54:28 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,muchun.song@linux.dev,mhartmay@linux.ibm.com,frankja@linux.ibm.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch added to mm-unstable branch
Message-Id: <20240719045429.39D56C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_vmemmap: don't synchronize_rcu() without HVO
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch

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
Cc: Muchun Song <muchun.song@linux.dev>
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
 
@@ -460,6 +462,9 @@ static int __hugetlb_vmemmap_restore_fol
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
+	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
+		synchronize_rcu();
+
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 	vmemmap_reuse	= vmemmap_start;
 	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
@@ -492,10 +497,7 @@ static int __hugetlb_vmemmap_restore_fol
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
@@ -518,14 +520,14 @@ long hugetlb_vmemmap_restore_folios(cons
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
@@ -573,6 +575,9 @@ static int __hugetlb_vmemmap_optimize_fo
 		return ret;
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
+
+	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
+		synchronize_rcu();
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -620,10 +625,7 @@ void hugetlb_vmemmap_optimize_folio(cons
 {
 	LIST_HEAD(vmemmap_pages);
 
-	/* avoid writes from page_ref_add_unless() while folding vmemmap */
-	synchronize_rcu();
-
-	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
+	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, VMEMMAP_SYNCHRONIZE_RCU);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -650,6 +652,7 @@ void hugetlb_vmemmap_optimize_folios(str
 {
 	struct folio *folio;
 	LIST_HEAD(vmemmap_pages);
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
 
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret = hugetlb_vmemmap_split_folio(h, folio);
@@ -666,14 +669,12 @@ void hugetlb_vmemmap_optimize_folios(str
 
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
@@ -687,8 +688,7 @@ void hugetlb_vmemmap_optimize_folios(str
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

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch

