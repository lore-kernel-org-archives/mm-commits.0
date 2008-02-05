From: akpm@linux-foundation.org
Subject: - uml-make-mconsole_stack-namespace-aware.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:39:03 -0800
Message-ID: <200802052238.m15MciLb012981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762665AbYBEWm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     uml: make mconsole_stack namespace-aware
has been removed from the -mm tree.  Its filename was
     uml-make-mconsole_stack-namespace-aware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: make mconsole_stack namespace-aware
From: Jeff Dike <jdike@addtoit.com>

Also fixed the include syntax while I was there.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |   35 +++++++++++++++---------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-make-mconsole_stack-namespace-aware arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-make-mconsole_stack-namespace-aware
+++ a/arch/um/drivers/mconsole_kern.c
@@ -1,24 +1,25 @@
 /*
  * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org)
- * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Copyright (C) 2001 - 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/console.h"
-#include "linux/ctype.h"
-#include "linux/interrupt.h"
-#include "linux/list.h"
-#include "linux/mm.h"
-#include "linux/module.h"
-#include "linux/notifier.h"
-#include "linux/reboot.h"
-#include "linux/proc_fs.h"
-#include "linux/slab.h"
-#include "linux/syscalls.h"
-#include "linux/utsname.h"
-#include "linux/workqueue.h"
-#include "linux/mutex.h"
-#include "asm/uaccess.h"
+#include <linux/console.h>
+#include <linux/ctype.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/proc_fs.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/utsname.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <asm/uaccess.h>
+
 #include "init.h"
 #include "irq_kern.h"
 #include "irq_user.h"
@@ -765,7 +766,7 @@ void mconsole_stack(struct mc_request *r
 		return;
 	}
 
-	to = find_task_by_pid(pid_requested);
+	to = find_task_by_pid_ns(pid_requested, &init_pid_ns);
 	if ((to == NULL) || (pid_requested == 0)) {
 		mconsole_reply(req, "Couldn't find that pid", 1, 0);
 		return;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
