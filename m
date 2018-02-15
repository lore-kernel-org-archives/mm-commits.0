From: akpm@linux-foundation.org
Subject: + ipc-msg-introduce-msgctlmsg_stat_any.patch added to -mm tree
Date: Thu, 15 Feb 2018 14:50:48 -0800
Message-ID: <5a860ec8.is7aDScq1Q8VB0UL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756462AbeBOWuu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Feb 2018 17:50:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, ebiederm@xmission.com, keescook@chromium.org, manfred@colorfullife.com, mhocko@kernel.org, mtk.manpages@gmail.com, robert.kettler@outlook.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: introduce msgctl(MSG_STAT_ANY)
has been added to the -mm tree.  Its filename is
     ipc-msg-introduce-msgctlmsg_stat_any.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-msg-introduce-msgctlmsg_stat_any.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-msg-introduce-msgctlmsg_stat_any.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/msg: introduce msgctl(MSG_STAT_ANY)

There is a permission discrepancy when consulting msq ipc object metadata
between /proc/sysvipc/msg (0444) and the MSG_STAT shmctl command.  The
later does permission checks for the object vs S_IRUGO.  As such there can
be cases where EACCESS is returned via syscall but the info is displayed
anyways in the procfs files.

While this might have security implications via info leaking (albeit no
writing to the msq metadata), this behavior goes way back and showing all
the objects regardless of the permissions was most likely an overlook - so
we are stuck with it.  Furthermore, modifying either the syscall or the
procfs file can cause userspace programs to break (ie ipcs).  Some
applications require getting the procfs info (without root privileges) and
can be rather slow in comparison with a syscall -- up to 500x in some
reported cases for shm.

This patch introduces a new MSG_STAT_ANY command such that the msq ipc
object permissions are ignored, and only audited instead.  In addition,
I've left the lsm security hook checks in place, as if some policy can
block the call, then the user has no other choice than just parsing the
procfs file.

Link: http://lkml.kernel.org/r/20180215162458.10059-4-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reported-by: Robert Kettler <robert.kettler@outlook.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/msg.h   |    1 +
 ipc/msg.c                  |   17 ++++++++++++-----
 security/selinux/hooks.c   |    1 +
 security/smack/smack_lsm.c |    1 +
 4 files changed, 15 insertions(+), 5 deletions(-)

diff -puN include/uapi/linux/msg.h~ipc-msg-introduce-msgctlmsg_stat_any include/uapi/linux/msg.h
--- a/include/uapi/linux/msg.h~ipc-msg-introduce-msgctlmsg_stat_any
+++ a/include/uapi/linux/msg.h
@@ -7,6 +7,7 @@
 /* ipcs ctl commands */
 #define MSG_STAT 11
 #define MSG_INFO 12
+#define MSG_STAT_ANY 13
 
 /* msgrcv options */
 #define MSG_NOERROR     010000  /* no error if message is too big */
diff -puN ipc/msg.c~ipc-msg-introduce-msgctlmsg_stat_any ipc/msg.c
--- a/ipc/msg.c~ipc-msg-introduce-msgctlmsg_stat_any
+++ a/ipc/msg.c
@@ -483,14 +483,14 @@ static int msgctl_stat(struct ipc_namesp
 	memset(p, 0, sizeof(*p));
 
 	rcu_read_lock();
-	if (cmd == MSG_STAT) {
+	if (cmd == MSG_STAT || cmd == MSG_STAT_ANY) {
 		msq = msq_obtain_object(ns, msqid);
 		if (IS_ERR(msq)) {
 			err = PTR_ERR(msq);
 			goto out_unlock;
 		}
 		id = msq->q_perm.id;
-	} else {
+	} else { /* IPC_STAT */
 		msq = msq_obtain_object_check(ns, msqid);
 		if (IS_ERR(msq)) {
 			err = PTR_ERR(msq);
@@ -498,9 +498,14 @@ static int msgctl_stat(struct ipc_namesp
 		}
 	}
 
-	err = -EACCES;
-	if (ipcperms(ns, &msq->q_perm, S_IRUGO))
-		goto out_unlock;
+	/* see comment for SHM_STAT_ANY */
+	if (cmd == MSG_STAT_ANY)
+		audit_ipc_obj(&msq->q_perm);
+	else {
+		err = -EACCES;
+		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
+			goto out_unlock;
+	}
 
 	err = security_msg_queue_msgctl(msq, cmd);
 	if (err)
@@ -558,6 +563,7 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int,
 		return err;
 	}
 	case MSG_STAT:	/* msqid is an index rather than a msg queue id */
+	case MSG_STAT_ANY:
 	case IPC_STAT:
 		err = msgctl_stat(ns, msqid, cmd, &msqid64);
 		if (err < 0)
@@ -671,6 +677,7 @@ COMPAT_SYSCALL_DEFINE3(msgctl, int, msqi
 	}
 	case IPC_STAT:
 	case MSG_STAT:
+	case MSG_STAT_ANY:
 		err = msgctl_stat(ns, msqid, cmd, &msqid64);
 		if (err < 0)
 			return err;
diff -puN security/selinux/hooks.c~ipc-msg-introduce-msgctlmsg_stat_any security/selinux/hooks.c
--- a/security/selinux/hooks.c~ipc-msg-introduce-msgctlmsg_stat_any
+++ a/security/selinux/hooks.c
@@ -5591,6 +5591,7 @@ static int selinux_msg_queue_msgctl(stru
 				    SECCLASS_SYSTEM, SYSTEM__IPC_INFO, NULL);
 	case IPC_STAT:
 	case MSG_STAT:
+	case MSG_STAT_ANY:
 		perms = MSGQ__GETATTR | MSGQ__ASSOCIATE;
 		break;
 	case IPC_SET:
diff -puN security/smack/smack_lsm.c~ipc-msg-introduce-msgctlmsg_stat_any security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~ipc-msg-introduce-msgctlmsg_stat_any
+++ a/security/smack/smack_lsm.c
@@ -3296,6 +3296,7 @@ static int smack_msg_queue_msgctl(struct
 	switch (cmd) {
 	case IPC_STAT:
 	case MSG_STAT:
+	case MSG_STAT_ANY:
 		may = MAY_READ;
 		break;
 	case IPC_SET:
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-shm-introduce-shmctlshm_stat_any.patch
ipc-sem-introduce-semctlsem_stat_any.patch
ipc-msg-introduce-msgctlmsg_stat_any.patch

