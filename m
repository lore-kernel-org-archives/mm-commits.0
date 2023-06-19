Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4688EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjFSX0d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjFSXYe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEE8E72
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48E2860FBB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2939C433C8;
        Mon, 19 Jun 2023 23:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216983;
        bh=TlFb3lPvUBC3AS/Y1CfklgbMSIx54LPQ4ChLubHSZZM=;
        h=Date:To:From:Subject:From;
        b=WgBDXhNq20NEL+gTfPVe8oS7YwUePdGN9gYx/S19wC3cH0UKns59RC2Hwc2PlnHuK
         yGKWqEnBC+EpM7euOKSUOgPEgSjX9W/Cp53sdHjWMFrE8AFgIryp2LIE51j2E5/A4N
         QjKOsOrqPcBRniVE7/8f1odllXKlQtdrg6gO48Ow=
Date:   Mon, 19 Jun 2023 16:23:03 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] gfs2-pass-a-folio-to-__gfs2_jdata_write_folio.patch removed from -mm tree
Message-Id: <20230619232303.A2939C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: gfs2: pass a folio to __gfs2_jdata_write_folio()
has been removed from the -mm tree.  Its filename was
     gfs2-pass-a-folio-to-__gfs2_jdata_write_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


