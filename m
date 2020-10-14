Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57913C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E5732224E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709178;
	bh=WW8cigi1UYRlyitrBDrNgujp30w4WfSfInqBJackync=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jZNO0Ui4IKPMUJdcwV4YFNQR5y/zUNddZP5jSzmgSngLIj3NR5Scc3W30CHzPGLak
	 flvsNGfc3OUrDE338ld3GBrlu/dst20F6YmN93N73HcCH6Un3ohZ5ysG9Ee7ZidTvy
	 n9my9qaTP2zE+rCRabEUUuvMl0AtLf2L2BTDd7rs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389529AbgJNU7h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389383AbgJNU7h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:37 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88EAF22248;
        Wed, 14 Oct 2020 20:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709177;
        bh=WW8cigi1UYRlyitrBDrNgujp30w4WfSfInqBJackync=;
        h=Date:From:To:Subject:From;
        b=qxeKAxaUo3hVe80V8S9+45lqFqkCpcDmxWd1QqOpFypUhRV2Fg21iEn9LlaKqSjN8
         p5Dwy0e7YWs35QtAzSEwiH1thJO8hORRHn/59k9Cc64C+3O7SiyQR2RCMz4feZVYiq
         dwRTuM6JeXHnvEN0ulgzV1ft6IT7oG+8RaAdq3zo=
Date:   Wed, 14 Oct 2020 13:59:36 -0700
From:   akpm@linux-foundation.org
To:     alexander.h.duyck@linux.intel.com, cai@lca.pw, david@redhat.com,
        hughd@google.com, iamjoonsoo.kim@lge.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, shy828301@gmail.com,
        ying.huang@intel.com, yuzhao@google.com
Subject:  [merged] mm-remove-superfluous-__clearpageactive.patch
 removed from -mm tree
Message-ID: <20201014205936._M3xzVzIV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove superfluous __ClearPageActive()
has been removed from the -mm tree.  Its filename was
     mm-remove-superfluous-__clearpageactive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: remove superfluous __ClearPageActive()

To activate a page, mark_page_accessed() always holds a reference on it. 
It either gets a new reference when adding a page to
lru_pvecs.activate_page or reuses an existing one it previously got when
it added a page to lru_pvecs.lru_add.  So it doesn't call SetPageActive()
on a page that doesn't have any reference left.  Therefore, the race is
impossible these days (I didn't brother to dig into its history).

For other paths, namely reclaim and migration, a reference count is always
held while calling SetPageActive() on a page.

SetPageSlabPfmemalloc() also uses SetPageActive(), but it's irrelevant to
LRU pages.

Link: http://lkml.kernel.org/r/20200818184704.3625199-2-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    2 --
 mm/swap.c     |    2 --
 2 files changed, 4 deletions(-)

--- a/mm/memremap.c~mm-remove-superfluous-__clearpageactive
+++ a/mm/memremap.c
@@ -494,8 +494,6 @@ void free_devmap_managed_page(struct pag
 		return;
 	}
 
-	/* Clear Active bit in case of parallel mark_page_accessed */
-	__ClearPageActive(page);
 	__ClearPageWaiters(page);
 
 	mem_cgroup_uncharge(page);
--- a/mm/swap.c~mm-remove-superfluous-__clearpageactive
+++ a/mm/swap.c
@@ -943,8 +943,6 @@ void release_pages(struct page **pages,
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		}
 
-		/* Clear Active bit in case of parallel mark_page_accessed */
-		__ClearPageActive(page);
 		__ClearPageWaiters(page);
 
 		list_add(&page->lru, &pages_to_free);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-use-self-explanatory-macros-rather-than-2.patch

