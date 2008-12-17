From: akpm@linux-foundation.org
Subject: + send_sig_noinfo-set-si_pid-to-tgid-instead-of-pid.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:51:37 -0800
Message-ID: <200812172251.mBHMpcNd025529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbYLQWv6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:51:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@linux.vnet.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org


The patch titled
     SEND_SIG_NOINFO: set si_pid to tgid instead of pid
has been added to the -mm tree.  Its filename is
     send_sig_noinfo-set-si_pid-to-tgid-instead-of-pid.patch

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
Subject: SEND_SIG_NOINFO: set si_pid to tgid instead of pid
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

POSIX requires the si_pid to be the process id of the sender, so ->si_pid
should really be set to 'tgid'.  This change does have following changes
in behavior:

	- When sending pdeath_signal on re-parent to a sub-thread, ->si_pid
	  cannot be used to identify the thread that did the re-parent since
	  it will now show the tgid instead of thread id.

	- A multi-threaded application that expects to find the specific
	  thread that encountered a SIGPIPE using the ->si_pid will now
	  break.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-By: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~send_sig_noinfo-set-si_pid-to-tgid-instead-of-pid kernel/signal.c
--- a/kernel/signal.c~send_sig_noinfo-set-si_pid-to-tgid-instead-of-pid
+++ a/kernel/signal.c
@@ -858,7 +858,7 @@ static int send_signal(int sig, struct s
 			q->info.si_signo = sig;
 			q->info.si_errno = 0;
 			q->info.si_code = SI_USER;
-			q->info.si_pid = task_pid_nr_ns(current,
+			q->info.si_pid = task_tgid_nr_ns(current,
 							task_active_pid_ns(t));
 			q->info.si_uid = current_uid();
 			break;
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

linux-next.patch
send_sig_noinfo-masquerade-si_pid-when-crossing-pid-ns-boundary.patch
send_sig_noinfo-set-si_pid-to-tgid-instead-of-pid.patch
pid-implement-ns_of_pid.patch
pid-implement-ns_of_pid-update.patch
pid-generalize-task_active_pid_ns.patch
mqueue-fix-si_pid-value-in-mqueue-do_notify.patch

