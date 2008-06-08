From: akpm@linux-foundation.org
Subject: - ipc-only-output-msgmni-value-at-boot-time.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:40 -0700
Message-ID: <200806081948.m58JmenF017525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488AbYFHTtT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:49:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, manfred@colorfullife.com, peifferp@gmail.com, serue@us.ibm.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ipc: only output msgmni value at boot time
has been removed from the -mm tree.  Its filename was
     ipc-only-output-msgmni-value-at-boot-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: only output msgmni value at boot time
From: Nadia Derbey <Nadia.Derbey@bull.net>

When posting:
[PATCH 1/8] Scaling msgmni to the amount of lowmem
(see http://lkml.org/lkml/2008/2/11/171), I have added a KERN_INFO message
that is output each time msgmni is recomputed.

In http://lkml.org/lkml/2008/4/29/575 Tony Luck complained that this
message references an ipc namespace address that is useless.

I first thought of using an audit_log instead of a printk, as suggested by
Serge Hallyn.  But unfortunately, we do not have any other information
than the namespace address to provide here too.  So I chose to move the
message and output it only at boot time, removing the reference to the
namespace.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN ipc/msg.c~ipc-only-output-msgmni-value-at-boot-time ipc/msg.c
--- a/ipc/msg.c~ipc-only-output-msgmni-value-at-boot-time
+++ a/ipc/msg.c
@@ -98,20 +98,15 @@ void recompute_msgmni(struct ipc_namespa
 
 	if (allowed < MSGMNI) {
 		ns->msg_ctlmni = MSGMNI;
-		goto out_callback;
+		return;
 	}
 
 	if (allowed > IPCMNI / nb_ns) {
 		ns->msg_ctlmni = IPCMNI / nb_ns;
-		goto out_callback;
+		return;
 	}
 
 	ns->msg_ctlmni = allowed;
-
-out_callback:
-
-	printk(KERN_INFO "msgmni has been set to %d for ipc namespace %p\n",
-		ns->msg_ctlmni, ns);
 }
 
 void msg_init_ns(struct ipc_namespace *ns)
@@ -136,6 +131,10 @@ void msg_exit_ns(struct ipc_namespace *n
 void __init msg_init(void)
 {
 	msg_init_ns(&init_ipc_ns);
+
+	printk(KERN_INFO "msgmni has been set to %d\n",
+		init_ipc_ns.msg_ctlmni);
+
 	ipc_init_proc_interface("sysvipc/msg",
 				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
 				IPC_MSG_IDS, sysvipc_msg_proc_show);
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_get_new-rcu-safe-fix.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch
ipc-semc-convert-undo-structures-to-struct-list_head.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-remove-unused-entries-from-struct-sem_queue.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
ipc-use-simple_read_from_buffer.patch

