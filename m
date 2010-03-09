From: akpm@linux-foundation.org
Subject: [merged] mm-use-the-same-log-level-for-show_mem.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:50 -0800
Message-ID: <201003091904.o29J4oml031070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755757Ab0CITFY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:05:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: use the same log level for show_mem()
has been removed from the -mm tree.  Its filename was
     mm-use-the-same-log-level-for-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: use the same log level for show_mem()
From: Amerigo Wang <amwang@redhat.com>

Use the same log level for printk's in show_mem(), so that those messages
can be shown completely when using log level 6.

Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/show_mem.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN lib/show_mem.c~mm-use-the-same-log-level-for-show_mem lib/show_mem.c
--- a/lib/show_mem.c~mm-use-the-same-log-level-for-show_mem
+++ a/lib/show_mem.c
@@ -15,7 +15,7 @@ void show_mem(void)
 	unsigned long total = 0, reserved = 0, shared = 0,
 		nonshared = 0, highmem = 0;
 
-	printk(KERN_INFO "Mem-Info:\n");
+	printk("Mem-Info:\n");
 	show_free_areas();
 
 	for_each_online_pgdat(pgdat) {
@@ -49,15 +49,15 @@ void show_mem(void)
 		pgdat_resize_unlock(pgdat, &flags);
 	}
 
-	printk(KERN_INFO "%lu pages RAM\n", total);
+	printk("%lu pages RAM\n", total);
 #ifdef CONFIG_HIGHMEM
-	printk(KERN_INFO "%lu pages HighMem\n", highmem);
+	printk("%lu pages HighMem\n", highmem);
 #endif
-	printk(KERN_INFO "%lu pages reserved\n", reserved);
-	printk(KERN_INFO "%lu pages shared\n", shared);
-	printk(KERN_INFO "%lu pages non-shared\n", nonshared);
+	printk("%lu pages reserved\n", reserved);
+	printk("%lu pages shared\n", shared);
+	printk("%lu pages non-shared\n", nonshared);
 #ifdef CONFIG_QUICKLIST
-	printk(KERN_INFO "%lu pages in pagetable cache\n",
+	printk("%lu pages in pagetable cache\n",
 		quicklist_total_size());
 #endif
 }
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
cpufreq-unexport-unlock_policy_rwsem-functions.patch
cpufreq-fix-a-lockdep-warning.patch
markup_oops-fix-perlcritic-warnings.patch
headerdep-perlcritic-warning.patch

