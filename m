Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C775AC4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FCFA2087D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601085482;
	bh=INh5FbJTebXffq0TKy1mTneMDGsnSA/qc38qO2OZ7ME=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=X5ap4L7BbqDLdW072XjRB+hEj2sQt24MQLic2pgLx4SFkH/+njR7M6zeakHR2MOpM
	 GpNsBxThZXXzWZ7XBheuKpMbWaqllM32ebXg78kDoeeaoyhZiOmdxBEdTRx5VWq7mM
	 eKdoRtQEUY/gmaW3d1VN/wsklfmCHMS/1E3zI3lk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgIZB6C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 21:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIZB6C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 21:58:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B003120936;
        Sat, 26 Sep 2020 01:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085480;
        bh=INh5FbJTebXffq0TKy1mTneMDGsnSA/qc38qO2OZ7ME=;
        h=Date:From:To:Subject:From;
        b=qQz0topHsoNaZoW4k7WPRohoi6lehQBW1x2U2jC+NqSPJVfg6cUxc5bCJR3ifoCdX
         ZrByc2FtiMOfW3xY3IIaYZGKFuPZdOWKomta6o8P2vJbbvzT0jNP5YIQ+r5CmVsViJ
         UuK4m1wS3QQhYCoFBCYAa+x81/+uDDbfI09seSgw=
Date:   Fri, 25 Sep 2020 18:57:59 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com
Subject:  [merged] mm-fix-check_move_unevictable_pages-on-thp.patch
 removed from -mm tree
Message-ID: <20200926015759.q2xH_EhCH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix check_move_unevictable_pages() on THP
has been removed from the -mm tree.  Its filename was
     mm-fix-check_move_unevictable_pages-on-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix check_move_unevictable_pages() on THP

check_move_unevictable_pages() is used in making unevictable shmem pages
evictable: by shmem_unlock_mapping(), drm_gem_check_release_pagevec() and
i915/gem check_release_pagevec().  Those may pass down subpages of a huge
page, when /sys/kernel/mm/transparent_hugepage/shmem_enabled is "force".

That does not crash or warn at present, but the accounting of vmstats
unevictable_pgs_scanned and unevictable_pgs_rescued is inconsistent:
scanned being incremented on each subpage, rescued only on the head (since
tails already appear evictable once the head has been updated).

5.8 commit 5d91f31faf8e ("mm: swap: fix vmstats for huge page") has
established that vm_events in general (and unevictable_pgs_rescued in
particular) should count every subpage: so follow that precedent here.

Do this in such a way that if mem_cgroup_page_lruvec() is made stricter
(to check page->mem_cgroup is always set), no problem: skip the tails
before calling it, and add thp_nr_pages() to vmstats on the head.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008301405000.5954@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-fix-check_move_unevictable_pages-on-thp
+++ a/mm/vmscan.c
@@ -4268,8 +4268,14 @@ void check_move_unevictable_pages(struct
 	for (i = 0; i < pvec->nr; i++) {
 		struct page *page = pvec->pages[i];
 		struct pglist_data *pagepgdat = page_pgdat(page);
+		int nr_pages;
+
+		if (PageTransTail(page))
+			continue;
+
+		nr_pages = thp_nr_pages(page);
+		pgscanned += nr_pages;
 
-		pgscanned++;
 		if (pagepgdat != pgdat) {
 			if (pgdat)
 				spin_unlock_irq(&pgdat->lru_lock);
@@ -4288,7 +4294,7 @@ void check_move_unevictable_pages(struct
 			ClearPageUnevictable(page);
 			del_page_from_lru_list(page, lruvec, LRU_UNEVICTABLE);
 			add_page_to_lru_list(page, lruvec, lru);
-			pgrescued++;
+			pgrescued += nr_pages;
 		}
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are


