Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F25C07E9C
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 18:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B39E761283
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 18:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhGJSxF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Jul 2021 14:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhGJSxF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Jul 2021 14:53:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A484361356;
        Sat, 10 Jul 2021 18:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625943020;
        bh=hzXvMhhdqZlc0GpG/e1ikiHlQIGzmHrwDK5KFiPGl1U=;
        h=Date:From:To:Subject:From;
        b=GtJvbw/a9L4vfFlo0e9nf2bISdD2t0az3vVcXUSdrhfRfoHqTiSen/xiB9gcSfUTO
         K4yCLVvfLoDTERgLnS7i5hjItAYxjRmz5CtvB0K3yZ9knJWifZfhq0zpJJRG87QCcM
         2sJDYdFtONxsXpeCGx+n4ldaCWc89IRzlXIRTasM=
Date:   Sat, 10 Jul 2021 11:50:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shli@fb.com, minchan@kernel.org, mhocko@suse.com,
        iamjoonsoo.kim@lge.com, hillf.zj@alibaba-inc.com,
        hannes@cmpxchg.org, david@redhat.com, axboe@kernel.dk,
        apopple@nvidia.com, alexs@kernel.org, linmiaohe@huawei.com
Subject:  +
 mm-vmscan-fix-misleading-comment-in-isolate_lru_pages.patch added to -mm tree
Message-ID: <20210710185019.i5CpF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: fix misleading comment in isolate_lru_pages()
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-misleading-comment-in-isolate_lru_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-misleading-comment-in-isolate_lru_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-misleading-comment-in-isolate_lru_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: fix misleading comment in isolate_lru_pages()

We couldn't know whether the page is being freed elsewhere until we failed
to increase the page count.

Link: https://lkml.kernel.org/r/20210710100329.49174-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-fix-misleading-comment-in-isolate_lru_pages
+++ a/mm/vmscan.c
@@ -1891,7 +1891,6 @@ static unsigned long isolate_lru_pages(u
 		 */
 		scan += nr_pages;
 		if (!__isolate_lru_page_prepare(page, mode)) {
-			/* It is being freed elsewhere */
 			list_move(&page->lru, src);
 			continue;
 		}
@@ -1901,6 +1900,7 @@ static unsigned long isolate_lru_pages(u
 		 * page release code relies on it.
 		 */
 		if (unlikely(!get_page_unless_zero(page))) {
+			/* It is being freed elsewhere. */
 			list_move(&page->lru, src);
 			continue;
 		}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmscan-put-the-redirtied-madv_free-pages-back-to-anonymous-lru-list.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmscan-fix-misleading-comment-in-isolate_lru_pages.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

