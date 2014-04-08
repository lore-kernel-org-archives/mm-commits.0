From: akpm@linux-foundation.org
Subject: [merged] exit-move-check_stack_usage-to-the-end-of-do_exit.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:15:12 -0700
Message-ID: <534466e0.rzHEb78rq5srPLFC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbaDHVPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com

Subject: [merged] exit-move-check_stack_usage-to-the-end-of-do_exit.patch removed from -mm tree
To: oleg@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:15:12 -0700


The patch titled
     Subject: exit: move check_stack_usage() to the end of do_exit()
has been removed from the -mm tree.  Its filename was
     exit-move-check_stack_usage-to-the-end-of-do_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: move check_stack_usage() to the end of do_exit()

It is not clear why check_stack_usage() is called so early and thus it
never checks the stack usage in, say, exit_notify() or
flush_ptrace_hw_breakpoint() or other functions which are only called by
do_exit().

Move the callsite down to the last preempt_disable/schedule.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~exit-move-check_stack_usage-to-the-end-of-do_exit kernel/exit.c
--- a/kernel/exit.c~exit-move-check_stack_usage-to-the-end-of-do_exit
+++ a/kernel/exit.c
@@ -788,7 +788,6 @@ void do_exit(long code)
 		disassociate_ctty(1);
 	exit_task_namespaces(tsk);
 	exit_task_work(tsk);
-	check_stack_usage();
 	exit_thread();
 
 	/*
@@ -842,6 +841,7 @@ void do_exit(long code)
 
 	validate_creds_for_do_exit(tsk);
 
+	check_stack_usage();
 	preempt_disable();
 	if (tsk->nr_dirtied)
 		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch

