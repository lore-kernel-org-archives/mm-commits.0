From: akpm@linux-foundation.org
Subject: [merged]
 fs-befs-linuxvfsc-befs_get_block-remove-unneeded-initialization-to-null.patch removed from -mm tree
Date: Fri, 27 May 2016 11:42:26 -0700
Message-ID: <57489512.1PQ5w70lpe2wvjN4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbcE0Sm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:42:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: salah.triki@acm.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/befs/linuxvfs.c:befs_get_block(): remove unneeded initialization to NULL
has been removed from the -mm tree.  Its filename was
     fs-befs-linuxvfsc-befs_get_block-remove-unneeded-initialization-to-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Salah Triki <salah.triki@acm.org>
Subject: fs/befs/linuxvfs.c:befs_get_block(): remove unneeded initialization to NULL

inode is reinitialized by befs_iget() so no need to init it
with NULL in the beginning of befs_lookup()

Link: http://lkml.kernel.org/r/03d7e46890aef94078130bed97c4f8f8ae9ea2b2.1462842886.git.salah.triki@acm.org
Signed-off-by: Salah Triki <salah.triki@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/befs/linuxvfs.c~fs-befs-linuxvfsc-befs_get_block-remove-unneeded-initialization-to-null fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~fs-befs-linuxvfsc-befs_get_block-remove-unneeded-initialization-to-null
+++ a/fs/befs/linuxvfs.c
@@ -155,7 +155,7 @@ befs_get_block(struct inode *inode, sect
 static struct dentry *
 befs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 {
-	struct inode *inode = NULL;
+	struct inode *inode;
 	struct super_block *sb = dir->i_sb;
 	const befs_data_stream *ds = &BEFS_I(dir)->i_data.ds;
 	befs_off_t offset;
_

Patches currently in -mm which might be from salah.triki@acm.org are


