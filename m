Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28F2C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Dec 2021 23:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhL2Xeh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 18:34:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51758 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbhL2Xeg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 18:34:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31B1BB819C4
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 23:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A980EC36AE9;
        Wed, 29 Dec 2021 23:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640820873;
        bh=k4RdKmxJtHsy4cg62XoNdKyOLluHdIzJch1TtT5T7KU=;
        h=Date:From:To:Subject:From;
        b=1T0QkJLPH4GWMv19UJK4lffREI7mk900cfkxjnZv/F62BujLli9EAlgfrTLRCXGL7
         67mgWxI6elcXu4eN75+eiAwNMBcKaxUAA0yj3HtpR3RFbrzreSyQBizsKmkT3olgvc
         vXToKhsXa0AP/otbzjNO8QvVf2iK4GSNw2XBn9DM=
Date:   Wed, 29 Dec 2021 15:34:33 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vbabka@suse.cz, osalvador@suse.de, iamjoonsoo.kim@lge.com,
        chenwandun@huawei.com
Subject:  +
 mm-page_isolation-unset-migratetype-directly-for-non-buddy-page.patch added
 to -mm tree
Message-ID: <20211229233433.-R8hO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: unset migratetype directly for non Buddy page
has been added to the -mm tree.  Its filename is
     mm-page_isolation-unset-migratetype-directly-for-non-buddy-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-unset-migratetype-directly-for-non-buddy-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-unset-migratetype-directly-for-non-buddy-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_isolation-unset-migratetype-directly-for-non-buddy-page.patch

