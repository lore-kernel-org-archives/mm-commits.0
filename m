Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7C814B810
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 19:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708628932; cv=none; b=WRlS3jnRA4lyj36nFPuy4gweiHsVvLsLmgewahPqFZ9Otwb/xJ1pGH8E4FnQ6mOM5eRMex5E38XwVrhU4CykOfRaqTf4l+OEoCKAJd34cNUjRC5wCu5/giQoAHT0q41WdwiUjjE+j/XsQZhiPVaA7DBKJ1jt07xGkTmBQ7e8lkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708628932; c=relaxed/simple;
	bh=MHSAveL1SZLhGHzziwiwuLo6n4XjpeTymzMZsJ5B2Vc=;
	h=Date:To:From:Subject:Message-Id; b=kXVelYWLBGjGzRg11vTSsshYBLWyxc4sPqzR/9Oni9/nbqog8xKi9fd9mOcBeAojiChKFLRtPJdpgcXY0E88SqQMo54qrdsXMrUSinLigAbKMssa/lVciU6ZyuIcrWSN2KtobhLnSQLHhdiAIrvyVkjLAPskVSPl/RPW9BeOT2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eBOiqql1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eBOiqql1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0366C43390;
	Thu, 22 Feb 2024 19:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708628931;
	bh=MHSAveL1SZLhGHzziwiwuLo6n4XjpeTymzMZsJ5B2Vc=;
	h=Date:To:From:Subject:From;
	b=eBOiqql1h0Jl1xdllgq/ALo25PFWVHaYSUDKJh2XF7fj+YjpaKaWZHqmnTIhgDqo2
	 VXr+68f2XAyniVFrSmEpoiaTCXl1oG5uD6To78NI2MXBmqRuREHDDLAuiznqXUofSS
	 16Mg8Zqhlre33jmsofITmQSOGLp5HXkOrqhjLLzg=
Date: Thu, 22 Feb 2024 11:08:51 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,rientjes@google.com,muchun.song@linux.dev,ligang.bdlg@bytedance.com,gang.li@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-split-hugetlb_hstate_alloc_pages.patch added to mm-unstable branch
Message-Id: <20240222190851.B0366C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: split hugetlb_hstate_alloc_pages
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-split-hugetlb_hstate_alloc_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-split-hugetlb_hstate_alloc_pages.patch

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
From: Gang Li <gang.li@linux.dev>
Subject: hugetlb: split hugetlb_hstate_alloc_pages
Date: Thu, 22 Feb 2024 22:04:15 +0800

1G and 2M huge pages have different allocation and initialization logic,
which leads to subtle differences in parallelization.  Therefore, it is
appropriate to split hugetlb_hstate_alloc_pages into gigantic and
non-gigantic.

This patch has no functional changes.

Link: https://lkml.kernel.org/r/20240222140422.393911-3-gang.li@linux.dev
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Tested-by: David Rientjes <rientjes@google.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   87 ++++++++++++++++++++++++-------------------------
 1 file changed, 43 insertions(+), 44 deletions(-)

--- a/mm/hugetlb.c~hugetlb-split-hugetlb_hstate_alloc_pages
+++ a/mm/hugetlb.c
@@ -3509,6 +3509,43 @@ static void __init hugetlb_hstate_alloc_
 	}
 }
 
+static unsigned long __init hugetlb_gigantic_pages_alloc_boot(struct hstate *h)
+{
+	unsigned long i;
+
+	for (i = 0; i < h->max_huge_pages; ++i) {
+		if (!alloc_bootmem_huge_page(h, NUMA_NO_NODE))
+			break;
+		cond_resched();
+	}
+
+	return i;
+}
+
+static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
+{
+	unsigned long i;
+	struct folio *folio;
+	LIST_HEAD(folio_list);
+	nodemask_t node_alloc_noretry;
+
+	/* Bit mask controlling how hard we retry per-node allocations.*/
+	nodes_clear(node_alloc_noretry);
+
+	for (i = 0; i < h->max_huge_pages; ++i) {
+		folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY],
+						&node_alloc_noretry);
+		if (!folio)
+			break;
+		list_add(&folio->lru, &folio_list);
+		cond_resched();
+	}
+
+	prep_and_add_allocated_folios(h, &folio_list);
+
+	return i;
+}
+
 /*
  * NOTE: this routine is called in different contexts for gigantic and
  * non-gigantic pages.
@@ -3522,10 +3559,7 @@ static void __init hugetlb_hstate_alloc_
  */
 static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
-	unsigned long i;
-	struct folio *folio;
-	LIST_HEAD(folio_list);
-	nodemask_t *node_alloc_noretry;
+	unsigned long allocated;
 
 	/* skip gigantic hugepages allocation if hugetlb_cma enabled */
 	if (hstate_is_gigantic(h) && hugetlb_cma_size) {
@@ -3538,47 +3572,12 @@ static void __init hugetlb_hstate_alloc_
 		return;
 
 	/* below will do all node balanced alloc */
-	if (!hstate_is_gigantic(h)) {
-		/*
-		 * Bit mask controlling how hard we retry per-node allocations.
-		 * Ignore errors as lower level routines can deal with
-		 * node_alloc_noretry == NULL.  If this kmalloc fails at boot
-		 * time, we are likely in bigger trouble.
-		 */
-		node_alloc_noretry = kmalloc(sizeof(*node_alloc_noretry),
-						GFP_KERNEL);
-	} else {
-		/* allocations done at boot time */
-		node_alloc_noretry = NULL;
-	}
-
-	/* bit mask controlling how hard we retry per-node allocations */
-	if (node_alloc_noretry)
-		nodes_clear(*node_alloc_noretry);
-
-	for (i = 0; i < h->max_huge_pages; ++i) {
-		if (hstate_is_gigantic(h)) {
-			/*
-			 * gigantic pages not added to list as they are not
-			 * added to pools now.
-			 */
-			if (!alloc_bootmem_huge_page(h, NUMA_NO_NODE))
-				break;
-		} else {
-			folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY],
-							node_alloc_noretry);
-			if (!folio)
-				break;
-			list_add(&folio->lru, &folio_list);
-		}
-		cond_resched();
-	}
-
-	/* list will be empty if hstate_is_gigantic */
-	prep_and_add_allocated_folios(h, &folio_list);
+	if (hstate_is_gigantic(h))
+		allocated = hugetlb_gigantic_pages_alloc_boot(h);
+	else
+		allocated = hugetlb_pages_alloc_boot(h);
 
-	hugetlb_hstate_alloc_pages_errcheck(i, h);
-	kfree(node_alloc_noretry);
+	hugetlb_hstate_alloc_pages_errcheck(allocated, h);
 }
 
 static void __init hugetlb_init_hstates(void)
_

Patches currently in -mm which might be from gang.li@linux.dev are

hugetlb-code-clean-for-hugetlb_hstate_alloc_pages.patch
hugetlb-split-hugetlb_hstate_alloc_pages.patch
hugetlb-pass-next_nid_to_alloc-directly-to-for_each_node_mask_to_alloc.patch
padata-dispatch-works-on-different-nodes.patch
padata-downgrade-padata_do_multithreaded-to-serial-execution-for-non-smp.patch
hugetlb-have-config_hugetlbfs-select-config_padata.patch
hugetlb-parallelize-2m-hugetlb-allocation-and-initialization.patch
hugetlb-parallelize-1g-hugetlb-initialization.patch

