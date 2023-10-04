Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B098E7C4F1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244524AbjJDUWM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244737AbjJDUUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:20:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04B5107
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:20:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2D1C433C8;
        Wed,  4 Oct 2023 20:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450846;
        bh=SqL559dL/N5MfO/xAPo+p47unF2vLjaxPr9qyaPwIDc=;
        h=Date:To:From:Subject:From;
        b=OEvCWgKrC5gtZwwTAP9j4ycLx5kxCWMXyqGoLq1e6JN6V4kADkEsn0+l/PlHzNiEk
         /oVWFJpJjR69WF1sYXL2/CLl4uhIdgSy3x33Hj/mgpMhgvceBw7Ft+Qf2V7+qDNowD
         NSPWDYrBJN4TQAi5C4gaGpEhmgMZf12sOInO5EDM=
Date:   Wed, 04 Oct 2023 13:20:44 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, vernhao@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch removed from -mm tree
Message-Id: <20231004202046.1C2D1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memcg: add THP swap out info for anonymous reclaim
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xin Hao <vernhao@tencent.com>
Subject: mm: memcg: add THP swap out info for anonymous reclaim
Date: Thu, 14 Sep 2023 00:49:37 +0800

At present, we support per-memcg reclaim strategy, however we do not know
the number of transparent huge pages being reclaimed, as we know the
transparent huge pages need to be splited before reclaim them, and they
will bring some performance bottleneck effect.  for example, when two
memcg (A & B) are doing reclaim for anonymous pages at same time, and 'A'
memcg is reclaiming a large number of transparent huge pages, we can
better analyze that the performance bottleneck will be caused by 'A'
memcg.  therefore, in order to better analyze such problems, there add THP
swap out info for per-memcg.

[akpm@linux-foundation.orgL fix swap_writepage_fs(), per Johannes]
  Link: https://lkml.kernel.org/r/20230913213343.GB48476@cmpxchg.org
Link: https://lkml.kernel.org/r/20230913164938.16918-1-vernhao@tencent.com
Signed-off-by: Xin Hao <vernhao@tencent.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    9 +++++++++
 mm/memcontrol.c                         |    2 ++
 mm/page_io.c                            |    8 ++++----
 mm/vmscan.c                             |    1 +
 4 files changed, 16 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1532,6 +1532,15 @@ PAGE_SIZE multiple when read back.
 		collapsing an existing range of pages. This counter is not
 		present when CONFIG_TRANSPARENT_HUGEPAGE is not set.
 
+	  thp_swpout (npn)
+		Number of transparent hugepages which are swapout in one piece
+		without splitting.
+
+	  thp_swpout_fallback (npn)
+		Number of transparent hugepages which were split before swapout.
+		Usually because failed to allocate some continuous swap space
+		for the huge page.
+
   memory.numa_stat
 	A read-only nested-keyed file which exists on non-root cgroups.
 
--- a/mm/memcontrol.c~mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim
+++ a/mm/memcontrol.c
@@ -704,6 +704,8 @@ static const unsigned int memcg_vm_event
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
 	THP_COLLAPSE_ALLOC,
+	THP_SWPOUT,
+	THP_SWPOUT_FALLBACK,
 #endif
 };
 
--- a/mm/page_io.c~mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim
+++ a/mm/page_io.c
@@ -208,8 +208,10 @@ int swap_writepage(struct page *page, st
 static inline void count_swpout_vm_event(struct folio *folio)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (unlikely(folio_test_pmd_mappable(folio)))
+	if (unlikely(folio_test_pmd_mappable(folio))) {
+		count_memcg_folio_events(folio, THP_SWPOUT, 1);
 		count_vm_event(THP_SWPOUT);
+	}
 #endif
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
@@ -278,9 +280,6 @@ static void sio_write_complete(struct ki
 			set_page_dirty(page);
 			ClearPageReclaim(page);
 		}
-	} else {
-		for (p = 0; p < sio->pages; p++)
-			count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));
 	}
 
 	for (p = 0; p < sio->pages; p++)
@@ -296,6 +295,7 @@ static void swap_writepage_fs(struct pag
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = page_file_offset(page);
 
+	count_swpout_vm_event(page_folio(page));
 	set_page_writeback(page);
 	unlock_page(page);
 	if (wbc->swap_plug)
--- a/mm/vmscan.c~mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim
+++ a/mm/vmscan.c
@@ -1214,6 +1214,7 @@ retry:
 								folio_list))
 						goto activate_locked;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+					count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
 					count_vm_event(THP_SWPOUT_FALLBACK);
 #endif
 					if (!add_to_swap(folio))
_

Patches currently in -mm which might be from vernhao@tencent.com are


