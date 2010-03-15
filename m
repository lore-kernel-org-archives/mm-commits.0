From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-extern-cleanup-pid.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:49:59 -0400
Message-ID: <201003150650.o2F6oWPB015780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COGue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:50:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: pid
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-pid.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: pid
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

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
@@ -35,6 +35,7 @@
 #include <linux/net.h>
 #include <linux/sysrq.h>
 #include <linux/highuid.h>
+#include <linux/pid.h>
 #include <linux/writeback.h>
 #include <linux/ratelimit.h>
 #include <linux/hugetlb.h>
@@ -73,9 +74,7 @@ extern int sysctl_panic_on_oom;
 extern int sysctl_oom_kill_allocating_task;
 extern int sysctl_oom_dump_tasks;
 extern int max_threads;
-extern int pid_max;
 extern int min_free_kbytes;
-extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
sysctl-extern-cleanup-pid.patch
sysctl-extern-cleanup-mm.patch
sysctl-extern-cleanup-compat.patch
sysctl-extern-cleanup-latencytop.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-block-iopoll.patch
linux-next.patch

