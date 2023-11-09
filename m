Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C0FC4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 21:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjKIVy5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 16:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbjKIVy4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 16:54:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FAD1FF6
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 13:54:50 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B4BC433C8;
        Thu,  9 Nov 2023 21:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699566890;
        bh=B97C/oEGxNG3ytgMOXKjHdcYU7nDp+bvGsv/UnEhetY=;
        h=Date:To:From:Subject:From;
        b=zz00ld0jok4He4GSRy/G8ymBjhTCKy0jrEJROtkQR7HAjFbYQJENcR0n+I1jIo1Hc
         OMbl2+JBB/xRsiv9b8kwRVBXLSTFbGTBGDkU3noi5N/EFUgkZ2V5d9x+kKC0byW3qT
         syyWup/54Ase9EP+xV69RYEziCFEXp4bgK0OdK0c=
Date:   Thu, 09 Nov 2023 13:54:49 -0800
To:     mm-commits@vger.kernel.org, tytso@mit.edu, djwong@kernel.org,
        agruenba@redhat.com, adilger.kernel@dilger.ca, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch added to mm-unstable branch
Message-Id: <20231109215450.37B4BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: convert stuffed_readpage() to stuffed_read_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch

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
Subject: gfs2: convert stuffed_readpage() to stuffed_read_folio()
Date: Tue, 7 Nov 2023 21:26:42 +0000

Use folio_fill_tail() to implement the unstuffing and folio_end_read() to
simultaneously mark the folio uptodate and unlock it.  Unifies a couple of
code paths.

Link: https://lkml.kernel.org/r/20231107212643.3490372-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/aops.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/fs/gfs2/aops.c~gfs2-convert-stuffed_readpage-to-stuffed_read_folio
+++ a/fs/gfs2/aops.c
@@ -403,18 +403,18 @@ static int gfs2_jdata_writepages(struct
 }
 
 /**
- * stuffed_readpage - Fill in a Linux folio with stuffed file data
+ * stuffed_read_folio - Fill in a Linux folio with stuffed file data
  * @ip: the inode
  * @folio: the folio
  *
  * Returns: errno
  */
-static int stuffed_readpage(struct gfs2_inode *ip, struct folio *folio)
+static int stuffed_read_folio(struct gfs2_inode *ip, struct folio *folio)
 {
-	struct buffer_head *dibh;
-	size_t i_size = i_size_read(&ip->i_inode);
-	void *data;
-	int error;
+	struct buffer_head *dibh = NULL;
+	size_t dsize = i_size_read(&ip->i_inode);
+	void *from = NULL;
+	int error = 0;
 
 	/*
 	 * Due to the order of unstuffing files and ->fault(), we can be
@@ -422,22 +422,20 @@ static int stuffed_readpage(struct gfs2_
 	 * so we need to supply one here. It doesn't happen often.
 	 */
 	if (unlikely(folio->index)) {
-		folio_zero_range(folio, 0, folio_size(folio));
-		folio_mark_uptodate(folio);
-		return 0;
+		dsize = 0;
+	} else {
+		error = gfs2_meta_inode_buffer(ip, &dibh);
+		if (error)
+			goto out;
+		from = dibh->b_data + sizeof(struct gfs2_dinode);
 	}
 
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		return error;
-
-	data = dibh->b_data + sizeof(struct gfs2_dinode);
-	memcpy_to_folio(folio, 0, data, i_size);
-	folio_zero_range(folio, i_size, folio_size(folio) - i_size);
+	folio_fill_tail(folio, 0, from, dsize);
 	brelse(dibh);
-	folio_mark_uptodate(folio);
+out:
+	folio_end_read(folio, error == 0);
 
-	return 0;
+	return error;
 }
 
 /**
@@ -456,8 +454,7 @@ static int gfs2_read_folio(struct file *
 	    (i_blocksize(inode) == PAGE_SIZE && !folio_buffers(folio))) {
 		error = iomap_read_folio(folio, &gfs2_iomap_ops);
 	} else if (gfs2_is_stuffed(ip)) {
-		error = stuffed_readpage(ip, folio);
-		folio_unlock(folio);
+		error = stuffed_read_folio(ip, folio);
 	} else {
 		error = mpage_read_folio(folio, gfs2_block_map);
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-folio_zero_tail-and-use-it-in-ext4.patch
mm-add-folio_fill_tail-and-use-it-in-iomap.patch
gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch
mm-remove-test_set_page_writeback.patch
afs-do-not-test-the-return-value-of-folio_start_writeback.patch
smb-do-not-test-the-return-value-of-folio_start_writeback.patch
mm-return-void-from-folio_start_writeback-and-related-functions.patch
mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch

