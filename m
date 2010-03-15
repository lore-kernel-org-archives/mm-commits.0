From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-extern-cleanup-compat.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:50:03 -0400
Message-ID: <201003150650.o2F6oaL0015791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COGup (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:50:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: compat
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-compat.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: compat
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

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
@@ -25,6 +25,7 @@
 #include <linux/sysctl.h>
 #include <linux/signal.h>
 #include <linux/proc_fs.h>
+#include <linux/compat.h>
 #include <linux/security.h>
 #include <linux/ctype.h>
 #include <linux/kmemcheck.h>
@@ -76,7 +77,6 @@ extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
-extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifndef CONFIG_MMU
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
sysctl-extern-cleanup-compat.patch
sysctl-extern-cleanup-latencytop.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-block-iopoll.patch
linux-next.patch

