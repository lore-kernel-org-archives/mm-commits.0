From: akpm@linux-foundation.org
Subject: - ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:38:57 -0800
Message-ID: <200712202338.lBKNcvFB019018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48022 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999AbXLTXqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:46:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ext4: Fix oops with jbd-stats-through-procfs and external journal
has been removed from the -mm tree.  Its filename was
     ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: Fix oops with jbd-stats-through-procfs and external journal
From: Eric Sandeen <sandeen@redhat.com>

When using an external device for the journal, jbd2_stats_proc_init() wants
to use journal->j_dev in its call to bdevname() but it's not assigned yet,
resulting in an oops.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jbd2/journal.c~ext4-fix-oops-with-jbd-stats-through-procfs-and-external fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~ext4-fix-oops-with-jbd-stats-through-procfs-and-external
+++ a/fs/jbd2/journal.c
@@ -1035,11 +1035,11 @@ journal_t * jbd2_journal_init_dev(struct
 		journal = NULL;
 		goto out;
 	}
-	jbd2_stats_proc_init(journal);
 	journal->j_dev = bdev;
 	journal->j_fs_dev = fs_dev;
 	journal->j_blk_offset = start;
 	journal->j_maxlen = len;
+	jbd2_stats_proc_init(journal);
 
 	bh = __getblk(journal->j_dev, start, journal->j_blocksize);
 	J_ASSERT(bh != NULL);
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
ecryptfs-fix-string-overflow-on-long-cipher-names.patch
ecryptfs-fix-unlocking-in-error-paths.patch
ecryptfs-redo-dgetmntget-on-dentry_open-failure.patch
hfs-handle-more-on-disk-corruptions-without-oopsing.patch
ext2-change-the-default-behaviour-on-error.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ext3-change-the-default-behaviour-on-error.patch
