From: akpm@linux-foundation.org
Subject: [merged] ufs-truncated-values-handling-64-bit-metadata.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:21 -0700
Message-ID: <201105271955.p4RJtQ8Z017453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148Ab1E0Tzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     ufs: fix truncated values handling 64 bit metadata
has been removed from the -mm tree.  Its filename was
     ufs-truncated-values-handling-64-bit-metadata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: fix truncated values handling 64 bit metadata
From: Dan Carpenter <error27@gmail.com>

Originally i_lastfrag was 32 bits but then we added support for handling
64 bit metadata and it became a 64 bit variable.  That was during 2007, in
54fb996ac15c "[PATCH] ufs2 write: block allocation update".  Unfortunately
these casts got left behind so the value got truncated to 32 bit again.

[akpm@linux-foundation.org: remove now-unneeded min_t/max_t casting]
Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c   |    9 +++++----
 fs/ufs/truncate.c |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/ufs/balloc.c~ufs-truncated-values-handling-64-bit-metadata fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs-truncated-values-handling-64-bit-metadata
+++ a/fs/ufs/balloc.c
@@ -424,8 +424,7 @@ u64 ufs_new_fragments(struct inode *inod
 			ufs_cpu_to_data_ptr(sb, p, result);
 			*err = 0;
 			UFS_I(inode)->i_lastfrag =
-				max_t(u32, UFS_I(inode)->i_lastfrag,
-				      fragment + count);
+				max(UFS_I(inode)->i_lastfrag, fragment + count);
 			ufs_clear_frags(inode, result + oldcount,
 					newcount - oldcount, locked_page != NULL);
 		}
@@ -440,7 +439,8 @@ u64 ufs_new_fragments(struct inode *inod
 	result = ufs_add_fragments (inode, tmp, oldcount, newcount, err);
 	if (result) {
 		*err = 0;
-		UFS_I(inode)->i_lastfrag = max_t(u32, UFS_I(inode)->i_lastfrag, fragment + count);
+		UFS_I(inode)->i_lastfrag = max(UFS_I(inode)->i_lastfrag,
+						fragment + count);
 		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
 				locked_page != NULL);
 		unlock_super(sb);
@@ -479,7 +479,8 @@ u64 ufs_new_fragments(struct inode *inod
 				   uspi->s_sbbase + result, locked_page);
 		ufs_cpu_to_data_ptr(sb, p, result);
 		*err = 0;
-		UFS_I(inode)->i_lastfrag = max_t(u32, UFS_I(inode)->i_lastfrag, fragment + count);
+		UFS_I(inode)->i_lastfrag = max(UFS_I(inode)->i_lastfrag,
+						fragment + count);
 		unlock_super(sb);
 		if (newcount < request)
 			ufs_free_fragments (inode, result + newcount, request - newcount);
diff -puN fs/ufs/truncate.c~ufs-truncated-values-handling-64-bit-metadata fs/ufs/truncate.c
--- a/fs/ufs/truncate.c~ufs-truncated-values-handling-64-bit-metadata
+++ a/fs/ufs/truncate.c
@@ -84,7 +84,7 @@ static int ufs_trunc_direct(struct inode
 	retry = 0;
 	
 	frag1 = DIRECT_FRAGMENT;
-	frag4 = min_t(u32, UFS_NDIR_FRAGMENT, ufsi->i_lastfrag);
+	frag4 = min_t(u64, UFS_NDIR_FRAGMENT, ufsi->i_lastfrag);
 	frag2 = ((frag1 & uspi->s_fpbmask) ? ((frag1 | uspi->s_fpbmask) + 1) : frag1);
 	frag3 = frag4 & ~uspi->s_fpbmask;
 	block1 = block2 = 0;
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch

