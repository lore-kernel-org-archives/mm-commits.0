Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1DAE9371F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Oct 2023 23:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379005AbjJIXaq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 19:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378152AbjJIXap (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 19:30:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5BB9D
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 16:30:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C039BC433C8;
        Mon,  9 Oct 2023 23:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696894244;
        bh=09zEFf2Mb3LmSEh6UowD4UR9AazQ1JiDnRqTgrxM9ng=;
        h=Date:To:From:Subject:From;
        b=JgNMPL9snDH2qLSSN1Xs+gQO8y3JfrCw06KImt3W7nh0x2a5Tq+7AYNnTk4i5Csjq
         kY6QCC1jqshU6f6Lta/+IJjWlNio2ZcMYrKoixFPH5xlAX/eK47ICWVJrLSdk7zjqU
         nv4tMr8zfyvY0NFs5yglfQQRqW5KATMguwwmSiDM=
Date:   Mon, 09 Oct 2023 16:30:29 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-correct-nr_failed-in-migrate_pages_sync.patch added to mm-unstable branch
Message-Id: <20231009233041.C039BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: correct nr_failed in migrate_pages_sync()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-correct-nr_failed-in-migrate_pages_sync.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-correct-nr_failed-in-migrate_pages_sync.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: correct nr_failed in migrate_pages_sync()
Date: Mon, 9 Oct 2023 16:32:31 -0400

In the upstream tree, large folios can be migrated via move_pages()
syscall and there is no VM_BUG_ON in do_move_pages_to_node() but pages
left in the source page list will not be returned to LRU lists.  This is
from my code inspection and I have not reproduced it on upstream tree yet.

nr_failed was missing the rc value from migrate_pages_batch() and can
cause a mismatch between migrate_pages() return value and the number of
not migrated pages, i.e., when the return value of migrate_pages() is 0,
there are still pages left in the from page list.  It will happen when a
non-PMD THP large folio fails to migrate due to -ENOMEM and is split
successfully but not all the split pages are not migrated,
migrate_pages_batch() would return non-zero, but astats.nr_thp_split =3D
0.  nr_failed would be 0 and returned to the caller of migrate_pages(),
but the not migrated pages are left in the from page list without being
added back to LRU lists.

Link: https://lkml.kernel.org/r/20231009203231.1715845-2-zi.yan@sent.com
Fixes: 2ef7dbb26990 ("migrate_pages: try migrate in batch asynchronously fi=
rstly")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-correct-nr_failed-in-migrate_pages_sync
+++ a/mm/migrate.c
@@ -1834,7 +1834,7 @@ static int migrate_pages_sync(struct lis
 		return rc;
 	}
 	stats->nr_thp_failed += astats.nr_thp_split;
-	nr_failed += astats.nr_thp_split;
+	nr_failed += rc + astats.nr_thp_split;
 	/*
 	 * Fall back to migrate all failed folios one by one synchronously. All
 	 * failed folios except split THPs will be retried, so their failure
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-correct-nr_failed-in-migrate_pages_sync.patch

