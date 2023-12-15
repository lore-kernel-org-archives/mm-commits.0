Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D3D41852
	for <mm-commits@vger.kernel.org>; Fri, 15 Dec 2023 19:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tgJoeoDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886E5C433C7;
	Fri, 15 Dec 2023 19:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702668308;
	bh=5vf7yGXzIuxiSpAAfs150pY1am9eEY5+Shj60p2lXk8=;
	h=Date:To:From:Subject:From;
	b=tgJoeoDsBTL3lCf2Ps5FKot+D+BU8mhhPj27iTOBkeGBELUFc+xG2HxMLAJ1Jqsg6
	 UJqEFtRyt59I5XN0S6o62U31wBvIRNhSFADXcVffENljxdNMPS0O2MHXZ2gPcYwwIG
	 ELhI/fOClFXe3jHzRjnKgsx/CclPtmWXwZelz58w=
Date: Fri, 15 Dec 2023 11:25:07 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,shakeelb@google.com,sachinp@linux.ibm.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch removed from -mm tree
Message-Id: <20231215192508.886E5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6
has been removed from the -mm tree.  Its filename was
     mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

This patch was dropped because it was folded into mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6
Date: Fri, 15 Sep 2023 16:34:17 +0800

fix NULL pointing derefence and hung task problem reported by Sachin

Link: https://lkml.kernel.org/r/20230915083417.3190512-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Tested-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sachin Sant <sachinp@linux.ibm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6
+++ a/mm/vmscan.c
@@ -324,7 +324,8 @@ static inline bool can_reclaim_anon_page
 			return true;
 		/* Is there any swapcache pages to reclaim? */
 		if (total_swapcache_pages() > 0) {
-			sc->swapcache_only = 1;
+			if (sc)
+				sc->swapcache_only = 1;
 			return true;
 		}
 	} else {
@@ -333,7 +334,8 @@ static inline bool can_reclaim_anon_page
 			return true;
 		/* Is there any swapcache pages in memcg to reclaim? */
 		if (mem_cgroup_get_nr_swapcache_pages(memcg) > 0) {
-			sc->swapcache_only = 1;
+			if (sc)
+				sc->swapcache_only = 1;
 			return true;
 		}
 	}
@@ -1597,19 +1599,6 @@ static bool skip_cma(struct folio *folio
 }
 #endif
 
-static bool skip_isolate(struct folio *folio, struct scan_control *sc,
-			 enum lru_list lru)
-{
-	if (folio_zonenum(folio) > sc->reclaim_idx)
-		return true;
-	if (skip_cma(folio, sc))
-		return true;
-	if (unlikely(sc->swapcache_only && !is_file_lru(lru) &&
-	    !folio_test_swapcache(folio)))
-		return true;
-	return false;
-}
-
 /*
  * Isolating page from the lruvec to fill in @dst list by nr_to_scan times.
  *
@@ -1656,7 +1645,8 @@ static unsigned long isolate_lru_folios(
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
 
-		if (skip_isolate(folio, sc, lru)) {
+		if (folio_zonenum(folio) > sc->reclaim_idx ||
+				skip_cma(folio, sc)) {
 			nr_skipped[folio_zonenum(folio)] += nr_pages;
 			move_to = &folios_skipped;
 			goto move;
@@ -1671,6 +1661,15 @@ static unsigned long isolate_lru_folios(
 		 */
 		scan += nr_pages;
 
+		/*
+		 * Count non-swapcache too because the swapcache pages may
+		 * be rare and it takes too much times here if not count
+		 * the non-swapcache pages.
+		 */
+		if (unlikely(sc->swapcache_only && !is_file_lru(lru) &&
+		    !folio_test_swapcache(folio)))
+			goto move;
+
 		if (!folio_test_lru(folio))
 			goto move;
 		if (!sc->may_unmap && folio_mapped(folio))
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch

