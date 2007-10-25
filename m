From: akpm@linux-foundation.org
Subject: + ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch added to -mm tree
Date: Thu, 25 Oct 2007 14:38:54 -0700
Message-ID: <200710252138.l9PLcsbV025293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752644AbXJYVjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 17:39:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com


The patch titled
     ext4: Fix oops with jbd-stats-through-procfs and external journal
has been added to the -mm tree.  Its filename is
     ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ext2-change-the-default-behaviour-on-error.patch
ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch
ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch
ext3-change-the-default-behaviour-on-error.patch
