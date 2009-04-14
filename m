From: akpm@linux-foundation.org
Subject: [merged] mm-move-the-scan_unevictable_pages-sysctl-to-the-vm-table.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:48:21 -0700
Message-ID: <200904141948.n3EJmLvt018999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbZDNTwj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: move the scan_unevictable_pages sysctl to the vm table
has been removed from the -mm tree.  Its filename was
     mm-move-the-scan_unevictable_pages-sysctl-to-the-vm-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move the scan_unevictable_pages sysctl to the vm table
From: Peter Zijlstra <peterz@infradead.org>

vm knobs should go in the vm table.  Probably too late for
randomize_va_space though.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN kernel/sysctl.c~mm-move-the-scan_unevictable_pages-sysctl-to-the-vm-table kernel/sysctl.c
--- a/kernel/sysctl.c~mm-move-the-scan_unevictable_pages-sysctl-to-the-vm-table
+++ a/kernel/sysctl.c
@@ -902,16 +902,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_UNEVICTABLE_LRU
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "scan_unevictable_pages",
-		.data		= &scan_unevictable_pages,
-		.maxlen		= sizeof(scan_unevictable_pages),
-		.mode		= 0644,
-		.proc_handler	= &scan_unevictable_handler,
-	},
-#endif
 #ifdef CONFIG_SLOW_WORK
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -1302,6 +1292,16 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_UNEVICTABLE_LRU
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "scan_unevictable_pages",
+		.data		= &scan_unevictable_pages,
+		.maxlen		= sizeof(scan_unevictable_pages),
+		.mode		= 0644,
+		.proc_handler	= &scan_unevictable_handler,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
linux-next.patch

