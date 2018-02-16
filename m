From: akpm@linux-foundation.org
Subject: + ipc-sem-introduce-semctlsem_stat_any.patch added to -mm tree
Date: Thu, 15 Feb 2018 16:24:36 -0800
Message-ID: <5a8624c4.ixDuP6ZKShWoPI7E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43978 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752900AbeBPAYi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Feb 2018 19:24:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, ebiederm@xmission.com, keescook@chromium.org, manfred@colorfullife.com, mhocko@kernel.org, mtk.manpages@gmail.com, robert.kettler@outlook.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: introduce semctl(SEM_STAT_ANY)
has been added to the -mm tree.  Its filename is
     ipc-sem-introduce-semctlsem_stat_any.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-introduce-semctlsem_stat_any.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-introduce-semctlsem_stat_any.patch

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
Subject: ipc/sem: introduce semctl(SEM_STAT_ANY)

There is a permission discrepancy when consulting shm ipc object metadata
between /proc/sysvipc/sem (0444) and the SEM_STAT semctl command.  The
later does permission checks for the object vs S_IRUGO.  As such there can
be cases where EACCESS is returned via syscall but the info is displayed
anyways in the procfs files.

While this might have security implications via info leaking (albeit no
writing to the sma metadata), this behavior goes way back and showing all
the objects regardless of the permissions was most likely an overlook - so
we are stuck with it.  Furthermore, modifying either the syscall or the
procfs file can cause userspace programs to break (ie ipcs).  Some
applications require getting the procfs info (without root privileges) and
can be rather slow in comparison with a syscall -- up to 500x in some
reported cases for shm.

This patch introduces a new SEM_STAT_ANY command such that the sem ipc
object permissions are ignored, and only audited instead.  In addition,
I've left the lsm security hook checks in place, as if some policy can
block the call, then the user has no other choice than just parsing the
procfs file.

Link: http://lkml.kernel.org/r/20180215162458.10059-3-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reported-by: Robert Kettler <robert.kettler@outlook.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/sem.h   |    1 +
 ipc/sem.c                  |   17 ++++++++++++-----
 security/selinux/hooks.c   |    1 +
 security/smack/smack_lsm.c |    1 +
 4 files changed, 15 insertions(+), 5 deletions(-)

diff -puN include/uapi/linux/sem.h~ipc-sem-introduce-semctlsem_stat_any include/uapi/linux/sem.h
--- a/include/uapi/linux/sem.h~ipc-sem-introduce-semctlsem_stat_any
+++ a/include/uapi/linux/sem.h
@@ -19,6 +19,7 @@
 /* ipcs ctl cmds */
 #define SEM_STAT 18
 #define SEM_INFO 19
+#define SEM_STAT_ANY 20
 
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct semid_ds {
diff -puN ipc/sem.c~ipc-sem-introduce-semctlsem_stat_any ipc/sem.c
--- a/ipc/sem.c~ipc-sem-introduce-semctlsem_stat_any
+++ a/ipc/sem.c
@@ -1190,14 +1190,14 @@ static int semctl_stat(struct ipc_namesp
 	memset(semid64, 0, sizeof(*semid64));
 
 	rcu_read_lock();
-	if (cmd == SEM_STAT) {
+	if (cmd == SEM_STAT || cmd == SEM_STAT_ANY) {
 		sma = sem_obtain_object(ns, semid);
 		if (IS_ERR(sma)) {
 			err = PTR_ERR(sma);
 			goto out_unlock;
 		}
 		id = sma->sem_perm.id;
-	} else {
+	} else { /* IPC_STAT */
 		sma = sem_obtain_object_check(ns, semid);
 		if (IS_ERR(sma)) {
 			err = PTR_ERR(sma);
@@ -1205,9 +1205,14 @@ static int semctl_stat(struct ipc_namesp
 		}
 	}
 
-	err = -EACCES;
-	if (ipcperms(ns, &sma->sem_perm, S_IRUGO))
-		goto out_unlock;
+	/* see comment for SHM_STAT_ANY */
+	if (cmd == SEM_STAT_ANY)
+		audit_ipc_obj(&sma->sem_perm);
+	else {
+		err = -EACCES;
+		if (ipcperms(ns, &sma->sem_perm, S_IRUGO))
+			goto out_unlock;
+	}
 
 	err = security_sem_semctl(sma, cmd);
 	if (err)
@@ -1596,6 +1601,7 @@ SYSCALL_DEFINE4(semctl, int, semid, int,
 		return semctl_info(ns, semid, cmd, p);
 	case IPC_STAT:
 	case SEM_STAT:
+	case SEM_STAT_ANY:
 		err = semctl_stat(ns, semid, cmd, &semid64);
 		if (err < 0)
 			return err;
@@ -1697,6 +1703,7 @@ COMPAT_SYSCALL_DEFINE4(semctl, int, semi
 		return semctl_info(ns, semid, cmd, p);
 	case IPC_STAT:
 	case SEM_STAT:
+	case SEM_STAT_ANY:
 		err = semctl_stat(ns, semid, cmd, &semid64);
 		if (err < 0)
 			return err;
diff -puN security/selinux/hooks.c~ipc-sem-introduce-semctlsem_stat_any security/selinux/hooks.c
--- a/security/selinux/hooks.c~ipc-sem-introduce-semctlsem_stat_any
+++ a/security/selinux/hooks.c
@@ -5847,6 +5847,7 @@ static int selinux_sem_semctl(struct sem
 		break;
 	case IPC_STAT:
 	case SEM_STAT:
+	case SEM_STAT_ANY:
 		perms = SEM__GETATTR | SEM__ASSOCIATE;
 		break;
 	default:
diff -puN security/smack/smack_lsm.c~ipc-sem-introduce-semctlsem_stat_any security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~ipc-sem-introduce-semctlsem_stat_any
+++ a/security/smack/smack_lsm.c
@@ -3167,6 +3167,7 @@ static int smack_sem_semctl(struct sem_a
 	case GETALL:
 	case IPC_STAT:
 	case SEM_STAT:
+	case SEM_STAT_ANY:
 		may = MAY_READ;
 		break;
 	case SETVAL:
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-shm-introduce-shmctlshm_stat_any.patch
ipc-sem-introduce-semctlsem_stat_any.patch
ipc-msg-introduce-msgctlmsg_stat_any.patch

