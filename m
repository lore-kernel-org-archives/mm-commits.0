Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDBA2C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiANWIQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:08:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60026 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiANWIN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:08:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D17CCB8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62005C36AED;
        Fri, 14 Jan 2022 22:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198091;
        bh=/hqtVcwg+2V7+zxTh2BL3YYwBuzfVyzUlbO59/g3EIc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Z+tp/pN7aNIPtZNoWJp6DaonCHYYcs+iIK74Mb5UuGlqDWnY4XRx9zA7pw50KUmil
         U4FiGvuATAYmDwog2g1unoYodbz/zYOh2KHazHl94t6hcF3DoBw8FHPWfxm2r5LfRB
         KPu+2TYwBUX0yMAdvwjEPkUf2NnoYxHqB+rLq3ms=
Date:   Fri, 14 Jan 2022 14:08:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chenwandun@huawei.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        wangkefeng.wang@huawei.com
Subject:  [patch 095/146] mm/page_isolation: unset migratetype
 directly for non Buddy page
Message-ID: <20220114220810.RDDLbQECb%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
