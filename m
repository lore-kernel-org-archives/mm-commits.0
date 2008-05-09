From: akpm@linux-foundation.org
Subject: + jbd2-need-to-hold-j_state_lock-during-updates-to-transaction-t_state.patch added to -mm tree
Date: Fri, 09 May 2008 15:49:37 -0700
Message-ID: <200805092249.m49MnboH029581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbYEIWuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 18:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmm@us.ibm.com, jack@ucw.cz, tytso@mit.edu


The patch titled
     jbd2: need to hold j_state_lock during updates to transaction t_state
has been added to the -mm tree.  Its filename is
     jbd2-need-to-hold-j_state_lock-during-updates-to-transaction-t_state.patch

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
ext4-switch-to-seq_files.patch
jbd2-need-to-hold-j_state_lock-during-updates-to-transaction-t_state.patch

