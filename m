Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91019EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjFSX0e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjFSXYm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713C519BB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52D2260FBF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9C4C433C0;
        Mon, 19 Jun 2023 23:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216986;
        bh=ubup2BXI0C8uq9zr8LreKFut9eKnDosImQLEh0OTBVY=;
        h=Date:To:From:Subject:From;
        b=xlofspkyFF3vA8ecMPZf76Zt1gUdSPLLlok6Ih3cPdNUoboRePHAKkkoDXYm41hAT
         f+X0hQEO74rUtuNsB5VhfGRNBMCTAXE78YdVGRzZ2K+khJc/ZmGFyDR+ZiMlmmtnwh
         BD4ObbzgXGJ5bRpgXWtMHE9VA9UrM6LTzIKvag78=
Date:   Mon, 19 Jun 2023 16:23:06 -0700
To:     mm-commits@vger.kernel.org, rpeterso@redhat.com, mcgrof@kernel.org,
        hare@suse.com, agruenba@redhat.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] gfs2-support-ludicrously-large-folios-in-gfs2_trans_add_databufs.patch removed from -mm tree
Message-Id: <20230619232306.AD9C4C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: gfs2: support ludicrously large folios in gfs2_trans_add_databufs()
has been removed from the -mm tree.  Its filename was
     gfs2-support-ludicrously-large-folios-in-gfs2_trans_add_databufs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


