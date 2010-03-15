From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-extern-cleanup-binfmts.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:49:55 -0400
Message-ID: <201003150650.o2F6oS30015774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758806Ab0COGur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, a.p.zijlstra@chello.nl, adobriyan@gmail.com, ebiederm@xmission.com, jmorris@namei.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: binfmts
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-binfmts.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: binfmts
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

Move core_uses_pid/core_pattern/core_pipe_limit extern declarations to
linux/binfmts.h. suid_dumpable is declared in binfmts.h already.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: James Morris <jmorris@namei.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/binfmts.h |    5 +++++
 kernel/sysctl.c         |    5 +----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN include/linux/binfmts.h~sysctl-extern-cleanup-binfmts include/linux/binfmts.h
--- a/include/linux/binfmts.h~sysctl-extern-cleanup-binfmts
+++ a/include/linux/binfmts.h
@@ -20,6 +20,11 @@ struct pt_regs;
 #ifdef __KERNEL__
 #include <linux/list.h>
 
+/* for sysctl */
+extern int core_uses_pid;
+extern char core_pattern[];
+extern unsigned int core_pipe_limit;
+
 #define CORENAME_MAX_SIZE 128
 
 /*
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-binfmts kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-binfmts
+++ a/kernel/sysctl.c
@@ -43,6 +43,7 @@
 #include <linux/times.h>
 #include <linux/limits.h>
 #include <linux/dcache.h>
+#include <linux/binfmts.h>
 #include <linux/syscalls.h>
 #include <linux/vmstat.h>
 #include <linux/nfs_fs.h>
@@ -72,10 +73,6 @@ extern int sysctl_panic_on_oom;
 extern int sysctl_oom_kill_allocating_task;
 extern int sysctl_oom_dump_tasks;
 extern int max_threads;
-extern int core_uses_pid;
-extern int suid_dumpable;
-extern char core_pattern[];
-extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
sysctl-extern-cleanup-binfmts.patch
sysctl-extern-cleanup-pid.patch
sysctl-extern-cleanup-mm.patch
sysctl-extern-cleanup-compat.patch
sysctl-extern-cleanup-latencytop.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-block-iopoll.patch
linux-next.patch

