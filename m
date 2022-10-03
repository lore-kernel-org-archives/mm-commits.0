Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42824C43219
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJCVG3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiJCVFd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E4414D01
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5D4E610A5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4A6C433D7;
        Mon,  3 Oct 2022 21:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831108;
        bh=UH2hkJiPwL4tL9eapUtxoR2eR5gauPyQEYFbQ1bGQxU=;
        h=Date:To:From:Subject:From;
        b=m2rXOF2Ob3+8N+X/TO0EnwxWHjkFNaAay5V2Tcao2wSSUKfr7caxWWuNlLoe/ne1M
         R2QkBbiHNHXDQwOwElXBXxo/4Qd2gLUpzggG/YO4wrI1+lLiwbOY+Kf/fsI3HbwW/J
         Ww2ei9BnVK9pd95ne/ElHD5axaYvEIALmPPDeSh4=
Date:   Mon, 03 Oct 2022 14:05:07 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_fallocate-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210508.1A4A6C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_fallocate() to use a folio
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_fallocate-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_fallocate() to use a folio
Date: Fri, 2 Sep 2022 20:46:24 +0100

Call shmem_get_folio() and use the folio APIs instead of the page APIs. 
Saves several calls to compound_head() and removes assumptions about the
size of a large folio.

Link: https://lkml.kernel.org/r/20220902194653.1739778-29-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_fallocate-to-use-a-folio
+++ a/mm/shmem.c
@@ -2787,7 +2787,7 @@ static long shmem_fallocate(struct file
 		info->fallocend = end;
 
 	for (index = start; index < end; ) {
-		struct page *page;
+		struct folio *folio;
 
 		/*
 		 * Good, the fallocate(2) manpage permits EINTR: we may have
@@ -2798,10 +2798,11 @@ static long shmem_fallocate(struct file
 		else if (shmem_falloc.nr_unswapped > shmem_falloc.nr_falloced)
 			error = -ENOMEM;
 		else
-			error = shmem_getpage(inode, index, &page, SGP_FALLOC);
+			error = shmem_get_folio(inode, index, &folio,
+						SGP_FALLOC);
 		if (error) {
 			info->fallocend = undo_fallocend;
-			/* Remove the !PageUptodate pages we added */
+			/* Remove the !uptodate folios we added */
 			if (index > start) {
 				shmem_undo_range(inode,
 				    (loff_t)start << PAGE_SHIFT,
@@ -2810,37 +2811,34 @@ static long shmem_fallocate(struct file
 			goto undone;
 		}
 
-		index++;
 		/*
 		 * Here is a more important optimization than it appears:
-		 * a second SGP_FALLOC on the same huge page will clear it,
-		 * making it PageUptodate and un-undoable if we fail later.
+		 * a second SGP_FALLOC on the same large folio will clear it,
+		 * making it uptodate and un-undoable if we fail later.
 		 */
-		if (PageTransCompound(page)) {
-			index = round_up(index, HPAGE_PMD_NR);
-			/* Beware 32-bit wraparound */
-			if (!index)
-				index--;
-		}
+		index = folio_next_index(folio);
+		/* Beware 32-bit wraparound */
+		if (!index)
+			index--;
 
 		/*
 		 * Inform shmem_writepage() how far we have reached.
 		 * No need for lock or barrier: we have the page lock.
 		 */
-		if (!PageUptodate(page))
+		if (!folio_test_uptodate(folio))
 			shmem_falloc.nr_falloced += index - shmem_falloc.next;
 		shmem_falloc.next = index;
 
 		/*
-		 * If !PageUptodate, leave it that way so that freeable pages
+		 * If !uptodate, leave it that way so that freeable folios
 		 * can be recognized if we need to rollback on error later.
-		 * But set_page_dirty so that memory pressure will swap rather
-		 * than free the pages we are allocating (and SGP_CACHE pages
+		 * But mark it dirty so that memory pressure will swap rather
+		 * than free the folios we are allocating (and SGP_CACHE folios
 		 * might still be clean: we now need to mark those dirty too).
 		 */
-		set_page_dirty(page);
-		unlock_page(page);
-		put_page(page);
+		folio_mark_dirty(folio);
+		folio_unlock(folio);
+		folio_put(folio);
 		cond_resched();
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are


