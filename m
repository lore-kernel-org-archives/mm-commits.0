Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D311BC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C26CF610E7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350523AbhICVB6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350474AbhICVBu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7A57610FB;
        Fri,  3 Sep 2021 21:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702850;
        bh=DIvuV+nbDsLdRdb1KW6YG+Q9XWcYe19aKzHlow0K5qQ=;
        h=Date:From:To:Subject:From;
        b=cIYAhUL353xe6M/2keh7sHAoUzs4LTtpR4jCKYN0CmuTbVf6RpQDcTirPVhZk5za+
         p6FRdFM+KP4j3nNINnvSZYsceqTnvSkEYkGaywJKYBXRvX4hCLq4Srghn0YkX+GmqY
         R9pdrqRXHX6FLfuLsQZhVVH8irmYUVVLiyGe42js=
Date:   Fri, 03 Sep 2021 14:00:49 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, apopple@nvidia.com, axboe@kernel.dk,
        david@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com,
        iamjoonsoo.kim@lge.com, jhubbard@nvidia.com, linmiaohe@huawei.com,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        shli@fb.com, vbabka@suse.cz, willy@infradead.org, yuzhao@google.com
Subject:  [merged]
 =?US-ASCII?Q?mm-vmscan-remove-the-pagedirty-check-after-madv=5Ffree-page?=
 =?US-ASCII?Q?s-are-page=5Fref=5Ffreezed.patch?= removed from -mm tree
Message-ID: <20210903210049.DapMCv0lI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: remove the PageDirty check after MADV_FREE pages are page_ref_freezed
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-the-pagedirty-check-after-madv_free-pages-are-page_ref_freezed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmscan: remove the PageDirty check after MADV_FREE pages are page_ref_freezed

Patch series "Cleanups for vmscan", v2.

This series contains cleanups to remove unneeded return value, misleading
setting and so on.  Also this remove the PageDirty check after MADV_FREE
pages are page_ref_freezed.  More details can be found in the respective
changelogs.


This patch (of 4):

If the MADV_FREE pages are redirtied before they could be reclaimed, put
the pages back to anonymous LRU list by setting SwapBacked flag and the
pages will be reclaimed in normal swapout way.  But as Yu Zhao pointed
out, "The page has only one reference left, which is from the isolation. 
After the caller puts the page back on lru and drops the reference, the
page will be freed anyway.  It doesn't matter which lru it goes." So we
don't bother checking PageDirty here.

[Yu Zhao's comment is also quoted in the code.]

Link: https://lkml.kernel.org/r/20210717065911.61497-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210717065911.61497-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
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
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-the-pagedirty-check-after-madv_free-pages-are-page_ref_freezed
+++ a/mm/vmscan.c
@@ -1732,11 +1732,14 @@ retry:
 			/* follow __remove_mapping for reference */
 			if (!page_ref_freeze(page, 1))
 				goto keep_locked;
-			if (PageDirty(page)) {
-				page_ref_unfreeze(page, 1);
-				goto keep_locked;
-			}
-
+			/*
+			 * The page has only one reference left, which is
+			 * from the isolation. After the caller puts the
+			 * page back on lru and drops the reference, the
+			 * page will be freed anyway. It doesn't matter
+			 * which lru it goes. So we don't bother checking
+			 * PageDirty here.
+			 */
 			count_vm_event(PGLAZYFREED);
 			count_memcg_page_event(page, PGLAZYFREED);
 		} else if (!mapping || !__remove_mapping(mapping, page, true,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

