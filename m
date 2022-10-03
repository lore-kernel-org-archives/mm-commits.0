Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44A0C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiJCVGZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiJCVFc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4167B7FD
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1E9DDCE0E7C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A363AC433B5;
        Mon,  3 Oct 2022 21:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831104;
        bh=6ATPU4VeoH84D4qLu8PYQD7Gf6NlRzD1qpQKG8cHkGE=;
        h=Date:To:From:Subject:From;
        b=c/x+OyHNoQr749ZiSrPTvz+X6MEpK4mRSaAqTbNMhz09PpWg2ZRWLkHZ2vn/AAc+f
         /VdQ8Y4NxdcENiOjOtOyZPca36poK7PPt12PypzN08RBn/RLzL5BR0thNl0DILCLNt
         U3djGkUDoJ7pxALffBxz/B9Z6b9dUihbEf48Lv2w=
Date:   Mon, 03 Oct 2022 14:05:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_get_partial_folio-to-use-shmem_get_folio.patch removed from -mm tree
Message-Id: <20221003210504.A363AC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_get_partial_folio() to use shmem_get_folio()
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_get_partial_folio-to-use-shmem_get_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_get_partial_folio() to use shmem_get_folio()
Date: Fri, 2 Sep 2022 20:46:21 +0100

Get rid of an unnecessary folio->page->folio conversion.

Link: https://lkml.kernel.org/r/20220902194653.1739778-26-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_get_partial_folio-to-use-shmem_get_folio
+++ a/mm/shmem.c
@@ -874,10 +874,9 @@ void shmem_unlock_mapping(struct address
 static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
 {
 	struct folio *folio;
-	struct page *page;
 
 	/*
-	 * At first avoid shmem_getpage(,,,SGP_READ): that fails
+	 * At first avoid shmem_get_folio(,,,SGP_READ): that fails
 	 * beyond i_size, and reports fallocated pages as holes.
 	 */
 	folio = __filemap_get_folio(inode->i_mapping, index,
@@ -888,9 +887,9 @@ static struct folio *shmem_get_partial_f
 	 * But read a page back from swap if any of it is within i_size
 	 * (although in some cases this is just a waste of time).
 	 */
-	page = NULL;
-	shmem_getpage(inode, index, &page, SGP_READ);
-	return page ? page_folio(page) : NULL;
+	folio = NULL;
+	shmem_get_folio(inode, index, &folio, SGP_READ);
+	return folio;
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are


