Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F36C636C8
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 23:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 096ED61106
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 23:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhGTW6E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 18:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236423AbhGTWv6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 18:51:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 650BE6023B;
        Tue, 20 Jul 2021 23:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626823956;
        bh=+P1pqd/drFPQWMTIYYKczCnEYo/Ta0qRYVF9z13cpcA=;
        h=Date:From:To:Subject:From;
        b=RV1HxgsOkpXciylYAxKqytANyagXeLPSGkQDhiJDdA9qqRs8+hUK2orEyM1CVVXPl
         AtdNEIWcZYQmJq9HalwCoq50IrfNEb6ej8E9KmsohbVxq727UCK281FjIcTdcO8oYm
         NK6TDj/w0rHxjEP8mjISnkPcqkElLgFFNGozf+4o=
Date:   Tue, 20 Jul 2021 16:32:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shli@fb.com, minchan@kernel.org, mhocko@suse.com,
        iamjoonsoo.kim@lge.com, hillf.zj@alibaba-inc.com,
        hannes@cmpxchg.org, david@redhat.com, axboe@kernel.dk,
        apopple@nvidia.com, alexs@kernel.org, linmiaohe@huawei.com
Subject:  [to-be-updated]
 mm-vmscan-put-the-redirtied-madv_free-pages-back-to-anonymous-lru-list.patch
 removed from -mm tree
Message-ID: <20210720233234.jDaV0%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: put the redirtied MADV_FREE pages back to anonymous LRU list
has been removed from the -mm tree.  Its filename was
     mm-vmscan-put-the-redirtied-madv_free-pages-back-to-anonymous-lru-list.patch

This patch was dropped because an updated version will be merged

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

mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

