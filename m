From: akpm@linux-foundation.org
Subject: + reiserfs-properly-honor-read-only-devices.patch added to -mm tree
Date: Mon, 22 Mar 2010 14:28:52 -0700
Message-ID: <201003222128.o2MLSqQe028567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552Ab0CVV3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 17:29:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com


The patch titled
     reiserfs: properly honor read-only devices
has been added to the -mm tree.  Its filename is
     reiserfs-properly-honor-read-only-devices.patch

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
Subject: reiserfs: properly honor read-only devices
From: Jeff Mahoney <jeffm@suse.com>

The reiserfs journal behaves inconsistently when determining whether to
allow a mount of a read-only device.

This is due to the use of the continue_replay variable to short circuit
the journal scanning.  If it's set, it's assumed that there are
transactions to replay, but there may not be.  If it's unset, it's assumed
that there aren't any, and that may not be the case either.

I've observed two failure cases:
1) Where a clean file system on a read-only device refuses to mount
2) Where a clean file system on a read-only device passes the
   optimization and then tries writing the journal header to update
   the latest mount id.

The former is easily observable by using a freshly created file system on
a read-only loopback device.

This patch moves the check into journal_read_transaction, where it can
bail out before it's about to replay a transaction.  That way it can go
through and skip transactions where appropriate, yet still refuse to mount
a file system with outstanding transactions.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/reiserfs/journal.c~reiserfs-properly-honor-read-only-devices fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-properly-honor-read-only-devices
+++ a/fs/reiserfs/journal.c
@@ -2217,6 +2217,15 @@ static int journal_read_transaction(stru
 		brelse(d_bh);
 		return 1;
 	}
+
+	if (bdev_read_only(sb->s_bdev)) {
+		reiserfs_warning(sb, "clm-2076",
+				 "device is readonly, unable to replay log");
+		brelse(c_bh);
+		brelse(d_bh);
+		return -EROFS;
+	}
+
 	trans_id = get_desc_trans_id(desc);
 	/* now we know we've got a good transaction, and it was inside the valid time ranges */
 	log_blocks = kmalloc(get_desc_trans_len(desc) *
@@ -2459,12 +2468,6 @@ static int journal_read(struct super_blo
 		goto start_log_replay;
 	}
 
-	if (continue_replay && bdev_read_only(sb->s_bdev)) {
-		reiserfs_warning(sb, "clm-2076",
-				 "device is readonly, unable to replay log");
-		return -1;
-	}
