From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-binfmts.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:31 -0800
Message-ID: <201002242019.o1OKJV3j018178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757743Ab0BXUUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:20:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, a.p.zijlstra@chello.nl, adobriyan@gmail.com, ebiederm@xmission.com, jmorris@namei.org, mingo@elte.hu


The patch titled
     sysctl extern cleanup: binfmts
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-binfmts.patch

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
Subject: sysctl extern cleanup: binfmts
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

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
+extern char *core_pattern;
+extern unsigned int core_pipe_limit;
+
 #define CORENAME_MAX_SIZE 128
 
 /*
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-binfmts kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-binfmts
+++ a/kernel/sysctl.c
@@ -55,6 +55,7 @@
 #include <linux/perf_event.h>
 #include <linux/rcustring.h>
 #include <linux/signal.h>
+#include <linux/binfmts.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -74,10 +75,6 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-extern int core_uses_pid;
-extern int suid_dumpable;
-extern char *core_pattern;
-extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
sysctl-extern-cleanup-c_a_d.patch
sysctl-extern-cleanup-signal.patch
sysctl-extern-cleanup-binfmts.patch
sysctl-extern-cleanup-pid.patch
sysctl-extern-cleanup-mm.patch
sysctl-extern-cleanup-compat.patch
sysctl-extern-cleanup-latencytop.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-rcu.patch
sysctl-extern-cleanup-block-iopoll.patch
sysctl-extern-cleanup-module.patch
sysctl-extern-cleanup-sg.patch
sysctl-extern-cleanup-acct.patch
sysctl-extern-cleanup-rtmutex.patch
sysctl-extern-cleanup-lockdep.patch
sysctl-extern-cleanup-poll.patch
sysctl-extern-cleanup-inotify.patch

