From: akpm@linux-foundation.org
Subject: [merged] bfs-correct-return-values.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:18 -0700
Message-ID: <55355172.gKtWj5dW+igEOHNj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbbDTTN5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sanidhya.gatech@gmail.com, tigran@aivazian.fsnet.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: bfs: correct return values
has been removed from the -mm tree.  Its filename was
     bfs-correct-return-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Subject: bfs: correct return values

In case of failed memory allocation, the return should be ENOMEM instead
of ENOSPC.

Return -EIO when sb_bread() fails.

Signed-off-by: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/bfs/dir.c~bfs-correct-return-values fs/bfs/dir.c
--- a/fs/bfs/dir.c~bfs-correct-return-values
+++ a/fs/bfs/dir.c
@@ -86,7 +86,7 @@ static int bfs_create(struct inode *dir,
 
 	inode = new_inode(s);
 	if (!inode)
-		return -ENOSPC;
+		return -ENOMEM;
 	mutex_lock(&info->bfs_lock);
 	ino = find_first_zero_bit(info->si_imap, info->si_lasti + 1);
 	if (ino > info->si_lasti) {
@@ -293,7 +293,7 @@ static int bfs_add_entry(struct inode *d
 	for (block = sblock; block <= eblock; block++) {
 		bh = sb_bread(dir->i_sb, block);
 		if (!bh)
-			return -ENOSPC;
+			return -EIO;
 		for (off = 0; off < BFS_BSIZE; off += BFS_DIRENT_SIZE) {
 			de = (struct bfs_dirent *)(bh->b_data + off);
 			if (!de->ino) {
_

Patches currently in -mm which might be from sanidhya.gatech@gmail.com are

origin.patch
ocfs2-trusted-xattr-missing-cap_sys_admin-check.patch
linux-next.patch

