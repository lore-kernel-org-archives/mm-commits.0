Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D8FC32772
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 15:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239912AbiHQPqz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbiHQPqt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 11:46:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416D8857F7
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 08:46:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4B1D6158B
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 15:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35648C433D7;
        Wed, 17 Aug 2022 15:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660751207;
        bh=lJtuQYWwlC/iWBpkzOHz9ua8jzZQkUJxzQ5keQ68ZdY=;
        h=Date:To:From:Subject:From;
        b=YGwYBZa1wnmmmXVdLyBGGgwzWkkQDj675nCE/TO/wDiRIcRKTwd2m+PG0pYAtI3n5
         pWtAHCe2MtS5+E81RzMz62duYGPCgjt2vDGQPJAkpd0Hg6yfXnc6nE837dvemAeCga
         lDTyVe6PQqFtMtgkVvk9VjyktQ9ODuqM2hWJl0zY=
Date:   Wed, 17 Aug 2022 08:46:46 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        osalvador@suse.de, baolin.wang@linux.alibaba.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-fix-thp-failure-counting-for-enomem.patch added to mm-unstable branch
Message-Id: <20220817154647.35648C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages(): fix THP failure counting for -ENOMEM
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-fix-thp-failure-counting-for-enomem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-fix-thp-failure-counting-for-enomem.patch

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

