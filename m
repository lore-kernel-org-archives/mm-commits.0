From: akpm@linux-foundation.org
Subject: + udf-check-for-allocated-memory-for-data-of-new-inodes.patch added to -mm tree
Date: Fri, 11 May 2007 12:17:11 -0700
Message-ID: <200705111917.l4BJHBtI024242@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763613AbXEKTRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:17:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, hch@lst.de, jack@ucw.cz


The patch titled
     UDF: check for allocated memory for data of new inodes
has been added to the -mm tree.  Its filename is
     udf-check-for-allocated-memory-for-data-of-new-inodes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: UDF: check for allocated memory for data of new inodes
From: Cyrill Gorcunov <gorcunov@gmail.com>

Add checking for granted memory for inode data at the moment of its
creation.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/ialloc.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN fs/udf/ialloc.c~udf-check-for-allocated-memory-for-data-of-new-inodes fs/udf/ialloc.c
--- a/fs/udf/ialloc.c~udf-check-for-allocated-memory-for-data-of-new-inodes
+++ a/fs/udf/ialloc.c
@@ -50,7 +50,7 @@ void udf_free_inode(struct inode * inode
 		else
 			UDF_SB_LVIDIU(sb)->numFiles =
 				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numFiles) - 1);
-		
+
 		mark_buffer_dirty(sbi->s_lvidbh);
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);
@@ -136,6 +136,12 @@ struct inode * udf_new_inode (struct ino
 		UDF_I_EFE(inode) = 0;
 		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
 	}
+	if (!UDF_I_DATA(inode))
+	{
+		iput(inode);
+		*err = -ENOMEM;
+		return NULL;
+	}
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
 	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
udf-check-for-allocated-memory-for-data-of-new-inodes.patch
