Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A13C43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiJCVG3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJCVFd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C6262D5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5AD2610E7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358CBC433C1;
        Mon,  3 Oct 2022 21:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831109;
        bh=eNoV53LS2RggfbJZ/hvPFrIPGEMYXtBtb14EXH05D9Q=;
        h=Date:To:From:Subject:From;
        b=tOiSGDVZuwofjjHPNmYY2zn0MioVrb4sDh+99Dxlhq5hKO4uGoW0r4pTlwey6Tap/
         YmEdu1ddqUMqbkUKg+XmkZbDve/1NwDVhSyUb4Lf8yFsLisqq4W28bONpdPERBkRMb
         LaAZJPvp1NbM65in316FPzYBqPi6rpO1Z7/jUNxM=
Date:   Mon, 03 Oct 2022 14:05:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-convert-shmem_symlink-to-use-a-folio.patch removed from -mm tree
Message-Id: <20221003210509.358CBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: convert shmem_symlink() to use a folio
has been removed from the -mm tree.  Its filename was
     shmem-convert-shmem_symlink-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: convert shmem_symlink() to use a folio
Date: Fri, 2 Sep 2022 20:46:25 +0100

While symlinks will always be < PAGE_SIZE, using the folio APIs gets rid
of unnecessary calls to compound_head().

Link: https://lkml.kernel.org/r/20220902194653.1739778-30-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_symlink-to-use-a-folio
+++ a/mm/shmem.c
@@ -3093,7 +3093,7 @@ static int shmem_symlink(struct user_nam
 	int error;
 	int len;
 	struct inode *inode;
-	struct page *page;
+	struct folio *folio;
 
 	len = strlen(symname) + 1;
 	if (len > PAGE_SIZE)
@@ -3121,18 +3121,18 @@ static int shmem_symlink(struct user_nam
 		inode->i_op = &shmem_short_symlink_operations;
 	} else {
 		inode_nohighmem(inode);
-		error = shmem_getpage(inode, 0, &page, SGP_WRITE);
+		error = shmem_get_folio(inode, 0, &folio, SGP_WRITE);
 		if (error) {
 			iput(inode);
 			return error;
 		}
 		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_op = &shmem_symlink_inode_operations;
-		memcpy(page_address(page), symname, len);
-		SetPageUptodate(page);
-		set_page_dirty(page);
-		unlock_page(page);
-		put_page(page);
+		memcpy(folio_address(folio), symname, len);
+		folio_mark_uptodate(folio);
+		folio_mark_dirty(folio);
+		folio_unlock(folio);
+		folio_put(folio);
 	}
 	dir->i_size += BOGO_DIRENT_SIZE;
 	dir->i_ctime = dir->i_mtime = current_time(dir);
_

Patches currently in -mm which might be from willy@infradead.org are


