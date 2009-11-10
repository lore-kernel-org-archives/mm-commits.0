From: akpm@linux-foundation.org
Subject: + prctl-add-pr_set_proctitle_area-option.patch added to -mm tree
Date: Mon, 09 Nov 2009 16:50:45 -0800
Message-ID: <200911100050.nAA0ojCk007497__30237.0657249869$1257814278$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbZKJAvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 19:51:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tss@iki.fi, bdonlan@gmail.com, drepper@redhat.com, kosaki.motohiro@jp.fujitsu.com, linux-api@vger.kernel.org, xiyou.wangcong@gmail.com


The patch titled
     prctl(): add PR_SET_PROCTITLE_AREA option
has been added to the -mm tree.  Its filename is
     prctl-add-pr_set_proctitle_area-option.patch

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
Subject: prctl(): add PR_SET_PROCTITLE_AREA option
From: Timo Sirainen <tss@iki.fi>

Currently glibc2 doesn't have setproctitle(3), so several userland daemons
attempt to emulate it by doing some brutal stack modifications.  This
works most of the time, but it has problems.  For example:

 % ps -ef |grep avahi-daemon
 avahi     1679     1  0 09:20 ?        00:00:00 avahi-daemon: running [kosadesk.local]

 # cat /proc/1679/cmdline
 avahi-daemon: running [kosadesk.local]

This looks good, but the process has also overwritten its environment
area and made the environ file useless:

 # cat /proc/1679/environ
 adesk.local]

Another problem is that the process title length is limited by the size of
the environment.  Security conscious people try to avoid potential
information leaks by clearing most of the environment before running a
daemon:

 # env - MINIMUM_NEEDED_VAR=foo /path/to/daemon

The resulting environment size may be too small to fit the wanted process
titles.

This patch makes it possible for userspace to implement setproctitle()
cleanly.  It adds a new PR_SET_PROCTITLE_AREA option for prctl(), which
updates task's mm_struct->arg_start and arg_end to the given area.

 test_setproctitle.c
 ================================================
 #include <string.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <stdio.h>
 #include <sys/prctl.h>

 #define ERR(str) (perror(str), exit(1))

 void settitle(char* title){
         int err;

         err = prctl(34, title, strlen(title)+1);
         if (err < 0)
                 ERR("prctl ");
 }

 void main(void){
         long i;
         char buf[1024];

         for (i = 0; i < 10000000000LL; i++){
                 sprintf(buf, "loooooooooooooooooooooooong string %d",i);
                 settitle(buf);
         }
 }
 ==================================================

Cc: Bryan Donlan <bdonlan@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Timo Sirainen <tss@iki.fi>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: <linux-api@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/proc/base.c~prctl-add-pr_set_proctitle_area-option fs/proc/base.c
--- a/fs/proc/base.c~prctl-add-pr_set_proctitle_area-option
+++ a/fs/proc/base.c
@@ -257,32 +257,45 @@ static int proc_pid_cmdline(struct task_
 	int res = 0;
 	unsigned int len;
 	struct mm_struct *mm = get_task_mm(task);
+
 	if (!mm)
 		goto out;
+
+	/* The process was not constructed yet? */
 	if (!mm->arg_end)
 		goto out_mm;	/* Shh! No looking before we're done */
 
- 	len = mm->arg_end - mm->arg_start;
- 
+	mutex_lock(&mm->arg_lock);
+	len = mm->arg_end - mm->arg_start;
 	if (len > PAGE_SIZE)
 		len = PAGE_SIZE;
- 
+
 	res = access_process_vm(task, mm->arg_start, buffer, len, 0);
+	if (mm->arg_end != mm->env_start)
+		/* prctl(PR_SET_PROCTITLE_AREA) used */
+		goto out_unlock;
 
-	// If the nul at the end of args has been overwritten, then
-	// assume application is using setproctitle(3).
+	/*
+	 * If the nul at the end of args has been overwritten, then assume
+	 * application is using sendmail's SPT_REUSEARGV style argv override.
+	 */
 	if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
 		len = strnlen(buffer, res);
-		if (len < res) {
-		    res = len;
-		} else {
+		if (len < res)
+			res = len;
+		else {
 			len = mm->env_end - mm->env_start;
 			if (len > PAGE_SIZE - res)
 				len = PAGE_SIZE - res;
-			res += access_process_vm(task, mm->env_start, buffer+res, len, 0);
+			res += access_process_vm(task, mm->env_start,
+						 buffer+res, len, 0);
 			res = strnlen(buffer, res);
 		}
 	}
+
+out_unlock:
+	mutex_unlock(&mm->arg_lock);
+
 out_mm:
 	mmput(mm);
 out:
diff -puN include/linux/mm_types.h~prctl-add-pr_set_proctitle_area-option include/linux/mm_types.h
--- a/include/linux/mm_types.h~prctl-add-pr_set_proctitle_area-option
+++ a/include/linux/mm_types.h
@@ -12,6 +12,7 @@
 #include <linux/completion.h>
 #include <linux/cpumask.h>
 #include <linux/page-debug-flags.h>
+#include <linux/mutex.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 
@@ -236,6 +237,7 @@ struct mm_struct {
 	unsigned long stack_vm, reserved_vm, def_flags, nr_ptes;
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long start_brk, brk, start_stack;
+	struct mutex arg_lock;
 	unsigned long arg_start, arg_end, env_start, env_end;
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
diff -puN include/linux/prctl.h~prctl-add-pr_set_proctitle_area-option include/linux/prctl.h
--- a/include/linux/prctl.h~prctl-add-pr_set_proctitle_area-option
+++ a/include/linux/prctl.h
@@ -102,4 +102,7 @@
 
 #define PR_MCE_KILL_GET 34
 
+/* Set process title memory area for setproctitle() */
+#define PR_SET_PROCTITLE_AREA 34
+
 #endif /* _LINUX_PRCTL_H */
diff -puN kernel/fork.c~prctl-add-pr_set_proctitle_area-option kernel/fork.c
--- a/kernel/fork.c~prctl-add-pr_set_proctitle_area-option
+++ a/kernel/fork.c
@@ -459,6 +459,7 @@ static struct mm_struct * mm_init(struct
 	mm->cached_hole_size = ~0UL;
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
+	mutex_init(&mm->arg_lock);
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
diff -puN kernel/sys.c~prctl-add-pr_set_proctitle_area-option kernel/sys.c
--- a/kernel/sys.c~prctl-add-pr_set_proctitle_area-option
+++ a/kernel/sys.c
@@ -1424,6 +1424,28 @@ static void k_getrusage(struct task_stru
 			} while (t != p);
 			break;
 
+		case PR_SET_PROCTITLE_AREA: {
+			struct mm_struct *mm = current->mm;
+			unsigned long addr = arg2;
+			unsigned long len = arg3;
+			unsigned long end = arg2 + arg3;
+
+			if (len > PAGE_SIZE)
+				return -EINVAL;
+
+			if (addr >= end)
+				return -EINVAL;
+
+			if (!access_ok(VERIFY_READ, addr, len))
+				return -EFAULT;
+
+			mutex_lock(&mm->arg_lock);
+			mm->arg_start = addr;
+			mm->arg_end = end;
+			mutex_unlock(&mm->arg_lock);
+
+			return 0;
+		}
 		default:
 			BUG();
 	}
_

Patches currently in -mm which might be from tss@iki.fi are

prctl-add-pr_set_proctitle_area-option.patch

