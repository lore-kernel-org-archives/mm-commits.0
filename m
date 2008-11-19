From: akpm@linux-foundation.org
Subject: + signals-protect-sbin-init-from-unwanted-signals-more.patch added to -mm tree
Date: Tue, 18 Nov 2008 23:47:56 -0800
Message-ID: <200811190747.mAJ7luJj023210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbYKSHsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 02:48:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com, serue@us.ibm.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     signals: protect /sbin/init from unwanted signals more
has been added to the -mm tree.  Its filename is
     signals-protect-sbin-init-from-unwanted-signals-more.patch

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
Subject: signals: protect /sbin/init from unwanted signals more
From: Oleg Nesterov <oleg@redhat.com>

init ignores the SIG_DFL signals but we queue them anyway, including
SIGKILL.  This is mostly OK, the signal will be dropped silently when
dequeued, but the pending SIGKILL has 2 bad implications:

	- it implies fatal_signal_pending(), so we confuse things
	  like wait_for_completion_killable/lock_page_killable.

	- for the sub-namespace inits, the pending SIGKILL can
	  mask (legacy_queue) the subsequent SIGKILL from the
	  parent namespace which must kill cinit reliably.
	  (preparation, cinits don't have SIGNAL_UNKILLABLE yet)

The patch can't help when init is ptraced, but ptracing of init is
not "safe" anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/signal.c~signals-protect-sbin-init-from-unwanted-signals-more kernel/signal.c
--- a/kernel/signal.c~signals-protect-sbin-init-from-unwanted-signals-more
+++ a/kernel/signal.c
@@ -43,7 +43,13 @@ static struct kmem_cache *sigqueue_cache
 
 static void __user *sig_handler(struct task_struct *t, int sig)
 {
-	return t->sighand->action[sig - 1].sa.sa_handler;
+	void __user *h = t->sighand->action[sig - 1].sa.sa_handler;
+
+	/* drop SIGKILL early to not confuse wait_xxx_killable/etc */
+	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) && h == SIG_DFL)
+		h = SIG_IGN;
+
+	return h;
 }
 
 static int sig_handler_ignored(void __user *handler, int sig)
_

Patches currently in -mm which might be from oleg@redhat.com are

forkc-cleanup-for-copy_sighand.patch
signals-protect-sbin-init-from-unwanted-signals-more.patch
signals-simplify-sig_ignored-pathes.patch
workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead.patch

