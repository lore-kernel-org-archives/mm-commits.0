Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26330C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbjJYXte (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjJYXsr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DA5D5C
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7682C433CB;
        Wed, 25 Oct 2023 23:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277722;
        bh=UyuHSwtozvDhOH92Mc9PbM3mghu/F4XbF0IuIUUMvPQ=;
        h=Date:To:From:Subject:From;
        b=MWegDKz3BBtI9GIA/xVMLcSjKAi2er0QNRBmGDR19sTGoHIlD6GMorvrryWK9BjAV
         x18ogj/95V0RDI2rpI23d5OtCGydU+Iqgg0J38KSYwmRFCQYp8NFLpWiAajjaFVosE
         2xXqkf224FnlQof879IyBDq+KCp2NyaMFX5U7/Ws=
Date:   Wed, 25 Oct 2023 16:48:42 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-xchg_page_access_time.patch removed from -mm tree
Message-Id: <20231025234842.B7682C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove xchg_page_access_time()
has been removed from the -mm tree.  Its filename was
     mm-remove-xchg_page_access_time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove xchg_page_access_time()
Date: Wed, 18 Oct 2023 22:07:58 +0800

Since all calls use folio_xchg_access_time(), remove
xchg_page_access_time().

Link: https://lkml.kernel.org/r/20231018140806.2783514-12-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-remove-xchg_page_access_time
+++ a/include/linux/mm.h
@@ -1724,11 +1724,12 @@ static inline void page_cpupid_reset_las
 }
 #endif /* LAST_CPUPID_NOT_IN_PAGE_FLAGS */
 
-static inline int xchg_page_access_time(struct page *page, int time)
+static inline int folio_xchg_access_time(struct folio *folio, int time)
 {
 	int last_time;
 
-	last_time = page_cpupid_xchg_last(page, time >> PAGE_ACCESS_TIME_BUCKETS);
+	last_time = page_cpupid_xchg_last(&folio->page,
+					  time >> PAGE_ACCESS_TIME_BUCKETS);
 	return last_time << PAGE_ACCESS_TIME_BUCKETS;
 }
 
@@ -1747,7 +1748,7 @@ static inline int page_cpupid_xchg_last(
 	return page_to_nid(page); /* XXX */
 }
 
-static inline int xchg_page_access_time(struct page *page, int time)
+static inline int folio_xchg_access_time(struct folio *folio, int time)
 {
 	return 0;
 }
@@ -1796,11 +1797,6 @@ static inline void vma_set_access_pid_bi
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
-static inline int folio_xchg_access_time(struct folio *folio, int time)
-{
-	return xchg_page_access_time(&folio->page, time);
-}
-
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 
 /*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


