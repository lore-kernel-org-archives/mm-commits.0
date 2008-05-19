From: akpm@linux-foundation.org
Subject: + ext3-call-blkdev_issue_flush-on-fsync.patch added to -mm tree
Date: Mon, 19 May 2008 16:46:21 -0700
Message-ID: <200805192346.m4JNkL5X027423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758115AbYESXq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 19:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com


The patch titled
     ext3: call blkdev_issue_flush on fsync
has been added to the -mm tree.  Its filename is
     ext3-call-blkdev_issue_flush-on-fsync.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: call blkdev_issue_flush on fsync
From: Eric Sandeen <sandeen@redhat.com>

To ensure that bits are truly on-disk after an fsync, ext3 should call
blkdev_issue_flush if barriers are supported.

Inspired by an old thread on barriers, by reiserfs & xfs which do the
same, and by a patch SuSE ships with their kernel.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/fsync.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ext3/fsync.c~ext3-call-blkdev_issue_flush-on-fsync fs/ext3/fsync.c
--- a/fs/ext3/fsync.c~ext3-call-blkdev_issue_flush-on-fsync
+++ a/fs/ext3/fsync.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/writeback.h>
 #include <linux/jbd.h>
+#include <linux/blkdev.h>
 #include <linux/ext3_fs.h>
 #include <linux/ext3_jbd.h>
 
@@ -45,6 +46,7 @@
 int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
+	journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
 	int ret = 0;
 
 	J_ASSERT(ext3_journal_current_handle() == NULL);
@@ -85,6 +87,9 @@ int ext3_sync_file(struct file * file, s
 			.nr_to_write = 0, /* sys_fsync did this */
 		};
 		ret = sync_inode(inode, &wbc);
+
+		if (journal && (journal->j_flags & JFS_BARRIER))
+			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	}
 out:
 	return ret;
_

Patches currently in -mm which might be from sandeen@redhat.com are

find-dynamic-stack-allocations-in-checkstackpl.patch
fix-checkstackpl-arch-detection.patch
ext3-call-blkdev_issue_flush-on-fsync.patch

