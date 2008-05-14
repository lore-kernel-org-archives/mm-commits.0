From: akpm@linux-foundation.org
Subject: - jbd2-need-to-hold-j_state_lock-during-updates-to-transaction-t_state.patch removed from -mm tree
Date: Wed, 14 May 2008 14:22:28 -0700
Message-ID: <200805142122.m4ELMS3D021604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbYENV2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 17:28:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmm@us.ibm.com, jack@ucw.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     jbd2: need to hold j_state_lock during updates to transaction t_state
has been removed from the -mm tree.  Its filename was
     jbd2-need-to-hold-j_state_lock-during-updates-to-transaction-t_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd2: need to hold j_state_lock during updates to transaction t_state
From: Mingming Cao <cmm@us.ibm.com>

Updating the current transaction's t_state is protected by j_state_lock.  We
need to do the same when updating t_state to T_COMMIT.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/commit.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/jbd2/commit.c~jbd2-need-to-hold-j_state_lock-during-updates-to-transaction-t_state fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~jbd2-need-to-hold-j_state_lock-during-updates-to-transaction-t_state
+++ a/fs/jbd2/commit.c
@@ -563,7 +563,9 @@ void jbd2_journal_commit_transaction(jou
 	 * transaction!  Now comes the tricky part: we need to write out
 	 * metadata.  Loop over the transaction's entire buffer list:
 	 */
+	spin_lock(&journal->j_state_lock);
 	commit_transaction->t_state = T_COMMIT;
+	spin_unlock(&journal->j_state_lock);
 
 	stats.u.run.rs_logging = jiffies;
 	stats.u.run.rs_flushing = jbd2_time_diff(stats.u.run.rs_flushing,
_

Patches currently in -mm which might be from cmm@us.ibm.com are

jbd-need-to-hold-j_state_lock-to-updates-to-transaction-t_state-to-t_commit.patch

