From: akpm@linux-foundation.org
Subject: + sysctl-extern-cleanup-acct.patch added to -mm tree
Date: Wed, 24 Feb 2010 12:19:52 -0800
Message-ID: <201002242019.o1OKJqaX018216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758008Ab0BXUVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 15:21:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com


The patch titled
     sysctl extern cleanup: acct
has been added to the -mm tree.  Its filename is
     sysctl-extern-cleanup-acct.patch

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
Subject: sysctl extern cleanup: acct
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be move to their own head file, and
then include them in relavant .c files.

Move acct_parm extern declaration to linux/acct.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acct.h |    1 +
 kernel/sysctl.c      |    7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/acct.h~sysctl-extern-cleanup-acct include/linux/acct.h
--- a/include/linux/acct.h~sysctl-extern-cleanup-acct
+++ a/include/linux/acct.h
@@ -121,6 +121,7 @@ struct vfsmount;
 struct super_block;
 struct pacct_struct;
 struct pid_namespace;
+extern int acct_parm[]; /* for sysctl */
 extern void acct_auto_close_mnt(struct vfsmount *m);
 extern void acct_auto_close(struct super_block *sb);
 extern void acct_collect(long exitcode, int group_dead);
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-acct kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-acct
+++ a/kernel/sysctl.c
@@ -63,6 +63,9 @@
 #ifdef CONFIG_BLOCK
 #include <linux/blk-iopoll.h>
 #endif
+#ifdef CONFIG_BSD_PROCESS_ACCT
+#include <linux/acct.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -132,10 +135,6 @@ extern int sysctl_userprocess_debug;
 extern int spin_retry;
 #endif
 
-#ifdef CONFIG_BSD_PROCESS_ACCT
-extern int acct_parm[];
-#endif
-
 #ifdef CONFIG_IA64
 extern int no_unaligned_warning;
 extern int unaligned_dump_stack;
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

