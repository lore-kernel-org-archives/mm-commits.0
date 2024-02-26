Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F9112FB25
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 18:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708973350; cv=none; b=V1LaJ03nuLMDE1M/ghKWWHSMIjaoXDXgnGelESaBCN+21SOSfIljQ6DpSvDcv59hhXZWaPKrkMHBX+4Rn4+BE78yhJt3qb5EJtxHO09eNOjYxcX75s5NrUtyc6PWlYAEIOZq5AklXEaBVPKzMR48st+bF1v1wXtBJ9PmAQz+o+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708973350; c=relaxed/simple;
	bh=yyYCwu5e0a29YeOSDcjd7n+kjrSQxHjpNY1lYu654R0=;
	h=Date:To:From:Subject:Message-Id; b=Vg7uuoiimwKekSXmgiEY+l05/SbM3taYFJru7MX/PBOwZG1TwZw/12RqhsJk6o1H0tcoP950wNwv+7vHW4aP0nFW0XBbY8QRaXd7VO8pOJsyzaQReizsp4jhFUoiE5L4hxhFudY7jJ7Yh//1TqwRrM7Mhf7zMZthhqssxPApMmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dvWQrsjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dvWQrsjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33521C433C7;
	Mon, 26 Feb 2024 18:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708973350;
	bh=yyYCwu5e0a29YeOSDcjd7n+kjrSQxHjpNY1lYu654R0=;
	h=Date:To:From:Subject:From;
	b=dvWQrsjP3LR+SgFXfbuDYSbqiW7jZp1S1KhwEPniPI/fL4xbILZiabdpNw5metGUl
	 iw65QgZny4bSD0emIYpKKNe2+0w36jNVs6yzEOnvag1ctqBW87TovjElQ8qY44qJdC
	 qFTPtMbQYBtM9OJg2jGVUYMyQNv6S6uu8TPUKluk=
Date: Mon, 26 Feb 2024 10:49:09 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,minchan@kernel.org,mhocko@suse.com,hannes@cmpxchg.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-pageout-ignore-references-rather-than-clearing-young.patch added to mm-unstable branch
Message-Id: <20240226184910.33521C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: madvise: pageout: ignore references rather than clearing young
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-pageout-ignore-references-rather-than-clearing-young.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-pageout-ignore-references-rather-than-clearing-young.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: madvise: pageout: ignore references rather than clearing young
Date: Mon, 26 Feb 2024 13:57:39 +1300

While doing MADV_PAGEOUT, the current code will clear PTE young so that
vmscan won't read young flags to allow the reclamation of madvised folios
to go ahead.  It seems we can do it by directly ignoring references, thus
we can remove tlb flush in madvise and rmap overhead in vmscan.

Regarding the side effect, in the original code, if a parallel thread runs
side by side to access the madvised memory with the thread doing madvise,
folios will get a chance to be re-activated by vmscan (though the time gap
is actually quite small since checking PTEs is done immediately after
clearing PTEs young).  But with this patch, they will still be reclaimed. 
But this behaviour doing PAGEOUT and doing access at the same time is
quite silly like DoS.  So probably, we don't need to care.  Or ignoring
the new access during the quite small time gap is even better.

For DAMON's DAMOS_PAGEOUT based on physical address region, we still keep
its behaviour as is since a physical address might be mapped by multiple
processes.  MADV_PAGEOUT based on virtual address is actually much more
aggressive on reclamation.  To untouch paddr's DAMOS_PAGEOUT, we simply
pass ignore_references as false in reclaim_pages().

A microbench as below has shown 6% decrement on the latency of
MADV_PAGEOUT,

 #define PGSIZE 4096
 main()
 {
 	int i;
 #define SIZE 512*1024*1024
 	volatile long *p = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
 			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

 	for (i = 0; i < SIZE/sizeof(long); i += PGSIZE / sizeof(long))
 		p[i] =  0x11;

 	madvise(p, SIZE, MADV_PAGEOUT);
 }

w/o patch                    w/ patch
root@10:~# time ./a.out      root@10:~# time ./a.out
real	0m49.634s            real   0m46.334s
user	0m0.637s             user   0m0.648s
sys	0m47.434s            sys    0m44.265s

