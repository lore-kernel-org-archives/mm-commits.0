Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F20CA0ECE
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 02:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbjILCmM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240093AbjILCl6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 22:41:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51501052BE
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 19:07:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6C4C433CB;
        Mon, 11 Sep 2023 21:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694466090;
        bh=NrWLtwUJ3QLjAUfCi9oz/EQQkk5+dwo7n9bdBH1L1rM=;
        h=Date:To:From:Subject:From;
        b=A5EEcMrr/R/3BFdDHFmmwljImGsv5hq3pgRff8zozgmNv2mCZWm1wvH0G5PPIIuKF
         7lOXdG6ZL3+h6doD1n3uk/M2HFrw3TMStHxt/rV6aiCA87ZGI7PYwZoqBmASSSmu2p
         cNIRksP6FsfrPRaOf0Cjf5nnk44bhLxN/+663Y1k=
Date:   Mon, 11 Sep 2023 14:01:29 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com,
        wangkefeng.wang@huawei.com, vbabka@suse.cz,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch added to mm-unstable branch
Message-Id: <20230911210130.0D6C4C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: move free pages when converting block during isolation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch

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
Subject: mm: page_alloc: move free pages when converting block during isolation
Date: Mon, 11 Sep 2023 15:41:44 -0400

When claiming a block during compaction isolation, move any remaining free
pages to the correct freelists as well, instead of stranding them on the
wrong list.  Otherwise, this encourages incompatible page mixing down the
line, and thus long-term fragmentation.

Link: https://lkml.kernel.org/r/20230911195023.247694-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-free-pages-when-converting-block-during-isolation
+++ a/mm/page_alloc.c
@@ -2584,9 +2584,12 @@ int __isolate_free_page(struct page *pag
 			 * Only change normal pageblocks (i.e., they can merge
 			 * with others)
 			 */
-			if (migratetype_is_mergeable(mt))
+			if (migratetype_is_mergeable(mt)) {
 				set_pageblock_migratetype(page,
 							  MIGRATE_MOVABLE);
+				move_freepages_block(zone, page,
+						     MIGRATE_MOVABLE, NULL);
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-consolidate-free-page-accounting.patch

