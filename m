Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFA8CA0ECF
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 03:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbjILDTy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 23:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242324AbjILDLX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 23:11:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483531058AD
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 19:07:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F68C43395;
        Mon, 11 Sep 2023 21:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694466083;
        bh=5HhQ8rrGzauRyTPaGlUY3C6sHOdgtnSwMLt6OIreP6w=;
        h=Date:To:From:Subject:From;
        b=wwtNH6ZOpGiYvZ3heluUCR3M3Q/94IretwdLDQp8NFMjNyN+RoCY90PaK7RGhpGW2
         JWAhAtl9qakIkkSsI4WFp3KsvPQmE8EUiMSZBdTz8/0r5blzdligiUzpSJP1XQDH6Y
         P0Ep+jIIm6nnmnESo3twxr6lf9xIDw1AIr3bL85g=
Date:   Mon, 11 Sep 2023 14:01:22 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        wangkefeng.wang@huawei.com, vbabka@suse.cz,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch added to mm-unstable branch
Message-Id: <20230911210123.13F68C43395@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: fix up block types when merging compatible blocks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: fix up block types when merging compatible blocks
Date: Mon, 11 Sep 2023 15:41:43 -0400

The buddy allocator coalesces compatible blocks during freeing, but it
doesn't update the types of the subblocks to match.  When an allocation
later breaks the chunk down again, its pieces will be put on freelists of
the wrong type.  This encourages incompatible page mixing (ask for one
type, get another), and thus long-term fragmentation.

Update the subblocks when merging a larger chunk, such that a later
expand() will maintain freelist type hygiene.

Link: https://lkml.kernel.org/r/20230911195023.247694-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks
+++ a/mm/page_alloc.c
@@ -783,10 +783,17 @@ static inline void __free_one_page(struc
 			 */
 			int buddy_mt = get_pfnblock_migratetype(buddy, buddy_pfn);
 
-			if (migratetype != buddy_mt
-					&& (!migratetype_is_mergeable(migratetype) ||
-						!migratetype_is_mergeable(buddy_mt)))
-				goto done_merging;
+			if (migratetype != buddy_mt) {
+				if (!migratetype_is_mergeable(migratetype) ||
+				    !migratetype_is_mergeable(buddy_mt))
+					goto done_merging;
+				/*
+				 * Match buddy type. This ensures that
+				 * an expand() down the line puts the
+				 * sub-blocks on the right freelists.
+				 */
+				set_pageblock_migratetype(buddy, migratetype);
+			}
 		}
 
 		/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-consolidate-free-page-accounting.patch

