From: akpm@linux-foundation.org
Subject: + signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary.patch added to -mm tree
Date: Thu, 19 Feb 2009 14:26:32 -0800
Message-ID: <200902192226.n1JMQWaX027302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753958AbZBSW06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 17:26:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@linux.vnet.ibm.com, daniel.lezcano@free.fr, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: SI_USER: Masquerade si_pid when crossing pid ns boundary
has been added to the -mm tree.  Its filename is
     signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary.patch

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
Subject: signals: SI_USER: Masquerade si_pid when crossing pid ns boundary
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

When sending a signal to a descendant namespace, set ->si_pid to 0 since
the sender does not have a pid in the receiver's namespace.

Note:
	- If rt_sigqueueinfo() sets si_code to SI_USER when sending a
	  signal across a pid namespace boundary, the value in ->si_pid
	  will be cleared to 0.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/signal.c~signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary kernel/signal.c
--- a/kernel/signal.c~signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary
+++ a/kernel/signal.c
@@ -883,6 +883,8 @@ static int __send_signal(int sig, struct
 			break;
 		default:
 			copy_siginfo(&q->info, info);
+			if (from_ancestor_ns)
+				q->info.si_pid = 0;
 			break;
 		}
 	} else if (!is_si_special(info)) {
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

vfs-simple_set_mnt-should-return-void.patch
devpts-must-release-s_umount-on-error.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
signals-protect-init-from-unwanted-signals-more.patch
signals-add-from_ancestor_ns-parameter-to-send_signal.patch
signals-protect-cinit-from-unblocked-sig_dfl-signals.patch
signals-zap_pid_ns_process-should-use-force_sig.patch
signals-protect-cinit-from-blocked-fatal-signals.patch
signals-si_user-masquerade-si_pid-when-crossing-pid-ns-boundary.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

