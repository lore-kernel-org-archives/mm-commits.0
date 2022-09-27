Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BF4C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiI0CsE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiI0Crp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D883F62A96
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7117461559
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43B6C433D6;
        Tue, 27 Sep 2022 02:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246858;
        bh=qEaU943Nf4+2DcyqdzzXijpalSTsXuMYnTks4jov2YY=;
        h=Date:To:From:Subject:From;
        b=sxPLNT8UG0lDkYb+Rg1seOQDhFJ7zr/H9TtBCYsW6RMbbyAOg7mZEIEyhAbcrT/tv
         kB0ikwgRE68/cHWlq2JQX30L2DxWyzat2lr56AWf7oYFVDuFYzJnVOP5JvGF/W1xJ5
         /0G1TEJ+W8U87Vm06ZhXWZBWHNDptuGnHP4mgtcE=
Date:   Mon, 26 Sep 2022 19:47:38 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        osalvador@suse.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate_pages-remove-unnecessary-list_safe_reset_next.patch removed from -mm tree
Message-Id: <20220927024738.C43B6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: migrate_pages(): remove unnecessary list_safe_reset_next()
has been removed from the -mm tree.  Its filename was
     migrate_pages-remove-unnecessary-list_safe_reset_next.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages(): remove unnecessary list_safe_reset_next()
Date: Wed, 17 Aug 2022 16:14:02 +0800

Before commit b5bade978e9b ("mm: migrate: fix the return value of
migrate_pages()"), the tail pages of THP will be put in the "from"
list directly.  So one of the loop cursors (page2) needs to be reset,
as is done in try_split_thp() via list_safe_reset_next().  But after
the commit, the tail pages of THP will be put in a dedicated
list (thp_split_pages).  That is, the "from" list will not be changed
during splitting.  So, it's unnecessary to call list_safe_reset_next()
anymore.

This is a code cleanup, no functionality changes are expected.

Link: https://lkml.kernel.org/r/20220817081408.513338-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/migrate.c~migrate_pages-remove-unnecessary-list_safe_reset_next
+++ a/mm/migrate.c
@@ -1369,16 +1369,13 @@ out:
 	return rc;
 }
 
-static inline int try_split_thp(struct page *page, struct page **page2,
-				struct list_head *from)
+static inline int try_split_thp(struct page *page, struct list_head *split_pages)
 {
-	int rc = 0;
+	int rc;
 
 	lock_page(page);
-	rc = split_huge_page_to_list(page, from);
+	rc = split_huge_page_to_list(page, split_pages);
 	unlock_page(page);
-	if (!rc)
-		list_safe_reset_next(page, *page2, lru);
 
 	return rc;
 }
@@ -1482,7 +1479,7 @@ retry:
 				/* THP migration is unsupported */
 				if (is_thp) {
 					nr_thp_failed++;
-					if (!try_split_thp(page, &page2, &thp_split_pages)) {
+					if (!try_split_thp(page, &thp_split_pages)) {
 						nr_thp_split++;
 						goto retry;
 					}
@@ -1501,7 +1498,7 @@ retry:
 				 */
 				if (is_thp && !nosplit) {
 					nr_thp_failed++;
-					if (!try_split_thp(page, &page2, &thp_split_pages)) {
+					if (!try_split_thp(page, &thp_split_pages)) {
 						nr_thp_split++;
 						goto retry;
 					}
_

Patches currently in -mm which might be from ying.huang@intel.com are


