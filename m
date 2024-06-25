Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBC6136E28;
	Tue, 25 Jun 2024 03:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287567; cv=none; b=qqYDKp3H9Hxe42rXxrduKHSfq8FtdsArWy45D91u2fmzVVAHYe7JDfJNbZbSJEX22Fd9ePFlFVoaPMgI8JnS7M6GYSb9q0Dm1Se3GJ/K/Obw+gyJ+ZQHdnKSJ6M+VWl9wrOvxA/TEQ2+blAJr3kRi6qTlpJRv3epim/UZgCjFA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287567; c=relaxed/simple;
	bh=ogOfrsBqP/kQg9Sev5wQcSuHEK53h1n/xgo7qmc2Gig=;
	h=Date:To:From:Subject:Message-Id; b=m+jt5Mp0i/CmcAS+2POlnldofrzvUBLNNXy2gX8I83bSPlz0scU29mgvAlzZlv+7/pyhnSeKPWIS3e8kYbOwI3yAocv4dw5DBfrTZll0IFiXFvOq5BoxeOEuryrhVXloWDtcK9EpKxukxxU+N6119yiAyRzrvPQFeDfRdjqKYhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XGY/LfiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XGY/LfiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7BFC4AF09;
	Tue, 25 Jun 2024 03:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719287567;
	bh=ogOfrsBqP/kQg9Sev5wQcSuHEK53h1n/xgo7qmc2Gig=;
	h=Date:To:From:Subject:From;
	b=XGY/LfiYlsDR8yUBkbQZh3ft7G8Ui6xE+YvKMqRj8Vg5TGsQVKmwAJrucEdp9lDWD
	 w5Jw9GLvxJqU69jNTEGJylT2RNsX0dKa367YPvHMsWZfscGUA+FaLEIJH495bq+nl2
	 D2raz6XtDO3JKNqEACkbVu6ke6CkTVIAmyaWrsQQ=
Date: Mon, 24 Jun 2024 20:52:46 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mgorman@techsingularity.net,baolin.wang@linux.alibaba.com,21cnbao@gmail.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-separate-thp-pcp-into-movable-and-non-movable-categories.patch removed from -mm tree
Message-Id: <20240625035247.5E7BFC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: Separate THP PCP into movable and non-movable categories
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-separate-thp-pcp-into-movable-and-non-movable-categories.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: yangge <yangge1116@126.com>
Subject: mm/page_alloc: Separate THP PCP into movable and non-movable categories
Date: Thu, 20 Jun 2024 08:59:50 +0800

Since commit 5d0a661d808f ("mm/page_alloc: use only one PCP list for
THP-sized allocations") no longer differentiates the migration type of
pages in THP-sized PCP list, it's possible that non-movable allocation
requests may get a CMA page from the list, in some cases, it's not
acceptable.

If a large number of CMA memory are configured in system (for example, the
CMA memory accounts for 50% of the system memory), starting a virtual
machine with device passthrough will get stuck.  During starting the
virtual machine, it will call pin_user_pages_remote(..., FOLL_LONGTERM,
...) to pin memory.  Normally if a page is present and in CMA area,
pin_user_pages_remote() will migrate the page from CMA area to non-CMA
area because of FOLL_LONGTERM flag.  But if non-movable allocation
requests return CMA memory, migrate_longterm_unpinnable_pages() will
migrate a CMA page to another CMA page, which will fail to pass the check
in check_and_migrate_movable_pages() and cause migration endless.

Call trace:
pin_user_pages_remote
--__gup_longterm_locked // endless loops in this function
----_get_user_pages_locked
----check_and_migrate_movable_pages
------migrate_longterm_unpinnable_pages
--------alloc_migration_target

This problem will also have a negative impact on CMA itself.  For example,
when CMA is borrowed by THP, and we need to reclaim it through cma_alloc()
or dma_alloc_coherent(), we must move those pages out to ensure CMA's
users can retrieve that contigous memory.  Currently, CMA's memory is
occupied by non-movable pages, meaning we can't relocate them.  As a
result, cma_alloc() is more likely to fail.

To fix the problem above, we add one PCP list for THP, which will not
introduce a new cacheline for struct per_cpu_pages.  THP will have 2 PCP
lists, one PCP list is used by MOVABLE allocation, and the other PCP list
is used by UNMOVABLE allocation.  MOVABLE allocation contains GPF_MOVABLE,
and UNMOVABLE allocation contains GFP_UNMOVABLE and GFP_RECLAIMABLE.

Link: https://lkml.kernel.org/r/1718845190-4456-1-git-send-email-yangge1116@126.com
Fixes: 5d0a661d808f ("mm/page_alloc: use only one PCP list for THP-sized allocations")
Signed-off-by: yangge <yangge1116@126.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    9 ++++-----
 mm/page_alloc.c        |    9 +++++++--
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-separate-thp-pcp-into-movable-and-non-movable-categories
+++ a/include/linux/mmzone.h
@@ -654,13 +654,12 @@ enum zone_watermarks {
 };
 
 /*
- * One per migratetype for each PAGE_ALLOC_COSTLY_ORDER. One additional list
- * for THP which will usually be GFP_MOVABLE. Even if it is another type,
- * it should not contribute to serious fragmentation causing THP allocation
- * failures.
+ * One per migratetype for each PAGE_ALLOC_COSTLY_ORDER. Two additional lists
+ * are added for THP. One PCP list is used by GPF_MOVABLE, and the other PCP list
+ * is used by GFP_UNMOVABLE and GFP_RECLAIMABLE.
  */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define NR_PCP_THP 1
+#define NR_PCP_THP 2
 #else
 #define NR_PCP_THP 0
 #endif
--- a/mm/page_alloc.c~mm-page_alloc-separate-thp-pcp-into-movable-and-non-movable-categories
+++ a/mm/page_alloc.c
@@ -504,10 +504,15 @@ out:
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
+	bool __maybe_unused movable;
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
 		VM_BUG_ON(order != HPAGE_PMD_ORDER);
-		return NR_LOWORDER_PCP_LISTS;
+
+		movable = migratetype == MIGRATE_MOVABLE;
+
+		return NR_LOWORDER_PCP_LISTS + movable;
 	}
 #else
 	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
@@ -521,7 +526,7 @@ static inline int pindex_to_order(unsign
 	int order = pindex / MIGRATE_PCPTYPES;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pindex == NR_LOWORDER_PCP_LISTS)
+	if (pindex >= NR_LOWORDER_PCP_LISTS)
 		order = HPAGE_PMD_ORDER;
 #else
 	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
_

Patches currently in -mm which might be from yangge1116@126.com are

mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch

