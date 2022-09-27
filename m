Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54197C6FA86
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiI0Cs1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiI0Crr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBEA61730
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98F76B81901
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F79C433C1;
        Tue, 27 Sep 2022 02:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246862;
        bh=qOygQmPnSaEviUPlVxh4hSvaFg7cugE7m2DS6y9pv/s=;
        h=Date:To:From:Subject:From;
        b=A6/pQW/iWGZyx7qQSLhvz1Ish6vY2OP1SUxQgYBhTBtqMVfwj4o1JxVu4XOrTiMIZ
         HscC+9UetljcCltVujbb2SPHMUreg739A+raiDTTzbQfHhGBXzGPtLaNjB13a5rYlI
         WzNvgimVpOH7EDW8o9p+/CfSin9xh9eKCP+ItPN4=
Date:   Mon, 26 Sep 2022 19:47:41 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        osalvador@suse.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate_pages-fix-failure-counting-for-thp-on-enosys.patch removed from -mm tree
Message-Id: <20220927024742.42F79C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: migrate_pages(): fix failure counting for THP on -ENOSYS
has been removed from the -mm tree.  Its filename was
     migrate_pages-fix-failure-counting-for-thp-on-enosys.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages(): fix failure counting for THP on -ENOSYS
Date: Wed, 17 Aug 2022 16:14:05 +0800

If THP or hugetlbfs page migration isn't supported, unmap_and_move() or
unmap_and_move_huge_page() will return -ENOSYS.  For THP, splitting will
be tried, but if splitting doesn't succeed, the THP will be left in "from"
list wrongly.  If some other pages are retried, the THP migration failure
will counted again.  This is fixed via moving the failure THP from "from"
to "ret_pages".

Another issue of the original code is that the unsupported failure
processing isn't consistent between THP and hugetlbfs page.  Make them
consistent in this patch to make the code easier to be understood too.

Link: https://lkml.kernel.org/r/20220817081408.513338-6-ying.huang@intel.com
Fixes: 5984fabb6e82 ("mm: move_pages: report the number of non-attempted pages")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~migrate_pages-fix-failure-counting-for-thp-on-enosys
+++ a/mm/migrate.c
@@ -1260,10 +1260,8 @@ static int unmap_and_move_huge_page(new_
 	 * tables or check whether the hugepage is pmd-based or not before
 	 * kicking migration.
 	 */
-	if (!hugepage_migration_supported(page_hstate(hpage))) {
-		list_move_tail(&hpage->lru, ret);
+	if (!hugepage_migration_supported(page_hstate(hpage)))
 		return -ENOSYS;
-	}
 
 	if (page_count(hpage) == 1) {
 		/* page was freed from under us. So we are done. */
@@ -1460,6 +1458,7 @@ retry:
 			 *		 page will be put back
 			 *	-EAGAIN: stay on the from list
 			 *	-ENOMEM: stay on the from list
+			 *	-ENOSYS: stay on the from list
 			 *	Other errno: put on ret_pages list then splice to
 			 *		     from list
 			 */
@@ -1489,6 +1488,7 @@ retry:
 				}
 
 				nr_failed_pages += nr_subpages;
+				list_move_tail(&page->lru, &ret_pages);
 				break;
 			case -ENOMEM:
 				/*
_

Patches currently in -mm which might be from ying.huang@intel.com are


