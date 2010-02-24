From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-poll.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:58 -0800
Message-ID: <201002242019.o1OKJwrW018236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757732Ab0BXUUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:20:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com


The patch titled
     sysctl extern cleanup: poll
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-poll.patch

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
Subject: sysctl extern cleanup: poll
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

Move epoll_table extern declaration to linux/poll.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poll.h |    2 ++
 kernel/sysctl.c      |    6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/poll.h~sysctl-extern-cleanup-poll include/linux/poll.h
--- a/include/linux/poll.h~sysctl-extern-cleanup-poll
+++ a/include/linux/poll.h
@@ -10,8 +10,10 @@
 #include <linux/wait.h>
 #include <linux/string.h>
 #include <linux/fs.h>
+#include <linux/sysctl.h>
 #include <asm/uaccess.h>
 
+extern struct ctl_table epoll_table[]; /* for sysctl */
 /* ~832 bytes of stack space used max in sys_select/sys_poll before allocating
    additional memory. */
 #define MAX_STACK_ALLOC 832
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-poll kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-poll
+++ a/kernel/sysctl.c
@@ -72,6 +72,9 @@
 #if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_LOCK_STAT)
 #include <linux/lockdep.h>
 #endif
+#ifdef CONFIG_EPOLL
+#include <linux/poll.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -178,9 +181,6 @@ extern struct ctl_table random_table[];
 #ifdef CONFIG_INOTIFY_USER
 extern struct ctl_table inotify_table[];
 #endif
-#ifdef CONFIG_EPOLL
-extern struct ctl_table epoll_table[];
-#endif
 
 /* The default sysctl tables: */
 
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

