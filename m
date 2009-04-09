From: akpm@linux-foundation.org
Subject: + mm-move-the-scan_unevictable_pages-sysctl-to-the-vm-table.patch added to -mm tree
Date: Thu, 09 Apr 2009 09:39:38 -0700
Message-ID: <200904091639.n39Gdc1x009016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936396AbZDIQn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 12:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     mm: move the scan_unevictable_pages sysctl to the vm table
has been added to the -mm tree.  Its filename is
     mm-move-the-scan_unevictable_pages-sysctl-to-the-vm-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

mm-move-the-scan_unevictable_pages-sysctl-to-the-vm-table.patch

