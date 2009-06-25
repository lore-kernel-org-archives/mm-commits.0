From: akpm@linux-foundation.org
Subject: + aio-ifdef-fields-in-mm_struct.patch added to -mm tree
Date: Thu, 25 Jun 2009 15:54:51 -0700
Message-ID: <200906252254.n5PMsp2K022460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbZFYWyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 18:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, bcrl@kvack.org, zach.brown@oracle.com


The patch titled
     aio: ifdef fields in mm_struct
has been added to the -mm tree.  Its filename is
     aio-ifdef-fields-in-mm_struct.patch

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
@@ -261,11 +261,10 @@ struct mm_struct {
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
@@ -420,6 +420,14 @@ __setup("coredump_filter=", coredump_fil
 
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
@@ -432,10 +440,9 @@ static struct mm_struct * mm_init(struct
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

procfs-provide-stack-information-for-threads-v08.patch
aio-ifdef-fields-in-mm_struct.patch

