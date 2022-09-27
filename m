Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8DFFC32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiI0CsZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiI0Crp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A53642DE
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9ECF61559
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196B9C433D6;
        Tue, 27 Sep 2022 02:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246861;
        bh=gmx+T2gd3mFYgAxOvgO54yYCr8WCEyoIAcfhh2804Eg=;
        h=Date:To:From:Subject:From;
        b=XZEy4eUqkBZ/pdMyvxnA1Knth4FhYdku1KHATjBKu8nCGFTB2k4lOVd8AKaL2DOTR
         Vg+dopTeLc1Ru44deRU0qWl6cMSur0MV7PW4UNhRV2ebgG0JDjbDxdLocL+yFqkoMI
         JsRbTsMPcq23g7k5Gr2ERcpnWYaSh+jqYg9yLdrY=
Date:   Mon, 26 Sep 2022 19:47:40 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        osalvador@suse.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate_pages-fix-failure-counting-for-thp-subpages-retrying.patch removed from -mm tree
Message-Id: <20220927024741.196B9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: migrate_pages(): fix failure counting for THP subpages retrying
has been removed from the -mm tree.  Its filename was
     migrate_pages-fix-failure-counting-for-thp-subpages-retrying.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages(): fix failure counting for THP subpages retrying
Date: Wed, 17 Aug 2022 16:14:04 +0800

If THP is failed to be migrated for -ENOSYS and -ENOMEM, the THP will be
split into thp_split_pages, and after other pages are migrated, pages in
thp_split_pages will be migrated with no_subpage_counting == true, because
its failure have been counted already.  If some pages in thp_split_pages
are retried during migration, we should not count their failure if
no_subpage_counting == true too.  This is done this patch to fix the
failure counting for THP subpages retrying.

Link: https://lkml.kernel.org/r/20220817081408.513338-5-ying.huang@intel.com
Fixes: 5984fabb6e82 ("mm: move_pages: report the number of non-attempted pages")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~migrate_pages-fix-failure-counting-for-thp-subpages-retrying
+++ a/mm/migrate.c
@@ -1545,7 +1545,8 @@ retry:
 			}
 		}
 	}
-	nr_failed += retry;
+	if (!no_subpage_counting)
+		nr_failed += retry;
 	nr_thp_failed += thp_retry;
 	/*
 	 * Try to migrate subpages of fail-to-migrate THPs, no nr_failed
_

Patches currently in -mm which might be from ying.huang@intel.com are


