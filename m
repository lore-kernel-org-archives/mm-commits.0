From: akpm@linux-foundation.org
Subject: - send_sig_noinfo-masquerade-si_pid-when-crossing-pid-ns-boundary.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:22 -0800
Message-ID: <200901072220.n07MKMe4019647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762236AbZAGWVc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:21:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     SEND_SIG_NOINFO: masquerade si_pid when crossing pid-ns boundary
has been removed from the -mm tree.  Its filename was
     send_sig_noinfo-masquerade-si_pid-when-crossing-pid-ns-boundary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
pid-implement-ns_of_pid.patch
pid-implement-ns_of_pid-update.patch
pid-generalize-task_active_pid_ns.patch
mqueue-fix-si_pid-value-in-mqueue-do_notify.patch

