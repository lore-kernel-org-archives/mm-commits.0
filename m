From: akpm@linux-foundation.org
Subject: + reiserfs-truncate-blocks-not-used-by-a-write-v2-fix.patch added to -mm tree
Date: Wed, 16 Dec 2009 13:17:59 -0800
Message-ID: <200912162117.nBGLHxZM015471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757605AbZLPVSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 16:18:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, jeffm@suse.com


The patch titled
     reiserfs-truncate-blocks-not-used-by-a-write-v2-fix
has been added to the -mm tree.  Its filename is
     reiserfs-truncate-blocks-not-used-by-a-write-v2-fix.patch

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
Subject: reiserfs-truncate-blocks-not-used-by-a-write-v2-fix
From: Jan Kara <jack@suse.cz>

  Andrew, this patch should have been replaced by the one below - this
version causes data corruption when using writev() (same problem as ext3 &
ext4 had)... I've sent you a new version on 2009-12-02 but apparently you
didn't see it.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/reiserfs/inode.c~reiserfs-truncate-blocks-not-used-by-a-write-v2-fix fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-truncate-blocks-not-used-by-a-write-v2-fix
+++ a/fs/reiserfs/inode.c
@@ -2538,6 +2538,12 @@ static int reiserfs_writepage(struct pag
 	return reiserfs_write_full_page(page, wbc);
 }
 
+static void reiserfs_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	reiserfs_truncate_file(inode, 0);
+}
+
 static int reiserfs_write_begin(struct file *file,
 				struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
@@ -2605,7 +2611,7 @@ static int reiserfs_write_begin(struct f
 		unlock_page(page);
 		page_cache_release(page);
 		/* Truncate allocated blocks */
-		reiserfs_truncate_file(inode, 0);
+		reiserfs_truncate_failed_write(inode);
 	}
 	return ret;
 }
@@ -2753,7 +2759,7 @@ static int reiserfs_write_end(struct fil
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		reiserfs_truncate_file(inode, 0);
+		reiserfs_truncate_failed_write(inode);
 
 	return ret == 0 ? copied : ret;
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
reiserfs-truncate-blocks-not-used-by-a-write-v2.patch
reiserfs-truncate-blocks-not-used-by-a-write-v2-fix.patch
linux-next.patch
reiser4-update-names-of-quota-methods.patch

