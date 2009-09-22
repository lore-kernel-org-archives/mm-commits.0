From: akpm@linux-foundation.org
Subject: [merged] mm-move-use_mm-unuse_mm-from-aioc-to-mm.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:43:50 -0700
Message-ID: <200909222043.n8MKhoK7012396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132AbZIVUnu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@redhat.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: move use_mm/unuse_mm from aio.c to mm/
has been removed from the -mm tree.  Its filename was
     mm-move-use_mm-unuse_mm-from-aioc-to-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move use_mm/unuse_mm from aio.c to mm/
From: "Michael S. Tsirkin" <mst@redhat.com>

Anyone who wants to do copy to/from user from a kernel thread, needs
use_mm (like what fs/aio has).  Move that into mm/, to make reusing and
exporting easier down the line, and make aio use it.  Next intended user,
besides aio, will be vhost-net.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c                    |   47 -----------------------------
 include/linux/mmu_context.h |    9 +++++
 mm/Makefile                 |    2 -
 mm/mmu_context.c            |   55 ++++++++++++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 47 deletions(-)

diff -puN fs/aio.c~mm-move-use_mm-unuse_mm-from-aioc-to-mm fs/aio.c
--- a/fs/aio.c~mm-move-use_mm-unuse_mm-from-aioc-to-mm
+++ a/fs/aio.c
@@ -24,6 +24,7 @@
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/mmu_context.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
 #include <linux/aio.h>
@@ -34,7 +35,6 @@
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
-#include <asm/mmu_context.h>
 
 #if DEBUG > 1
 #define dprintk		printk
@@ -595,51 +595,6 @@ static struct kioctx *lookup_ioctx(unsig
 }
 
 /*
- * use_mm
- *	Makes the calling kernel thread take on the specified
- *	mm context.
- *	Called by the retry thread execute retries within the
- *	iocb issuer's mm context, so that copy_from/to_user
- *	operations work seamlessly for aio.
- *	(Note: this routine is intended to be called only
- *	from a kernel thread context)
- */
-static void use_mm(struct mm_struct *mm)
-{
-	struct mm_struct *active_mm;
-	struct task_struct *tsk = current;
-
-	task_lock(tsk);
-	active_mm = tsk->active_mm;
-	atomic_inc(&mm->mm_count);
-	tsk->mm = mm;
-	tsk->active_mm = mm;
-	switch_mm(active_mm, mm, tsk);
-	task_unlock(tsk);
-
-	mmdrop(active_mm);
-}
-
-/*
- * unuse_mm
- *	Reverses the effect of use_mm, i.e. releases the
- *	specified mm context which was earlier taken on
- *	by the calling kernel thread
- *	(Note: this routine is intended to be called only
- *	from a kernel thread context)
- */
-static void unuse_mm(struct mm_struct *mm)
-{
-	struct task_struct *tsk = current;
-
-	task_lock(tsk);
-	tsk->mm = NULL;
-	/* active_mm is still 'mm' */
-	enter_lazy_tlb(mm, tsk);
-	task_unlock(tsk);
-}
-
-/*
  * Queue up a kiocb to be retried. Assumes that the kiocb
  * has already been marked as kicked, and places it on
  * the retry run list for the corresponding ioctx, if it
diff -puN /dev/null include/linux/mmu_context.h
--- /dev/null
+++ a/include/linux/mmu_context.h
@@ -0,0 +1,9 @@
+#ifndef _LINUX_MMU_CONTEXT_H
+#define _LINUX_MMU_CONTEXT_H
+
+struct mm_struct;
+
+void use_mm(struct mm_struct *mm);
+void unuse_mm(struct mm_struct *mm);
+
+#endif
diff -puN mm/Makefile~mm-move-use_mm-unuse_mm-from-aioc-to-mm mm/Makefile
--- a/mm/Makefile~mm-move-use_mm-unuse_mm-from-aioc-to-mm
+++ a/mm/Makefile
@@ -11,7 +11,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o mm_init.o $(mmu-y)
+			   page_isolation.o mm_init.o mmu_context.o $(mmu-y)
 obj-y += init-mm.o
 
 obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
diff -puN /dev/null mm/mmu_context.c
--- /dev/null
+++ a/mm/mmu_context.c
@@ -0,0 +1,55 @@
+/* Copyright (C) 2009 Red Hat, Inc.
+ *
+ * See ../COPYING for licensing terms.
+ */
+
+#include <linux/mm.h>
+#include <linux/mmu_context.h>
+#include <linux/sched.h>
+
+#include <asm/mmu_context.h>
+
+/*
+ * use_mm
+ *	Makes the calling kernel thread take on the specified
+ *	mm context.
+ *	Called by the retry thread execute retries within the
+ *	iocb issuer's mm context, so that copy_from/to_user
+ *	operations work seamlessly for aio.
+ *	(Note: this routine is intended to be called only
+ *	from a kernel thread context)
+ */
+void use_mm(struct mm_struct *mm)
+{
+	struct mm_struct *active_mm;
+	struct task_struct *tsk = current;
+
+	task_lock(tsk);
+	active_mm = tsk->active_mm;
+	atomic_inc(&mm->mm_count);
+	tsk->mm = mm;
+	tsk->active_mm = mm;
+	switch_mm(active_mm, mm, tsk);
+	task_unlock(tsk);
+
+	mmdrop(active_mm);
+}
+
+/*
+ * unuse_mm
+ *	Reverses the effect of use_mm, i.e. releases the
+ *	specified mm context which was earlier taken on
+ *	by the calling kernel thread
+ *	(Note: this routine is intended to be called only
+ *	from a kernel thread context)
+ */
+void unuse_mm(struct mm_struct *mm)
+{
+	struct task_struct *tsk = current;
+
+	task_lock(tsk);
+	tsk->mm = NULL;
+	/* active_mm is still 'mm' */
+	enter_lazy_tlb(mm, tsk);
+	task_unlock(tsk);
+}
_

Patches currently in -mm which might be from mst@redhat.com are

origin.patch
linux-next.patch

