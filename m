From: akpm@linux-foundation.org
Subject: [merged] fs-reiserfs-inodec-replace-0-by-null-for-pointers.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:42:54 -0800
Message-ID: <54e4eb3e.RTAMuo3hbXbCJVVM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbbBRTmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:42:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/reiserfs/inode.c: replace 0 by NULL for pointers
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-inodec-replace-0-by-null-for-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/reiserfs/inode.c: replace 0 by NULL for pointers

Fix sparse warning:
fs/reiserfs/inode.c:2769:19: warning: Using plain integer as NULL pointer

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/inode.c~fs-reiserfs-inodec-replace-0-by-null-for-pointers fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~fs-reiserfs-inodec-replace-0-by-null-for-pointers
+++ a/fs/reiserfs/inode.c
@@ -2766,7 +2766,7 @@ static int reiserfs_write_begin(struct f
 	int old_ref = 0;
 
  	inode = mapping->host;
-	*fsdata = 0;
+	*fsdata = NULL;
  	if (flags & AOP_FLAG_CONT_EXPAND &&
  	    (pos & (inode->i_sb->s_blocksize - 1)) == 0) {
  		pos ++;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

