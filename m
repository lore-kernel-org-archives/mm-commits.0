From: akpm@linux-foundation.org
Subject: [merged] sysctl-extern-cleanup-inotify.patch removed from -mm tree
Date: Thu, 04 Mar 2010 11:41:59 -0800
Message-ID: <201003041941.o24JfxQo025965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932233Ab0CDTmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 14:42:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, eparis@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: inotify
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-inotify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: inotify
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

Move inotify_table extern declaration to linux/inotify.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/inotify.h |    5 +++++
 kernel/sysctl.c         |    6 +++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN include/linux/inotify.h~sysctl-extern-cleanup-inotify include/linux/inotify.h
--- a/include/linux/inotify.h~sysctl-extern-cleanup-inotify
+++ a/include/linux/inotify.h
@@ -69,4 +69,9 @@ struct inotify_event {
 #define IN_CLOEXEC O_CLOEXEC
 #define IN_NONBLOCK O_NONBLOCK
 
+#ifdef __KERNEL__
+#include <linux/sysctl.h>
+extern struct ctl_table inotify_table[]; /* for sysctl */
+#endif
+
 #endif	/* _LINUX_INOTIFY_H */
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-inotify kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-inotify
+++ a/kernel/sysctl.c
@@ -85,6 +85,9 @@
 #ifdef CONFIG_EPOLL
 #include <linux/poll.h>
 #endif
+#ifdef CONFIG_INOTIFY_USER
+#include <linux/inotify.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -179,9 +182,6 @@ static struct ctl_table fs_table[];
 static struct ctl_table debug_table[];
 static struct ctl_table dev_table[];
 extern struct ctl_table random_table[];
-#ifdef CONFIG_INOTIFY_USER
-extern struct ctl_table inotify_table[];
-#endif
 
 /* The default sysctl tables: */
 
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
documentation-email-clientstxt-update-gmail-information.patch
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

