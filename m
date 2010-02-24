From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-signal.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:29 -0800
Message-ID: <201002242019.o1OKJTgf018175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757743Ab0BXUUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:20:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, oleg@redhat.com, roland@redhat.com


The patch titled
     sysctl extern cleanup: signal
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-signal.patch

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
Subject: sysctl extern cleanup: signal
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

Move print_fatal_signals extern declaration to linux/signal.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    2 ++
 kernel/sysctl.c        |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/signal.h~sysctl-extern-cleanup-signal include/linux/signal.h
--- a/include/linux/signal.h~sysctl-extern-cleanup-signal
+++ a/include/linux/signal.h
@@ -7,6 +7,8 @@
 #ifdef __KERNEL__
 #include <linux/list.h>
 
+/* for sysctl */
+extern int print_fatal_signals;
 /*
  * Real Time signals may be queued.
  */
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-signal kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-signal
+++ a/kernel/sysctl.c
@@ -54,6 +54,7 @@
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
 #include <linux/rcustring.h>
+#include <linux/signal.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -72,7 +73,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int print_fatal_signals;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
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

