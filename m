Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075B5C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E19A760E9B
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350304AbhICU5y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350309AbhICU5x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6ED260C3E;
        Fri,  3 Sep 2021 20:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702613;
        bh=7LPCTXTQrx0Rx/GyzntX5LQhsNBM9y4W2mfJDk6rGIs=;
        h=Date:From:To:Subject:From;
        b=T2ln+g+EDAD6Q3OCW+PguBCw9azWz6QXXMmBKmWLUhdBXo/AToYfr3y7TY31bH7Ny
         XegkVkyKJ+3xdKYRVE82y+gpsjB0O878Qd6ZfBTiacuRjlAQS7cqxy3hKRNb4maNaZ
         emyEqD+EqItHcPIewxL2ns7ADzS6gtJBiTMV0A9c=
Date:   Fri, 03 Sep 2021 13:56:52 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        shy828301@gmail.com, willy@infradead.org
Subject:  [merged]
 huge-tmpfs-fix-fallocatevanilla-advance-over-huge-pages.patch removed from
 -mm tree
Message-ID: <20210903205652.bKE6fBJrv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: fix fallocate(vanilla) advance over huge pages
has been removed from the -mm tree.  Its filename was
     huge-tmpfs-fix-fallocatevanilla-advance-over-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: fix fallocate(vanilla) advance over huge pages

Patch series "huge tmpfs: shmem_is_huge() fixes and cleanups".

A series of huge tmpfs fixes and cleanups.


This patch (of 9):

shmem_fallocate() goes to a lot of trouble to leave its newly allocated
pages !Uptodate, partly to identify and undo them on failure, partly to
leave the overhead of clearing them until later.  But the huge page case
did not skip to the end of the extent, walked through the tail pages one
by one, and appeared to work just fine: but in doing so, cleared and
Uptodated the huge page, so there was no way to undo it on failure.

And by setting Uptodate too soon, it messed up both its nr_falloced and
nr_unswapped counts, so that the intended "time to give up" heuristic did
not work at all.

Now advance immediately to the end of the huge extent, with a comment on
why this is more than just an optimization.  But although this speeds up
huge tmpfs fallocation, it does leave the clearing until first use, and
some users may have come to appreciate slow fallocate but fast first use:
if they complain, then we can consider adding a pass to clear at the end.

Link: https://lkml.kernel.org/r/da632211-8e3e-6b1-aee-ab24734429a0@google.com
Link: https://lkml.kernel.org/r/16201bd2-70e-37e2-e89b-5f929430da@google.com
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~huge-tmpfs-fix-fallocatevanilla-advance-over-huge-pages
+++ a/mm/shmem.c
@@ -2719,7 +2719,7 @@ static long shmem_fallocate(struct file
 	inode->i_private = &shmem_falloc;
 	spin_unlock(&inode->i_lock);
 
-	for (index = start; index < end; index++) {
+	for (index = start; index < end; ) {
 		struct page *page;
 
 		/*
@@ -2742,13 +2742,26 @@ static long shmem_fallocate(struct file
 			goto undone;
 		}
 
+		index++;
+		/*
+		 * Here is a more important optimization than it appears:
+		 * a second SGP_FALLOC on the same huge page will clear it,
+		 * making it PageUptodate and un-undoable if we fail later.
+		 */
+		if (PageTransCompound(page)) {
+			index = round_up(index, HPAGE_PMD_NR);
+			/* Beware 32-bit wraparound */
+			if (!index)
+				index--;
+		}
+
 		/*
 		 * Inform shmem_writepage() how far we have reached.
 		 * No need for lock or barrier: we have the page lock.
 		 */
-		shmem_falloc.next++;
 		if (!PageUptodate(page))
-			shmem_falloc.nr_falloced++;
+			shmem_falloc.nr_falloced += index - shmem_falloc.next;
+		shmem_falloc.next = index;
 
 		/*
 		 * If !PageUptodate, leave it that way so that freeable pages
_

Patches currently in -mm which might be from hughd@google.com are


