Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771D6C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 15:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240504AbiHQPrD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240367AbiHQPqx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 11:46:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D3D832E7
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 08:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E97E561579
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 15:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB81C433C1;
        Wed, 17 Aug 2022 15:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660751211;
        bh=dIwsoh1ShefyHlfmLQCJBLbr64nJgaYZiYFYbIKNwR0=;
        h=Date:To:From:Subject:From;
        b=XdNhM8fg6JIZeTH98Q6N+I5CKrvkOR7IMxxHn4eEAJOVJgpZ5Iwdhb2DvTBwnfram
         weuWo8JBPqVyibONNIzHtPLNMqMCkNoxY+EKgqyP00rlrIpwr2h2NT/dYgrEUnIgD6
         2DIkSI+HXSd4+EC4HNJdP0Zf14Xv8SrTFP5mBBnM=
Date:   Wed, 17 Aug 2022 08:46:50 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        osalvador@suse.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-fix-failure-counting-for-thp-on-enosys.patch added to mm-unstable branch
Message-Id: <20220817154651.4BB81C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages(): fix failure counting for THP on -ENOSYS
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-fix-failure-counting-for-thp-on-enosys.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-fix-failure-counting-for-thp-on-enosys.patch

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

memory-tiering-hot-page-selection-with-hint-page-fault-latency.patch
memory-tiering-rate-limit-numa-migration-throughput.patch
memory-tiering-adjust-hot-threshold-automatically.patch
migrate-fix-syscall-move_pages-return-value-for-failure.patch
migrate_pages-remove-unnecessary-list_safe_reset_next.patch
migrate_pages-fix-thp-failure-counting-for-enomem.patch
migrate_pages-fix-failure-counting-for-thp-subpages-retrying.patch
migrate_pages-fix-failure-counting-for-thp-on-enosys.patch
migrate_pages-fix-failure-counting-for-thp-splitting.patch
migrate_pages-fix-failure-counting-for-retry.patch

