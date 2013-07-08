From: akpm@linux-foundation.org
Subject: [merged] ptrace-add-ability-to-get-set-signal-blocked-mask.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:35:39 -0700
Message-ID: <51db148b.nVeKeRp9nsfZS1pM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3GHTfn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, roland@redhat.com, oleg@redhat.com, mtk.manpages@gmail.com, gorcunov@openvz.org, avagin@openvz.org

Subject: [merged] ptrace-add-ability-to-get-set-signal-blocked-mask.patch removed from -mm tree
To: avagin@openvz.org,gorcunov@openvz.org,mtk.manpages@gmail.com,oleg@redhat.com,roland@redhat.com,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:39 -0700


The patch titled
     Subject: ptrace: add ability to get/set signal-blocked mask
has been removed from the -mm tree.  Its filename was
     ptrace-add-ability-to-get-set-signal-blocked-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: ptrace: add ability to get/set signal-blocked mask

crtools uses a parasite code for dumping processes.  The parasite code is
injected into a process with help PTRACE_SEIZE.

Currently crtools blocks signals from a parasite code.  If a process has
pending signals, crtools wait while a process handles these signals.

This method is not suitable for stopped tasks.  A stopped task can have a
few pending signals, when we will try to execute a parasite code, we will
need to drop SIGSTOP, but all other signals must remain pending, because a
state of processes must not be changed during checkpointing.

This patch adds two ptrace commands to set/get signal-blocked mask.

I think gdb can use this commands too.

[akpm@linux-foundation.org: be consistent with brace layout]
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/ptrace.h |    3 ++
 kernel/ptrace.c             |   44 ++++++++++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

diff -puN include/uapi/linux/ptrace.h~ptrace-add-ability-to-get-set-signal-blocked-mask include/uapi/linux/ptrace.h
--- a/include/uapi/linux/ptrace.h~ptrace-add-ability-to-get-set-signal-blocked-mask
+++ a/include/uapi/linux/ptrace.h
@@ -61,6 +61,9 @@ struct ptrace_peeksiginfo_args {
 	__s32 nr;	/* how may siginfos to take */
 };
 
+#define PTRACE_GETSIGMASK	0x420a
+#define PTRACE_SETSIGMASK	0x420b
+
 /* Read signals from a shared (process wide) queue */
 #define PTRACE_PEEKSIGINFO_SHARED	(1 << 0)
 
diff -puN kernel/ptrace.c~ptrace-add-ability-to-get-set-signal-blocked-mask kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-add-ability-to-get-set-signal-blocked-mask
+++ a/kernel/ptrace.c
@@ -844,6 +844,47 @@ int ptrace_request(struct task_struct *c
 			ret = ptrace_setsiginfo(child, &siginfo);
 		break;
 
+	case PTRACE_GETSIGMASK:
+		if (addr != sizeof(sigset_t)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (copy_to_user(datavp, &child->blocked, sizeof(sigset_t)))
+			ret = -EFAULT;
+		else
+			ret = 0;
+
+		break;
+
+	case PTRACE_SETSIGMASK: {
+		sigset_t new_set;
+
+		if (addr != sizeof(sigset_t)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (copy_from_user(&new_set, datavp, sizeof(sigset_t))) {
+			ret = -EFAULT;
+			break;
+		}
+
+		sigdelsetmask(&new_set, sigmask(SIGKILL)|sigmask(SIGSTOP));
+
+		/*
+		 * Every thread does recalc_sigpending() after resume, so
+		 * retarget_shared_pending() and recalc_sigpending() are not
+		 * called here.
+		 */
+		spin_lock_irq(&child->sighand->siglock);
+		child->blocked = new_set;
+		spin_unlock_irq(&child->sighand->siglock);
+
+		ret = 0;
+		break;
+	}
+
 	case PTRACE_INTERRUPT:
 		/*
 		 * Stop tracee without any side-effect on signal or job
@@ -948,8 +989,7 @@ int ptrace_request(struct task_struct *c
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	case PTRACE_GETREGSET:
-	case PTRACE_SETREGSET:
-	{
+	case PTRACE_SETREGSET: {
 		struct iovec kiov;
 		struct iovec __user *uiov = datavp;
 
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch
linux-next.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

