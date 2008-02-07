From: akpm@linux-foundation.org
Subject: - iget-stop-bfs-from-using-iget-and-read_inode-try-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:33:34 -0800
Message-ID: <200802070333.m173XF2C014032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54439 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759271AbYBGDdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:33:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Build Fail - fs/bfs/inode.c
has been removed from the -mm tree.  Its filename was
     iget-stop-bfs-from-using-iget-and-read_inode-try-fix.patch

This patch was dropped because it was folded into iget-stop-bfs-from-using-iget-and-read_inode-try.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Build Fail - fs/bfs/inode.c
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

fs/bfs/inode.c: In function `bfs_iget':
fs/bfs/inode.c:37: error: `ino' redeclared as different kind of symbol
fs/bfs/inode.c:35: error: previous definition of `ino' was here
fs/bfs/inode.c:37: error: `inode' undeclared (first use in this function)
fs/bfs/inode.c:37: error: (Each undeclared identifier is reported onlyonce
fs/bfs/inode.c:37: error: for each function it appears in.)

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/bfs/inode.c~iget-stop-bfs-from-using-iget-and-read_inode-try-fix fs/bfs/inode.c
--- a/fs/bfs/inode.c~iget-stop-bfs-from-using-iget-and-read_inode-try-fix
+++ a/fs/bfs/inode.c
@@ -34,7 +34,6 @@ void dump_imap(const char *prefix, struc
 
 struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 {
-	unsigned long ino = inode->i_ino;
 	struct bfs_inode *di;
 	struct inode *inode;
 	struct buffer_head *bh;
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

origin.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try-fix.patch
