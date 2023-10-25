Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA4FC25B6E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbjJYXtR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjJYXsr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B70D4A
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531E6C433C9;
        Wed, 25 Oct 2023 23:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277718;
        bh=omFzVYSYrY6J0xpIaiV7Mxwuf9ylim0luL1AUx1IcFY=;
        h=Date:To:From:Subject:From;
        b=bbHcvYnVdbBTwlKQ9xLvg4KuF30iCoo9Aim+JBLenNdvXO3+EQ85VVNgQ3rD1H6Si
         RFB4/TCMinNshmF0tFjY/nQ1otIY4nZ4F5VDO8pM3UTaHpjsYnPFvMIBNyKCOavi5Q
         GHMyXK+Aw3JlMTVFyDvutaXyFG6s92xLtZ53Oe7U=
Date:   Wed, 25 Oct 2023 16:48:37 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_cpupid_last.patch removed from -mm tree
Message-Id: <20231025234838.531E6C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove page_cpupid_last()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_cpupid_last.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove page_cpupid_last()
Date: Wed, 18 Oct 2023 22:07:53 +0800

Since all calls use folio_last_cpupid(), remove page_cpupid_last().

Link: https://lkml.kernel.org/r/20231018140806.2783514-7-wangkefeng.wang@huawei.com
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

 include/linux/mm.h |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h~mm-remove-page_cpupid_last
+++ a/include/linux/mm.h
@@ -1702,18 +1702,18 @@ static inline int page_cpupid_xchg_last(
 	return xchg(&page->_last_cpupid, cpupid & LAST_CPUPID_MASK);
 }
 
-static inline int page_cpupid_last(struct page *page)
+static inline int folio_last_cpupid(struct folio *folio)
 {
-	return page->_last_cpupid;
+	return folio->_last_cpupid;
 }
 static inline void page_cpupid_reset_last(struct page *page)
 {
 	page->_last_cpupid = -1 & LAST_CPUPID_MASK;
 }
 #else
-static inline int page_cpupid_last(struct page *page)
+static inline int folio_last_cpupid(struct folio *folio)
 {
-	return (page->flags >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
+	return (folio->flags >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
 }
 
 extern int page_cpupid_xchg_last(struct page *page, int cpupid);
@@ -1752,9 +1752,9 @@ static inline int xchg_page_access_time(
 	return 0;
 }
 
-static inline int page_cpupid_last(struct page *page)
+static inline int folio_last_cpupid(struct folio *folio)
 {
-	return page_to_nid(page); /* XXX */
+	return folio_nid(folio); /* XXX */
 }
 
 static inline int cpupid_to_nid(int cpupid)
@@ -1796,11 +1796,6 @@ static inline void vma_set_access_pid_bi
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
-static inline int folio_last_cpupid(struct folio *folio)
-{
-	return page_cpupid_last(&folio->page);
-}
-
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 
 /*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


