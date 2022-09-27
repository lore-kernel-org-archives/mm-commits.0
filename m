Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70354C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiI0CsW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiI0Crp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0BA642DD
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97E4961543
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCABC433D6;
        Tue, 27 Sep 2022 02:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246860;
        bh=3LaG5MlwpLvUGniKGbu5KEe76dCTo5uc/l0tOllpYLs=;
        h=Date:To:From:Subject:From;
        b=w2CD4nk5467mLDpK43mnv4SgiD417kWNRGWYxbiZ9S3qGvpANRpUxTMmS5Kb+vOvC
         r0n+zYYAe0XES5BI8d71cKNOKEd3HTZ3H9IrLTohMxnUh4x9e9PCcB9+7qG14gPfyX
         2Ncyg5rgnG1khETXS+mP52eOrBLANxCkG8rinjgY=
Date:   Mon, 26 Sep 2022 19:47:39 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        osalvador@suse.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate_pages-fix-thp-failure-counting-for-enomem.patch removed from -mm tree
Message-Id: <20220927024739.ECCABC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: migrate_pages(): fix THP failure counting for -ENOMEM
has been removed from the -mm tree.  Its filename was
     migrate_pages-fix-thp-failure-counting-for-enomem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages(): fix THP failure counting for -ENOMEM
Date: Wed, 17 Aug 2022 16:14:03 +0800

In unmap_and_move(), if the new THP cannot be allocated, -ENOMEM will be
returned, and migrate_pages() will try to split the THP unless "reason" is
MR_NUMA_MISPLACED (that is, nosplit == true).  But when nosplit == true,
the THP migration failure will not be counted.

This is incorrect, so in this patch, the THP migration failure will be
counted for -ENOMEM regardless of nosplit is true or false.  The nr_failed
counting isn't fixed because it's not used.  Added some comments for it
per Baolin's suggestion.

Link: https://lkml.kernel.org/r/20220817081408.513338-4-ying.huang@intel.com
Fixes: 5984fabb6e82 ("mm: move_pages: report the number of non-attempted pages")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~migrate_pages-fix-thp-failure-counting-for-enomem
+++ a/mm/migrate.c
@@ -1494,11 +1494,11 @@ retry:
 				/*
 				 * When memory is low, don't bother to try to migrate
 				 * other pages, just exit.
-				 * THP NUMA faulting doesn't split THP to retry.
 				 */
-				if (is_thp && !nosplit) {
+				if (is_thp) {
 					nr_thp_failed++;
-					if (!try_split_thp(page, &thp_split_pages)) {
+					/* THP NUMA faulting doesn't split THP to retry. */
+					if (!nosplit && !try_split_thp(page, &thp_split_pages)) {
 						nr_thp_split++;
 						goto retry;
 					}
@@ -1514,6 +1514,7 @@ retry:
 				 * the caller otherwise the page refcnt will be leaked.
 				 */
 				list_splice_init(&thp_split_pages, from);
+				/* nr_failed isn't updated for not used */
 				nr_thp_failed += thp_retry;
 				goto out;
 			case -EAGAIN:
_

Patches currently in -mm which might be from ying.huang@intel.com are


