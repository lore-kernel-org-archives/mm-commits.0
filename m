From: akpm@linux-foundation.org
Subject: [patch 2/3] radix tree test suite: fix compilation
Date: Wed, 07 Dec 2016 14:44:33 -0800
Message-ID: <584890d1.pxjiS4FIiqgBrT6Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933635AbcLGWoB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2016 17:44:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mawilcox@microsoft.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com

From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: radix tree test suite: fix compilation

Patch "lib/radix-tree: Convert to hotplug state machine" breaks the test
suite as it adds a call to cpuhp_setup_state_nocalls() which is not
currently emulated in the test suite.  Add it, and delete the emulation of
the old CPU hotplug mechanism.

Link: http://lkml.kernel.org/r/1480369871-5271-36-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                          |    1 
 tools/testing/radix-tree/linux/cpu.h      |   22 --------------------
 tools/testing/radix-tree/linux/notifier.h |    8 -------
 3 files changed, 1 insertion(+), 30 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-test-suite-fix-compilation lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-test-suite-fix-compilation
+++ a/lib/radix-tree.c
@@ -30,7 +30,6 @@
 #include <linux/percpu.h>
 #include <linux/slab.h>
 #include <linux/kmemleak.h>
-#include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/string.h>
 #include <linux/bitops.h>
diff -puN tools/testing/radix-tree/linux/cpu.h~radix-tree-test-suite-fix-compilation tools/testing/radix-tree/linux/cpu.h
--- a/tools/testing/radix-tree/linux/cpu.h~radix-tree-test-suite-fix-compilation
+++ a/tools/testing/radix-tree/linux/cpu.h
@@ -1,21 +1 @@
-
-#define hotcpu_notifier(a, b)
-
-#define CPU_ONLINE		0x0002 /* CPU (unsigned)v is up */
-#define CPU_UP_PREPARE		0x0003 /* CPU (unsigned)v coming up */
-#define CPU_UP_CANCELED		0x0004 /* CPU (unsigned)v NOT coming up */
-#define CPU_DOWN_PREPARE	0x0005 /* CPU (unsigned)v going down */
-#define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
-#define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
-#define CPU_POST_DEAD		0x0009 /* CPU (unsigned)v dead, cpu_hotplug
-					* lock is dropped */
-#define CPU_BROKEN		0x000C /* CPU (unsigned)v did not die properly,
-					* perhaps due to preemption. */
-#define CPU_TASKS_FROZEN	0x0010
-
-#define CPU_ONLINE_FROZEN	(CPU_ONLINE | CPU_TASKS_FROZEN)
-#define CPU_UP_PREPARE_FROZEN	(CPU_UP_PREPARE | CPU_TASKS_FROZEN)
-#define CPU_UP_CANCELED_FROZEN  (CPU_UP_CANCELED | CPU_TASKS_FROZEN)
-#define CPU_DOWN_PREPARE_FROZEN (CPU_DOWN_PREPARE | CPU_TASKS_FROZEN)
-#define CPU_DOWN_FAILED_FROZEN  (CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
-#define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
+#define cpuhp_setup_state_nocalls(a, b, c, d)	(0)
diff -puN tools/testing/radix-tree/linux/notifier.h~radix-tree-test-suite-fix-compilation /dev/null
--- a/tools/testing/radix-tree/linux/notifier.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _NOTIFIER_H
-#define _NOTIFIER_H
-
-struct notifier_block;
-
-#define NOTIFY_OK              0x0001          /* Suits me */
