From: akpm@linux-foundation.org
Subject: + exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch added to -mm tree
Date: Tue, 21 Jul 2009 16:56:44 -0700
Message-ID: <200907212356.n6LNujpI020060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbZGUX50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 19:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, earl_chew@agilent.com, oleg@tv-sign.ru


The patch titled
     exec: let do_coredump() limit the number of concurrent dumps to pipes
has been added to the -mm tree.  Its filename is
     exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch

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
Subject: exec: let do_coredump() limit the number of concurrent dumps to pipes
From: Neil Horman <nhorman@tuxdriver.com>

Introduce core pipe limiting sysctl.

Since we can dump cores to pipe, rather than directly to the filesystem,
we create a condition in which a user can create a very high load on the
system simply by running bad applications.

If the pipe reader specified in core_pattern is poorly written, we can
have lots of ourstandig resources and processes in the system.

This sysctl introduces an ability to limit that resource consumption. 
core_pipe_limit defines how many in-flight dumps may be run in parallel,
dumps beyond this value are skipped and a note is made in the kernel log. 
A special value of 0 in core_pipe_limit denotes unlimited core dumps may
be handled (this is the default value).

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Earl Chew <earl_chew@agilent.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   22 ++++++++++++++++++++++
 fs/exec.c                       |   23 ++++++++++++++++++-----
 kernel/sysctl.c                 |    9 +++++++++
 3 files changed, 49 insertions(+), 5 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9 Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9
+++ a/Documentation/sysctl/kernel.txt
@@ -21,6 +21,7 @@ show up in /proc/sys/kernel:
 - acct
 - auto_msgmni
 - core_pattern
+- core_pipe_limit
 - core_uses_pid
 - ctrl-alt-del
 - dentry-state
@@ -119,6 +120,27 @@ core_pattern is used to specify a core d
 
 ==============================================================
 
+core_pipe_limit:
+
+This sysctl is only applicable when core_pattern is configured to pipe core
+files to user space helper a (when the first character of core_pattern is a '|',
+see above).  When collecting cores via a pipe to an application, it is
+occasionally usefull for the collecting application to gather data about the
+crashing process from its /proc/pid directory.  In order to do this safely, the
+kernel must wait for the collecting process to exit, so as not to remove the
+crashing processes proc files prematurely.  This in turn creates the possibility
+that a misbehaving userspace collecting process can block the reaping of a
+crashed process simply by never exiting.  This sysctl defends against that.  It
+defines how many concurrent crashing processes may be piped to user space
+applications in parallel.  If this value is exceeded, then those crashing
+processes above that value are noted via the kernel log and their cores are
+skipped.  0 is a special value, indicating that unlimited processes may be
+captured in parallel, but that no waiting will take place (i.e. the collecting
+process is not guaranteed access to /proc/<crahing pid>/).  This value defaults
+to 0.
+
+==============================================================
+
 core_uses_pid:
 
 The default coredump filename is "core".  By setting
diff -puN fs/exec.c~exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9 fs/exec.c
--- a/fs/exec.c~exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9
+++ a/fs/exec.c
@@ -63,6 +63,7 @@
 
 int core_uses_pid;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
+unsigned int core_pipe_limit;
 int suid_dumpable = 0;
 
 /* The maximal length of core_pattern is also specified in sysctl.c */
@@ -1733,7 +1734,8 @@ void do_coredump(long signr, int exit_co
 	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 	char **helper_argv = NULL;
 	int helper_argc = 0;
-	char *delimit;
+	int dump_count = 0;
+	static atomic_t core_dump_count = ATOMIC_INIT(0);
 
 	audit_core_dumps(signr);
 
@@ -1815,28 +1817,36 @@ void do_coredump(long signr, int exit_co
 			goto fail_unlock;
 		}
 
+		dump_count = atomic_inc_return(&core_dump_count);
+		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
+			printk(KERN_WARNING "Pid %d(%s) over core_pipe_limit\n",
+			       task_tgid_vnr(current), current->comm);
+			printk(KERN_WARNING "Skipping core dump\n");
+			goto fail_dropcount;
+		}
+
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
-			goto fail_unlock;
+			goto fail_dropcount;
 		}
 
 		core_limit = RLIM_INFINITY;
 
 		/* SIGPIPE can happen, but it's just never processed */
- 		if (call_usermodehelper_pipe(corename+1, helper_argv, NULL,
+ 		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
 				&file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
- 			goto fail_unlock;
+ 			goto fail_dropcount;
  		}
  	} else
  		file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
 	if (IS_ERR(file))
-		goto fail_unlock;
+		goto fail_dropcount;
 	inode = file->f_path.dentry->d_inode;
 	if (inode->i_nlink > 1)
 		goto close_fail;	/* multiple links - don't dump */
@@ -1866,6 +1876,9 @@ void do_coredump(long signr, int exit_co
 		current->signal->group_exit_code |= 0x80;
 close_fail:
 	filp_close(file, NULL);
+fail_dropcount:
+	if (dump_count)
+		atomic_dec(&core_dump_count);
 fail_unlock:
 	if (helper_argv)
 		argv_free(helper_argv);
diff -puN kernel/sysctl.c~exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9 kernel/sysctl.c
--- a/kernel/sysctl.c~exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9
+++ a/kernel/sysctl.c
@@ -77,6 +77,7 @@ extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
 extern char core_pattern[];
+extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
@@ -413,6 +414,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "core_pipe_limit",
+		.data		= &core_pipe_limit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #ifdef CONFIG_PROC_SYSCTL
 	{
 		.procname	= "tainted",
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

linux-next.patch
kmod-fix-race-in-usermodehelper-code.patch
proc-fix-reported-unit-for-rlimit_cpu.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch
exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9.patch

