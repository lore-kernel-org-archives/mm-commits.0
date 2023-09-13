Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9493EE020A
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjIMTcB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjIMTcB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:32:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409A783
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:31:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2BFC433C7;
        Wed, 13 Sep 2023 19:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694633516;
        bh=dg3FBLT+yuSJfXTIHnYoH94NzGsYakEW0VriHDkCWp4=;
        h=Date:To:From:Subject:From;
        b=0MpSMtdiune8trzmpfxR4VIxoJCCpFSnb/Hr24+p0flI+9Vufi1Y46U4gFEYB3Fh1
         uIzL/kE9B41OjrucYyL7mjVfFki88nSX/D+CHqnXGB6o6fL32apFBTOCkUdXPzo4Ta
         PqWG3iuvcGIpI6lZTa7kt6UBImwNQhrnUoMTgPAU=
Date:   Wed, 13 Sep 2023 12:31:56 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, vernhao@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch added to mm-unstable branch
Message-Id: <20230913193156.CE2BFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: add THP swap out info for anonymous reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch

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
 
+	count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));
 	set_page_writeback(page);
 	unlock_page(page);
 	if (wbc->swap_plug)
--- a/mm/vmscan.c~mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim
+++ a/mm/vmscan.c
@@ -1227,6 +1227,7 @@ retry:
 								folio_list))
 						goto activate_locked;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+					count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
 					count_vm_event(THP_SWPOUT_FALLBACK);
 #endif
 					if (!add_to_swap(folio))
_

Patches currently in -mm which might be from vernhao@tencent.com are

mm-vmscan-use-folio_migratetype-instead-of-get_pageblock_migratetype.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch

