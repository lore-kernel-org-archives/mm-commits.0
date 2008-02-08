From: akpm@linux-foundation.org
Subject: - pidns-fix-badly-converted-mqueues-pid-handling.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:14:36 -0800
Message-ID: <200802082014.m18KEHiA010399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755033AbYBHVCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:02:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     Pidns: fix badly converted mqueues pid handling
has been removed from the -mm tree.  Its filename was
     pidns-fix-badly-converted-mqueues-pid-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Pidns: fix badly converted mqueues pid handling
From: Pavel Emelyanov <xemul@openvz.org>

When sending the pid namespaces patches I wrongly converted the tsk->tgid into
task_pid_vnr(tsk) in mqueue-s (the git id of this patch is
b488893a390edfe027bae7a46e9af8083e740668).

The proper behavior is to get the task_tgid_vnr(tsk).

This seem to be the only mistake of that kind.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/mqueue.c~pidns-fix-badly-converted-mqueues-pid-handling ipc/mqueue.c
--- a/ipc/mqueue.c~pidns-fix-badly-converted-mqueues-pid-handling
+++ a/ipc/mqueue.c
@@ -509,7 +509,7 @@ static void __do_notify(struct mqueue_in
 			sig_i.si_errno = 0;
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
-			sig_i.si_pid = task_pid_vnr(current);
+			sig_i.si_pid = task_tgid_vnr(current);
 			sig_i.si_uid = current->uid;
 
 			kill_pid_info(info->notify.sigev_signo,
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
deprecate-find_task_by_pid-kgdb.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
