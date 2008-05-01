From: akpm@linux-foundation.org
Subject: - mm-bdi-export-bdi_writeout_inc.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:54 -0700
Message-ID: <200805010931.m419VsMo030915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755870AbYEAJb7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: bdi: export bdi_writeout_inc()
has been removed from the -mm tree.  Its filename was
     mm-bdi-export-bdi_writeout_inc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: bdi: export bdi_writeout_inc()
From: Miklos Szeredi <mszeredi@suse.cz>

Fuse needs this for writable mmap support.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    2 ++
 mm/page-writeback.c         |   10 ++++++++++
 2 files changed, 12 insertions(+)

diff -puN include/linux/backing-dev.h~mm-bdi-export-bdi_writeout_inc include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-bdi-export-bdi_writeout_inc
+++ a/include/linux/backing-dev.h
@@ -135,6 +135,8 @@ static inline s64 bdi_stat_sum(struct ba
 	return sum;
 }
 
+extern void bdi_writeout_inc(struct backing_dev_info *bdi);
+
 /*
  * maximal error of a stat counter.
  */
diff -puN mm/page-writeback.c~mm-bdi-export-bdi_writeout_inc mm/page-writeback.c
--- a/mm/page-writeback.c~mm-bdi-export-bdi_writeout_inc
+++ a/mm/page-writeback.c
@@ -168,6 +168,16 @@ static inline void __bdi_writeout_inc(st
 			      bdi->max_prop_frac);
 }
 
+void bdi_writeout_inc(struct backing_dev_info *bdi)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__bdi_writeout_inc(bdi);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(bdi_writeout_inc);
+
 static inline void task_dirty_inc(struct task_struct *tsk)
 {
 	prop_inc_single(&vm_dirties, &tsk->dirties);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-permission-checking-in-sys_utimensat.patch

