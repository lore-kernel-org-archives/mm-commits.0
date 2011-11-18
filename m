From: akpm@linux-foundation.org
Subject: + reiserfs-delete-comments-refering-to-the-bkl.patch added to -mm tree
Date: Thu, 17 Nov 2011 16:08:53 -0800
Message-ID: <201111180008.pAI08rH8021401@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:37621 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab1KRAI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 19:08:56 -0500
Received: by wwe5 with SMTP id 5so55679wwe.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 16:08:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@gnu.org


The patch titled
     Subject: reiserfs: delete comments refering to the BKL
has been added to the -mm tree.  Its filename is
     reiserfs-delete-comments-refering-to-the-bkl.patch

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
From: Davidlohr Bueso <dave@gnu.org>
Subject: reiserfs: delete comments refering to the BKL

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
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
Subject: Subject: reiserfs: delete comments refering to the BKL

Patches currently in -mm which might be from dave@gnu.org are

reiserfs-delete-comments-refering-to-the-bkl.patch

