Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45035E936E8
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244971AbjJDUXT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbjJDUWy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBADD11B
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BC3C433C9;
        Wed,  4 Oct 2023 20:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450970;
        bh=9tP2xrawOqaBF+eMJ1OIEHusLh1fiYbbaqpWtHb5ixg=;
        h=Date:To:From:Subject:From;
        b=xVCp/EbeerYeWueziJvsakJc7bCgJ6bQkmH7r6tQhyk78JJeYPOzvnDG82Dc+bBxR
         c5OPU1kRzdVmVl6IkpNE/leDrT8X/U7va0FoQ5ZIJxo/eY8I5WRRK7E/IbQv9QVi7p
         K46GRfVE4miWO3BuTsP4kWgRcF8Hi1rj4TlynH38=
Date:   Wed, 04 Oct 2023 13:22:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        roidinev@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-writeback-update-filemap_dirty_folio-comment.patch removed from -mm tree
Message-Id: <20231004202250.32BC3C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/writeback: update filemap_dirty_folio() comment
has been removed from the -mm tree.  Its filename was
     mm-writeback-update-filemap_dirty_folio-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jianguo Bao <roidinev@gmail.com>
Subject: mm/writeback: update filemap_dirty_folio() comment
Date: Sun, 17 Sep 2023 23:04:01 +0800

Change to use new address space operation dirty_folio().

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


