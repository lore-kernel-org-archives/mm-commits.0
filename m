From: akpm@linux-foundation.org
Subject: + ptrace-add-ability-to-get-set-signal-blocked-mask.patch added
 to -mm tree
Date: Tue, 28 May 2013 16:27:04 -0700
Message-ID: <51a53d48.Eya1PLSp+i52gWdc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab3E1X1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 19:27:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, roland@redhat.com, oleg@redhat.com, mtk.manpages@gmail.com, gorcunov@openvz.org, avagin@openvz.org

Subject: + ptrace-add-ability-to-get-set-signal-blocked-mask.patch added to -mm tree
To: avagin@openvz.org,gorcunov@openvz.org,mtk.manpages@gmail.com,oleg@redhat.com,roland@redhat.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 16:27:04 -0700


The patch titled
     Subject: ptrace: add ability to get/set signal-blocked mask
has been added to the -mm tree.  Its filename is
     ptrace-add-ability-to-get-set-signal-blocked-mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/ptrace.h |    3 ++
 kernel/ptrace.c             |   42 ++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

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
@@ -843,6 +843,48 @@ int ptrace_request(struct task_struct *c
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
+	case PTRACE_SETSIGMASK:
+	{
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
_

Patches currently in -mm which might be from avagin@openvz.org are

memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
ptrace-add-ability-to-get-set-signal-blocked-mask.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch

