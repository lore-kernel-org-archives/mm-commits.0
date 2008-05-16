From: akpm@linux-foundation.org
Subject: - jbd-need-to-hold-j_state_lock-to-updates-to-transaction-t_state-to-t_commit.patch removed from -mm tree
Date: Fri, 16 May 2008 15:52:56 -0700
Message-ID: <200805162252.m4GMqujQ003099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024AbYEPWxR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:53:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmm@us.ibm.com, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     jbd: need to hold j_state_lock to updates to transaction t_state to T_COMMIT
has been removed from the -mm tree.  Its filename was
     jbd-need-to-hold-j_state_lock-to-updates-to-transaction-t_state-to-t_commit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: need to hold j_state_lock to updates to transaction t_state to T_COMMIT
From: Mingming Cao <cmm@us.ibm.com>

Updating the current transaction's t_state is protected by j_state_lock.  We
need to do the same when updating the t_state to T_COMMIT.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Acked-by: Jan Kara <jack@ucw.cz>
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

origin.patch
linux-next.patch

