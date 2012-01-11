From: akpm@linux-foundation.org
Subject: [merged] reiserfs-delete-comments-refering-to-the-bkl.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:51 -0800
Message-ID: <20120111213251.8893B1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61363 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab2AKVcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:52 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134903ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@gnu.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: reiserfs: delete comments referring to the BKL
has been removed from the -mm tree.  Its filename was
     reiserfs-delete-comments-refering-to-the-bkl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Davidlohr Bueso <dave@gnu.org>
Subject: reiserfs: delete comments referring to the BKL

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN fs/reiserfs/journal.c~reiserfs-delete-comments-refering-to-the-bkl fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-delete-comments-refering-to-the-bkl
+++ a/fs/reiserfs/journal.c
@@ -2896,14 +2896,13 @@ int journal_transaction_should_end(struc
 	    journal->j_cnode_free < (journal->j_trans_max * 3)) {
 		return 1;
 	}
-	/* protected by the BKL here */
+
 	journal->j_len_alloc += new_alloc;
 	th->t_blocks_allocated += new_alloc ;
 	return 0;
 }
 
-/* this must be called inside a transaction, and requires the
-** kernel_lock to be held
+/* this must be called inside a transaction
 */
 void reiserfs_block_writes(struct reiserfs_transaction_handle *th)
 {
@@ -2914,8 +2913,7 @@ void reiserfs_block_writes(struct reiser
 	return;
 }
 
-/* this must be called without a transaction started, and does not
-** require BKL
+/* this must be called without a transaction started
 */
 void reiserfs_allow_writes(struct super_block *s)
 {
@@ -2924,8 +2922,7 @@ void reiserfs_allow_writes(struct super_
 	wake_up(&journal->j_join_wait);
 }
 
-/* this must be called without a transaction started, and does not
-** require BKL
+/* this must be called without a transaction started
 */
 void reiserfs_wait_on_write_block(struct super_block *s)
 {
_

Patches currently in -mm which might be from dave@gnu.org are

origin.patch
linux-next.patch
ipc-mqueue-simplify-reading-msgqueue-limit.patch

