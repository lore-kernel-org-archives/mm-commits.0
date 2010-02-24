From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-rcu.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:44 -0800
Message-ID: <201002242019.o1OKJi5u018201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757743Ab0BXUU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:20:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, josh@joshtriplett.org, paulmck@linux.vnet.ibm.com


The patch titled
     sysctl extern cleanup: rcu
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-rcu.patch

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
Subject: sysctl extern cleanup: rcu
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

Move rcutorture_runnable extern declaration to linux/rcupdate.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupdate.h |    4 ++++
 kernel/sysctl.c          |    3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/rcupdate.h~sysctl-extern-cleanup-rcu include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~sysctl-extern-cleanup-rcu
+++ a/include/linux/rcupdate.h
@@ -41,6 +41,10 @@
 #include <linux/lockdep.h>
 #include <linux/completion.h>
 
+#ifdef CONFIG_RCU_TORTURE_TEST
+extern int rcutorture_runnable; /* for sysctl */
+#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
+
 /**
  * struct rcu_head - callback structure for use with RCU
  * @next: next update requests in a list
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-rcu kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-rcu
+++ a/kernel/sysctl.c
@@ -79,9 +79,6 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-#ifdef CONFIG_RCU_TORTURE_TEST
-extern int rcutorture_runnable;
-#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 #ifdef CONFIG_BLOCK
 extern int blk_iopoll_enabled;
 #endif
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

