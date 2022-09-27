Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8775EC07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiI0Csq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiI0Crt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972216B667
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22BEFB81906
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0EBC433C1;
        Tue, 27 Sep 2022 02:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246865;
        bh=2qoQNDF/c42N84/j2V/5jhNNMiKl7lLifYMBL2ZPamw=;
        h=Date:To:From:Subject:From;
        b=POaxAVnFQtr+kzjHw6p9JRIEsyRTFUskBQmz//yyEKaaog2GFNszoNv6VLJOtkLNL
         Rpc8GHP8b8A2RGzTP/Ilq/epgfkNxyedjKaDlKAcvow4hXebShq43Y0HDEtiGF4evl
         pwHpXgRrry3WClmpSpX2G+/nR/cRr8tmVjnm9SDQ=
Date:   Mon, 26 Sep 2022 19:47:45 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        shy828301@gmail.com, osalvador@suse.de,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-do-not-retry-10-times-for-the-subpages-of-fail-to-migrate-thp.patch removed from -mm tree
Message-Id: <20220927024745.CE0EBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: do not retry 10 times for the subpages of fail-to-migrate THP
has been removed from the -mm tree.  Its filename was
     mm-migrate-do-not-retry-10-times-for-the-subpages-of-fail-to-migrate-thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: do not retry 10 times for the subpages of fail-to-migrate THP
Date: Wed, 17 Aug 2022 16:14:08 +0800

If THP is failed to migrate due to -ENOSYS or -ENOMEM case, the THP will
be split, and the subpages of fail-to-migrate THP will be tried to migrate
again, so we should not account the retry counter in the second loop,
since we already accounted 'nr_thp_failed' in the first loop.

Moreover we also do not need retry 10 times for -EAGAIN case for the
subpages of fail-to-migrate THP in the second loop, since we already
regarded the THP as migration failure, and save some migration time (for
the worst case, will try 512 * 10 times) according to previous discussion
[1].

[1] https://lore.kernel.org/linux-mm/87r13a7n04.fsf@yhuang6-desk2.ccr.corp.intel.com/

Link: https://lkml.kernel.org/r/20220817081408.513338-9-ying.huang@intel.com
Tested-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~mm-migrate-do-not-retry-10-times-for-the-subpages-of-fail-to-migrate-thp
+++ a/mm/migrate.c
@@ -1522,7 +1522,7 @@ thp_subpage_migration:
 			case -EAGAIN:
 				if (is_thp)
 					thp_retry++;
-				else
+				else if (!no_subpage_counting)
 					retry++;
 				nr_retry_pages += nr_subpages;
 				break;
@@ -1548,8 +1548,7 @@ thp_subpage_migration:
 			}
 		}
 	}
-	if (!no_subpage_counting)
-		nr_failed += retry;
+	nr_failed += retry;
 	nr_thp_failed += thp_retry;
 	nr_failed_pages += nr_retry_pages;
 	/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-hugetlb-fix-races-when-looking-up-a-cont-pte-pmd-size-hugetlb-page.patch

