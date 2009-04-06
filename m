From: akpm@linux-foundation.org
Subject: [merged] tracehook_notify_death-use-task_detached-helper.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:52 -0700
Message-ID: <200904061935.n36JZq56012214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbZDFUTw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:19:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, markus.t.metzger@intel.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tracehook_notify_death: use task_detached() helper
has been removed from the -mm tree.  Its filename was
     tracehook_notify_death-use-task_detached-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook_notify_death: use task_detached() helper
From: Oleg Nesterov <oleg@redhat.com>

Now that task_detached() is exported, change tracehook_notify_death() to
use this helper, nobody else checks ->exit_signal == -1 by hand.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/tracehook.h~tracehook_notify_death-use-task_detached-helper include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook_notify_death-use-task_detached-helper
+++ a/include/linux/tracehook.h
@@ -502,7 +502,7 @@ static inline int tracehook_notify_jctl(
 static inline int tracehook_notify_death(struct task_struct *task,
 					 void **death_cookie, int group_dead)
 {
-	if (task->exit_signal == -1)
+	if (task_detached(task))
 		return task->ptrace ? SIGCHLD : DEATH_REAP;
 
 	/*
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

