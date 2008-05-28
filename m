From: akpm@linux-foundation.org
Subject: + ipc-only-output-msgmni-value-at-boot-time.patch added to -mm tree
Date: Wed, 28 May 2008 16:15:56 -0700
Message-ID: <200805282315.m4SNFuEu005338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494AbYE1X1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 19:27:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, manfred@colorfullife.com, peifferp@gmail.com, serue@us.ibm.com, tony.luck@intel.com


The patch titled
     ipc: only output msgmni value at boot time
has been added to the -mm tree.  Its filename is
     ipc-only-output-msgmni-value-at-boot-time.patch

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

ipc-restore-msgpool-original-value.patch
ipc-only-output-msgmni-value-at-boot-time.patch
idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch

