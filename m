From: akpm@linux-foundation.org
Subject: + aio-convert-the-ioctx-list-to-radix-tree.patch added to -mm tree
Date: Fri, 10 May 2013 13:42:21 -0700
Message-ID: <20130510204221.9D1575A415D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:55427 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab3EJUmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 May 2013 16:42:23 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so421038ghr.0
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2013 13:42:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: octavian.purdila@intel.com, ak@linux.intel.com, bcrl@kvack.org, jwboyer@redhat.com, kirill.shutemov@linux.intel.com, koverstreet@google.com, schwidefsky@de.ibm.com, zab@redhat.com


The patch titled
     Subject: aio: convert the ioctx list to radix tree
has been added to the -mm tree.  Its filename is
     aio-convert-the-ioctx-list-to-radix-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Octavian Purdila <octavian.purdila@intel.com>
Subject: aio: convert the ioctx list to radix tree

When using a large number of threads performing AIO operations the IOCTX
list may get a significant number of entries which will cause significant
overhead.  For example, when running this fio script:

rw=randrw; size=256k ;directory=/mnt/fio; ioengine=libaio; iodepth=1
blocksize=1024; numjobs=512; thread; loops=100

on an EXT2 filesystem mounted on top of a ramdisk we can observe up to
30% CPU time spent by lookup_ioctx:

 32.51%  [guest.kernel]  [g] lookup_ioctx
  9.19%  [guest.kernel]  [g] __lock_acquire.isra.28
  4.40%  [guest.kernel]  [g] lock_release
  4.19%  [guest.kernel]  [g] sched_clock_local
  3.86%  [guest.kernel]  [g] local_clock
  3.68%  [guest.kernel]  [g] native_sched_clock
  3.08%  [guest.kernel]  [g] sched_clock_cpu
  2.64%  [guest.kernel]  [g] lock_release_holdtime.part.11
  2.60%  [guest.kernel]  [g] memcpy
  2.33%  [guest.kernel]  [g] lock_acquired
  2.25%  [guest.kernel]  [g] lock_acquire
  1.84%  [guest.kernel]  [g] do_io_submit

This patch converts the ioctx list to a radix tree.  For a performance
comparison the above FIO script was run on a 2 sockets 8 core machine. 
This are the results (average and %rsd of 10 runs) for the original list
based implementation and for the radix tree based implementation:

cores         1         2         4         8         16        32
list       109376 ms  69119 ms  35682 ms  22671 ms  19724 ms  16408 ms
%rsd         0.69%      1.15%     1.17%     1.21%     1.71%     1.43%
radix       73651 ms  41748 ms  23028 ms  16766 ms  15232 ms   13787 ms
%rsd         1.19%      0.98%     0.69%     1.13%    0.72%      0.75%
% of radix
relative    66.12%     65.59%    66.63%    72.31%   77.26%     83.66%
to list

To consider the impact of the patch on the typical case of having only one
ctx per process the following FIO script was run:

rw=randrw; size=100m ;directory=/mnt/fio; ioengine=libaio; iodepth=1
blocksize=1024; numjobs=1; thread; loops=100

on the same system and the results are the following:

list        58892 ms
%rsd         0.91%
radix       59404 ms
%rsd         0.81%
% of radix
relative    100.87%
to list

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgtable.c   |    4 +-
 fs/aio.c                 |   74 +++++++++++++++++++++++--------------
 include/linux/mm_types.h |    3 +
 kernel/fork.c            |    2 -
 4 files changed, 51 insertions(+), 32 deletions(-)

diff -puN arch/s390/mm/pgtable.c~aio-convert-the-ioctx-list-to-radix-tree arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~aio-convert-the-ioctx-list-to-radix-tree
+++ a/arch/s390/mm/pgtable.c
@@ -1029,7 +1029,7 @@ int s390_enable_sie(void)
 	task_lock(tsk);
 	if (!tsk->mm || atomic_read(&tsk->mm->mm_users) > 1 ||
 #ifdef CONFIG_AIO
-	    !hlist_empty(&tsk->mm->ioctx_list) ||
+	    tsk->mm->ioctx_rtree.rnode ||
 #endif
 	    tsk->mm != tsk->active_mm) {
 		task_unlock(tsk);
@@ -1056,7 +1056,7 @@ int s390_enable_sie(void)
 	task_lock(tsk);
 	if (!tsk->mm || atomic_read(&tsk->mm->mm_users) > 1 ||
 #ifdef CONFIG_AIO
-	    !hlist_empty(&tsk->mm->ioctx_list) ||
+	    tsk->mm->ioctx_rtree.rnode ||
 #endif
 	    tsk->mm != tsk->active_mm) {
 		mmput(mm);
diff -puN fs/aio.c~aio-convert-the-ioctx-list-to-radix-tree fs/aio.c
--- a/fs/aio.c~aio-convert-the-ioctx-list-to-radix-tree
+++ a/fs/aio.c
@@ -38,6 +38,7 @@
 #include <linux/blkdev.h>
 #include <linux/compat.h>
 #include <linux/percpu-refcount.h>
+#include <linux/radix-tree.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -69,9 +70,7 @@ struct kioctx_cpu {
 struct kioctx {
 	struct percpu_ref	users;
 
-	/* This needs improving */
 	unsigned long		user_id;
-	struct hlist_node	list;
 
 	struct __percpu kioctx_cpu *cpu;
 
@@ -457,10 +456,18 @@ static struct kioctx *ioctx_alloc(unsign
 	aio_nr += ctx->max_reqs;
 	spin_unlock(&aio_nr_lock);
 
-	/* now link into global list. */
+	/* now insert into the radix tree */
+	err = radix_tree_preload(GFP_KERNEL);
+	if (err)
+		goto out_cleanup;
 	spin_lock(&mm->ioctx_lock);
-	hlist_add_head_rcu(&ctx->list, &mm->ioctx_list);
+	err = radix_tree_insert(&mm->ioctx_rtree, ctx->user_id, ctx);
 	spin_unlock(&mm->ioctx_lock);
+	radix_tree_preload_end();
+	if (err) {
+		WARN_ONCE(1, "aio: insert into ioctx tree failed: %d", err);
+		goto out_cleanup;
+	}
 
 	pr_debug("allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
 		 ctx, ctx->user_id, mm, ctx->nr_events);
@@ -501,8 +508,8 @@ static void kill_ioctx_rcu(struct rcu_he
 static void kill_ioctx(struct kioctx *ctx)
 {
 	if (percpu_ref_kill(&ctx->users)) {
-		hlist_del_rcu(&ctx->list);
-		/* Between hlist_del_rcu() and dropping the initial ref */
+		radix_tree_delete(&current->mm->ioctx_rtree, ctx->user_id);
+		/* Between radix_tree_delete() and dropping the initial ref */
 		synchronize_rcu();
 
 		/*
@@ -542,25 +549,38 @@ EXPORT_SYMBOL(wait_on_sync_kiocb);
  */
 void exit_aio(struct mm_struct *mm)
 {
-	struct kioctx *ctx;
-	struct hlist_node *n;
+	struct kioctx *ctx[16];
+	unsigned long idx = 0;
+	int count;
 
-	hlist_for_each_entry_safe(ctx, n, &mm->ioctx_list, list) {
-		/*
-		 * We don't need to bother with munmap() here -
-		 * exit_mmap(mm) is coming and it'll unmap everything.
-		 * Since aio_free_ring() uses non-zero ->mmap_size
-		 * as indicator that it needs to unmap the area,
-		 * just set it to 0; aio_free_ring() is the only
-		 * place that uses ->mmap_size, so it's safe.
-		 */
-		ctx->mmap_size = 0;
+	do {
+		int i;
 
-		if (percpu_ref_kill(&ctx->users)) {
-			hlist_del_rcu(&ctx->list);
-			call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
+		count = radix_tree_gang_lookup(&mm->ioctx_rtree, (void **)ctx,
+					       idx, sizeof(ctx)/sizeof(void *));
+		for (i = 0; i < count; i++) {
+			void *ret;
+
+			BUG_ON(ctx[i]->user_id < idx);
+			idx = ctx[i]->user_id;
+
+			/*
+			 * We don't need to bother with munmap() here -
+			 * exit_mmap(mm) is coming and it'll unmap everything.
+			 * Since aio_free_ring() uses non-zero ->mmap_size
+			 * as indicator that it needs to unmap the area,
+			 * just set it to 0; aio_free_ring() is the only
+			 * place that uses ->mmap_size, so it's safe.
+			 */
+			ctx[i]->mmap_size = 0;
+
+			if (percpu_ref_kill(&ctx[i]->users)) {
+				ret = radix_tree_delete(&mm->ioctx_rtree, idx);
+				BUG_ON(!ret || ret != ctx[i]);
+				call_rcu(&ctx[i]->rcu_head, kill_ioctx_rcu);
+			}
 		}
-	}
+	} while (count);
 }
 
 static void put_reqs_available(struct kioctx *ctx, unsigned nr)
@@ -665,12 +685,10 @@ static struct kioctx *lookup_ioctx(unsig
 
 	rcu_read_lock();
 
-	hlist_for_each_entry_rcu(ctx, &mm->ioctx_list, list) {
-		if (ctx->user_id == ctx_id) {
-			percpu_ref_get(&ctx->users);
-			ret = ctx;
-			break;
-		}
+	ctx = radix_tree_lookup(&mm->ioctx_rtree, ctx_id);
+	if (ctx) {
+		percpu_ref_get(&ctx->users);
+		ret = ctx;
 	}
 
 	rcu_read_unlock();
diff -puN include/linux/mm_types.h~aio-convert-the-ioctx-list-to-radix-tree include/linux/mm_types.h
--- a/include/linux/mm_types.h~aio-convert-the-ioctx-list-to-radix-tree
+++ a/include/linux/mm_types.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/threads.h>
 #include <linux/list.h>
+#include <linux/radix-tree.h>
 #include <linux/spinlock.h>
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
@@ -383,7 +384,7 @@ struct mm_struct {
 	struct core_state *core_state; /* coredumping support */
 #ifdef CONFIG_AIO
 	spinlock_t		ioctx_lock;
-	struct hlist_head	ioctx_list;
+	struct radix_tree_root	ioctx_rtree;
 #endif
 #ifdef CONFIG_MM_OWNER
 	/*
diff -puN kernel/fork.c~aio-convert-the-ioctx-list-to-radix-tree kernel/fork.c
--- a/kernel/fork.c~aio-convert-the-ioctx-list-to-radix-tree
+++ a/kernel/fork.c
@@ -522,7 +522,7 @@ static void mm_init_aio(struct mm_struct
 {
 #ifdef CONFIG_AIO
 	spin_lock_init(&mm->ioctx_lock);
-	INIT_HLIST_HEAD(&mm->ioctx_list);
+	INIT_RADIX_TREE(&mm->ioctx_rtree, GFP_KERNEL);
 #endif
 }
 
_

Patches currently in -mm which might be from octavian.purdila@intel.com are

aio-convert-the-ioctx-list-to-radix-tree.patch

