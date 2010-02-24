From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-pid.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:34 -0800
Message-ID: <201002242019.o1OKJYU0018181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757998Ab0BXUVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:21:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com


The patch titled
     sysctl extern cleanup: pid
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-pid.patch

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
Subject: sysctl extern cleanup: pid
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

Move pid/pid_max_min/pid_max_max extern declarations to linux/pid.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    4 ++++
 kernel/sysctl.c     |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/pid.h~sysctl-extern-cleanup-pid include/linux/pid.h
--- a/include/linux/pid.h~sysctl-extern-cleanup-pid
+++ a/include/linux/pid.h
@@ -3,6 +3,10 @@
 
 #include <linux/rcupdate.h>
 
+/* for sysctl */
+extern int pid_max;
+extern int pid_max_min, pid_max_max;
+
 enum pid_type
 {
 	PIDTYPE_PID,
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-pid kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-pid
+++ a/kernel/sysctl.c
@@ -56,6 +56,7 @@
 #include <linux/rcustring.h>
 #include <linux/signal.h>
 #include <linux/binfmts.h>
+#include <linux/pid.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -75,9 +76,7 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-extern int pid_max;
 extern int min_free_kbytes;
-extern int pid_max_min, pid_max_max;
 extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
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

