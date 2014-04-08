From: akpm@linux-foundation.org
Subject: [merged] procfs-make-proc-stacksyscallpersonality-0400.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:17:52 -0700
Message-ID: <53446780.Wn6dRJQM3cIPhkJV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbaDHVRx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:17:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, oleg@redhat.com, mingo@kernel.org, luto@amacapital.net, keescook@chromium.org, ebiederm@xmission.com, tixxdz@opendz.org

Subject: [merged] procfs-make-proc-stacksyscallpersonality-0400.patch removed from -mm tree
To: tixxdz@opendz.org,ebiederm@xmission.com,keescook@chromium.org,luto@amacapital.net,mingo@kernel.org,oleg@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:17:52 -0700


The patch titled
     Subject: procfs: make /proc/*/{stack,syscall,personality} 0400
has been removed from the -mm tree.  Its filename was
     procfs-make-proc-stacksyscallpersonality-0400.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Djalal Harouni <tixxdz@opendz.org>
Subject: procfs: make /proc/*/{stack,syscall,personality} 0400

These procfs files contain sensitive information and currently their mode
is 0444.  Change this to 0400, so the VFS will be able to block
unprivileged processes from getting file descriptors on arbitrary
privileged /proc/*/{stack,syscall,personality} files.

This reduces the scope of ASLR leaking and bypasses by protecting already
running processes.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Andy Lutomirski <luto@amacapital.net>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/proc/base.c~procfs-make-proc-stacksyscallpersonality-0400 fs/proc/base.c
--- a/fs/proc/base.c~procfs-make-proc-stacksyscallpersonality-0400
+++ a/fs/proc/base.c
@@ -2588,7 +2588,7 @@ static const struct pid_entry tgid_base_
 	REG("environ",    S_IRUSR, proc_environ_operations),
 	INF("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
-	ONE("personality", S_IRUGO, proc_pid_personality),
+	ONE("personality", S_IRUSR, proc_pid_personality),
 	INF("limits",	  S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
@@ -2598,7 +2598,7 @@ static const struct pid_entry tgid_base_
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",    S_IRUGO, proc_pid_syscall),
+	INF("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
@@ -2626,7 +2626,7 @@ static const struct pid_entry tgid_base_
 	INF("wchan",      S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUGO, proc_pid_stack),
+	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
@@ -2927,14 +2927,14 @@ static const struct pid_entry tid_base_s
 	REG("environ",   S_IRUSR, proc_environ_operations),
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
-	ONE("personality", S_IRUGO, proc_pid_personality),
+	ONE("personality", S_IRUSR, proc_pid_personality),
 	INF("limits",	 S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",   S_IRUGO, proc_pid_syscall),
+	INF("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
@@ -2964,7 +2964,7 @@ static const struct pid_entry tid_base_s
 	INF("wchan",     S_IRUGO, proc_pid_wchan),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUGO, proc_pid_stack),
+	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat", S_IRUGO, proc_pid_schedstat),
_

Patches currently in -mm which might be from tixxdz@opendz.org are

origin.patch

