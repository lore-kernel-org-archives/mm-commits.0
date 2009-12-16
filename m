From: akpm@linux-foundation.org
Subject: [merged] signals-send_signal-use-si_fromuser-to-detect-from_ancestor_ns.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:18 -0800
Message-ID: <200912162038.nBGKcIqY013414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964944AbZLPUio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dlezcano@fr.ibm.com, roland@redhat.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     signals: send_signal: use si_fromuser() to detect from_ancestor_ns
has been removed from the -mm tree.  Its filename was
     signals-send_signal-use-si_fromuser-to-detect-from_ancestor_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: send_signal: use si_fromuser() to detect from_ancestor_ns
From: Oleg Nesterov <oleg@redhat.com>

Change send_signal() to use si_fromuser().  From now SEND_SIG_NOINFO
triggers the "from_ancestor_ns" check.

This fixes reparent_thread()->group_send_sig_info(pdeath_signal)
behaviour, before this patch send_signal() does not detect the
cross-namespace case when the child of the dying parent belongs to the
sub-namespace.

This patch can affect the behaviour of send_sig(), kill_pgrp() and
kill_pid() when the caller sends the signal to the sub-namespace with
"priv == 0" but surprisingly all callers seem to use them correctly,
including disassociate_ctty(on_exit).

Except: drivers/staging/comedi/drivers/addi-data/*.c incorrectly use
send_sig(priv => 0).  But his is minor and should be fixed anyway.

Reported-by: Daniel Lezcano <dlezcano@fr.ibm.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Reviewed-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/signal.c~signals-send_signal-use-si_fromuser-to-detect-from_ancestor_ns kernel/signal.c
--- a/kernel/signal.c~signals-send_signal-use-si_fromuser-to-detect-from_ancestor_ns
+++ a/kernel/signal.c
@@ -960,9 +960,8 @@ static int send_signal(int sig, struct s
 	int from_ancestor_ns = 0;
 
 #ifdef CONFIG_PID_NS
-	if (!is_si_special(info) && SI_FROMUSER(info) &&
-			task_pid_nr_ns(current, task_active_pid_ns(t)) <= 0)
-		from_ancestor_ns = 1;
+	from_ancestor_ns = si_fromuser(info) &&
+			   !task_pid_nr_ns(current, task_active_pid_ns(t));
 #endif
 
 	return __send_signal(sig, info, t, group, from_ancestor_ns);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
mm-introduce-coredump-parameter-structure.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch

