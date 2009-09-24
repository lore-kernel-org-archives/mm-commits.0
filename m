From: akpm@linux-foundation.org
Subject: [merged] aio-ifdef-fields-in-mm_struct.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:07 -0700
Message-ID: <200909241937.n8OJb7P9003939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752557AbZIXTm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:42:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, bcrl@kvack.org, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: ifdef fields in mm_struct
has been removed from the -mm tree.  Its filename was
     aio-ifdef-fields-in-mm_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: ifdef fields in mm_struct
From: Alexey Dobriyan <adobriyan@gmail.com>

->ioctx_lock and ->ioctx_list are used only under CONFIG_AIO.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    5 ++---
 kernel/fork.c            |   11 +++++++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN include/linux/mm_types.h~aio-ifdef-fields-in-mm_struct include/linux/mm_types.h
--- a/include/linux/mm_types.h~aio-ifdef-fields-in-mm_struct
+++ a/include/linux/mm_types.h
@@ -259,11 +259,10 @@ struct mm_struct {
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	struct core_state *core_state; /* coredumping support */
-
-	/* aio bits */
+#ifdef CONFIG_AIO
 	spinlock_t		ioctx_lock;
 	struct hlist_head	ioctx_list;
-
+#endif
 #ifdef CONFIG_MM_OWNER
 	/*
 	 * "owner" points to a task that is regarded as the canonical
diff -puN kernel/fork.c~aio-ifdef-fields-in-mm_struct kernel/fork.c
--- a/kernel/fork.c~aio-ifdef-fields-in-mm_struct
+++ a/kernel/fork.c
@@ -434,6 +434,14 @@ __setup("coredump_filter=", coredump_fil
 
 #include <linux/init_task.h>
 
+static void mm_init_aio(struct mm_struct *mm)
+{
+#ifdef CONFIG_AIO
+	spin_lock_init(&mm->ioctx_lock);
+	INIT_HLIST_HEAD(&mm->ioctx_list);
+#endif
+}
+
 static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
 {
 	atomic_set(&mm->mm_users, 1);
@@ -447,10 +455,9 @@ static struct mm_struct * mm_init(struct
 	set_mm_counter(mm, file_rss, 0);
 	set_mm_counter(mm, anon_rss, 0);
 	spin_lock_init(&mm->page_table_lock);
-	spin_lock_init(&mm->ioctx_lock);
-	INIT_HLIST_HEAD(&mm->ioctx_list);
 	mm->free_area_cache = TASK_UNMAPPED_BASE;
 	mm->cached_hole_size = ~0UL;
+	mm_init_aio(mm);
 	mm_init_owner(mm, p);
 
 	if (likely(!mm_alloc_pgd(mm))) {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

