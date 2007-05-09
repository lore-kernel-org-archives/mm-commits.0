From: akpm@linux-foundation.org
Subject: - udf-add-assertions.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:03 -0700
Message-ID: <200705090256.l492u3YK010001@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032370AbXEIC4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     udf: add assertions
has been removed from the -mm tree.  Its filename was
     udf-add-assertions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: udf: add assertions
From: Jan Kara <jack@suse.cz>

Add a few assertions into udf_discard_prealloc() to check that the file is
sane (mostly helps debugging further patches ;).

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/truncate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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

origin.patch
ext4-copy-i_flags-to-inode-flags-on-write.patch
