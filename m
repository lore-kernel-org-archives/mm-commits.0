Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265DFC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjDRXfM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbjDRXe3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D81A5F4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AE1B634A5
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D729C433D2;
        Tue, 18 Apr 2023 23:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860854;
        bh=SVI+kk0CBLkp2jrqyx9eQhakUZ/ExlqvnIkPFgYeLWI=;
        h=Date:To:From:Subject:From;
        b=VPDLZS+fVOA0DdYOUvrllof9tdjKG9RpFCvlJjGD50SAeG0L2b32i1iVwxqm2I7Ls
         227VsJ/shVYFOAYLzRVLi5+LuraoyOWcb6XYZVq52+4MoRWzSP11Ex8yjvv7FpxcBb
         4urb1x/0RP8kkZlbkJiiIXulr8lXcSfHpNxhEckw=
Date:   Tue, 18 Apr 2023 16:34:13 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, peterx@redhat.com, kirill@shutemov.name,
        jiaqiyan@google.com, hughd@google.com, david@redhat.com,
        stevensd@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-drain-lru-after-swapping-in-shmem.patch removed from -mm tree
Message-Id: <20230418233414.5D729C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: drain lru after swapping in shmem
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-drain-lru-after-swapping-in-shmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Stevens <stevensd@chromium.org>
Subject: mm/khugepaged: drain lru after swapping in shmem
Date: Tue, 4 Apr 2023 21:01:14 +0900

Patch series "mm/khugepaged: fixes for khugepaged+shmem", v6.

This series reworks collapse_file so that the intermediate state of the
collapse does not leak out of collapse_file. Although this makes
collapse_file a bit more complicated, it means that the rest of the
kernel doesn't have to deal with the unusual state. This directly fixes
races with both lseek and mincore.

This series also fixes the fact that khugepaged completely breaks
userfaultfd+shmem. The rework of collapse_file provides a convenient
place to check for registered userfaultfds without making the shmem
userfaultfd implementation care about khugepaged.

Finally, this series adds a lru_add_drain after swapping in shmem pages,
which makes the subsequent folio_isolate_lru significantly more likely to
succeed.


This patch (of 4):

Call lru_add_drain after swapping in shmem pages so that isolate_lru_page
is more likely to succeed.

Link: https://lkml.kernel.org/r/20230404120117.2562166-1-stevensd@google.com
Link: https://lkml.kernel.org/r/20230404120117.2562166-2-stevensd@google.com
Signed-off-by: David Stevens <stevensd@chromium.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-drain-lru-after-swapping-in-shmem
+++ a/mm/khugepaged.c
@@ -1967,6 +1967,8 @@ static int collapse_file(struct mm_struc
 					result = SCAN_FAIL;
 					goto xa_unlocked;
 				}
+				/* drain pagevecs to help isolate_lru_page() */
+				lru_add_drain();
 				page = folio_file_page(folio, index);
 			} else if (trylock_page(page)) {
 				get_page(page);
_

Patches currently in -mm which might be from stevensd@chromium.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp.patch
mm-khugepaged-refactor-collapse_file-control-flow.patch
mm-khugepaged-skip-shmem-with-userfaultfd.patch
mm-khugepaged-maintain-page-cache-uptodate-flag.patch

