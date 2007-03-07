From: akpm@linux-foundation.org
Subject: + udf-add-assertions.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:20:41 -0800
Message-ID: <200703070120.l271KfRM015363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41947 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161117AbXCGBUu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:20:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     udf: add assertions
has been added to the -mm tree.  Its filename is
     udf-add-assertions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: udf: add assertions
From: Jan Kara <jack@suse.cz>

Add a few assertions into udf_discard_prealloc() to check that the file is
sane (mostly helps debugging further patches ;).

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/truncate.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/udf/truncate.c~udf-add-assertions fs/udf/truncate.c
--- a/fs/udf/truncate.c~udf-add-assertions
+++ a/fs/udf/truncate.c
@@ -88,8 +88,9 @@ void udf_discard_prealloc(struct inode *
 	{
 		etype = netype;
 		lbcount += elen;
-		if (lbcount > inode->i_size && lbcount - inode->i_size < inode->i_sb->s_blocksize)
+		if (lbcount > inode->i_size && lbcount - elen < inode->i_size)
 		{
+			WARN_ON(lbcount - inode->i_size >= inode->i_sb->s_blocksize);
 			nelen = elen - (lbcount - inode->i_size);
 			epos.offset -= adsize;
 			extent_trunc(inode, &epos, eloc, etype, elen, nelen);
@@ -119,6 +120,7 @@ void udf_discard_prealloc(struct inode *
 	}
 	UDF_I_LENEXTENTS(inode) = lbcount;
 
+	WARN_ON(lbcount != inode->i_size);
 	brelse(epos.bh);
 }
 
_

Patches currently in -mm which might be from jack@suse.cz are

udf-use-sector_t-and-loff_t-for-file-offsets.patch
udf-introduce-struct-extent_position.patch
udf-use-get_bh.patch
udf-add-assertions.patch
udf-support-files-larger-than-1g.patch
udf-fix-link-counts.patch
