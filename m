Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B249EC25B6F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjJYXsH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjJYXsD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFD218D
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:47:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39524C433C9;
        Wed, 25 Oct 2023 23:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277675;
        bh=aso8RB9s4jFNDMVzJdCefoWxPOMpS9reEgQEICWCgrA=;
        h=Date:To:From:Subject:From;
        b=S1/jfLYN7dYtyqK+8uEz7A3q9sU5FMu4CgbT84j6OnmG1biyWz51Xop0kNN2kzR5L
         L5I/gAfs8T7j2Yh7JkgIVQWGjkJbqexyPhCI76prhM9uFJS7V7rDuXx4CQx/vOmz9f
         3GHNERVgH1bSitqnbPcCNVfgLCvlJACqs4zWvR2w=
Date:   Wed, 25 Oct 2023 16:47:54 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        konishi.ryusuke@gmail.com, agruenba@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] gfs2-convert-gfs2_getbuf-to-folios.patch removed from -mm tree
Message-Id: <20231025234755.39524C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: gfs2: convert gfs2_getbuf() to folios
has been removed from the -mm tree.  Its filename was
     gfs2-convert-gfs2_getbuf-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: gfs2: convert gfs2_getbuf() to folios
Date: Mon, 16 Oct 2023 21:10:54 +0100

Remove several folio->page->folio conversions.  Also use __GFP_NOFAIL
instead of calling yield() and the new get_nth_bh().

Link: https://lkml.kernel.org/r/20231016201114.1928083-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/meta_io.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

--- a/fs/gfs2/meta_io.c~gfs2-convert-gfs2_getbuf-to-folios
+++ a/fs/gfs2/meta_io.c
@@ -115,7 +115,7 @@ struct buffer_head *gfs2_getbuf(struct g
 {
 	struct address_space *mapping = gfs2_glock2aspace(gl);
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
-	struct page *page;
+	struct folio *folio;
 	struct buffer_head *bh;
 	unsigned int shift;
 	unsigned long index;
@@ -129,36 +129,31 @@ struct buffer_head *gfs2_getbuf(struct g
 	bufnum = blkno - (index << shift);  /* block buf index within page */
 
 	if (create) {
-		for (;;) {
-			page = grab_cache_page(mapping, index);
-			if (page)
-				break;
-			yield();
-		}
-		if (!page_has_buffers(page))
-			create_empty_buffers(page, sdp->sd_sb.sb_bsize, 0);
+		folio = __filemap_get_folio(mapping, index,
+				FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+				mapping_gfp_mask(mapping) | __GFP_NOFAIL);
+		bh = folio_buffers(folio);
+		if (!bh)
+			bh = folio_create_empty_buffers(folio,
+				sdp->sd_sb.sb_bsize, 0);
 	} else {
-		page = find_get_page_flags(mapping, index,
-						FGP_LOCK|FGP_ACCESSED);
-		if (!page)
+		folio = __filemap_get_folio(mapping, index,
+				FGP_LOCK | FGP_ACCESSED, 0);
+		if (IS_ERR(folio))
 			return NULL;
-		if (!page_has_buffers(page)) {
-			bh = NULL;
-			goto out_unlock;
-		}
+		bh = folio_buffers(folio);
 	}
 
-	/* Locate header for our buffer within our page */
-	for (bh = page_buffers(page); bufnum--; bh = bh->b_this_page)
-		/* Do nothing */;
-	get_bh(bh);
+	if (!bh)
+		goto out_unlock;
 
+	bh = get_nth_bh(bh, bufnum);
 	if (!buffer_mapped(bh))
 		map_bh(bh, sdp->sd_vfs, blkno);
 
 out_unlock:
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 
 	return bh;
 }
_

Patches currently in -mm which might be from willy@infradead.org are


