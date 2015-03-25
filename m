From: akpm@linux-foundation.org
Subject: + bfs-correct-return-values.patch added to -mm tree
Date: Wed, 25 Mar 2015 14:48:14 -0700
Message-ID: <55132d1e.PCOTh0kafJXwGyYx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbCYVsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 17:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sanidhya.gatech@gmail.com, tigran@aivazian.fsnet.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: bfs: correct return values
has been added to the -mm tree.  Its filename is
     bfs-correct-return-values.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bfs-correct-return-values.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bfs-correct-return-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-trusted-xattr-missing-cap_sys_admin-check.patch
adfs-returning-correct-return-values.patch
affs-kstrdup-memory-handling.patch
affs-kstrdup-memory-handling-fix.patch
bfs-correct-return-values.patch

