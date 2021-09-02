Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4D6C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35AB760E8B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347765AbhIBWAn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347671AbhIBWAn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABA626056B;
        Thu,  2 Sep 2021 21:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619984;
        bh=rkMRVuQSiEAzgF163rcxOkvHhMXxRZbYPkMlRgQ8M5A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BpZX6CkldOUl1RG7/pnKVYshn42t4BS2IQGWA/7gcqeYYOWEQmiMuobOXLwpb8xs+
         48+dHoHZyVj6f66VpF16gGdznzCwgegLpfY+ynNigeY0ag/tQRM7YE4KXW2vfM2k8P
         NqjcolkRF8uLl21NgSOXsDRGoGaxwk0tR4C2uSdU=
Date:   Thu, 02 Sep 2021 14:59:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, apopple@nvidia.com,
        axboe@kernel.dk, david@redhat.com, hannes@cmpxchg.org,
        hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com,
        jhubbard@nvidia.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        shli@fb.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        willy@infradead.org, yuzhao@google.com
Subject:  [patch 184/212] mm/vmscan: remove misleading setting to
 sc->priority
Message-ID: <20210902215943.oZ948kdKc%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: remove misleading setting to sc->priority

The priority field of sc is used to control how many pages we should scan
at once while we always traverse the list to shrink the pages in these
functions.  So these settings are unneeded and misleading.

Link: https://lkml.kernel.org/r/20210717065911.61497-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-misleading-setting-to-sc-priority
+++ a/mm/vmscan.c
@@ -1820,7 +1820,6 @@ unsigned int reclaim_clean_pages_from_li
 {
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
-		.priority = DEF_PRIORITY,
 		.may_unmap = 1,
 	};
 	struct reclaim_stat stat;
@@ -2445,7 +2444,6 @@ unsigned long reclaim_pages(struct list_
 	unsigned int noreclaim_flag;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
-		.priority = DEF_PRIORITY,
 		.may_writepage = 1,
 		.may_unmap = 1,
 		.may_swap = 1,
_
