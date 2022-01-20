Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8C2C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377863AbiATV1G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377866AbiATV1F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5756C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:27:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63D8960A6C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A818C340E0;
        Thu, 20 Jan 2022 21:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714024;
        bh=frGV2dciTV9Ik6ioHf+LlL2UgprWvV3pvXcgTwqtJE8=;
        h=Date:From:To:Subject:From;
        b=rt2B/EhfYXuoAZxgPqBqlsnsoTp4CHhQFjvB8UEKJm7PZDE7iUrKcg7qY9EHVkH+o
         Q6Cm11Y32iWM3uN6iA6GcrrBYC+a8g0C/J98mPZf4OzSxf5uAixNHeWPcb8WgxOr4R
         JcQNq9yguxPk4d3/C2prMN9LedQWqaQZuNlTAU4A=
Date:   Thu, 20 Jan 2022 13:27:04 -0800
From:   akpm@linux-foundation.org
To:     chenwandun@huawei.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, vbabka@suse.cz,
        wangkefeng.wang@huawei.com
Subject:  [merged]
 mm-page_isolation-unset-migratetype-directly-for-non-buddy-page.patch
 removed from -mm tree
Message-ID: <20220120212704.d91ksYafj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: unset migratetype directly for non Buddy page
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-unset-migratetype-directly-for-non-buddy-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm/page_isolation: unset migratetype directly for non Buddy page

In unset_migratetype_isolate(), we can bypass the call to
move_freepages_block() for non-buddy pages.

It will save a few cpu cycles for some situations such as cma and hugetlb
when allocating continue pages, in these situation function
alloc_contig_pages will be called.

alloc_contig_pages
	__alloc_contig_migrate_range
	isolate_freepages_range ==> pages has been remove from buddy
	undo_isolate_page_range
		unset_migratetype_isolate ==> can directly set migratetype

[osalvador@suse.de: changelog tweak]
Link: https://lkml.kernel.org/r/20211229033649.2760586-1-chenwandun@huawei.com
Fixes: 3c605096d315 ("mm/page_alloc: restrict max order of merging on isolated pageblock")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Wang Kefeng <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_isolation.c~mm-page_isolation-unset-migratetype-directly-for-non-buddy-page
+++ a/mm/page_isolation.c
@@ -115,7 +115,7 @@ static void unset_migratetype_isolate(st
 	 * onlining - just onlined memory won't immediately be considered for
 	 * allocation.
 	 */
-	if (!isolated_page) {
+	if (!isolated_page && PageBuddy(page)) {
 		nr_pages = move_freepages_block(zone, page, migratetype, NULL);
 		__mod_zone_freepage_state(zone, nr_pages, migratetype);
 	}
_

Patches currently in -mm which might be from chenwandun@huawei.com are


