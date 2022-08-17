Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE88C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 15:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240683AbiHQPrS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240478AbiHQPrC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 11:47:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A662C8A1CF
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 08:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7619B81E0C
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 15:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED99C433C1;
        Wed, 17 Aug 2022 15:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660751217;
        bh=EolxM0W45XOlAu+Zv07/IUL8NFfdPfL2AdJTGeyAuAY=;
        h=Date:To:From:Subject:From;
        b=BR67fL6SNJCxnmyYnqnq/b/B+QtbLoCF4A5Ql5ziTu0mrhEYW7PU8XxJ5wKKs5P31
         WOi+QQU4RTwAm7Kmd7pHbPse3vbgwpJikalbxDfD+LTzmBgwc9zMwWLljSqT5nbAR/
         3qWH5MP/WQ42mkEXq5QY+6OCF59OBzpAx64NM4nc=
Date:   Wed, 17 Aug 2022 08:46:56 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        shy828301@gmail.com, osalvador@suse.de,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-do-not-retry-10-times-for-the-subpages-of-fail-to-migrate-thp.patch added to mm-unstable branch
Message-Id: <20220817154657.4ED99C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: do not retry 10 times for the subpages of fail-to-migrate THP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-do-not-retry-10-times-for-the-subpages-of-fail-to-migrate-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-do-not-retry-10-times-for-the-subpages-of-fail-to-migrate-thp.patch

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

mm-migrate-do-not-retry-10-times-for-the-subpages-of-fail-to-migrate-thp.patch

