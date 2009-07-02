From: akpm@linux-foundation.org
Subject: + do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch added to -mm tree
Date: Thu, 02 Jul 2009 14:26:51 -0700
Message-ID: <200907022126.n62LQplj021470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683AbZGBV1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 17:27:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, mingo@elte.hu, rnalumasu@gmail.com, roland@redhat.com, vmayatsk@redhat.com


The patch titled
     do_wait() wakeup optimization: child_wait_callback: check __WNOTHREAD case
has been added to the -mm tree.  Its filename is
     do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch

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
Subject: do_wait() wakeup optimization: child_wait_callback: check __WNOTHREAD case
From: Oleg Nesterov <oleg@redhat.com>

Suggested by Roland.

do_wait(__WNOTHREAD) can only succeed if the caller is either ptracer, or
it is ->real_parent and the child is not traced. IOW, caller == p->parent
otherwise we should not wake up.

Change child_wait_callback() to check this. Ratan reports the workload with
CPU load >99% caused by unnecessary wakeups, should be fixed by this patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/exit.c~do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case kernel/exit.c
--- a/kernel/exit.c~do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case
+++ a/kernel/exit.c
@@ -1577,6 +1577,9 @@ static int child_wait_callback(wait_queu
 	if (!eligible_child(wo, p))
 		return 0;
 
+	if ((wo->wo_flags & __WNOTHREAD) && wait->private != p->parent)
+		return 0;
+
 	return default_wake_function(wait, mode, sync, key);
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cred_guard_mutex-do-not-return-eintr-to-user-space.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

