Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D293BB47
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957172; cv=none; b=sFAB6MjNj/IHtEzj7LHNdtMR8yIlKlZNkgloQ1++tZwfVBSrjmoOjrkVe1W7nuPVm7IdX/qgr+pbrGHqk2j+3+KNIG4WTHZU4tteELaFKKGSf/ML+5N5iJaWlpKbe1pvnL1rfNXZ4AdT5dRmtyO03khWhhDgPzF4ZejXaw2GsAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957172; c=relaxed/simple;
	bh=Q3pvpDDDtgcNnOjsRE7Ob7PDtzuSik0RRYedFlaqT3U=;
	h=Date:To:From:Subject:Message-Id; b=XYtyfViqjlIip+N1FIQe6hDKt/qvhfbjoS/UgsRnhRpwELmIsRdc4MANyad1FLEJdnt3RLehrJi8aifiPubs1bvkSj/aDBE7HTXdk2ZEV5M85ZGbmUBZ6aWKvVfvnZA0pPye8oi2H4Vp1iG9jHsopj8m01w+Vd8jgLhQt/+mnkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q8i+0kNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q8i+0kNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F19C116B1;
	Mon,  6 May 2024 00:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957171;
	bh=Q3pvpDDDtgcNnOjsRE7Ob7PDtzuSik0RRYedFlaqT3U=;
	h=Date:To:From:Subject:From;
	b=Q8i+0kNitwmhDwARP7Htubi5fh66nX6F60C9AwNdAGD6n43Y5CCNS0E2YFmg6u2vR
	 hlGj6zWC8dS7FUZcUfkR4KpzpueATgKwrixvnGcFeXsyE7G1p+wNNRAIf/8DrDprVZ
	 wn2Yfx8U3fTWIEX/IF2sFDEYS+V4EKlATVXE6I0s=
Date: Sun, 05 May 2024 17:59:30 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch removed from -mm tree
Message-Id: <20240506005931.15F19C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: remove ignore_references argument of reclaim_pages()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/vmscan: remove ignore_references argument of reclaim_pages()
Date: Mon, 29 Apr 2024 15:44:50 -0700

All reclaim_pages() callers are setting 'ignore_references' parameter
'true'.  In other words, the parameter is not really being used.  Remove
the argument to make it simple.

Link: https://lkml.kernel.org/r/20240429224451.67081-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    2 +-
 mm/internal.h    |    2 +-
 mm/madvise.c     |    4 ++--
 mm/vmscan.c      |    6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

--- a/mm/damon/paddr.c~mm-vmscan-remove-ignore_references-argument-of-reclaim_pages
+++ a/mm/damon/paddr.c
@@ -283,7 +283,7 @@ put_folio:
 	}
 	if (install_young_filter)
 		damos_destroy_filter(filter);
-	applied = reclaim_pages(&folio_list, true);
+	applied = reclaim_pages(&folio_list);
 	cond_resched();
 	return applied * PAGE_SIZE;
 }
--- a/mm/internal.h~mm-vmscan-remove-ignore_references-argument-of-reclaim_pages
+++ a/mm/internal.h
@@ -1052,7 +1052,7 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
-unsigned long reclaim_pages(struct list_head *folio_list, bool ignore_references);
+unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
 /* The ALLOC_WMARK bits are used as an index to zone->watermark */
--- a/mm/madvise.c~mm-vmscan-remove-ignore_references-argument-of-reclaim_pages
+++ a/mm/madvise.c
@@ -423,7 +423,7 @@ static int madvise_cold_or_pageout_pte_r
 huge_unlock:
 		spin_unlock(ptl);
 		if (pageout)
-			reclaim_pages(&folio_list, true);
+			reclaim_pages(&folio_list);
 		return 0;
 	}
 
@@ -547,7 +547,7 @@ restart:
 		pte_unmap_unlock(start_pte, ptl);
 	}
 	if (pageout)
-		reclaim_pages(&folio_list, true);
+		reclaim_pages(&folio_list);
 	cond_resched();
 
 	return 0;
--- a/mm/vmscan.c~mm-vmscan-remove-ignore_references-argument-of-reclaim_pages
+++ a/mm/vmscan.c
@@ -2133,7 +2133,7 @@ static unsigned int reclaim_folio_list(s
 	return nr_reclaimed;
 }
 
-unsigned long reclaim_pages(struct list_head *folio_list, bool ignore_references)
+unsigned long reclaim_pages(struct list_head *folio_list)
 {
 	int nid;
 	unsigned int nr_reclaimed = 0;
@@ -2156,11 +2156,11 @@ unsigned long reclaim_pages(struct list_
 		}
 
 		nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid),
-						   ignore_references);
+						   true);
 		nid = folio_nid(lru_to_folio(folio_list));
 	} while (!list_empty(folio_list));
 
-	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid), ignore_references);
+	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid), true);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

