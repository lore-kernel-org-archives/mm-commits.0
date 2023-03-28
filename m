Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B5EC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjC1XXF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjC1XWG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F4A2D75
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:22:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACF94619FC
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10744C433EF;
        Tue, 28 Mar 2023 23:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045722;
        bh=QmPJCA7rkreUnndARESJqRsH3FHC04/vQoL6iqPWKMg=;
        h=Date:To:From:Subject:From;
        b=QBRY/hxPQt9MXc98q7AKChtDi8TArsDVqWjfOTsDx+3hTyelFkcUiaY3tEA+IGvJP
         p7V7Y4fyMB+WvUKTAZixKOSPJQqJ3LjlThO6CcEIBXF04FlH+VL+mOBz8zvLkqVTmB
         p3Gz2v9axfl6nnYU2kF1Ri1CK/1zp1Gd6hTRhd9U=
Date:   Tue, 28 Mar 2023 16:22:01 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        xhao@linux.alibaba.com, willy@infradead.org, p.raghav@samsung.com,
        keescook@chromium.org, hughd@google.com, david@redhat.com,
        dave@stgolabs.net, brauner@kernel.org, a.manzanares@samsung.com,
        mcgrof@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-set-shmem_writepage-variables-early.patch removed from -mm tree
Message-Id: <20230328232202.10744C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: set shmem_writepage() variables early
has been removed from the -mm tree.  Its filename was
     shmem-set-shmem_writepage-variables-early.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: shmem: set shmem_writepage() variables early
Date: Thu, 9 Mar 2023 15:05:41 -0800

shmem_writepage() sets up variables typically used *after* a possible huge
page split.  However even if that does happen the address space mapping
should not change, and the inode does not change either.  So it should be
safe to set that from the very beginning.

This commit makes no functional changes.

Link: https://lkml.kernel.org/r/20230309230545.2930737-3-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Tested-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/shmem.c~shmem-set-shmem_writepage-variables-early
+++ a/mm/shmem.c
@@ -1341,9 +1341,9 @@ int shmem_unuse(unsigned int type)
 static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct folio *folio = page_folio(page);
-	struct shmem_inode_info *info;
-	struct address_space *mapping;
-	struct inode *inode;
+	struct address_space *mapping = folio->mapping;
+	struct inode *inode = mapping->host;
+	struct shmem_inode_info *info = SHMEM_I(inode);
 	swp_entry_t swap;
 	pgoff_t index;
 
@@ -1361,10 +1361,7 @@ static int shmem_writepage(struct page *
 		folio_clear_dirty(folio);
 	}
 
-	mapping = folio->mapping;
 	index = folio->index;
-	inode = mapping->host;
-	info = SHMEM_I(inode);
 	if (info->flags & VM_LOCKED)
 		goto redirty;
 	if (!total_swap_pages)
_

Patches currently in -mm which might be from mcgrof@kernel.org are


