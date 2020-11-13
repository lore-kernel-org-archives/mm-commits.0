Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F8AC4742C
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 23:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7137E2225E
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 23:42:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="v3vgZ5je"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgKMXma (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 18:42:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgKMXma (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 18:42:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 293CF2225D;
        Fri, 13 Nov 2020 23:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605310949;
        bh=VFpLXDtTT6SjsOQtF8oeJ9Tab+NcQaBa/iCUmfxVhLE=;
        h=Date:From:To:Subject:From;
        b=v3vgZ5jeUV+yYhbFd6UnYbjE0J22UHPX81/8S5E4GC8rqqTAEyLMMdqfTdP/QYz0P
         F+Z21tw2J5P/4eiDRZhMTjjyjHDSbsSCNeGsPgRdlAJMUkdd9OAYCOvFGhLW4HCUJa
         n1m7k+BkGlqIQNW40Gh+OAezDRm+mMGo29gwJmdE=
Date:   Fri, 13 Nov 2020 15:42:28 -0800
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  + mm-truncate_complete_page-is-not-existed-anymore.patch
 added to -mm tree
Message-ID: <20201113234228.Ec2YeSSH-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: truncate_complete_page() does not exist any more
has been added to the -mm tree.  Its filename is
     mm-truncate_complete_page-is-not-existed-anymore.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-truncate_complete_page-is-not-existed-anymore.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-truncate_complete_page-is-not-existed-anymore.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: truncate_complete_page() does not exist any more

Patch series "mm: misc migrate cleanup and improvement", v3.


This patch (of 5):

The commit 9f4e41f4717832e ("mm: refactor truncate_complete_page()")
refactored truncate_complete_page(), and it is not existed anymore,
correct the comment in vmscan and migrate to avoid confusion.

Link: https://lkml.kernel.org/r/20201113205359.556831-1-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20201113205359.556831-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 mm/vmscan.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-truncate_complete_page-is-not-existed-anymore
+++ a/mm/migrate.c
@@ -1106,7 +1106,7 @@ static int __unmap_and_move(struct page
 	 * and treated as swapcache but it has no rmap yet.
 	 * Calling try_to_unmap() against a page->mapping==NULL page will
 	 * trigger a BUG.  So handle it here.
-	 * 2. An orphaned page (see truncate_complete_page) might have
+	 * 2. An orphaned page (see truncate_cleanup_page) might have
 	 * fs-private metadata. The page can be picked up due to memory
 	 * offlining.  Everywhere else except page reclaim, the page is
 	 * invisible to the vm, so the page can not be migrated.  So try to
--- a/mm/vmscan.c~mm-truncate_complete_page-is-not-existed-anymore
+++ a/mm/vmscan.c
@@ -1392,7 +1392,7 @@ static unsigned int shrink_page_list(str
 		 *
 		 * Rarely, pages can have buffers and no ->mapping.  These are
 		 * the pages which were not successfully invalidated in
-		 * truncate_complete_page().  We try to drop those buffers here
+		 * truncate_cleanup_page().  We try to drop those buffers here
 		 * and if that worked, and the page is no longer mapped into
 		 * process address space (page_count == 1) it can be freed.
 		 * Otherwise, leave the page on the LRU so it is swappable.
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-truncate_complete_page-is-not-existed-anymore.patch
mm-migrate-simplify-the-logic-for-handling-permanent-failure.patch
mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch
mm-migrate-clean-up-migrate_prep_local.patch
mm-migrate-return-enosys-if-thp-migration-is-unsupported.patch

