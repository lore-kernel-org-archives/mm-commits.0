From: akpm@linux-foundation.org
Subject: + send_sig_noinfo-masquerade-si_pid-when-crossing-pid-ns-boundary.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:51:34 -0800
Message-ID: <200812172251.mBHMpYUo025526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbYLQWwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:52:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@linux.vnet.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org


The patch titled
     SEND_SIG_NOINFO: masquerade si_pid when crossing pid-ns boundary
has been added to the -mm tree.  Its filename is
     send_sig_noinfo-masquerade-si_pid-when-crossing-pid-ns-boundary.patch

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
Subject: SEND_SIG_NOINFO: masquerade si_pid when crossing pid-ns boundary
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

For SEND_SIG_NOINFO, si_pid is currently set to the pid of sender
in sender's active pid namespace. But if the receiver is in a
Eg: when parent sends the 'pdeath_signal' to a child that is in
a descendant pid namespace, we should set si_pid 0.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-By: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/signal.c~send_sig_noinfo-masquerade-si_pid-when-crossing-pid-ns-boundary kernel/signal.c
--- a/kernel/signal.c~send_sig_noinfo-masquerade-si_pid-when-crossing-pid-ns-boundary
+++ a/kernel/signal.c
@@ -858,7 +858,8 @@ static int send_signal(int sig, struct s
 			q->info.si_signo = sig;
 			q->info.si_errno = 0;
 			q->info.si_code = SI_USER;
-			q->info.si_pid = task_pid_vnr(current);
+			q->info.si_pid = task_pid_nr_ns(current,
+							task_active_pid_ns(t));
 			q->info.si_uid = current_uid();
 			break;
 		case (unsigned long) SEND_SIG_PRIV:
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

linux-next.patch
send_sig_noinfo-masquerade-si_pid-when-crossing-pid-ns-boundary.patch
send_sig_noinfo-set-si_pid-to-tgid-instead-of-pid.patch
pid-implement-ns_of_pid.patch
pid-implement-ns_of_pid-update.patch
pid-generalize-task_active_pid_ns.patch
mqueue-fix-si_pid-value-in-mqueue-do_notify.patch

