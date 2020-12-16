Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F0DC2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC0DA2343E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgLPRIv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:08:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgLPRIv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:08:51 -0500
Date:   Wed, 16 Dec 2020 09:08:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138490;
        bh=Rs4nrrvdvHOAk25qheFbM+hPpNk+FO9UiE9he+yqDuM=;
        h=From:To:Subject:From;
        b=LpMRGbzjVSmrUiCJWp2bd4u+GH3ShYyyQ1d9O1AvH2Nah2Ht/dZDRsldnW9mlbyDk
         rTpU/IlailqjW6PScaSRhLXJEJS8YqT0AcMb5OkyI5dnmZcm+TurMGFmq9GQFKtiyO
         3DpKIekVk2gPt3bZdy/tmH1EXt1+fIN4Ljl1PrOk=
From:   akpm@linux-foundation.org
To:     huangzhaoyang@gmail.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, zhaoyang.huang@unisoc.com
Subject:  [merged] mm-fix-a-race-on-nr_swap_pages.patch removed
 from -mm tree
Message-ID: <20201216170809.zi1mkSlH-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix a race on nr_swap_pages
has been removed from the -mm tree.  Its filename was
     mm-fix-a-race-on-nr_swap_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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
@@ -1045,16 +1045,18 @@ int get_swap_pages(int n_goal, swp_entry
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
@@ -1128,14 +1130,13 @@ swp_entry_t get_swap_page_of_type(int ty
 
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

Patches currently in -mm which might be from huangzhaoyang@gmail.com are


