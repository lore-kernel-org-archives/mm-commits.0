From: akpm@linux-foundation.org
Subject: - send_sig_noinfo-set-si_pid-to-tgid-instead-of-pid.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:25 -0800
Message-ID: <200901072220.n07MKP9i019683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762211AbZAGWVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:21:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     SEND_SIG_NOINFO: set si_pid to tgid instead of pid
has been removed from the -mm tree.  Its filename was
     send_sig_noinfo-set-si_pid-to-tgid-instead-of-pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
pid-implement-ns_of_pid.patch
pid-implement-ns_of_pid-update.patch
pid-generalize-task_active_pid_ns.patch
mqueue-fix-si_pid-value-in-mqueue-do_notify.patch

