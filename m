From: akpm@linux-foundation.org
Subject: [merged] fs-affs-filec-replace-if-bug-by-bug_on.patch removed
 from -mm tree
Date: Wed, 18 Feb 2015 11:43:28 -0800
Message-ID: <54e4eb60.q5hlEpxNxX2VP2SJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbbBRTn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/file.c: replace if/BUG by BUG_ON
has been removed from the -mm tree.  Its filename was
     fs-affs-filec-replace-if-bug-by-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/file.c: replace if/BUG by BUG_ON

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/affs/file.c~fs-affs-filec-replace-if-bug-by-bug_on fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-replace-if-bug-by-bug_on
+++ a/fs/affs/file.c
@@ -180,8 +180,7 @@ affs_get_extblock_slow(struct inode *ino
 		ext_key = be32_to_cpu(AFFS_TAIL(sb, bh)->extension);
 		if (ext < AFFS_I(inode)->i_extcnt)
 			goto read_ext;
-		if (ext > AFFS_I(inode)->i_extcnt)
-			BUG();
+		BUG_ON(ext > AFFS_I(inode)->i_extcnt);
 		bh = affs_alloc_extblock(inode, bh, ext);
 		if (IS_ERR(bh))
 			return bh;
@@ -198,8 +197,7 @@ affs_get_extblock_slow(struct inode *ino
 		struct buffer_head *prev_bh;
 
 		/* allocate a new extended block */
-		if (ext > AFFS_I(inode)->i_extcnt)
-			BUG();
+		BUG_ON(ext > AFFS_I(inode)->i_extcnt);
 
 		/* get previous extended block */
 		prev_bh = affs_get_extblock(inode, ext - 1);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

