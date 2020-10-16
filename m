Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C75C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4ABE21D81
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881691;
	bh=QEPJI9PkHBJv9dZmhCkWqieM/KX9S1DEtQ6vjAGd/4M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Ju6EAyRWsErIfkF/On8EWCWSpuBtSleUxthe8ytd7AeBEFMTXV1Vp1XKbkHKZ4YAi
	 aL4yV76WJHnI7qUxEgRx2PyfceKdyy84KhAZYXiGTPXsdq4f4CS2XSpvNvng5QcPcV
	 yYD0kJXw8mdfRkZkw7s4nmlTeQbWFrsgkwDlA5CA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409428AbgJPUyv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732596AbgJPUyv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:54:51 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA714216C4;
        Fri, 16 Oct 2020 20:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881690;
        bh=QEPJI9PkHBJv9dZmhCkWqieM/KX9S1DEtQ6vjAGd/4M=;
        h=Date:From:To:Subject:From;
        b=gen47Rwk6OGLXjF5OlWLNQwdytYr+DUr891p/TiyVM9mgoFUtYuMcNMLAnchLSX7Z
         3CuPfulSEFsB8NS1jEgoLCVaiMU/W1MZhrwuyYE3T1bbCVFvTl/Zroi/hjDGxDJ9OS
         sAzBXAqLEhlqxwAXQMo9gJAi2t9qPxgr6PVsQIB8=
Date:   Fri, 16 Oct 2020 13:54:50 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch removed from -mm
 tree
Message-ID: <20201016205450.CRIzX6B_H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ramfs: fix nommu mmap with gaps in the page cache
has been removed from the -mm tree.  Its filename was
     ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox (Oracle) <willy@infradead.org>
Subject: ramfs: fix nommu mmap with gaps in the page cache

ramfs needs to check that pages are both physically contiguous and
contiguous in the file.  If the page cache happens to have, eg, page A for
index 0 of the file, no page for index 1, and page A+1 for index 2, then
an mmap of the first two pages of the file will succeed when it should
fail.

Link: https://lkml.kernel.org/r/20200914122239.GO6583@casper.infradead.org
Fixes: 642fb4d1f1dd ("[PATCH] NOMMU: Provide shared-writable mmap support on ramfs")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ramfs/file-nommu.c~ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache
+++ a/fs/ramfs/file-nommu.c
@@ -224,7 +224,7 @@ static unsigned long ramfs_nommu_get_unm
 	if (!pages)
 		goto out_free;
 
-	nr = find_get_pages(inode->i_mapping, &pgoff, lpages, pages);
+	nr = find_get_pages_contig(inode->i_mapping, pgoff, lpages, pages);
 	if (nr != lpages)
 		goto out_free_pages; /* leave if some pages were missing */
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

