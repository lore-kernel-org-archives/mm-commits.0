From: akpm@linux-foundation.org
Subject: - inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default-reiser4.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:43 -0800
Message-ID: <200703060159.l261xhsn008634@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46557 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965663AbXCFB7p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:59:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     inode-diet: Eliminate i_blksize and use a per-superblock default
has been removed from the -mm tree.  Its filename was
     inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default-reiser4.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: inode-diet: Eliminate i_blksize and use a per-superblock default
From: "Theodore Ts'o" <tytso@mit.edu>

This eliminates the i_blksize field from struct inode.  Filesystems that want
to provide a per-inode st_blksize can do so by providing their own getattr
routine instead of using the generic_fillattr() function.

Note that some filesystems were providing pretty much random (and incorrect)
values for i_blksize.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/item/static_stat.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN fs/reiser4/plugin/item/static_stat.c~inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default-reiser4 fs/reiser4/plugin/item/static_stat.c
--- a/fs/reiser4/plugin/item/static_stat.c~inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default-reiser4
+++ a/fs/reiser4/plugin/item/static_stat.c
@@ -169,7 +169,6 @@ int init_inode_static_sd(struct inode *i
 	}
 	state->extmask = bigmask;
 	/* common initialisations */
-	inode->i_blksize = get_super_private(inode->i_sb)->optimal_io_size;
 	if (len - (bit / 16 * sizeof(d16)) > 0) {
 		/* alignment in save_len_static_sd() is taken into account
 		   -edward */
_

Patches currently in -mm which might be from tytso@mit.edu are

reiser4.patch
inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default-reiser4.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
