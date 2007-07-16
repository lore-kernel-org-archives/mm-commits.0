From: akpm@linux-foundation.org
Subject: - udf-check-for-allocated-memory-for-data-of-new-inodes.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:09 -0700
Message-ID: <200707162053.l6GKr9ED001603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52976 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759148AbXGPVdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:33:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, hch@lst.de, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     UDF: check for allocated memory for data of new inodes
has been removed from the -mm tree.  Its filename was
     udf-check-for-allocated-memory-for-data-of-new-inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 fs/udf/ialloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

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
@@ -136,6 +136,13 @@ struct inode * udf_new_inode (struct ino
 		UDF_I_EFE(inode) = 0;
 		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct fileEntry), GFP_KERNEL);
 	}
+	if (!UDF_I_DATA(inode))
+	{
+		iput(inode);
+		*err = -ENOMEM;
+		mutex_unlock(&sbi->s_alloc_mutex);
+		return NULL;
+	}
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
 		UDF_I_ALLOCTYPE(inode) = ICBTAG_FLAG_AD_IN_ICB;
 	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
sky-cpu-and-nexus-get-rid-of-useless-null-init.patch
sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch
udf-coding-style-conversion-lindent.patch
