Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDA8C07E95
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 18:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 760746135E
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 18:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhGJSw5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 10 Jul 2021 14:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhGJSw4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 10 Jul 2021 14:52:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 141B261356;
        Sat, 10 Jul 2021 18:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625943011;
        bh=Twn1bOPq+n6EJJ5dZ2qdKjyF3GxN6HL/LIpYwMnZC+Y=;
        h=Date:From:To:Subject:From;
        b=dQOmm5nRo4LJP6MJdUlPk01CTu7R793NDgHkWrGeWfURHHI2EsLPnHYafFXHqOCPP
         Zy4q0Cuo+NVyi8CbbLepT9iWdHXmOgUDdHamhsOQRF+m6RAPPXE4eNkJsp5XREIWLa
         n5FdYtEQVQc/ZCVOWPAVj77MT2L0XBDG3iWvUtI4=
Date:   Sat, 10 Jul 2021 11:50:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shli@fb.com, minchan@kernel.org, mhocko@suse.com,
        iamjoonsoo.kim@lge.com, hillf.zj@alibaba-inc.com,
        hannes@cmpxchg.org, david@redhat.com, axboe@kernel.dk,
        apopple@nvidia.com, alexs@kernel.org, linmiaohe@huawei.com
Subject:  +
 mm-vmscan-put-the-redirtied-madv_free-pages-back-to-anonymous-lru-list.patch
 added to -mm tree
Message-ID: <20210710185010.geLwj%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: put the redirtied MADV_FREE pages back to anonymous LRU list
has been added to the -mm tree.  Its filename is
     mm-vmscan-put-the-redirtied-madv_free-pages-back-to-anonymous-lru-list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-put-the-redirtied-madv_free-pages-back-to-anonymous-lru-list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-put-the-redirtied-madv_free-pages-back-to-anonymous-lru-list.patch

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
Subject: mm/vmscan: put the redirtied MADV_FREE pages back to anonymous LRU list

Patch series "Cleanup and fixup for vmscan".

This series contains cleanups to remove unneeded return value, misleading
comment and so on.  Also this puts the redirtied MADV_FREE pages back to
anonymous LRU list.  More details can be found in the respective
changelogs.


This patch (of 5):

If the MADV_FREE pages are redirtied before they could be reclaimed, put
the pages back to anonymous LRU list by setting SwapBacked flag and the
pages will be reclaimed in normal swapout way.  Otherwise MADV_FREE pages
won't be reclaimed as expected.

Link: https://lkml.kernel.org/r/20210710100329.49174-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210710100329.49174-2-linmiaohe@huawei.com
Fixes: 802a3a92ad7a ("mm: reclaim MADV_FREE pages")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmscan.c~mm-vmscan-put-the-redirtied-madv_free-pages-back-to-anonymous-lru-list
+++ a/mm/vmscan.c
@@ -1628,6 +1628,7 @@ static unsigned int shrink_page_list(str
 			if (!page_ref_freeze(page, 1))
 				goto keep_locked;
 			if (PageDirty(page)) {
+				SetPageSwapBacked(page);
 				page_ref_unfreeze(page, 1);
 				goto keep_locked;
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

