Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B167EC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiJCVG0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJCVFc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1303140F6
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FEF1610D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53F6C433C1;
        Mon,  3 Oct 2022 21:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831107;
        bh=uHlXIJe3gFgcY+J4L/stuCjtzKt+lsq2mceOPi8yNCo=;
        h=Date:To:From:Subject:From;
        b=bumf/Bk1IxZRym1ayzTff3YxwkUFuZSri7oaPtJ9NMWGXv01JCALNb4Q6pTJwJlse
         /W9ZwHM/XNp4VaF4h9AvDh/pO/1Tbe8E+njrTmFkqln61z2EQrY2UiMqyqfRjanipv
         Q1isCpWNwI5Dm7Tmov1vND5JQSE2E9/QmgFt++Ok=
Date:   Mon, 03 Oct 2022 14:05:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_file_read_iter-to-use-shmem_get_folio.patch removed from -mm tree
Message-Id: <20221003210506.E53F6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_file_read_iter() to use shmem_get_folio()
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_file_read_iter-to-use-shmem_get_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_file_read_iter() to use shmem_get_folio()
Date: Fri, 2 Sep 2022 20:46:23 +0100

Use a folio throughout, saving five calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-28-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_file_read_iter-to-use-shmem_get_folio
+++ a/mm/shmem.c
@@ -2577,6 +2577,7 @@ static ssize_t shmem_file_read_iter(stru
 	offset = *ppos & ~PAGE_MASK;
 
 	for (;;) {
+		struct folio *folio = NULL;
 		struct page *page = NULL;
 		pgoff_t end_index;
 		unsigned long nr, ret;
@@ -2591,17 +2592,18 @@ static ssize_t shmem_file_read_iter(stru
 				break;
 		}
 
-		error = shmem_getpage(inode, index, &page, SGP_READ);
+		error = shmem_get_folio(inode, index, &folio, SGP_READ);
 		if (error) {
 			if (error == -EINVAL)
 				error = 0;
 			break;
 		}
-		if (page) {
-			unlock_page(page);
+		if (folio) {
+			folio_unlock(folio);
 
+			page = folio_file_page(folio, index);
 			if (PageHWPoison(page)) {
-				put_page(page);
+				folio_put(folio);
 				error = -EIO;
 				break;
 			}
@@ -2617,14 +2619,14 @@ static ssize_t shmem_file_read_iter(stru
 		if (index == end_index) {
 			nr = i_size & ~PAGE_MASK;
 			if (nr <= offset) {
-				if (page)
-					put_page(page);
+				if (folio)
+					folio_put(folio);
 				break;
 			}
 		}
 		nr -= offset;
 
-		if (page) {
+		if (folio) {
 			/*
 			 * If users can be writing to this page using arbitrary
 			 * virtual addresses, take care about potential aliasing
@@ -2636,13 +2638,13 @@ static ssize_t shmem_file_read_iter(stru
 			 * Mark the page accessed if we read the beginning.
 			 */
 			if (!offset)
-				mark_page_accessed(page);
+				folio_mark_accessed(folio);
 			/*
 			 * Ok, we have the page, and it's up-to-date, so
 			 * now we can copy it to user space...
 			 */
 			ret = copy_page_to_iter(page, offset, nr, to);
-			put_page(page);
+			folio_put(folio);
 
 		} else if (user_backed_iter(to)) {
 			/*
_

Patches currently in -mm which might be from willy@infradead.org are


