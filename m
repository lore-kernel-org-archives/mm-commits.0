From: akpm@linux-foundation.org
Subject: [merged]
 fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null.patch removed from -mm tree
Date: Fri, 27 May 2016 11:42:20 -0700
Message-ID: <5748950c.nvDSf+kZaAcUYbKZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbcE0SmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:42:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/datastream.c:befs_read_datastream(): remove unneeded initialization to NULL
has been removed from the -mm tree.  Its filename was
     fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/datastream.c:befs_read_datastream(): remove unneeded initialization to NULL

bh is reinitialized by befs_bread_iaddr() so no need to init it
with NULL in the beginning of befs_read_datastream().

Link: http://lkml.kernel.org/r/81e1f70187db34d195c8e42b1ff78be6a71c0060.1462649034.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/datastream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/befs/datastream.c~fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null fs/befs/datastream.c
--- a/fs/befs/datastream.c~fs-befs-datastreamc-befs_read_datastream-remove-unneeded-initialization-to-null
+++ a/fs/befs/datastream.c
@@ -48,7 +48,7 @@ struct buffer_head *
 befs_read_datastream(struct super_block *sb, const befs_data_stream *ds,
 		     befs_off_t pos, uint * off)
 {
-	struct buffer_head *bh = NULL;
+	struct buffer_head *bh;
 	befs_block_run run;
 	befs_blocknr_t block;	/* block coresponding to pos */
 
_

Patches currently in -mm which might be from salah.triki@acm.org are


