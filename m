From: akpm@linux-foundation.org
Subject: + writeback-remove-unused-variable.patch added to -mm
 tree
Date: Fri, 29 May 2020 15:05:37 -0700
Message-ID: <20200529220537.5jb73Yw6o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726975AbgE2WFh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 29 May 2020 18:05:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yuchao0@huawei.com


The patch titled
     Subject: writeback: remove unused variable
has been added to the -mm tree.  Its filename is
     writeback-remove-unused-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-remove-unused-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-remove-unused-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chao Yu <yuchao0@huawei.com>
Subject: writeback: remove unused variable

Commit 64081362e8ff ("mm/page-writeback.c: fix range_cyclic writeback
vs writepages deadlock") left unused variable, remove it.

Link: http://lkml.kernel.org/r/20200528033740.17269-1-yuchao0@huawei.com
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page-writeback.c~writeback-remove-unused-variable
+++ a/mm/page-writeback.c
@@ -2164,7 +2164,6 @@ int write_cache_pages(struct address_spa
 	int error;
 	struct pagevec pvec;
 	int nr_pages;
-	pgoff_t uninitialized_var(writeback_index);
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
@@ -2173,8 +2172,7 @@ int write_cache_pages(struct address_spa
 
 	pagevec_init(&pvec);
 	if (wbc->range_cyclic) {
-		writeback_index = mapping->writeback_index; /* prev offset */
-		index = writeback_index;
+		index = mapping->writeback_index; /* prev offset */
 		end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_SHIFT;
_

Patches currently in -mm which might be from yuchao0@huawei.com are

writeback-remove-unused-variable.patch
