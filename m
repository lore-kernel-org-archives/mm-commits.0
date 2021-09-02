Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9028C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C3660F12
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347634AbhIBVzk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347874AbhIBVzR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A15A260724;
        Thu,  2 Sep 2021 21:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619659;
        bh=QyLDbNGCUNLLhT2RWZYdkChkQrGue/C457sFaDGD6Kw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WL3D0VaSRLWwfgNtKnR8u1IPL3VnNqx2Luno15plhGrivNsXEkvw8nA5vLCtDK7Ey
         9nN5amYk3q7njt0P0p0uSS6KwGeryK4r/sm4zAcohBwxiAgf7CXlnyHQeTbYNvnPRD
         gGQ0G4mpukQKHL/WlZHrejf1cKUS3rVHvZLD4gaU=
Date:   Thu, 02 Sep 2021 14:54:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 083/212] huge tmpfs: fix fallocate(vanilla)
 advance over huge pages
Message-ID: <20210902215418.P3lH1STOG%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
