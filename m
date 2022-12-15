Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519F3C10F1E
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 23:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiLOXKY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 18:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiLOXJn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 18:09:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CE94A58B
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 15:09:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D5C3B81CD7
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 23:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D6BC433EF;
        Thu, 15 Dec 2022 23:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671145777;
        bh=wi0pOiA6ZvGxQgEM7Iwes4vs7qSiGjCKvAR9pBtoLog=;
        h=Date:To:From:Subject:From;
        b=Nz6VfMGwswOom45fT5ZdHTwuddA5/ktg83IefGSTRze+8y9Wvae+kt8/RHIN82wU7
         JX7PNiJKKJV6iUvvpMU98uG0ASUwJta7XS9vuAZFO/u4zmVNLmkvcjLHzJwm1jnLP0
         LCSXDaOtWDgbX+A1Yfy2dwKaGpXBYO8/OWxPmDc0=
Date:   Thu, 15 Dec 2022 15:09:37 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch added to mm-unstable branch
Message-Id: <20221215230937.B9D6BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: replace obvious uses of b_page with b_folio
has been added to the -mm mm-unstable branch.  Its filename is
     gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch

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
Subject: gfs2: replace obvious uses of b_page with b_folio
Date: Thu, 15 Dec 2022 21:43:58 +0000

These places just use b_page to get to the buffer's address_space.

Link: https://lkml.kernel.org/r/20221215214402.3522366-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/glops.c   |    2 +-
 fs/gfs2/log.c     |    2 +-
 fs/gfs2/meta_io.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/gfs2/glops.c~gfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/gfs2/glops.c
@@ -39,7 +39,7 @@ static void gfs2_ail_error(struct gfs2_g
 	       "AIL buffer %p: blocknr %llu state 0x%08lx mapping %p page "
 	       "state 0x%lx\n",
 	       bh, (unsigned long long)bh->b_blocknr, bh->b_state,
-	       bh->b_page->mapping, bh->b_page->flags);
+	       bh->b_folio->mapping, bh->b_folio->flags);
 	fs_err(sdp, "AIL glock %u:%llu mapping %p\n",
 	       gl->gl_name.ln_type, gl->gl_name.ln_number,
 	       gfs2_glock2aspace(gl));
--- a/fs/gfs2/log.c~gfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/gfs2/log.c
@@ -127,7 +127,7 @@ __acquires(&sdp->sd_ail_lock)
 			continue;
 		gl = bd->bd_gl;
 		list_move(&bd->bd_ail_st_list, &tr->tr_ail1_list);
-		mapping = bh->b_page->mapping;
+		mapping = bh->b_folio->mapping;
 		if (!mapping)
 			continue;
 		spin_unlock(&sdp->sd_ail_lock);
--- a/fs/gfs2/meta_io.c~gfs2-replace-obvious-uses-of-b_page-with-b_folio
+++ a/fs/gfs2/meta_io.c
@@ -334,7 +334,7 @@ int gfs2_meta_wait(struct gfs2_sbd *sdp,
 
 void gfs2_remove_from_journal(struct buffer_head *bh, int meta)
 {
-	struct address_space *mapping = bh->b_page->mapping;
+	struct address_space *mapping = bh->b_folio->mapping;
 	struct gfs2_sbd *sdp = gfs2_mapping2sbd(mapping);
 	struct gfs2_bufdata *bd = bh->b_private;
 	struct gfs2_trans *tr = current->journal_info;
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch

