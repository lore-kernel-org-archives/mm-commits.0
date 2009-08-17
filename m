From: akpm@linux-foundation.org
Subject: + fcntl-add-f_etown_ex.patch added to -mm tree
Date: Mon, 17 Aug 2009 14:39:45 -0700
Message-ID: <200908172139.n7HLdjda020884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758100AbZHQVkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 17:40:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@googlemail.com, hch@lst.de, mtk.manpages@googlemail.com, oleg@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     fcntl: add F_[SG]ETOWN_EX
has been added to the -mm tree.  Its filename is
     fcntl-add-f_etown_ex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fcntl: add F_[SG]ETOWN_EX
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

In order to direct the SIGIO signal to a particular thread of a
multi-threaded application we cannot, like suggested by the manpage, put a
TID into the regular fcntl(F_SETOWN) call.  It will still be send to the
whole process of which that thread is part.

Since people do want to properly direct SIGIO we introduce F_SETOWN_EX.

The need to direct SIGIO comes from self-monitoring profiling such as with
perf-counters.  Perf-counters uses SIGIO to notify that new sample data is
available.  If the signal is delivered to the same task that generated the
new sample it can augment that data by inspecting the task's user-space
state right after it returns from the kernel.  This is esp.  convenient
for interpreted or virtual machine driven environments.

Both F_SETOWN_EX and F_GETOWN_EX take a pointer to a struct f_owner_ex
as argument:

struct f_owner_ex {
	int   type;
	pid_t pid;
};

Where type is one of F_OWNER_TID, F_OWNER_PID or F_OWNER_GID.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: stephane eranian <eranian@googlemail.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/fcntl.h  |    2 
 arch/parisc/include/asm/fcntl.h |    2 
 fs/fcntl.c                      |  108 +++++++++++++++++++++++++++---
 include/asm-generic/fcntl.h     |   13 +++
 4 files changed, 117 insertions(+), 8 deletions(-)

diff -puN arch/alpha/include/asm/fcntl.h~fcntl-add-f_etown_ex arch/alpha/include/asm/fcntl.h
--- a/arch/alpha/include/asm/fcntl.h~fcntl-add-f_etown_ex
+++ a/arch/alpha/include/asm/fcntl.h
@@ -26,6 +26,8 @@
 #define F_GETOWN	6	/*  for sockets. */
 #define F_SETSIG	10	/*  for sockets. */
 #define F_GETSIG	11	/*  for sockets. */
+#define F_SETOWN_EX	12
+#define F_GETOWN_EX	13
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		1
diff -puN arch/parisc/include/asm/fcntl.h~fcntl-add-f_etown_ex arch/parisc/include/asm/fcntl.h
--- a/arch/parisc/include/asm/fcntl.h~fcntl-add-f_etown_ex
+++ a/arch/parisc/include/asm/fcntl.h
@@ -28,6 +28,8 @@
 #define F_SETOWN	12	/*  for sockets. */
 #define F_SETSIG	13	/*  for sockets. */
 #define F_GETSIG	14	/*  for sockets. */
+#define F_GETOWN_EX	15
+#define F_SETOWN_EX	16
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		01
diff -puN fs/fcntl.c~fcntl-add-f_etown_ex fs/fcntl.c
--- a/fs/fcntl.c~fcntl-add-f_etown_ex
+++ a/fs/fcntl.c
@@ -263,6 +263,79 @@ pid_t f_getown(struct file *filp)
 	return pid;
 }
 
