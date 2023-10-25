Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D22C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjJYXtr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbjJYXsw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2C2193
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8BDC433CB;
        Wed, 25 Oct 2023 23:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277730;
        bh=PW4LpcFLEY8W4jmwHULxF7JX4IdAlKmoLoTSLPcZtZs=;
        h=Date:To:From:Subject:From;
        b=ZIecCylhNdRvmh9/zyYDWnP6fi6oi4dRfoJnKXyW703i4CZ6D0tMCH0A1XVmoGWjZ
         pRavtqJxP0fPvlTLMn6zQWuWgvhqhUholnOvmBe7dLIZZa14b89aEeqJ6wSNRm45v7
         HNHmHhRbV85jBMMAJgZVTxJHUOSx2HitGXBFW+Xw=
Date:   Wed, 25 Oct 2023 16:48:49 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_cpupid_xchg_last.patch removed from -mm tree
Message-Id: <20231025234850.5E8BDC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove page_cpupid_xchg_last()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_cpupid_xchg_last.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove page_cpupid_xchg_last()
Date: Wed, 18 Oct 2023 22:08:06 +0800

Since all calls use folio_xchg_last_cpupid(), remove
page_cpupid_xchg_last().

Link: https://lkml.kernel.org/r/20231018140806.2783514-20-wangkefeng.wang@huawei.com
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

 include/linux/mm.h |   19 +++++++------------
 mm/mmzone.c        |    6 +++---
 2 files changed, 10 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-remove-page_cpupid_xchg_last
+++ a/include/linux/mm.h
@@ -1696,9 +1696,9 @@ static inline bool __cpupid_match_pid(pi
 
 #define cpupid_match_pid(task, cpupid) __cpupid_match_pid(task->pid, cpupid)
 #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
-static inline int page_cpupid_xchg_last(struct page *page, int cpupid)
+static inline int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
 {
-	return xchg(&page->_last_cpupid, cpupid & LAST_CPUPID_MASK);
+	return xchg(&folio->_last_cpupid, cpupid & LAST_CPUPID_MASK);
 }
 
 static inline int folio_last_cpupid(struct folio *folio)
@@ -1715,7 +1715,7 @@ static inline int folio_last_cpupid(stru
 	return (folio->flags >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
 }
 
-extern int page_cpupid_xchg_last(struct page *page, int cpupid);
+int folio_xchg_last_cpupid(struct folio *folio, int cpupid);
 
 static inline void page_cpupid_reset_last(struct page *page)
 {
@@ -1727,8 +1727,8 @@ static inline int folio_xchg_access_time
 {
 	int last_time;
 
-	last_time = page_cpupid_xchg_last(&folio->page,
-					  time >> PAGE_ACCESS_TIME_BUCKETS);
+	last_time = folio_xchg_last_cpupid(folio,
+					   time >> PAGE_ACCESS_TIME_BUCKETS);
 	return last_time << PAGE_ACCESS_TIME_BUCKETS;
 }
 
@@ -1742,9 +1742,9 @@ static inline void vma_set_access_pid_bi
 	}
 }
 #else /* !CONFIG_NUMA_BALANCING */
-static inline int page_cpupid_xchg_last(struct page *page, int cpupid)
+static inline int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
 {
-	return page_to_nid(page); /* XXX */
+	return folio_nid(folio); /* XXX */
 }
 
 static inline int folio_xchg_access_time(struct folio *folio, int time)
@@ -1796,11 +1796,6 @@ static inline void vma_set_access_pid_bi
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
-static inline int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
-{
-	return page_cpupid_xchg_last(&folio->page, cpupid);
-}
-
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 
 /*
--- a/mm/mmzone.c~mm-remove-page_cpupid_xchg_last
+++ a/mm/mmzone.c
@@ -93,19 +93,19 @@ void lruvec_init(struct lruvec *lruvec)
 }
 
 #if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS)
-int page_cpupid_xchg_last(struct page *page, int cpupid)
+int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
 {
 	unsigned long old_flags, flags;
 	int last_cpupid;
 
-	old_flags = READ_ONCE(page->flags);
+	old_flags = READ_ONCE(folio->flags);
 	do {
 		flags = old_flags;
 		last_cpupid = (flags >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
 
 		flags &= ~(LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT);
 		flags |= (cpupid & LAST_CPUPID_MASK) << LAST_CPUPID_PGSHIFT;
-	} while (unlikely(!try_cmpxchg(&page->flags, &old_flags, flags)));
+	} while (unlikely(!try_cmpxchg(&folio->flags, &old_flags, flags)));
 
 	return last_cpupid;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


