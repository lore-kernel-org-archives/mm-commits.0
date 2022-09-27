Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA622C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiI0Cs2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiI0Crp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F4161120
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 123D661547
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696FFC433D6;
        Tue, 27 Sep 2022 02:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246863;
        bh=JJmGeO/FTuHCiKLKbZWb/6g4hZORn67K36YBCDAVaf0=;
        h=Date:To:From:Subject:From;
        b=ZLeXh+6ko4IiRiaDLAAU4ViWyKMUh+D4s8DqrdXdzhIZbg4eng02IQMoXWmjcIknr
         7G6RvmJUOjl09HR4dZxVya2DtcDKz6Lrr84EBbiVw0TqmhYX9WLYr9du4U3bEkI0UH
         OfsCBlWIlkR4DnfB8T+A2RW9K9ZqfJcQTOyBJplw=
Date:   Mon, 26 Sep 2022 19:47:42 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        osalvador@suse.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate_pages-fix-failure-counting-for-thp-splitting.patch removed from -mm tree
Message-Id: <20220927024743.696FFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: migrate_pages(): fix failure counting for THP splitting
has been removed from the -mm tree.  Its filename was
     migrate_pages-fix-failure-counting-for-thp-splitting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages(): fix failure counting for THP splitting
Date: Wed, 17 Aug 2022 16:14:06 +0800

If THP is failed to be migrated, it may be split and retry.  But after
splitting, the head page will be left in "from" list, although THP
migration failure has been counted already.  If the head page is failed to
be migrated too, the failure will be counted twice incorrectly.  So this
is fixed in this patch via moving the head page of THP after splitting to
"thp_split_pages" too.

Link: https://lkml.kernel.org/r/20220817081408.513338-7-ying.huang@intel.com
Fixes: 5984fabb6e82 ("mm: move_pages: report the number of non-attempted pages")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/migrate.c~migrate_pages-fix-failure-counting-for-thp-splitting
+++ a/mm/migrate.c
@@ -1374,6 +1374,8 @@ static inline int try_split_thp(struct p
 	lock_page(page);
 	rc = split_huge_page_to_list(page, split_pages);
 	unlock_page(page);
+	if (!rc)
+		list_move_tail(&page->lru, split_pages);
 
 	return rc;
 }
@@ -1433,7 +1435,6 @@ thp_subpage_migration:
 		thp_retry = 0;
 
 		list_for_each_entry_safe(page, page2, from, lru) {
-retry:
 			/*
 			 * THP statistics is based on the source huge page.
 			 * Capture required information that might get lost
@@ -1469,10 +1470,9 @@ retry:
 			 * retry on the same page with the THP split
 			 * to base pages.
 			 *
-			 * Head page is retried immediately and tail
-			 * pages are added to the tail of the list so
-			 * we encounter them after the rest of the list
-			 * is processed.
+			 * Sub-pages are put in thp_split_pages, and
+			 * we will migrate them after the rest of the
+			 * list is processed.
 			 */
 			case -ENOSYS:
 				/* THP migration is unsupported */
@@ -1480,7 +1480,7 @@ retry:
 					nr_thp_failed++;
 					if (!try_split_thp(page, &thp_split_pages)) {
 						nr_thp_split++;
-						goto retry;
+						break;
 					}
 				/* Hugetlb migration is unsupported */
 				} else if (!no_subpage_counting) {
@@ -1500,7 +1500,7 @@ retry:
 					/* THP NUMA faulting doesn't split THP to retry. */
 					if (!nosplit && !try_split_thp(page, &thp_split_pages)) {
 						nr_thp_split++;
-						goto retry;
+						break;
 					}
 				} else if (!no_subpage_counting) {
 					nr_failed++;
_

Patches currently in -mm which might be from ying.huang@intel.com are


