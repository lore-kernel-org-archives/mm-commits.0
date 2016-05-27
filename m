From: akpm@linux-foundation.org
Subject: [merged]
 kdump-fix-gdb-macros-work-work-with-newer-and-64-bit-kernels.patch removed
 from -mm tree
Date: Fri, 27 May 2016 11:43:47 -0700
Message-ID: <57489563.gCAoz+2ek0f8n7Ac%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbcE0Sns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, bhe@redhat.com, hbabu@us.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kdump: fix gdb macros work work with newer and 64-bit kernels
has been removed from the -mm tree.  Its filename was
     kdump-fix-gdb-macros-work-work-with-newer-and-64-bit-kernels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Corey Minyard <cminyard@mvista.com>
Subject: kdump: fix gdb macros work work with newer and 64-bit kernels

Lots of little changes needed to be made to clean these up, remove the
four byte pointer assumption and traverse the pid queue properly.  Also
consolidate the traceback code into a single function instead of having
three copies of it.

Link: http://lkml.kernel.org/r/1462926655-9390-1-git-send-email-minyard@acm.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/gdbmacros.txt |   96 ++++++++++++----------------
 1 file changed, 44 insertions(+), 52 deletions(-)

diff -puN Documentation/kdump/gdbmacros.txt~kdump-fix-gdb-macros-work-work-with-newer-and-64-bit-kernels Documentation/kdump/gdbmacros.txt
--- a/Documentation/kdump/gdbmacros.txt~kdump-fix-gdb-macros-work-work-with-newer-and-64-bit-kernels
+++ a/Documentation/kdump/gdbmacros.txt
@@ -15,15 +15,16 @@
 
 define bttnobp
 	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
-	set $pid_off=((size_t)&((struct task_struct *)0)->pids[1].pid_list.next)
+	set $pid_off=((size_t)&((struct task_struct *)0)->thread_group.next)
 	set $init_t=&init_task
 	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
+	set var $stacksize = sizeof(union thread_union)
 	while ($next_t != $init_t)
 		set $next_t=(struct task_struct *)$next_t
 		printf "\npid %d; comm %s:\n", $next_t.pid, $next_t.comm
 		printf "===================\n"
-		set var $stackp = $next_t.thread.esp
-		set var $stack_top = ($stackp & ~4095) + 4096
+		set var $stackp = $next_t.thread.sp
+		set var $stack_top = ($stackp & ~($stacksize - 1)) + $stacksize
 
 		while ($stackp < $stack_top)
 			if (*($stackp) > _stext && *($stackp) < _sinittext)
@@ -31,13 +32,13 @@ define bttnobp
 			end
 			set $stackp += 4
 		end
-		set $next_th=(((char *)$next_t->pids[1].pid_list.next) - $pid_off)
+		set $next_th=(((char *)$next_t->thread_group.next) - $pid_off)
 		while ($next_th != $next_t)
 			set $next_th=(struct task_struct *)$next_th
 			printf "\npid %d; comm %s:\n", $next_t.pid, $next_t.comm
 			printf "===================\n"
-			set var $stackp = $next_t.thread.esp
-			set var $stack_top = ($stackp & ~4095) + 4096
+			set var $stackp = $next_t.thread.sp
+			set var $stack_top = ($stackp & ~($stacksize - 1)) + stacksize
 
 			while ($stackp < $stack_top)
 				if (*($stackp) > _stext && *($stackp) < _sinittext)
@@ -45,7 +46,7 @@ define bttnobp
 				end
 				set $stackp += 4
 			end
-			set $next_th=(((char *)$next_th->pids[1].pid_list.next) - $pid_off)
+			set $next_th=(((char *)$next_th->thread_group.next) - $pid_off)
 		end
 		set $next_t=(char *)($next_t->tasks.next) - $tasks_off
 	end
@@ -54,42 +55,44 @@ document bttnobp
 	dump all thread stack traces on a kernel compiled with !CONFIG_FRAME_POINTER
 end
 
+define btthreadstack
+	set var $pid_task = $arg0
+
+	printf "\npid %d; comm %s:\n", $pid_task.pid, $pid_task.comm
+	printf "task struct: "
+	print $pid_task
+	printf "===================\n"
+	set var $stackp = $pid_task.thread.sp
+	set var $stacksize = sizeof(union thread_union)
+	set var $stack_top = ($stackp & ~($stacksize - 1)) + $stacksize
+	set var $stack_bot = ($stackp & ~($stacksize - 1))
+
+	set $stackp = *((unsigned long *) $stackp)
+	while (($stackp < $stack_top) && ($stackp > $stack_bot))
+		set var $addr = *(((unsigned long *) $stackp) + 1)
+		info symbol $addr
+		set $stackp = *((unsigned long *) $stackp)
+	end
+end
+document btthreadstack
+	 dump a thread stack using the given task structure pointer
+end
+
+
 define btt
 	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
