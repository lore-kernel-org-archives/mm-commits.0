From: akpm@linux-foundation.org
Subject: [patch 07/84] fs/befs/linuxvfs.c:befs_get_block(): remove
 unneeded initialization to NULL
Date: Mon, 23 May 2016 16:22:40 -0700
Message-ID: <574390c0.1MWjs90kPjDB4TrG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbcEWXWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:22:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, salah.triki@acm.org

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
