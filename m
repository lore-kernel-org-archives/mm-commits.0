Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA883C83F2C
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 01:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbjICBfS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 21:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbjICBfR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 21:35:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57934119
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 18:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 78798CE02C6
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 01:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8B5C433C7;
        Sun,  3 Sep 2023 01:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693704908;
        bh=UTWrZHpy7qKclLd6//FMrM795DOM3TZLYgVrZuqj0zs=;
        h=Date:To:From:Subject:From;
        b=LLDTooxWY2YE7Q0YPalDU2EAuKDDZLugHu0yW1HbTTBrQ4AZ43p/BLUmknEgBQOjA
         ePOL4vXzDwulIAibnp/upAbdr9C3y51l5PWqSJlf+bK7qb0Nqhym1AWD7xWReUcnJQ
         /ca3yjTKNcGQ9llpZRMyCQSpl8XKahaXO/ZKXHzo=
Date:   Sat, 02 Sep 2023 18:35:07 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, wangkefeng.wang@huawei.com,
        shakeelb@google.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch added to mm-unstable branch
Message-Id: <20230903013508.9C8B5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: try to reclaim swapcache pages if no swap space
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch

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
Subject: mm: vmscan: try to reclaim swapcache pages if no swap space
Date: Wed, 30 Aug 2023 11:56:00 +0800

When spaces of swap devices are exhausted, only file pages can be
reclaimed.  But there are still some swapcache pages in anon lru list. 
This can lead to a premature out-of-memory.

The problem is found with such step:

 Firstly, set a 9MB disk swap space, then create a cgroup with 10MB
 memory limit, then runs an program to allocates about 15MB memory.

The problem occurs occasionally, which may need about 100 times.

Fix it by checking number of swapcache pages in can_reclaim_anon_pages(). 
If the number is not zero, return true either.  Moreover, add a new bit
swapcache_only in struct scan_control to skip isolating anon pages that
are not swapcache when only swapcache pages can be reclaimed to accelerate
reclaim efficiency.

Link: https://lore.kernel.org/lkml/CAJD7tkZAfgncV+KbKr36=eDzMnT=9dZOT0dpMWcurHLr6Do+GA@mail.gmail.com/
Link: https://lkml.kernel.org/r/20230830035600.1656792-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Tested-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++++++
 mm/memcontrol.c      |    8 ++++++++
 mm/vmscan.c          |   29 +++++++++++++++++++++++++++--
 3 files changed, 41 insertions(+), 2 deletions(-)

--- a/include/linux/swap.h~mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space
+++ a/include/linux/swap.h
@@ -658,6 +658,7 @@ static inline void mem_cgroup_uncharge_s
 }
 
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
+extern long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
 static inline void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry)
@@ -680,6 +681,11 @@ static inline long mem_cgroup_get_nr_swa
 	return get_nr_swap_pages();
 }
 
+static inline long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
+{
+	return total_swapcache_pages();
+}
+
 static inline bool mem_cgroup_swap_full(struct folio *folio)
 {
 	return vm_swap_full();
--- a/mm/memcontrol.c~mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space
+++ a/mm/memcontrol.c
@@ -7619,6 +7619,14 @@ long mem_cgroup_get_nr_swap_pages(struct
 	return nr_swap_pages;
 }
 
+long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled())
+		return total_swapcache_pages();
+
+	return memcg_page_state(memcg, NR_SWAPCACHE);
+}
+
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
--- a/mm/vmscan.c~mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space
+++ a/mm/vmscan.c
@@ -137,6 +137,9 @@ struct scan_control {
 	/* Always discard instead of demoting to lower tier memory */
 	unsigned int no_demotion:1;
 
+	/* Swap space is exhausted, only reclaim swapcache for anon LRU */
+	unsigned int swapcache_only:1;
+
 	/* Allocation order */
 	s8 order;
 
@@ -613,10 +616,20 @@ static inline bool can_reclaim_anon_page
 		 */
 		if (get_nr_swap_pages() > 0)
 			return true;
+		/* Is there any swapcache pages to reclaim? */
+		if (total_swapcache_pages() > 0) {
+			sc->swapcache_only = 1;
+			return true;
+		}
 	} else {
 		/* Is the memcg below its swap limit? */
 		if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
 			return true;
+		/* Is there any swapcache pages in memcg to reclaim? */
+		if (mem_cgroup_get_nr_swapcache_pages(memcg) > 0) {
+			sc->swapcache_only = 1;
+			return true;
+		}
 	}
 
 	/*
@@ -2280,6 +2293,19 @@ static bool skip_cma(struct folio *folio
 }
 #endif
 
+static bool skip_isolate(struct folio *folio, struct scan_control *sc,
+			 enum lru_list lru)
+{
+	if (folio_zonenum(folio) > sc->reclaim_idx)
+		return true;
+	if (skip_cma(folio, sc))
+		return true;
+	if (unlikely(sc->swapcache_only && !is_file_lru(lru) &&
+	    !folio_test_swapcache(folio)))
+		return true;
+	return false;
+}
+
 /*
  * Isolating page from the lruvec to fill in @dst list by nr_to_scan times.
  *
@@ -2326,8 +2352,7 @@ static unsigned long isolate_lru_folios(
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
 
-		if (folio_zonenum(folio) > sc->reclaim_idx ||
-				skip_cma(folio, sc)) {
+		if (skip_isolate(folio, sc, lru)) {
 			nr_skipped[folio_zonenum(folio)] += nr_pages;
 			move_to = &folios_skipped;
 			goto move;
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch

