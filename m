From: akpm@linux-foundation.org
Subject: [merged]
 exit-call-disassociate_ctty-before-exit_task_namespaces.patch removed from
 -mm tree
Date: Tue, 08 Apr 2014 14:14:40 -0700
Message-ID: <534466c0.XsGYtQwEZkvdAVCm%akpm__49523.4357579195$1396991697$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbaDHVOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:14:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, stable@vger.kernel.org, sreeharsha@totakura.in, peter@hurleysoftware.com, mingo@elte.hu, jdike@addtoit.com, ebiederm@xmission.com, avagin@openvz.org, oleg@redhat.com

Subject: [merged] exit-call-disassociate_ctty-before-exit_task_namespaces.patch removed from -mm tree
To: oleg@redhat.com,avagin@openvz.org,ebiederm@xmission.com,jdike@addtoit.com,mingo@elte.hu,peter@hurleysoftware.com,sreeharsha@totakura.in,stable@vger.kernel.org,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:14:40 -0700


The patch titled
     Subject: exit: call disassociate_ctty() before exit_task_namespaces()
has been removed from the -mm tree.  Its filename was
     exit-call-disassociate_ctty-before-exit_task_namespaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: call disassociate_ctty() before exit_task_namespaces()

8aac62706ada ("move exit_task_namespaces() outside of exit_notify()")
breaks pppd and the exiting service crashes the kernel:

    BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
    IP: [<ffffffffa06985a3>] ppp_register_channel+0x13/0x20 [ppp_generic]
    ...
    Call Trace:
     [<ffffffffa06ab2ab>] ? ppp_asynctty_open+0x12b/0x170 [ppp_async]
     [<ffffffff812ec907>] ? tty_ldisc_open.isra.2+0x27/0x60
     [<ffffffff812ed1d3>] ? tty_ldisc_hangup+0x1e3/0x220
     [<ffffffff812e4614>] ? __tty_hangup+0x2c4/0x440
     [<ffffffff812e56a1>] ? disassociate_ctty+0x61/0x270
     [<ffffffff810483c2>] ? do_exit+0x7f2/0xa50

ppp_register_channel() needs ->net_ns and current->nsproxy == NULL.

Move disassociate_ctty() before exit_task_namespaces(), it doesn't make
sense to delay it after perf_event_exit_task() or cgroup_exit().

This also allows to use task_work_add() inside the (nontrivial) code
paths in disassociate_ctty().

Investigated by Peter Hurley.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Sree Harsha Totakura <sreeharsha@totakura.in>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Sree Harsha Totakura <sreeharsha@totakura.in>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>	[v3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~exit-call-disassociate_ctty-before-exit_task_namespaces kernel/exit.c
--- a/kernel/exit.c~exit-call-disassociate_ctty-before-exit_task_namespaces
+++ a/kernel/exit.c
@@ -784,6 +784,8 @@ void do_exit(long code)
 	exit_shm(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
+	if (group_dead)
+		disassociate_ctty(1);
 	exit_task_namespaces(tsk);
 	exit_task_work(tsk);
 	check_stack_usage();
@@ -799,13 +801,9 @@ void do_exit(long code)
 
 	cgroup_exit(tsk);
 
-	if (group_dead)
-		disassociate_ctty(1);
-
 	module_put(task_thread_info(tsk)->exec_domain->module);
 
 	proc_exit_connector(tsk);
