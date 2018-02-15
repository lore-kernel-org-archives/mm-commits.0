From: akpm@linux-foundation.org
Subject: + ipc-shm-introduce-shmctlshm_stat_any.patch added to -mm tree
Date: Thu, 15 Feb 2018 14:50:44 -0800
Message-ID: <5a860ec4.X22+fpgP6U4G24a+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43376 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756461AbeBOWuq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Feb 2018 17:50:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, ebiederm@xmission.com, keescook@chromium.org, manfred@colorfullife.com, mhocko@kernel.org, mtk.manpages@gmail.com, robert.kettler@outlook.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: introduce shmctl(SHM_STAT_ANY)
has been added to the -mm tree.  Its filename is
     ipc-shm-introduce-shmctlshm_stat_any.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-shm-introduce-shmctlshm_stat_any.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-shm-introduce-shmctlshm_stat_any.patch

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
Subject: ipc/shm: introduce shmctl(SHM_STAT_ANY)

Patch series "sysvipc: introduce STAT_ANY commands", v2.

The following patches adds the discussed
(https://lkml.org/lkml/2017/12/19/220) new command for shm as well as for
sems and msq as they are subject to the same discrepancies for ipc object
permission checks between the syscall and via procfs.  These new commands
are justified in that (1) we are stuck with this semantics as changing
syscall and procfs can break userland; and (2) some users can benefit from
performance (for large amounts of shm segments, for example) from not
having to parse the procfs interface.

Once merged, I will submit the necesary manpage updates.  But I'm thinking
something like:

diff --git a/man2/shmctl.2 b/man2/shmctl.2
index 7bb503999941..bb00bbe21a57 100644
--- a/man2/shmctl.2
+++ b/man2/shmctl.2
@@ -41,6 +41,7 @@
 .\" 2005-04-25, mtk -- noted aberrant Linux behavior w.r.t. new
 .\"	attaches to a segment that has already been marked for deletion.
 .\" 2005-08-02, mtk: Added IPC_INFO, SHM_INFO, SHM_STAT descriptions.
+.\" 2018-02-13, dbueso: Added SHM_STAT_ANY description.
 .\"
 .TH SHMCTL 2 2017-09-15 "Linux" "Linux Programmer's Manual"
 .SH NAME
@@ -242,6 +243,18 @@ However, the
 argument is not a segment identifier, but instead an index into
 the kernel's internal array that maintains information about
 all shared memory segments on the system.
+.TP
+.BR SHM_STAT_ANY " (Linux-specific)"
+Return a
+.I shmid_ds
+structure as for
+.BR SHM_STAT .
+However, the
+.I shm_perm.mode
+is not checked for read access for
+.IR shmid ,
+resembing the behaviour of
+/proc/sysvipc/shm.
 .PP
 The caller can prevent or allow swapping of a shared
 memory segment with the following \fIcmd\fP values:
@@ -287,7 +300,7 @@ operation returns the index of the highest used entry in the
 kernel's internal array recording information about all
 shared memory segments.
 (This information can be used with repeated
-.B SHM_STAT
+.B SHM_STAT/SHM_STAT_ANY
 operations to obtain information about all shared memory segments
 on the system.)
 A successful
@@ -328,7 +341,7 @@ isn't accessible.
 \fIshmid\fP is not a valid identifier, or \fIcmd\fP
 is not a valid command.
 Or: for a
-.B SHM_STAT
+.B SHM_STAT/SHM_STAT_ANY
 operation, the index value specified in
 .I shmid
 referred to an array slot that is currently unused.



This patch (of 3):

There is a permission discrepancy when consulting shm ipc object metadata
between /proc/sysvipc/shm (0444) and the SHM_STAT shmctl command.  The
later does permission checks for the object vs S_IRUGO.  As such there can
be cases where EACCESS is returned via syscall but the info is displayed
anyways in the procfs files.

While this might have security implications via info leaking (albeit no
writing to the shm metadata), this behavior goes way back and showing all
the objects regardless of the permissions was most likely an overlook - so
we are stuck with it.  Furthermore, modifying either the syscall or the
procfs file can cause userspace programs to break (ie ipcs).  Some
applications require getting the procfs info (without root privileges) and
can be rather slow in comparison with a syscall -- up to 500x in some
reported cases.

This patch introduces a new SHM_STAT_ANY command such that the shm ipc
object permissions are ignored, and only audited instead.  In addition,
I've left the lsm security hook checks in place, as if some policy can
block the call, then the user has no other choice than just parsing the
procfs file.

Link: http://lkml.kernel.org/r/20180215162458.10059-2-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Robert Kettler <robert.kettler@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/shm.h   |    5 +++--
 ipc/shm.c                  |   23 ++++++++++++++++++-----
 security/selinux/hooks.c   |    1 +
 security/smack/smack_lsm.c |    1 +
 4 files changed, 23 insertions(+), 7 deletions(-)

diff -puN include/uapi/linux/shm.h~ipc-shm-introduce-shmctlshm_stat_any include/uapi/linux/shm.h
--- a/include/uapi/linux/shm.h~ipc-shm-introduce-shmctlshm_stat_any
+++ a/include/uapi/linux/shm.h
@@ -83,8 +83,9 @@ struct shmid_ds {
 #define SHM_UNLOCK 	12
 
 /* ipcs ctl commands */
-#define SHM_STAT 	13
-#define SHM_INFO 	14
+#define SHM_STAT	13
+#define SHM_INFO	14
+#define SHM_STAT_ANY    15
 
 /* Obsolete, used only for backwards compatibility */
 struct	shminfo {
diff -puN ipc/shm.c~ipc-shm-introduce-shmctlshm_stat_any ipc/shm.c
--- a/ipc/shm.c~ipc-shm-introduce-shmctlshm_stat_any
+++ a/ipc/shm.c
@@ -915,14 +915,14 @@ static int shmctl_stat(struct ipc_namesp
 	memset(tbuf, 0, sizeof(*tbuf));
 
 	rcu_read_lock();
-	if (cmd == SHM_STAT) {
+	if (cmd == SHM_STAT || cmd == SHM_STAT_ANY) {
 		shp = shm_obtain_object(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
 			goto out_unlock;
 		}
 		id = shp->shm_perm.id;
-	} else {
+	} else { /* IPC_STAT */
 		shp = shm_obtain_object_check(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
@@ -930,9 +930,20 @@ static int shmctl_stat(struct ipc_namesp
 		}
 	}
 
-	err = -EACCES;
-	if (ipcperms(ns, &shp->shm_perm, S_IRUGO))
-		goto out_unlock;
+	/*
+	 * Semantically SHM_STAT_ANY ought to be identical to
+	 * that functionality provided by the /proc/sysvipc/
+	 * interface. As such, only audit these calls and
+	 * do not do traditional S_IRUGO permission checks on
+	 * the ipc object.
+	 */
+	if (cmd == SHM_STAT_ANY)
+		audit_ipc_obj(&shp->shm_perm);
+	else {
+		err = -EACCES;
+		if (ipcperms(ns, &shp->shm_perm, S_IRUGO))
+			goto out_unlock;
+	}
 
 	err = security_shm_shmctl(shp, cmd);
 	if (err)
@@ -1072,6 +1083,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 		return err;
 	}
 	case SHM_STAT:
+	case SHM_STAT_ANY:
 	case IPC_STAT: {
 		err = shmctl_stat(ns, shmid, cmd, &sem64);
 		if (err < 0)
@@ -1245,6 +1257,7 @@ COMPAT_SYSCALL_DEFINE3(shmctl, int, shmi
 		return err;
 	}
 	case IPC_STAT:
+	case SHM_STAT_ANY:
 	case SHM_STAT:
 		err = shmctl_stat(ns, shmid, cmd, &sem64);
 		if (err < 0)
diff -puN security/selinux/hooks.c~ipc-shm-introduce-shmctlshm_stat_any security/selinux/hooks.c
--- a/security/selinux/hooks.c~ipc-shm-introduce-shmctlshm_stat_any
+++ a/security/selinux/hooks.c
@@ -5734,6 +5734,7 @@ static int selinux_shm_shmctl(struct shm
 				    SECCLASS_SYSTEM, SYSTEM__IPC_INFO, NULL);
 	case IPC_STAT:
 	case SHM_STAT:
+	case SHM_STAT_ANY:
 		perms = SHM__GETATTR | SHM__ASSOCIATE;
 		break;
 	case IPC_SET:
diff -puN security/smack/smack_lsm.c~ipc-shm-introduce-shmctlshm_stat_any security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~ipc-shm-introduce-shmctlshm_stat_any
+++ a/security/smack/smack_lsm.c
@@ -3034,6 +3034,7 @@ static int smack_shm_shmctl(struct shmid
 	switch (cmd) {
 	case IPC_STAT:
 	case SHM_STAT:
+	case SHM_STAT_ANY:
 		may = MAY_READ;
 		break;
 	case IPC_SET:
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-shm-introduce-shmctlshm_stat_any.patch
ipc-sem-introduce-semctlsem_stat_any.patch
ipc-msg-introduce-msgctlmsg_stat_any.patch

