From: akpm@linux-foundation.org
Subject: + deprecate-find_task_by_pid-warning-fix.patch added to -mm tree
Date: Thu, 28 Feb 2008 17:24:30 -0800
Message-ID: <200802290124.m1T1OUga031171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbYB2BZ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 20:25:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, ebiederm@xmission.com, xemul@openvz.org


The patch titled
     Fix warning in kernel/pid.c
has been added to the -mm tree.  Its filename is
     deprecate-find_task_by_pid-warning-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix warning in kernel/pid.c
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

We get a warning in kernel/pid.c due to the deprecated find_task_by_pid(). 
Make the function inline in sched.h to avoid the warning.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    5 ++++-
 kernel/pid.c          |    6 ------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN include/linux/sched.h~deprecate-find_task_by_pid-warning-fix include/linux/sched.h
--- a/include/linux/sched.h~deprecate-find_task_by_pid-warning-fix
+++ a/include/linux/sched.h
@@ -1633,7 +1633,10 @@ extern struct pid_namespace init_pid_ns;
 extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
 		struct pid_namespace *ns);
 
-extern struct task_struct *find_task_by_pid(pid_t nr) __deprecated;
+static inline struct task_struct *__deprecated find_task_by_pid(pid_t nr)
+{
+	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
+}
 extern struct task_struct *find_task_by_vpid(pid_t nr);
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
diff -puN kernel/pid.c~deprecate-find_task_by_pid-warning-fix kernel/pid.c
--- a/kernel/pid.c~deprecate-find_task_by_pid-warning-fix
+++ a/kernel/pid.c
@@ -382,12 +382,6 @@ struct task_struct *find_task_by_pid_typ
 
 EXPORT_SYMBOL(find_task_by_pid_type_ns);
 
-struct task_struct *find_task_by_pid(pid_t nr)
-{
-	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
-}
-EXPORT_SYMBOL(find_task_by_pid);
