Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6852DEED617
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 16:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjIOQSC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 12:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbjIOQRa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 12:17:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BAF1AD
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 09:17:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C97C433C7;
        Fri, 15 Sep 2023 16:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694794645;
        bh=FfP74SO1BqrSDHdWdJ7ieNKY8ed2fkbFTBhqZqL2fzg=;
        h=Date:To:From:Subject:From;
        b=tSeOKlpo2f+uYRwsAl1iTP/2+6j71Ub86kUEp4FgHdXtfSYLz28ldY6b23JN1/zqQ
         sdOO5hFTOM3oBhALS/RLAOuRBFX5iQ7w7yl5pUXcmDunLBx0Ofd8Ix48WgmGccOV3r
         lAVpWd9x6D4YlHuj9MnOqm20zgrw2vwL9DXuJfSA=
Date:   Fri, 15 Sep 2023 09:17:24 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-pcppage-migratetype-caching-fix.patch added to mm-unstable branch
Message-Id: <20230915161725.83C97C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: Fri, 15 Sep 2023 09:59:52 -0400
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-pcppage-migratetype-caching-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-pcppage-migratetype-caching-fix.patch

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
Date: Fri, 15 Sep 2023 09:59:52 -0400
Subject: mm-page_alloc-remove-pcppage-migratetype-caching-fix

Mike reports the following crash in -next:

[   28.643019] page:ffffea0004fb4280 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x13ed0a
[   28.645455] flags: 0x200000000000000(node=0|zone=2)
[   28.646835] page_type: 0xffffffff()
[   28.647886] raw: 0200000000000000 dead000000000100 dead000000000122 0000000000000000
[   28.651170] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[   28.653124] page dumped because: VM_BUG_ON_PAGE(is_migrate_isolate(mt))
[   28.654769] ------------[ cut here ]------------
[   28.655972] kernel BUG at mm/page_alloc.c:1231!

This VM_BUG_ON() used to check that the cached pcppage_migratetype set by
free_unref_page() wasn't MIGRATE_ISOLATE.

When I removed the caching, I erroneously changed the assert to check that
no isolated pages are on the pcplist.  This is quite different, because
pages can be isolated *after* they had been put on the freelist already
(which is handled just fine).

IOW, this was purely a sanity check on the migratetype caching.  With that
gone, the check should have been removed as well.  Do that now.

Link: https://lkml.kernel.org/r/20230915141610.GA104956@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-pcppage-migratetype-caching-fix
+++ a/mm/page_alloc.c
@@ -1201,9 +1201,6 @@ static void free_pcppages_bulk(struct zo
 			count -= nr_pages;
 			pcp->count -= nr_pages;
 
-			/* MIGRATE_ISOLATE page should not go to pcplists */
-			VM_BUG_ON_PAGE(is_migrate_isolate(mt), page);
-
 			__free_one_page(page, pfn, zone, order, mt, FPI_NONE);
 			trace_mm_page_pcpu_drain(page, order, mt);
 		} while (count > 0 && !list_empty(list));
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch
mm-memcontrol-fix-gfp_nofs-recursion-in-memoryhigh-enforcement.patch
mm-page_alloc-remove-pcppage-migratetype-caching.patch
mm-page_alloc-remove-pcppage-migratetype-caching-fix.patch
mm-page_alloc-fix-up-block-types-when-merging-compatible-blocks.patch
mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch
mm-page_alloc-fix-move_freepages_block-range-error.patch
mm-page_alloc-fix-freelist-movement-during-block-conversion.patch
mm-page_alloc-consolidate-free-page-accounting.patch

