Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B10CD37B4
	for <mm-commits@archiver.kernel.org>; Sun, 17 Sep 2023 18:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbjIQR7u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Sep 2023 13:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237864AbjIQR7V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Sep 2023 13:59:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7615F122
        for <mm-commits@vger.kernel.org>; Sun, 17 Sep 2023 10:59:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B42C433C8;
        Sun, 17 Sep 2023 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694973555;
        bh=edvs6bDqk7Y35qdqrqgXD4sqevkWvBRNRo/s8n5RZhA=;
        h=Date:To:From:Subject:From;
        b=losa0vTt27qw4T12QZo4x0MG+PDv47qkgCwMp+FZXJCnzupHWk3MW5Cf6//XVSH3o
         P1yBHoW4WSyeonjA/tRzhcfCyziVYzZodoeTh3KDmzGeWlLvr+/hqg0w4d0JOUx1rR
         7zg0VdZWgXa1AF3jIK4toJ5Dbx9uW5YnE5D6Cy9w=
Date:   Sun, 17 Sep 2023 10:59:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        roidinev@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-writeback-update-filemap_dirty_folio-comment.patch added to mm-unstable branch
Message-Id: <20230917175915.01B42C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/writeback: update filemap_dirty_folio() comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-writeback-update-filemap_dirty_folio-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-writeback-update-filemap_dirty_folio-comment.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jianguo Bau <roidinev@gmail.com>
Subject: mm/writeback: update filemap_dirty_folio() comment
Date: Sun, 17 Sep 2023 23:04:01 +0800

Change to use new address space operation dirty_folio

Link: https://lkml.kernel.org/r/20230917-trycontrib1-v1-1-db22630b8839@gmail.com
Fixes: 6f31a5a261db ("fs: Add aops->dirty_folio")
Signed-off-by: Jianguo Bau <roidinev@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-writeback-update-filemap_dirty_folio-comment
+++ a/mm/page-writeback.c
@@ -2679,7 +2679,7 @@ void __folio_mark_dirty(struct folio *fo
  * @folio: Folio to be marked as dirty.
  *
  * Filesystems which do not use buffer heads should call this function
- * from their set_page_dirty address space operation.  It ignores the
+ * from their dirty_folio address space operation.  It ignores the
  * contents of folio_get_private(), so if the filesystem marks individual
  * blocks as dirty, the filesystem should handle that itself.
  *
_

Patches currently in -mm which might be from roidinev@gmail.com are

mm-writeback-update-filemap_dirty_folio-comment.patch

