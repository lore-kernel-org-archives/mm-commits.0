From: akpm@linux-foundation.org
Subject: [merged] sysctl-extern-cleanup-acct.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:05:11 -0400
Message-ID: <201003150705.o2F75iYC017110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933035Ab0COHFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: acct
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-acct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: acct
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

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
@@ -69,6 +69,9 @@
 #include <asm/stacktrace.h>
 #include <asm/io.h>
 #endif
+#ifdef CONFIG_BSD_PROCESS_ACCT
+#include <linux/acct.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -135,10 +138,6 @@ extern int sysctl_userprocess_debug;
 extern int spin_retry;
 #endif
 
-#ifdef CONFIG_BSD_PROCESS_ACCT
-extern int acct_parm[];
-#endif
