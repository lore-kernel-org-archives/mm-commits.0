From: akpm@linux-foundation.org
Subject: [alternative-merged]
 jbd-jbd2-use-non-movable-memory-for-the-jbd-superblock.patch removed from
 -mm tree
Date: Fri, 05 Sep 2014 12:12:51 -0700
Message-ID: <540a0b33.Xc8huCParE5N3CxD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaIETMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 15:12:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gioh.kim@lge.com, adilger.kernel@dilger.ca, gunho.lee@lge.com, jack@suse.cz, js1304@gmail.com, minchan@kernel.org, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: jbd/jbd2: use non-movable memory for the jbd superblock
has been removed from the -mm tree.  Its filename was
     jbd-jbd2-use-non-movable-memory-for-the-jbd-superblock.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Gioh Kim <gioh.kim@lge.com>
Subject: jbd/jbd2: use non-movable memory for the jbd superblock

A long-lasting buffer-cache can distrub page migration so that it must be
allocated from non-movable area.

The journal_init_inode is creating a buffer-cache for superblock
journaling.  The superblock exists until system shutdown so that the
buffer-cache for the superblock would also exist for a long time and it
can distrub page migration.

This patch make the buffer-cache be allocated from non-movable area not to
distrub page migration.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Gunho Lee <gunho.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/jbd/journal.c~jbd-jbd2-use-non-movable-memory-for-the-jbd-superblock fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-jbd2-use-non-movable-memory-for-the-jbd-superblock
+++ a/fs/jbd/journal.c
@@ -886,7 +886,7 @@ journal_t * journal_init_inode (struct i
 		goto out_err;
 	}
 
-	bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+	bh = getblk_unmovable(journal->j_dev, blocknr, journal->j_blocksize);
 	if (!bh) {
 		printk(KERN_ERR
 		       "%s: Cannot get buffer for journal superblock\n",
diff -puN fs/jbd2/journal.c~jbd-jbd2-use-non-movable-memory-for-the-jbd-superblock fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd-jbd2-use-non-movable-memory-for-the-jbd-superblock
+++ a/fs/jbd2/journal.c
@@ -1237,7 +1237,7 @@ journal_t * jbd2_journal_init_inode (str
 		goto out_err;
 	}
 
-	bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+	bh = getblk_unmovable(journal->j_dev, blocknr, journal->j_blocksize);
 	if (!bh) {
 		printk(KERN_ERR
 		       "%s: Cannot get buffer for journal superblock\n",
_

Patches currently in -mm which might be from gioh.kim@lge.com are

linux-next.patch

