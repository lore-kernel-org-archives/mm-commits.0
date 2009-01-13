From: akpm@linux-foundation.org
Subject: + ext2-update-also-inode-on-disk-when-dir-is-is_dirsync.patch added to -mm tree
Date: Tue, 13 Jan 2009 15:19:00 -0800
Message-ID: <200901132319.n0DNJ0HZ010145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289AbZAMXTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 18:19:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, pavel@suse.cz


The patch titled
     ext2: also update the inode on disk when dir is IS_DIRSYNC
has been added to the -mm tree.  Its filename is
     ext2-update-also-inode-on-disk-when-dir-is-is_dirsync.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: also update the inode on disk when dir is IS_DIRSYNC
From: Jan Kara <jack@suse.cz>

We used to just write changed page for IS_DIRSYNC inodes.  But we also
have to update the directory inode itself just for the case that we've
allocated a new block and changed i_size.

Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/ext2/dir.c~ext2-update-also-inode-on-disk-when-dir-is-is_dirsync fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-update-also-inode-on-disk-when-dir-is-is_dirsync
+++ a/fs/ext2/dir.c
@@ -94,11 +94,10 @@ static int ext2_commit_chunk(struct page
 		i_size_write(dir, pos+len);
 		mark_inode_dirty(dir);
 	}
+	unlock_page(page);
 
 	if (IS_DIRSYNC(dir))
-		err = write_one_page(page, 1);
-	else
-		unlock_page(page);
+		err = ext2_sync_inode(dir);
 
 	return err;
 }
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch

