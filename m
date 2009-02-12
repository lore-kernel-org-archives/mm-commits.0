From: akpm@linux-foundation.org
Subject: [merged] mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:25:14 -0800
Message-ID: <200902122025.n1CKPEOL014374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758754AbZBLUfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:35:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sven.wegener@stealer.net, cl@linux-foundation.org, david@fromorbit.com, peterz@infradead.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix dirty_bytes/dirty_background_bytes sysctls on 64bit arches
has been removed from the -mm tree.  Its filename was
     mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix dirty_bytes/dirty_background_bytes sysctls on 64bit arches
From: Sven Wegener <sven.wegener@stealer.net>

We need to pass an unsigned long as the minimum, because it gets casted
to an unsigned long in the sysctl handler. If we pass an int, we'll
access four more bytes on 64bit arches, resulting in a random minimum
value.

[rientjes@google.com: fix type of `old_bytes']
Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c     |    5 +++--
 mm/page-writeback.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/sysctl.c~mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches kernel/sysctl.c
--- a/kernel/sysctl.c~mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches
+++ a/kernel/sysctl.c
@@ -101,6 +101,7 @@ static int two = 2;
 
 static int zero;
 static int one = 1;
+static unsigned long one_ul = 1;
 static int one_hundred = 100;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
@@ -974,7 +975,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &dirty_background_bytes_handler,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &one,
+		.extra1		= &one_ul,
 	},
 	{
 		.ctl_name	= VM_DIRTY_RATIO,
@@ -995,7 +996,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &dirty_bytes_handler,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &one,
+		.extra1		= &one_ul,
 	},
 	{
 		.procname	= "dirty_writeback_centisecs",
diff -puN mm/page-writeback.c~mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches mm/page-writeback.c
--- a/mm/page-writeback.c~mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches
+++ a/mm/page-writeback.c
@@ -209,7 +209,7 @@ int dirty_bytes_handler(struct ctl_table
 		struct file *filp, void __user *buffer, size_t *lenp,
 		loff_t *ppos)
 {
-	int old_bytes = vm_dirty_bytes;
+	unsigned long old_bytes = vm_dirty_bytes;
 	int ret;
 
 	ret = proc_doulongvec_minmax(table, write, filp, buffer, lenp, ppos);
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

origin.patch

