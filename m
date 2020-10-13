Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EB1C2BD0C
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFE3B22201
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633142;
	bh=vNMA6MVhwcudTM+q+Y6GKJx0Ymx8ggL+IeNOm1GF1yo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=1F2g23T9j4c1phDnl5a42pvdZqQb9hXJRRjW8BDuCV3WgkFM2CIpJVMW4dXDhYTMR
	 3ZM5cmSyzsfF5xChdweHGuDedCq7ocJqWaK4NB60hXsYMwl+gS9TRVuJPstSMuWnjn
	 SlX3ZX6nUdOotXU6hILOOvKhG1OwMxZWXUqL/baE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgJMXwV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728770AbgJMXwN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEED122200;
        Tue, 13 Oct 2020 23:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633132;
        bh=vNMA6MVhwcudTM+q+Y6GKJx0Ymx8ggL+IeNOm1GF1yo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sCxSL+I9/RNAS1iL+7APXDWEKMVbnpvXptaKKVjPn99Hwds5bDJs4EbHkIadk83lc
         9yJIprNBJNfl/bhXNN7lRXWszWScpfSNaRMG2ZlyKGGLHmF4LVLSg63zOxs+ZsPpWx
         97+hkha0jeJzKYYtLDf1KxhelP7z7TEr/CRlf1yI=
Date:   Tue, 13 Oct 2020 16:52:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        cai@lca.pw, david@redhat.com, hughd@google.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, shy828301@gmail.com,
        torvalds@linux-foundation.org, ying.huang@intel.com,
        yuzhao@google.com
Subject:  [patch 070/181] mm: remove superfluous
 __ClearPageActive()
Message-ID: <20201013235211.c2AQxgjbm%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
