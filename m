Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC83C25B6E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjJYXsY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbjJYXsG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6671419D
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34976C433C9;
        Wed, 25 Oct 2023 23:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277681;
        bh=6Ej1Oq+R6NavU5QH+tK9zGDeS2oMsOMakjyo7qaWVSI=;
        h=Date:To:From:Subject:From;
        b=m/O+moZ4SClmHlwLnl4SuP+/i9/qdvw29TewoI1acnkJqebeqswdLuTJfD5wZwZfn
         GbxdKh/plK7gC0UiaDXluzIfXrIkUGZMJURWYb016qoWWWuA+WRdG7s0GwghhFxoKJ
         FjPJs7aO1bclR4Si0PF5qq1huDeV6dnzsORdhpDI=
Date:   Wed, 25 Oct 2023 16:48:00 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nilfs2-convert-nilfs_mdt_get_frozen_buffer-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231025234801.34976C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: convert nilfs_mdt_get_frozen_buffer to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_mdt_get_frozen_buffer-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_mdt_get_frozen_buffer to use a folio
Date: Mon, 16 Oct 2023 21:11:01 +0100

Remove a number of folio->page->folio conversions.

Link: https://lkml.kernel.org/r/20231016201114.1928083-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/mdt.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/nilfs2/mdt.c~nilfs2-convert-nilfs_mdt_get_frozen_buffer-to-use-a-folio
+++ a/fs/nilfs2/mdt.c
@@ -592,17 +592,19 @@ nilfs_mdt_get_frozen_buffer(struct inode
 {
 	struct nilfs_shadow_map *shadow = NILFS_MDT(inode)->mi_shadow;
 	struct buffer_head *bh_frozen = NULL;
-	struct page *page;
+	struct folio *folio;
 	int n;
 
-	page = find_lock_page(shadow->inode->i_mapping, bh->b_folio->index);
-	if (page) {
-		if (page_has_buffers(page)) {
+	folio = filemap_lock_folio(shadow->inode->i_mapping,
+			bh->b_folio->index);
+	if (!IS_ERR(folio)) {
+		bh_frozen = folio_buffers(folio);
+		if (bh_frozen) {
 			n = bh_offset(bh) >> inode->i_blkbits;
-			bh_frozen = nilfs_page_get_nth_block(page, n);
+			bh_frozen = get_nth_bh(bh_frozen, n);
 		}
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 	}
 	return bh_frozen;
 }
_

Patches currently in -mm which might be from willy@infradead.org are


