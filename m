From: akpm@linux-foundation.org
Subject: - mqueue-fix-si_pid-value-in-mqueue-do_notify.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:28 -0800
Message-ID: <200901082250.n08MoSNW029661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823AbZAHWwD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:52:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, Nadia.Derbey@bull.net, bastian@waldi.eu.org, ebiederm@xmission.com, oleg@redhat.com, roland@redhat.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger


The patch titled
     mqueue: fix si_pid value in mqueue do_notify()
has been removed from the -mm tree.  Its filename was
     mqueue-fix-si_pid-value-in-mqueue-do_notify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mqueue: fix si_pid value in mqueue do_notify()
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

If a process registers for asynchronous notification on a POSIX message
queue, it gets a signal and a siginfo_t structure when a message arrives
on the message queue.  The si_pid in the siginfo_t structure is set to the
PID of the process that sent the message to the message queue.

The principle is the following:
. when mq_notify(SIGEV_SIGNAL) is called, the caller registers for
  notification when a msg arrives. The associated pid structure is stroed into
  inode_info->notify_owner. Let's call this process P1.
. when mq_send() is called by say P2, P2 sends a signal to P1 to notify
  him about msg arrival.

The way .si_pid is set today is not correct, since it doesn't take into account
the fact that the process that is sending the message might not be in the
same namespace as the notified one.

This patch proposes to set si_pid to the sender's pid into the notify_owner
namespace.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Bastian Blank <bastian@waldi.eu.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN ipc/mqueue.c~mqueue-fix-si_pid-value-in-mqueue-do_notify ipc/mqueue.c
--- a/ipc/mqueue.c~mqueue-fix-si_pid-value-in-mqueue-do_notify
+++ a/ipc/mqueue.c
@@ -505,7 +505,8 @@ static void __do_notify(struct mqueue_in
 			sig_i.si_errno = 0;
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
-			sig_i.si_pid = task_tgid_vnr(current);
+			sig_i.si_pid = task_tgid_nr_ns(current,
+						ns_of_pid(info->notify_owner));
 			sig_i.si_uid = current_uid();
 
 			kill_pid_info(info->notify.sigev_signo,
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

origin.patch

