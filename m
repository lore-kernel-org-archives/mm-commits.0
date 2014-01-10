From: akpm@linux-foundation.org
Subject: + ipcmsg-document-barriers.patch added to -mm tree
Date: Fri, 10 Jan 2014 15:19:36 -0800
Message-ID: <52d08008.Xzy0g46qzu8Y8iXH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaAJXTh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 18:19:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: + ipcmsg-document-barriers.patch added to -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 15:19:36 -0800


The patch titled
     Subject: ipc,msg: document barriers
has been added to the -mm tree.  Its filename is
     ipcmsg-document-barriers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcmsg-document-barriers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcmsg-document-barriers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc,msg: document barriers

Both expunge_all() and pipeline_send() rely on both a nil msg value and a
full barrier to guarantee the correct ordering when waking up a task. 
While its counter part at the receiving end is well documented for the
lockless recv algorithm, we still need to document these specific smp_mb()
calls.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN ipc/msg.c~ipcmsg-document-barriers ipc/msg.c
--- a/ipc/msg.c~ipcmsg-document-barriers
+++ a/ipc/msg.c
@@ -253,8 +253,14 @@ static void expunge_all(struct msg_queue
 	struct msg_receiver *msr, *t;
 
 	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
-		msr->r_msg = NULL;
+		msr->r_msg = NULL; /* initialize expunge ordering */
 		wake_up_process(msr->r_tsk);
+		/*
+		 * Ensure that the wakeup is visible before setting r_msg as
+		 * the receiving end depends on it: either spinning on a nil,
+		 * or dealing with -EAGAIN cases. See lockless reveice part 1
+		 * and 2 in do_msgrcv().
+		 */
 		smp_mb();
 		msr->r_msg = ERR_PTR(res);
 	}
@@ -638,15 +644,22 @@ static inline int pipelined_send(struct
 
 			list_del(&msr->r_list);
 			if (msr->r_maxsize < msg->m_ts) {
+				/* initialize pipelined send ordering */
 				msr->r_msg = NULL;
 				wake_up_process(msr->r_tsk);
-				smp_mb();
+				smp_mb(); /* see barrier comment below */
 				msr->r_msg = ERR_PTR(-E2BIG);
 			} else {
 				msr->r_msg = NULL;
 				msq->q_lrpid = task_pid_vnr(msr->r_tsk);
 				msq->q_rtime = get_seconds();
 				wake_up_process(msr->r_tsk);
+				/*
+				 * Ensure that the wakeup is visible before
+				 * setting r_msg, as the receiving end depends
+				 * on it. See lockless reveice part 1 and 2 in
+				 * do_msgrcv().
+				 */
 				smp_mb();
 				msr->r_msg = msg;
 
@@ -654,6 +667,7 @@ static inline int pipelined_send(struct
 			}
 		}
 	}
+
 	return 0;
 }
 
@@ -716,6 +730,7 @@ long do_msgsnd(int msqid, long mtype, vo
 			goto out_unlock0;
 		}
 
+		/* enqueue the sender and prepare to block */
 		ss_add(msq, &s);
 
 		if (!ipc_rcu_getref(msq)) {
_

Patches currently in -mm which might be from davidlohr@hp.com are

x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-mmapc-add-mlock_future_check-helper.patch
mm-mlock-prepare-params-outside-critical-region.patch
partitions-efi-complete-documentation-of-gpt-kernel-param-purpose.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2.patch
ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races.patch
ipc-change-kern_ipc_permdeleted-type-to-bool.patch
ipc-whitespace-cleanup.patch
ipc-standardize-code-comments.patch
ipc-remove-braces-for-single-statements.patch
ipc-remove-useless-return-statement.patch
ipc-simplify-sysvipc_proc_open-return.patch
ipc-delete-seq_max-field-in-struct-ipc_ids.patch
ipc-share-ids-rwsem-when-possible-in-ipcget_public.patch
ipcmsg-document-barriers.patch