-	set $pid_off=((size_t)&((struct task_struct *)0)->pids[1].pid_list.next)
+	set $pid_off=((size_t)&((struct task_struct *)0)->thread_group.next)
 	set $init_t=&init_task
 	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
 	while ($next_t != $init_t)
 		set $next_t=(struct task_struct *)$next_t
-		printf "\npid %d; comm %s:\n", $next_t.pid, $next_t.comm
-		printf "===================\n"
-		set var $stackp = $next_t.thread.esp
-		set var $stack_top = ($stackp & ~4095) + 4096
-		set var $stack_bot = ($stackp & ~4095)
-
-		set $stackp = *($stackp)
-		while (($stackp < $stack_top) && ($stackp > $stack_bot))
-			set var $addr = *($stackp + 4)
-			info symbol $addr
-			set $stackp = *($stackp)
-		end
+		btthreadstack $next_t
 
-		set $next_th=(((char *)$next_t->pids[1].pid_list.next) - $pid_off)
+		set $next_th=(((char *)$next_t->thread_group.next) - $pid_off)
 		while ($next_th != $next_t)
 			set $next_th=(struct task_struct *)$next_th
-			printf "\npid %d; comm %s:\n", $next_t.pid, $next_t.comm
-			printf "===================\n"
-			set var $stackp = $next_t.thread.esp
-			set var $stack_top = ($stackp & ~4095) + 4096
-			set var $stack_bot = ($stackp & ~4095)
-
-			set $stackp = *($stackp)
-			while (($stackp < $stack_top) && ($stackp > $stack_bot))
-				set var $addr = *($stackp + 4)
-				info symbol $addr
-				set $stackp = *($stackp)
-			end
-			set $next_th=(((char *)$next_th->pids[1].pid_list.next) - $pid_off)
+			btthreadstack $next_th
+			set $next_th=(((char *)$next_th->thread_group.next) - $pid_off)
 		end
 		set $next_t=(char *)($next_t->tasks.next) - $tasks_off
 	end
@@ -101,7 +104,7 @@ end
 define btpid
 	set var $pid = $arg0
 	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
-	set $pid_off=((size_t)&((struct task_struct *)0)->pids[1].pid_list.next)
+	set $pid_off=((size_t)&((struct task_struct *)0)->thread_group.next)
 	set $init_t=&init_task
 	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
 	set var $pid_task = 0
@@ -113,29 +116,18 @@ define btpid
 			set $pid_task = $next_t
 		end
 
-		set $next_th=(((char *)$next_t->pids[1].pid_list.next) - $pid_off)
+		set $next_th=(((char *)$next_t->thread_group.next) - $pid_off)
 		while ($next_th != $next_t)
 			set $next_th=(struct task_struct *)$next_th
 			if ($next_th.pid == $pid)
 				set $pid_task = $next_th
 			end
-			set $next_th=(((char *)$next_th->pids[1].pid_list.next) - $pid_off)
+			set $next_th=(((char *)$next_th->thread_group.next) - $pid_off)
 		end
 		set $next_t=(char *)($next_t->tasks.next) - $tasks_off
 	end
 
-	printf "\npid %d; comm %s:\n", $pid_task.pid, $pid_task.comm
-	printf "===================\n"
-	set var $stackp = $pid_task.thread.esp
-	set var $stack_top = ($stackp & ~4095) + 4096
-	set var $stack_bot = ($stackp & ~4095)
-
-	set $stackp = *($stackp)
-	while (($stackp < $stack_top) && ($stackp > $stack_bot))
-		set var $addr = *($stackp + 4)
-		info symbol $addr
-		set $stackp = *($stackp)
-	end
+	btthreadstack $pid_task
 end
 document btpid
 	backtrace of pid
@@ -145,7 +137,7 @@ end
 define trapinfo
 	set var $pid = $arg0
 	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
-	set $pid_off=((size_t)&((struct task_struct *)0)->pids[1].pid_list.next)
+	set $pid_off=((size_t)&((struct task_struct *)0)->thread_group.next)
 	set $init_t=&init_task
 	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
 	set var $pid_task = 0
@@ -157,13 +149,13 @@ define trapinfo
 			set $pid_task = $next_t
 		end
 
-		set $next_th=(((char *)$next_t->pids[1].pid_list.next) - $pid_off)
+		set $next_th=(((char *)$next_t->thread_group.next) - $pid_off)
 		while ($next_th != $next_t)
 			set $next_th=(struct task_struct *)$next_th
 			if ($next_th.pid == $pid)
 				set $pid_task = $next_th
 			end
-			set $next_th=(((char *)$next_th->pids[1].pid_list.next) - $pid_off)
+			set $next_th=(((char *)$next_th->thread_group.next) - $pid_off)
 		end
 		set $next_t=(char *)($next_t->tasks.next) - $tasks_off
 	end
_

Patches currently in -mm which might be from cminyard@mvista.com are

kdump-fix-dmesg-gdbmacro-to-work-with-record-based-printk.patch

