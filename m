Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3A8C001B3
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjFSX0X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjFSXYc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE48E73
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 459D160F79
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEB2C433C8;
        Mon, 19 Jun 2023 23:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216982;
        bh=r/uaU505kz34txxg6Fu/zKXjV/0oDKYfKfnXLUWKyPE=;
        h=Date:To:From:Subject:From;
        b=jOypuwg5qCir+vR0gx/5eFADuSms5SE69M234N3FD94rH4WYb7N52Pl/BJeIQpJIS
         O+6sJrP5P8HRZEmUrQdPhALsz4w+xTnRsMhL29DtEfeLdGNo5h1Xoi4xVSebJrwsdt
         1lweRsSRvcpeoYpYM4FC6F7ovKiTtvND0I0RoUXw=
Date:   Mon, 19 Jun 2023 16:23:02 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] gfs2-use-a-folio-inside-gfs2_jdata_writepage.patch removed from -mm tree
Message-Id: <20230619232302.9FEB2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: gfs2: use a folio inside gfs2_jdata_writepage()
has been removed from the -mm tree.  Its filename was
     gfs2-use-a-folio-inside-gfs2_jdata_writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: gfs2: use a folio inside gfs2_jdata_writepage()
Date: Mon, 12 Jun 2023 22:01:28 +0100

Patch series "gfs2/buffer folio changes for 6.5", v3.

This kind of started off as a gfs2 patch series, then became entwined with
buffer heads once I realised that gfs2 was the only remaining caller of
__block_write_full_page().  For those not in the gfs2 world, the big point
of this series is that block_write_full_page() should now handle large
folios correctly.


This patch (of 14):

Replace a few implicit calls to compound_head() with one explicit one.

Link: https://lkml.kernel.org/r/20230612210141.730128-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230612210141.730128-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/aops.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/gfs2/aops.c~gfs2-use-a-folio-inside-gfs2_jdata_writepage
+++ a/fs/gfs2/aops.c
@@ -150,20 +150,21 @@ static int __gfs2_jdata_writepage(struct
 
 static int gfs2_jdata_writepage(struct page *page, struct writeback_control *wbc)
 {
+	struct folio *folio = page_folio(page);
 	struct inode *inode = page->mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 
 	if (gfs2_assert_withdraw(sdp, gfs2_glock_is_held_excl(ip->i_gl)))
 		goto out;
-	if (PageChecked(page) || current->journal_info)
+	if (folio_test_checked(folio) || current->journal_info)
 		goto out_ignore;
-	return __gfs2_jdata_writepage(page, wbc);
+	return __gfs2_jdata_writepage(&folio->page, wbc);
 
 out_ignore:
-	redirty_page_for_writepage(wbc, page);
+	folio_redirty_for_writepage(wbc, folio);
 out:
-	unlock_page(page);
+	folio_unlock(folio);
 	return 0;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


