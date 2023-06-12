Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13989C7EE43
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbjFLVuY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjFLVuX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:50:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D327E9
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01B3362E8C
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41087C433D2;
        Mon, 12 Jun 2023 21:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606621;
        bh=wiuRELiIg2da9bccxQ0+Eu9nZ1QUKgs+afm0XW7MyLI=;
        h=Date:To:From:Subject:From;
        b=rXUsE1W7C9gB5oO3vxz4IMVcnTx9InN2+yWEL061tGgVXT3oQM+aBuB66jlAhedI4
         c8/hY5IEfFQ1rNsWKmyC/7znTan9CT3lRkYT+C5choqXA5CEVf6a76CRgeqEuI/zyA
         8SqV091UYg9+UDMgyQkcFMCB3Lv5mKLwleaa+ZMY=
Date:   Mon, 12 Jun 2023 14:50:20 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gfs2-use-a-folio-inside-gfs2_jdata_writepage.patch added to mm-unstable branch
Message-Id: <20230612215021.41087C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: use a folio inside gfs2_jdata_writepage()
has been added to the -mm mm-unstable branch.  Its filename is
     gfs2-use-a-folio-inside-gfs2_jdata_writepage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gfs2-use-a-folio-inside-gfs2_jdata_writepage.patch

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

