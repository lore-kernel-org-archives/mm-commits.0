Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633F2C43466
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3064121D43
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600489214;
	bh=tls6E4Ua3Hx2Fst6WvezMpFemZNLNASuADiBnEa7OCw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=RcN2h0U/HacjvxOsrD9Zzk9bwsrCf7TSnPMMVxvnOnMdJPD/QZfw9oeq38ycb3NSq
	 tbQAYlXiz/DHPnuGlTWVGNFb+ldmN6rWvbpd1sjqRSDvypkpXuMkHnU/LKDO7lpKeq
	 119fy9AzLzImqztyAna+VL5RrlfvtLwn3PzauSYA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgISEUN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Sep 2020 00:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISEUN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Sep 2020 00:20:13 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D053E221EC;
        Sat, 19 Sep 2020 04:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489213;
        bh=tls6E4Ua3Hx2Fst6WvezMpFemZNLNASuADiBnEa7OCw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1IXapl09EJ4rmbVcS2s9r8jM30RqXauZSqK/HWZ7oklFFCilnsZgrAYkG59fX+0/f
         Vuk9h2xbE2ZwR28axA7XJJtb1cGf448C7ccROBAmLcKdmKLxw8lpyeRD55RPz70rYK
         D2tp2g/HGQ0Eo29+Tjtq5ujHrRR+/rPkW0Y2WfnA=
Date:   Fri, 18 Sep 2020 21:20:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, hannes@cmpxchg.org,
        hughd@google.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 05/15] mm: fix check_move_unevictable_pages() on
 THP
Message-ID: <20200919042012.n9ppaodpA%akpm@linux-foundation.org>
In-Reply-To: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
