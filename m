Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B75C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9007B2313C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgLPEnf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgLPEnf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:35 -0500
Date:   Tue, 15 Dec 2020 20:42:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093743;
        bh=H9+2BSJQftd73XII1G7ABiPos+ty7JV63LO37wLGhK8=;
        h=From:To:Subject:In-Reply-To:From;
        b=FVeVymn+k/bBX3W6unCq5xZYvOTAa9Oiv9QnQv7leADhWVrqOcBDUzbVkcoEGZC2w
         VejsELE94qkEaZwM6x/hCT6u11O/kL29fjpBTEBn0AJdlWd79SMqh5z7FMVAxw7mCD
         tmGky6S4HHKvrxZQjku5WGEgbH4EfeHATIql2VvM=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, huangzhaoyang@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        zhaoyang.huang@unisoc.com
Subject:  [patch 01/95] mm: fix a race on nr_swap_pages
Message-ID: <20201216044223.WYHH30Gdg%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Subject: mm: fix a race on nr_swap_pages

The scenario on which "Free swap = -4kB" happens in my system, which is caused
by several get_swap_pages racing with each other and show_swap_cache_info
happens simutaniously. No need to add a lock on get_swap_page_of_type as we
remove "Presub/PosAdd" here.

ProcessA			ProcessB			ProcessC
ngoals = 1			ngoals = 1
avail = nr_swap_pages(1)	avail = nr_swap_pages(1)
nr_swap_pages(1) -= ngoals
				nr_swap_pages(0) -= ngoals
								nr_swap_pages = -1

Link: https://lkml.kernel.org/r/1607050340-4535-1-git-send-email-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/swapfile.c~mm-fix-a-race-on-nr_swap_pages
+++ a/mm/swapfile.c
@@ -1042,16 +1042,18 @@ int get_swap_pages(int n_goal, swp_entry
 	/* Only single cluster request supported */
 	WARN_ON_ONCE(n_goal > 1 && size == SWAPFILE_CLUSTER);
 
+	spin_lock(&swap_avail_lock);
+
 	avail_pgs = atomic_long_read(&nr_swap_pages) / size;
-	if (avail_pgs <= 0)
+	if (avail_pgs <= 0) {
+		spin_unlock(&swap_avail_lock);
 		goto noswap;
+	}
 
 	n_goal = min3((long)n_goal, (long)SWAP_BATCH, avail_pgs);
 
 	atomic_long_sub(n_goal * size, &nr_swap_pages);
 
-	spin_lock(&swap_avail_lock);
-
 start_over:
 	node = numa_node_id();
 	plist_for_each_entry_safe(si, next, &swap_avail_heads[node], avail_lists[node]) {
@@ -1125,14 +1127,13 @@ swp_entry_t get_swap_page_of_type(int ty
 
 	spin_lock(&si->lock);
 	if (si->flags & SWP_WRITEOK) {
-		atomic_long_dec(&nr_swap_pages);
 		/* This is called for allocating swap entry, not cache */
 		offset = scan_swap_map(si, 1);
 		if (offset) {
+			atomic_long_dec(&nr_swap_pages);
 			spin_unlock(&si->lock);
 			return swp_entry(type, offset);
 		}
-		atomic_long_inc(&nr_swap_pages);
 	}
 	spin_unlock(&si->lock);
 fail:
_
