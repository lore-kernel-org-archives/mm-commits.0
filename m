From: akpm@linux-foundation.org
Subject: - reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:00:45 -0700
Message-ID: <200710180700.l9I70jsl031110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57661 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932205AbXJRHiB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:38:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ytht.net@gmail.com, chris.mason@oracle.com, jeffm@suse.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: workaround for dead loop in finish_unfinished
has been removed from the -mm tree.  Its filename was
     reiserfs-workaround-for-dead-loop-in-finish_unfinished.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: workaround for dead loop in finish_unfinished
From: Lepton Wu <ytht.net@gmail.com>

There is possible dead loop in finish_unfinished function.

In most situation, the call chain iput -> ...  -> reiserfs_delete_inode ->
remove_save_link will success.  But for some reason such as data
corruption, reiserfs_delete_inode fails on reiserfs_do_truncate ->
search_for_position_by_key.

Then remove_save_link won't be called.  We always get the same
"save_link_key" in the while loop in finish_unfinished function.  The
following patch adds a check for the possible dead loop and just remove
save link when deap loop.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Lepton Wu <ytht.net@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN fs/reiserfs/super.c~reiserfs-workaround-for-dead-loop-in-finish_unfinished fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-workaround-for-dead-loop-in-finish_unfinished
+++ a/fs/reiserfs/super.c
@@ -145,7 +145,7 @@ static int finish_unfinished(struct supe
 {
 	INITIALIZE_PATH(path);
 	struct cpu_key max_cpu_key, obj_key;
-	struct reiserfs_key save_link_key;
+	struct reiserfs_key save_link_key, last_inode_key;
 	int retval = 0;
 	struct item_head *ih;
 	struct buffer_head *bh;
@@ -166,6 +166,8 @@ static int finish_unfinished(struct supe
 	set_cpu_key_k_offset(&max_cpu_key, ~0U);
 	max_cpu_key.key_length = 3;
 
+	memset(&last_inode_key, 0, sizeof(last_inode_key));
+
 #ifdef CONFIG_QUOTA
 	/* Needed for iput() to work correctly and not trash data */
 	if (s->s_flags & MS_ACTIVE) {
@@ -278,8 +280,18 @@ static int finish_unfinished(struct supe
 			REISERFS_I(inode)->i_flags |= i_link_saved_unlink_mask;
 			/* not completed unlink (rmdir) found */
 			reiserfs_info(s, "Removing %k..", INODE_PKEY(inode));
-			/* removal gets completed in iput */
-			retval = 0;
+			if (memcmp(&last_inode_key, INODE_PKEY(inode),
+					sizeof(last_inode_key))){
+				last_inode_key = *INODE_PKEY(inode);
+				/* removal gets completed in iput */
+				retval = 0;
+			} else {
+				reiserfs_warning(s, "Dead loop in "
+						"finish_unfinished detected, "
+						"just remove save link\n");
+				retval = remove_save_link_only(s,
+							&save_link_key, 0);
+			}
 		}
 
 		iput(inode);
_

Patches currently in -mm which might be from ytht.net@gmail.com are

origin.patch
