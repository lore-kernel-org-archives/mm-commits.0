From: akpm@linux-foundation.org
Subject: [merged] ipc-compat-use-signed-size_t-types-for-msgsnd-and-msgrcv.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:54:12 -0700
Message-ID: <20120731185412.CE504100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:39624 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab2GaSyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:54:18 -0400
Received: by vbnl22 with SMTP id l22so758599vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:54:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, arnd@arndb.de, catalin.marinas@arm.com, cmetcalf@tilera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: compat: use signed size_t types for msgsnd and msgrcv
has been removed from the -mm tree.  Its filename was
     ipc-compat-use-signed-size_t-types-for-msgsnd-and-msgrcv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: ipc: compat: use signed size_t types for msgsnd and msgrcv

The msgsnd and msgrcv system calls use size_t to represent the size of the
message being transferred.  POSIX states that values of msgsz greater than
SSIZE_MAX cause the result to be implementation-defined.  On Linux, this
equates to returning -EINVAL if (long) msgsz < 0.

For compat tasks where !CONFIG_ARCH_WANT_OLD_COMPAT_IPC and compat_size_t
is smaller than size_t, negative size values passed from userspace will be
interpreted as positive values by do_msg{rcv,snd} and will fail to exit
early with -EINVAL.

This patch changes the compat prototypes for msg{rcv,snd} so that the
message size is represented as a compat_ssize_t, which we cast to the
native ssize_t type for the core IPC code.

Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    4 ++--
 ipc/compat.c           |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/compat.h~ipc-compat-use-signed-size_t-types-for-msgsnd-and-msgrcv include/linux/compat.h
--- a/include/linux/compat.h~ipc-compat-use-signed-size_t-types-for-msgsnd-and-msgrcv
+++ a/include/linux/compat.h
@@ -266,9 +266,9 @@ long compat_sys_shmat(int first, int sec
 #else
 long compat_sys_semctl(int semid, int semnum, int cmd, int arg);
 long compat_sys_msgsnd(int msqid, struct compat_msgbuf __user *msgp,
-		size_t msgsz, int msgflg);
+		compat_ssize_t msgsz, int msgflg);
 long compat_sys_msgrcv(int msqid, struct compat_msgbuf __user *msgp,
-		size_t msgsz, long msgtyp, int msgflg);
+		compat_ssize_t msgsz, long msgtyp, int msgflg);
 long compat_sys_shmat(int shmid, compat_uptr_t shmaddr, int shmflg);
 #endif
 long compat_sys_msgctl(int first, int second, void __user *uptr);
diff -puN ipc/compat.c~ipc-compat-use-signed-size_t-types-for-msgsnd-and-msgrcv ipc/compat.c
--- a/ipc/compat.c~ipc-compat-use-signed-size_t-types-for-msgsnd-and-msgrcv
+++ a/ipc/compat.c
@@ -373,21 +373,21 @@ long compat_sys_semctl(int semid, int se
 }
 
 long compat_sys_msgsnd(int msqid, struct compat_msgbuf __user *msgp,
-		       size_t msgsz, int msgflg)
+		       compat_ssize_t msgsz, int msgflg)
 {
 	compat_long_t mtype;
 
 	if (get_user(mtype, &msgp->mtype))
 		return -EFAULT;
-	return do_msgsnd(msqid, mtype, msgp->mtext, msgsz, msgflg);
+	return do_msgsnd(msqid, mtype, msgp->mtext, (ssize_t)msgsz, msgflg);
 }
 
 long compat_sys_msgrcv(int msqid, struct compat_msgbuf __user *msgp,
-		       size_t msgsz, long msgtyp, int msgflg)
+		       compat_ssize_t msgsz, long msgtyp, int msgflg)
 {
 	long err, mtype;
 
-	err =  do_msgrcv(msqid, &mtype, msgp->mtext, msgsz, msgtyp, msgflg);
+	err =  do_msgrcv(msqid, &mtype, msgp->mtext, (ssize_t)msgsz, msgtyp, msgflg);
 	if (err < 0)
 		goto out;
 
_

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch
linux-next.patch

