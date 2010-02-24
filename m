From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-compat.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:38 -0800
Message-ID: <201002242019.o1OKJcNs018188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757998Ab0BXUV7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:21:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, arnd@arndb.de


The patch titled
     sysctl extern cleanup: compat
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-compat.patch

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
Subject: sysctl extern cleanup: compat
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

Move compat_log extern declaration to linux/compat.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    1 +
 kernel/sysctl.c        |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/compat.h~sysctl-extern-cleanup-compat include/linux/compat.h
--- a/include/linux/compat.h~sysctl-extern-cleanup-compat
+++ a/include/linux/compat.h
@@ -17,6 +17,7 @@
 #include <asm/siginfo.h>
 #include <asm/signal.h>
 
+extern int compat_log; /* for sysctl */
 #define compat_jiffies_to_clock_t(x)	\
 		(((unsigned long)(x) * COMPAT_USER_HZ) / HZ)
 
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-compat kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-compat
+++ a/kernel/sysctl.c
@@ -57,6 +57,7 @@
 #include <linux/signal.h>
 #include <linux/binfmts.h>
 #include <linux/pid.h>
+#include <linux/compat.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -76,7 +77,6 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifdef CONFIG_RCU_TORTURE_TEST
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

