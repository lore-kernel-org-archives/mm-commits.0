From: akpm@linux-foundation.org
Subject: [merged] sysctl-extern-cleanup-signal.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:59 -0400
Message-ID: <201003150705.o2F75WkB017098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933525Ab0COHFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sysctl extern cleanup: signal
has been removed from the -mm tree.  Its filename was
     sysctl-extern-cleanup-signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl extern cleanup: signal
From: Dave Young <hidave.darkstar@gmail.com>

Extern declarations in sysctl.c should be moved to their own header file,
and then include them in relavant .c files.

Move print_fatal_signals extern declaration to linux/signal.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    2 ++
 kernel/sysctl.c        |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/signal.h~sysctl-extern-cleanup-signal include/linux/signal.h
--- a/include/linux/signal.h~sysctl-extern-cleanup-signal
+++ a/include/linux/signal.h
@@ -7,6 +7,8 @@
 #ifdef __KERNEL__
 #include <linux/list.h>
 
+/* for sysctl */
+extern int print_fatal_signals;
 /*
  * Real Time signals may be queued.
  */
diff -puN kernel/sysctl.c~sysctl-extern-cleanup-signal kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-extern-cleanup-signal
+++ a/kernel/sysctl.c
@@ -23,6 +23,7 @@
 #include <linux/swap.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
+#include <linux/signal.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
 #include <linux/ctype.h>
@@ -65,7 +66,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int print_fatal_signals;
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
linux-next.patch

