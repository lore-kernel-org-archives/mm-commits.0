From: akpm@linux-foundation.org
Subject: - use-defines-in-sys_getpriority-sys_setpriority.patch removed from -mm tree
Date: Fri, 11 May 2007 22:34:12 -0700
Message-ID: <200705120534.l4C5YCKS002186@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755242AbXELFeY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:34:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     use defines in sys_getpriority/sys_setpriority
has been removed from the -mm tree.  Its filename was
     use-defines-in-sys_getpriority-sys_setpriority.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use defines in sys_getpriority/sys_setpriority
From: Daniel Walker <dwalker@mvista.com>

Switch to the defines for these two checks, instead of hard coding the
values.

[akpm@linux-foundation.org: add missing include]
Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~use-defines-in-sys_getpriority-sys_setpriority kernel/sys.c
--- a/kernel/sys.c~use-defines-in-sys_getpriority-sys_setpriority
+++ a/kernel/sys.c
@@ -14,6 +14,7 @@
 #include <linux/prctl.h>
 #include <linux/highuid.h>
 #include <linux/fs.h>
+#include <linux/resource.h>
 #include <linux/kernel.h>
 #include <linux/kexec.h>
 #include <linux/workqueue.h>
@@ -659,7 +660,7 @@ asmlinkage long sys_setpriority(int whic
 	int error = -EINVAL;
 	struct pid *pgrp;
 
-	if (which > 2 || which < 0)
+	if (which > PRIO_USER || which < PRIO_PROCESS)
 		goto out;
 
 	/* normalize: avoid signed division (rounding problems) */
@@ -723,7 +724,7 @@ asmlinkage long sys_getpriority(int whic
 	long niceval, retval = -ESRCH;
 	struct pid *pgrp;
 
-	if (which > 2 || which < 0)
+	if (which > PRIO_USER || which < PRIO_PROCESS)
 		return -EINVAL;
 
 	read_lock(&tasklist_lock);
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
