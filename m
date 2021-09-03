Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393FDC43217
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1927861131
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbhICVB6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350493AbhICVBx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7577E6112F;
        Fri,  3 Sep 2021 21:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702853;
        bh=utcVMJv1bu21jQp2ny/TI1EsRJhM3LaA+ZtcvrAkvno=;
        h=Date:From:To:Subject:From;
        b=1iAwW21fyvR0rJVbDhBXJx4z5jfwu7xHhfUQROXEZUjZVVx0Sde5Ml15M/S56y3pn
         lS241XAibVtx61H3ZR393fMWDRv/X2jkvYhFj3z6t1ow0wFPVC93B4kaMjx6U/JEDf
         VsZaUT0w+DuahLuLAgUWFRSOBVjZDozWLW08LRa0=
Date:   Fri, 03 Sep 2021 14:00:52 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, apopple@nvidia.com, axboe@kernel.dk,
        david@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com,
        iamjoonsoo.kim@lge.com, jhubbard@nvidia.com, linmiaohe@huawei.com,
        mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        shli@fb.com, vbabka@suse.cz, willy@infradead.org, yuzhao@google.com
Subject:  [merged]
 mm-vmscan-remove-misleading-setting-to-sc-priority.patch removed from -mm
 tree
Message-ID: <20210903210052.Zv2hqMO3H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: remove misleading setting to sc->priority
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-misleading-setting-to-sc-priority.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

