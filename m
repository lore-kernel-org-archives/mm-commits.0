Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B12C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJCVG1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJCVFc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1A5140FD
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D103B81123
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42BEC433D6;
        Mon,  3 Oct 2022 21:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831105;
        bh=xwQn2QBpDwHzTQLxxrhxiL3H4K5ZoWGtA110EVCmXVM=;
        h=Date:To:From:Subject:From;
        b=Vq1o1lQB+WAje5f/OPom0y/kZ1TBB4L1DHJC8NEpwMWvgreVTCZGLMDcepfDd/BRs
         wt9sBLCfg6YcIrEndJm7JiGHq+pnZEOOutpxt7rUtVjq6+0yUs7DjFbulXlGqt5zAb
         4przRUpRJNWQn+24gXzq5RMWcq9La8cV2ggSIYbg=
Date:   Mon, 03 Oct 2022 14:05:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_write_begin-to-use-shmem_get_folio.patch removed from -mm tree
Message-Id: <20221003210505.C42BEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_write_begin() to use shmem_get_folio()
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_write_begin-to-use-shmem_get_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_write_begin() to use shmem_get_folio()
Date: Fri, 2 Sep 2022 20:46:22 +0100

Use a folio throughout this function, saving a couple of calls to
compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-27-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_write_begin-to-use-shmem_get_folio
+++ a/mm/shmem.c
@@ -2498,6 +2498,7 @@ shmem_write_begin(struct file *file, str
 	struct inode *inode = mapping->host;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t index = pos >> PAGE_SHIFT;
+	struct folio *folio;
 	int ret = 0;
 
 	/* i_rwsem is held by caller */
@@ -2509,14 +2510,15 @@ shmem_write_begin(struct file *file, str
 			return -EPERM;
 	}
 
-	ret = shmem_getpage(inode, index, pagep, SGP_WRITE);
+	ret = shmem_get_folio(inode, index, &folio, SGP_WRITE);
 
 	if (ret)
 		return ret;
 
+	*pagep = folio_file_page(folio, index);
 	if (PageHWPoison(*pagep)) {
-		unlock_page(*pagep);
-		put_page(*pagep);
+		folio_unlock(folio);
+		folio_put(folio);
 		*pagep = NULL;
 		return -EIO;
 	}
_

Patches currently in -mm which might be from willy@infradead.org are