+static int f_setown_ex(struct file *filp, unsigned long arg)
+{
+	struct f_owner_ex * __user owner_p = (void * __user)arg;
+	struct f_owner_ex owner;
+	struct pid *pid;
+	int type;
+	int ret;
+
+	ret = copy_from_user(&owner, owner_p, sizeof(owner));
+	if (ret)
+		return ret;
+
+	switch (owner.type) {
+	case F_OWNER_TID:
+		type = PIDTYPE_MAX;
+		break;
+
+	case F_OWNER_PID:
+		type = PIDTYPE_PID;
+		break;
+
+	case F_OWNER_GID:
+		type = PIDTYPE_PGID;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	rcu_read_lock();
+	pid = find_vpid(owner.pid);
+	if (owner.pid && !pid)
+		ret = -ESRCH;
+	else
+		ret = __f_setown(filp, pid, type, 1);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static int f_getown_ex(struct file *filp, unsigned long arg)
+{
+	struct f_owner_ex * __user owner_p = (void * __user)arg;
+	struct f_owner_ex owner;
+	int ret = 0;
+
+	read_lock(&filp->f_owner.lock);
+	owner.pid = pid_vnr(filp->f_owner.pid);
+	switch (filp->f_owner.pid_type) {
+	case PIDTYPE_MAX:
+		owner.type = F_OWNER_TID;
+		break;
+
+	case PIDTYPE_PID:
+		owner.type = F_OWNER_PID;
+		break;
+
+	case PIDTYPE_PGID:
+		owner.type = F_OWNER_GID;
+		break;
+
+	default:
+		WARN_ON(1);
+		ret = -EINVAL;
+		break;
+	}
+	read_unlock(&filp->f_owner.lock);
+
+	if (!ret)
+		ret = copy_to_user(owner_p, &owner, sizeof(owner));
+	return ret;
+}
+
 static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		struct file *filp)
 {
@@ -313,6 +386,12 @@ static long do_fcntl(int fd, unsigned in
 	case F_SETOWN:
 		err = f_setown(filp, arg, 1);
 		break;
+	case F_GETOWN_EX:
+		err = f_getown_ex(filp, arg);
+		break;
+	case F_SETOWN_EX:
+		err = f_setown_ex(filp, arg);
+		break;
 	case F_GETSIG:
 		err = filp->f_owner.signum;
 		break;
@@ -428,8 +507,7 @@ static inline int sigio_perm(struct task
 
 static void send_sigio_to_task(struct task_struct *p,
 			       struct fown_struct *fown,
-			       int fd,
-			       int reason)
+			       int fd, int reason, int group)
 {
 	/*
 	 * F_SETSIG can change ->signum lockless in parallel, make
@@ -461,11 +539,11 @@ static void send_sigio_to_task(struct ta
 			else
 				si.si_band = band_table[reason - POLL_IN];
 			si.si_fd    = fd;
-			if (!do_send_sig_info(signum, &si, p, true))
+			if (!do_send_sig_info(signum, &si, p, group))
 				break;
 		/* fall-through: fall back on the old plain SIGIO signal */
 		case 0:
-			do_send_sig_info(SIGIO, SEND_SIG_PRIV, p, true);
+			do_send_sig_info(SIGIO, SEND_SIG_PRIV, p, group);
 	}
 }
 
@@ -474,16 +552,23 @@ void send_sigio(struct fown_struct *fown
 	struct task_struct *p;
 	enum pid_type type;
 	struct pid *pid;
+	int group = 1;
 	
 	read_lock(&fown->lock);
+
 	type = fown->pid_type;
+	if (type == PIDTYPE_MAX) {
+		group = 0;
+		type = PIDTYPE_PID;
+	}
+
 	pid = fown->pid;
 	if (!pid)
 		goto out_unlock_fown;
 	
 	read_lock(&tasklist_lock);
 	do_each_pid_task(pid, type, p) {
-		send_sigio_to_task(p, fown, fd, band);
+		send_sigio_to_task(p, fown, fd, band, group);
 	} while_each_pid_task(pid, type, p);
 	read_unlock(&tasklist_lock);
  out_unlock_fown:
@@ -491,10 +576,10 @@ void send_sigio(struct fown_struct *fown
 }
 
 static void send_sigurg_to_task(struct task_struct *p,
-                                struct fown_struct *fown)
+				struct fown_struct *fown, int group)
 {
 	if (sigio_perm(p, fown, SIGURG))
-		group_send_sig_info(SIGURG, SEND_SIG_PRIV, p);
+		do_send_sig_info(SIGURG, SEND_SIG_PRIV, p, group);
 }
 
 int send_sigurg(struct fown_struct *fown)
@@ -502,10 +587,17 @@ int send_sigurg(struct fown_struct *fown
 	struct task_struct *p;
 	enum pid_type type;
 	struct pid *pid;
+	int group = 1;
 	int ret = 0;
 	
 	read_lock(&fown->lock);
+
 	type = fown->pid_type;
+	if (type == PIDTYPE_MAX) {
+		group = 0;
+		type = PIDTYPE_PID;
+	}
+
 	pid = fown->pid;
 	if (!pid)
 		goto out_unlock_fown;
@@ -514,7 +606,7 @@ int send_sigurg(struct fown_struct *fown
 	
 	read_lock(&tasklist_lock);
 	do_each_pid_task(pid, type, p) {
-		send_sigurg_to_task(p, fown);
+		send_sigurg_to_task(p, fown, group);
 	} while_each_pid_task(pid, type, p);
 	read_unlock(&tasklist_lock);
  out_unlock_fown:
diff -puN include/asm-generic/fcntl.h~fcntl-add-f_etown_ex include/asm-generic/fcntl.h
--- a/include/asm-generic/fcntl.h~fcntl-add-f_etown_ex
+++ a/include/asm-generic/fcntl.h
@@ -73,6 +73,19 @@
 #define F_SETSIG	10	/* for sockets. */
 #define F_GETSIG	11	/* for sockets. */
 #endif
+#ifndef F_SETOWN_EX
+#define F_SETOWN_EX	12
+#define F_GETOWN_EX	13
+#endif
+
+#define F_OWNER_TID	0
+#define F_OWNER_PID	1
+#define F_OWNER_GID	2
+
+struct f_owner_ex {
+	int	type;
+	pid_t	pid;
+};
 
 /* for F_[GET|SET]FL */
 #define FD_CLOEXEC	1	/* actually anything with low bit set goes */
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds.patch
spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds-v3.patch
waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes-checkpatch-fixes.patch
spinlock-move-spinlock-function-bodies-to-header-file.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
mm-count-only-reclaimable-lru-pages-v2.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
fcntl-add-f_etown_ex.patch

