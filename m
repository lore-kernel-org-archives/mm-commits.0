From: akpm@linux-foundation.org
Subject: + ocfs2-remove-unecessary-variable-needs_checkpoint.patch added
 to -mm tree
Date: Mon, 10 Jun 2013 16:36:35 -0700
Message-ID: <51b66303.f+FtSJX3C1OIM+TN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3FJXgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 19:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, rgoldwyn@gmail.com

Subject: + ocfs2-remove-unecessary-variable-needs_checkpoint.patch added to -mm tree
To: rgoldwyn@gmail.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 16:36:35 -0700


The patch titled
     Subject: ocfs2: remove unecessary variable needs_checkpoint
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unecessary-variable-needs_checkpoint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Subject: ocfs2: remove unecessary variable needs_checkpoint

Code cleanup: needs_checkpoint is assigned to but never used.  Delete the
variable.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Jeff Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.h |    1 -
 fs/ocfs2/ocfs2.h   |    1 -
 fs/ocfs2/super.c   |    6 ++----
 3 files changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/journal.h~ocfs2-remove-unecessary-variable-needs_checkpoint fs/ocfs2/journal.h
--- a/fs/ocfs2/journal.h~ocfs2-remove-unecessary-variable-needs_checkpoint
+++ a/fs/ocfs2/journal.h
@@ -200,7 +200,6 @@ void ocfs2_complete_quota_recovery(struc
 
 static inline void ocfs2_start_checkpoint(struct ocfs2_super *osb)
 {
-	atomic_set(&osb->needs_checkpoint, 1);
 	wake_up(&osb->checkpoint_event);
 }
 
diff -puN fs/ocfs2/ocfs2.h~ocfs2-remove-unecessary-variable-needs_checkpoint fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-remove-unecessary-variable-needs_checkpoint
+++ a/fs/ocfs2/ocfs2.h
@@ -347,7 +347,6 @@ struct ocfs2_super
 	struct task_struct *recovery_thread_task;
 	int disable_recovery;
 	wait_queue_head_t checkpoint_event;
-	atomic_t needs_checkpoint;
 	struct ocfs2_journal *journal;
 	unsigned long osb_commit_interval;
 
diff -puN fs/ocfs2/super.c~ocfs2-remove-unecessary-variable-needs_checkpoint fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-remove-unecessary-variable-needs_checkpoint
+++ a/fs/ocfs2/super.c
@@ -286,10 +286,9 @@ static int ocfs2_osb_dump(struct ocfs2_s
 	spin_unlock(&osb->osb_lock);
 
 	out += snprintf(buf + out, len - out,
-			"%10s => Pid: %d  Interval: %lu  Needs: %d\n", "Commit",
+			"%10s => Pid: %d  Interval: %lu\n", "Commit",
 			(osb->commit_task ? task_pid_nr(osb->commit_task) : -1),
-			osb->osb_commit_interval,
-			atomic_read(&osb->needs_checkpoint));
+			osb->osb_commit_interval);
 
 	out += snprintf(buf + out, len - out,
 			"%10s => State: %d  TxnId: %lu  NumTxns: %d\n",
@@ -2154,7 +2153,6 @@ static int ocfs2_initialize_super(struct
 	}
 
 	init_waitqueue_head(&osb->checkpoint_event);
-	atomic_set(&osb->needs_checkpoint, 0);
 
 	osb->s_atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
 
_

Patches currently in -mm which might be from rgoldwyn@gmail.com are

fs-ocfs2-nameic-remove-unecessary-error-when-removing-non-empty-directory.patch
ocfs2-remove-unecessary-variable-needs_checkpoint.patch

