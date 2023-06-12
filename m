Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC95C7EE43
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbjFLVu2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjFLVuZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358E618C
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B875C62E8C
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1522EC433D2;
        Mon, 12 Jun 2023 21:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606623;
        bh=PeGscM776p3Vxmf1pCzrOubmH3IlfHh83I3V61xVqMo=;
        h=Date:To:From:Subject:From;
        b=ZBR/EAaJ2qRM/70A/0INGhSJ+FZKZov7ntPIvkIWdTAr6N7kj/PFgo98eer09PHhA
         8ORHulCgM6ClPh/N3ATaRHfJTh3xdhagH4C8F6W+SLvDxEJuxEdF9ZSulj7tbCJVQU
         arQl65OLotYJ7LBP2Vhdm2LslwBESIkIXrkJKcKw=
Date:   Mon, 12 Jun 2023 14:50:22 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gfs2-pass-a-folio-to-__gfs2_jdata_write_folio.patch added to mm-unstable branch
Message-Id: <20230612215023.1522EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: pass a folio to __gfs2_jdata_write_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     gfs2-pass-a-folio-to-__gfs2_jdata_write_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gfs2-pass-a-folio-to-__gfs2_jdata_write_folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: gfs2: pass a folio to __gfs2_jdata_write_folio()
Date: Mon, 12 Jun 2023 22:01:29 +0100

Remove a couple of folio->page conversions in the callers, and two calls
to compound_head() in the function itself.  Rename it from
__gfs2_jdata_writepage() to __gfs2_jdata_write_folio().

Link: https://lkml.kernel.org/r/20230612210141.730128-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/aops.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/fs/gfs2/aops.c~gfs2-pass-a-folio-to-__gfs2_jdata_write_folio
+++ a/fs/gfs2/aops.c
@@ -113,30 +113,31 @@ static int gfs2_write_jdata_page(struct
 }
 
 /**
- * __gfs2_jdata_writepage - The core of jdata writepage
- * @page: The page to write
+ * __gfs2_jdata_write_folio - The core of jdata writepage
+ * @folio: The folio to write
  * @wbc: The writeback control
  *
  * This is shared between writepage and writepages and implements the
  * core of the writepage operation. If a transaction is required then
- * PageChecked will have been set and the transaction will have
+ * the checked flag will have been set and the transaction will have
  * already been started before this is called.
  */
-
-static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *wbc)
+static int __gfs2_jdata_write_folio(struct folio *folio,
+		struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
 
-	if (PageChecked(page)) {
-		ClearPageChecked(page);
-		if (!page_has_buffers(page)) {
-			create_empty_buffers(page, inode->i_sb->s_blocksize,
-					     BIT(BH_Dirty)|BIT(BH_Uptodate));
+	if (folio_test_checked(folio)) {
+		folio_clear_checked(folio);
+		if (!folio_buffers(folio)) {
+			folio_create_empty_buffers(folio,
+					inode->i_sb->s_blocksize,
+					BIT(BH_Dirty)|BIT(BH_Uptodate));
 		}
-		gfs2_trans_add_databufs(ip, page_folio(page), 0, PAGE_SIZE);
+		gfs2_trans_add_databufs(ip, folio, 0, folio_size(folio));
 	}
-	return gfs2_write_jdata_page(page, wbc);
+	return gfs2_write_jdata_page(&folio->page, wbc);
 }
 
 /**
@@ -159,7 +160,7 @@ static int gfs2_jdata_writepage(struct p
 		goto out;
 	if (folio_test_checked(folio) || current->journal_info)
 		goto out_ignore;
-	return __gfs2_jdata_writepage(&folio->page, wbc);
+	return __gfs2_jdata_write_folio(folio, wbc);
 
 out_ignore:
 	folio_redirty_for_writepage(wbc, folio);
@@ -256,7 +257,7 @@ continue_unlock:
 
 		trace_wbc_writepage(wbc, inode_to_bdi(inode));
 
-		ret = __gfs2_jdata_writepage(&folio->page, wbc);
+		ret = __gfs2_jdata_write_folio(folio, wbc);
 		if (unlikely(ret)) {
 			if (ret == AOP_WRITEPAGE_ACTIVATE) {
 				folio_unlock(folio);
_

Patches currently in -mm which might be from willy@infradead.org are

gfs2-use-a-folio-inside-gfs2_jdata_writepage.patch
gfs2-pass-a-folio-to-__gfs2_jdata_write_folio.patch
gfs2-convert-gfs2_write_jdata_page-to-gfs2_write_jdata_folio.patch
buffer-convert-__block_write_full_page-to-__block_write_full_folio.patch
gfs2-support-ludicrously-large-folios-in-gfs2_trans_add_databufs.patch
buffer-make-block_write_full_page-handle-large-folios-correctly.patch
buffer-convert-block_page_mkwrite-to-use-a-folio.patch
buffer-convert-__block_commit_write-to-take-a-folio.patch
buffer-convert-page_zero_new_buffers-to-folio_zero_new_buffers.patch
buffer-convert-grow_dev_page-to-use-a-folio.patch
buffer-convert-init_page_buffers-to-folio_init_buffers.patch
buffer-convert-link_dev_buffers-to-take-a-folio.patch
buffer-use-a-folio-in-__find_get_block_slow.patch
buffer-convert-block_truncate_page-to-use-a-folio.patch