Link: https://lkml.kernel.org/r/20240226005739.24350-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    2 +-
 mm/internal.h    |    2 +-
 mm/madvise.c     |    8 ++++----
 mm/vmscan.c      |   12 +++++++-----
 4 files changed, 13 insertions(+), 11 deletions(-)

--- a/mm/damon/paddr.c~mm-madvise-pageout-ignore-references-rather-than-clearing-young
+++ a/mm/damon/paddr.c
@@ -249,7 +249,7 @@ static unsigned long damon_pa_pageout(st
 put_folio:
 		folio_put(folio);
 	}
-	applied = reclaim_pages(&folio_list);
+	applied = reclaim_pages(&folio_list, false);
 	cond_resched();
 	return applied * PAGE_SIZE;
 }
--- a/mm/internal.h~mm-madvise-pageout-ignore-references-rather-than-clearing-young
+++ a/mm/internal.h
@@ -870,7 +870,7 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
-unsigned long reclaim_pages(struct list_head *folio_list);
+unsigned long reclaim_pages(struct list_head *folio_list, bool ignore_references);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
 /* The ALLOC_WMARK bits are used as an index to zone->watermark */
--- a/mm/madvise.c~mm-madvise-pageout-ignore-references-rather-than-clearing-young
+++ a/mm/madvise.c
@@ -386,7 +386,7 @@ static int madvise_cold_or_pageout_pte_r
 			return 0;
 		}
 
-		if (pmd_young(orig_pmd)) {
+		if (!pageout && pmd_young(orig_pmd)) {
 			pmdp_invalidate(vma, addr, pmd);
 			orig_pmd = pmd_mkold(orig_pmd);
 
@@ -410,7 +410,7 @@ static int madvise_cold_or_pageout_pte_r
 huge_unlock:
 		spin_unlock(ptl);
 		if (pageout)
-			reclaim_pages(&folio_list);
+			reclaim_pages(&folio_list, true);
 		return 0;
 	}
 
@@ -490,7 +490,7 @@ restart:
 
 		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
 
-		if (pte_young(ptent)) {
+		if (!pageout && pte_young(ptent)) {
 			ptent = ptep_get_and_clear_full(mm, addr, pte,
 							tlb->fullmm);
 			ptent = pte_mkold(ptent);
@@ -524,7 +524,7 @@ restart:
 		pte_unmap_unlock(start_pte, ptl);
 	}
 	if (pageout)
-		reclaim_pages(&folio_list);
+		reclaim_pages(&folio_list, true);
 	cond_resched();
 
 	return 0;
--- a/mm/vmscan.c~mm-madvise-pageout-ignore-references-rather-than-clearing-young
+++ a/mm/vmscan.c
@@ -2088,7 +2088,8 @@ static void shrink_active_list(unsigned
 }
 
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
-				      struct pglist_data *pgdat)
+				      struct pglist_data *pgdat,
+				      bool ignore_references)
 {
 	struct reclaim_stat dummy_stat;
 	unsigned int nr_reclaimed;
@@ -2101,7 +2102,7 @@ static unsigned int reclaim_folio_list(s
 		.no_demotion = 1,
 	};
 
-	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &dummy_stat, false);
+	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &dummy_stat, ignore_references);
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
@@ -2111,7 +2112,7 @@ static unsigned int reclaim_folio_list(s
 	return nr_reclaimed;
 }
 
-unsigned long reclaim_pages(struct list_head *folio_list)
+unsigned long reclaim_pages(struct list_head *folio_list, bool ignore_references)
 {
 	int nid;
 	unsigned int nr_reclaimed = 0;
@@ -2133,11 +2134,12 @@ unsigned long reclaim_pages(struct list_
 			continue;
 		}
 
-		nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid));
+		nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid),
+						   ignore_references);
 		nid = folio_nid(lru_to_folio(folio_list));
 	} while (!list_empty(folio_list));
 
-	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid));
+	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid), ignore_references);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

docs-mm-damon-design-remove-the-details-for-pageout-as-paddr-doesnt-use-madv_pageout.patch
mm-madvise-pageout-ignore-references-rather-than-clearing-young.patch

