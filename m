Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A9CC7EE43
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbjFLVui (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbjFLVub (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D167218E
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE7562F6E
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C219CC433EF;
        Mon, 12 Jun 2023 21:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606629;
        bh=A8RWQV4+57v8Ze5/EKTNvQrBSJnfWIxbB02cILwGySo=;
        h=Date:To:From:Subject:From;
        b=cHV+U8pYPZfc27ZRzB7Q/TAT6W6R+UVA7UqJ8toUxdJF7w4zIRSN3Pp9kJWsDECTU
         tVlNP7nBxaSdzqlNqqoP8euGX7JE9349mnEK1JPNBb44p98VlhHnAYvUz9juK2g7WV
         0e1sBSfYK4QjL+wIW4MrcFyeGpZ2vyH9jKcmC6uw=
Date:   Mon, 12 Jun 2023 14:50:29 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gfs2-support-ludicrously-large-folios-in-gfs2_trans_add_databufs.patch added to mm-unstable branch
Message-Id: <20230612215029.C219CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: support ludicrously large folios in gfs2_trans_add_databufs()
has been added to the -mm mm-unstable branch.  Its filename is
     gfs2-support-ludicrously-large-folios-in-gfs2_trans_add_databufs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gfs2-support-ludicrously-large-folios-in-gfs2_trans_add_databufs.patch

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
Subject: gfs2: support ludicrously large folios in gfs2_trans_add_databufs()
Date: Mon, 12 Jun 2023 22:01:32 +0100

We may someday support folios larger than 4GB, so use a size_t for the
byte count within a folio to prevent unpleasant truncations.

Link: https://lkml.kernel.org/r/20230612210141.730128-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/aops.c |    6 +++---
 fs/gfs2/aops.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/gfs2/aops.c~gfs2-support-ludicrously-large-folios-in-gfs2_trans_add_databufs
+++ a/fs/gfs2/aops.c
@@ -38,13 +38,13 @@
 
 
 void gfs2_trans_add_databufs(struct gfs2_inode *ip, struct folio *folio,
-			     unsigned int from, unsigned int len)
+			     size_t from, size_t len)
 {
 	struct buffer_head *head = folio_buffers(folio);
 	unsigned int bsize = head->b_size;
 	struct buffer_head *bh;
-	unsigned int to = from + len;
-	unsigned int start, end;
+	size_t to = from + len;
+	size_t start, end;
 
 	for (bh = head, start = 0; bh != head || !start;
 	     bh = bh->b_this_page, start = end) {
--- a/fs/gfs2/aops.h~gfs2-support-ludicrously-large-folios-in-gfs2_trans_add_databufs
+++ a/fs/gfs2/aops.h
@@ -10,6 +10,6 @@
 
 extern void adjust_fs_space(struct inode *inode);
 extern void gfs2_trans_add_databufs(struct gfs2_inode *ip, struct folio *folio,
-				    unsigned int from, unsigned int len);
+				    size_t from, size_t len);
 
 #endif /* __AOPS_DOT_H__ */
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

