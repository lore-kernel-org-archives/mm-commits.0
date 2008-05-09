From: akpm@linux-foundation.org
Subject: + jbd-need-to-hold-j_state_lock-to-updates-to-transaction-t_state-to-t_commit.patch added to -mm tree
Date: Fri, 09 May 2008 15:48:31 -0700
Message-ID: <200805092248.m49MmVq9029566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741AbYEIWt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 18:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmm@us.ibm.com, jack@ucw.cz


The patch titled
     jbd: need to hold j_state_lock to updates to transaction t_state to T_COMMIT
has been added to the -mm tree.  Its filename is
     jbd-need-to-hold-j_state_lock-to-updates-to-transaction-t_state-to-t_commit.patch

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
Subject: jbd: need to hold j_state_lock to updates to transaction t_state to T_COMMIT
From: Mingming Cao <cmm@us.ibm.com>

Updating the current transaction's t_state is protected by j_state_lock.  We
need to do the same when updating the t_state to T_COMMIT.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/jbd/commit.c~jbd-need-to-hold-j_state_lock-to-updates-to-transaction-t_state-to-t_commit fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-need-to-hold-j_state_lock-to-updates-to-transaction-t_state-to-t_commit
+++ a/fs/jbd/commit.c
@@ -470,7 +470,9 @@ void journal_commit_transaction(journal_
 	 * transaction!  Now comes the tricky part: we need to write out
 	 * metadata.  Loop over the transaction's entire buffer list:
 	 */
+	spin_lock(&journal->j_state_lock);
 	commit_transaction->t_state = T_COMMIT;
+	spin_unlock(&journal->j_state_lock);
 
 	J_ASSERT(commit_transaction->t_nr_buffers <=
 		 commit_transaction->t_outstanding_credits);
_

Patches currently in -mm which might be from cmm@us.ibm.com are

jbd-need-to-hold-j_state_lock-to-updates-to-transaction-t_state-to-t_commit.patch
ext4-switch-to-seq_files.patch
jbd2-need-hold-j_state_lock-to-updates-to-transaction-t_state-to-t_commit.patch

