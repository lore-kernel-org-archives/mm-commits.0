Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABBCEED617
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 16:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjIOQ1G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 12:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbjIOQ0k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 12:26:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05222126
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 09:26:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0CBC433C7;
        Fri, 15 Sep 2023 16:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694795192;
        bh=KAPgbC5TGc8z0+I5gFNVxdXQ1BHZV8NGD+pHHyyAJRA=;
        h=Date:To:From:Subject:From;
        b=iYL/YLcwntqcgJCJ2MydBRvuX9NGdYTBeh+y1xjfW8gR2PaRJ3PTTYEtFhMWjovFn
         gj5kmnA+C+Uj8IdCidK7GTLCqhvH5QEbM4O1jG0xUdzo35QVWqOmc99n0F7VvjQ8mt
         0+flVmDOFvA7MZPwPLT11nBsZuNrgcJwOKpBdfSE=
Date:   Fri, 15 Sep 2023 09:26:31 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, wangkefeng.wang@huawei.com,
        shakeelb@google.com, sachinp@linux.ibm.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch added to mm-unstable branch
Message-Id: <20230915162632.7E0CBC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

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
@@ -618,7 +618,8 @@ static inline bool can_reclaim_anon_page
 			return true;
 		/* Is there any swapcache pages to reclaim? */
 		if (total_swapcache_pages() > 0) {
-			sc->swapcache_only = 1;
+			if (sc)
+				sc->swapcache_only = 1;
 			return true;
 		}
 	} else {
@@ -627,7 +628,8 @@ static inline bool can_reclaim_anon_page
 			return true;
 		/* Is there any swapcache pages in memcg to reclaim? */
 		if (mem_cgroup_get_nr_swapcache_pages(memcg) > 0) {
-			sc->swapcache_only = 1;
+			if (sc)
+				sc->swapcache_only = 1;
 			return true;
 		}
 	}
@@ -2293,19 +2295,6 @@ static bool skip_cma(struct folio *folio
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
@@ -2352,7 +2341,8 @@ static unsigned long isolate_lru_folios(
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
 
-		if (skip_isolate(folio, sc, lru)) {
+		if (folio_zonenum(folio) > sc->reclaim_idx ||
+				skip_cma(folio, sc)) {
 			nr_skipped[folio_zonenum(folio)] += nr_pages;
 			move_to = &folios_skipped;
 			goto move;
@@ -2367,6 +2357,15 @@ static unsigned long isolate_lru_folios(
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
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

