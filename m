From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-remove-usage-and-export-of-__put_task_struct.patch removed from -mm tree
Date: Wed, 18 Jul 2007 22:54:03 -0700
Message-ID: <200707190554.l6J5s3K2016574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938AbXGSFyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: remove usage and export of __put_task_struct()
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-remove-usage-and-export-of-__put_task_struct.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

------------------------------------------------------
Subject: lguest: remove usage and export of __put_task_struct()
From: Rusty Russell <rusty@rustcorp.com.au>

lguest takes a reference count of tasks for two reasons.  The first is
bogus: the /dev/lguest close callback will be called before the task is
destroyed anyway, so no need to take a reference on open.

The second is code to defer waking up tasks for inter-guest I/O, but the
current lguest drivers are too simplistic to benefit (only batched
hypercalls will see an effect, and it's likely that lguests' entire I/O
model will be replaced with virtio and ringbuffers anyway).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/hypercalls.c  |    1 -
 drivers/lguest/io.c          |   18 +-----------------
 drivers/lguest/lg.h          |    1 -
 drivers/lguest/lguest_user.c |    2 --
 kernel/fork.c                |    1 -
 5 files changed, 1 insertion(+), 22 deletions(-)

diff -puN drivers/lguest/hypercalls.c~lguest-the-host-code-remove-usage-and-export-of-__put_task_struct drivers/lguest/hypercalls.c
--- a/drivers/lguest/hypercalls.c~lguest-the-host-code-remove-usage-and-export-of-__put_task_struct
+++ a/drivers/lguest/hypercalls.c
@@ -189,5 +189,4 @@ void do_hypercalls(struct lguest *lg)
 		do_hcall(lg, lg->regs);
 		clear_hcall(lg);
 	}
-	set_wakeup_process(lg, NULL);
 }
diff -puN drivers/lguest/io.c~lguest-the-host-code-remove-usage-and-export-of-__put_task_struct drivers/lguest/io.c
--- a/drivers/lguest/io.c~lguest-the-host-code-remove-usage-and-export-of-__put_task_struct
+++ a/drivers/lguest/io.c
@@ -296,7 +296,7 @@ static int dma_transfer(struct lguest *s
 
 	/* Do this last so dst doesn't simply sleep on lock. */
 	set_bit(dst->interrupt, dstlg->irqs_pending);
-	set_wakeup_process(srclg, dstlg->tsk);
+	wake_up_process(dstlg->tsk);
 	return i == dst->num_dmas;
 
 fail:
@@ -333,7 +333,6 @@ again:
 			/* Give any recipients one chance to restock. */
 			up_read(&current->mm->mmap_sem);
 			mutex_unlock(&lguest_lock);
-			set_wakeup_process(lg, NULL);
 			empty++;
 			goto again;
 		}
@@ -362,21 +361,6 @@ void release_all_dma(struct lguest *lg)
 	up_read(&lg->mm->mmap_sem);
 }
 
-/* We cache one process to wakeup: helps for batching & wakes outside locks. */
-void set_wakeup_process(struct lguest *lg, struct task_struct *p)
-{
-	if (p == lg->wake)
-		return;
-
-	if (lg->wake) {
-		wake_up_process(lg->wake);
-		put_task_struct(lg->wake);
-	}
-	lg->wake = p;
-	if (lg->wake)
-		get_task_struct(lg->wake);
-}
-
 /* Userspace wants a dma buffer from this guest. */
 unsigned long get_dma_buffer(struct lguest *lg,
 			     unsigned long ukey, unsigned long *interrupt)
diff -puN drivers/lguest/lg.h~lguest-the-host-code-remove-usage-and-export-of-__put_task_struct drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-the-host-code-remove-usage-and-export-of-__put_task_struct
+++ a/drivers/lguest/lg.h
@@ -240,7 +240,6 @@ void send_dma(struct lguest *info, unsig
 void release_all_dma(struct lguest *lg);
 unsigned long get_dma_buffer(struct lguest *lg, unsigned long key,
 			     unsigned long *interrupt);
-void set_wakeup_process(struct lguest *lg, struct task_struct *p);
 
 /* hypercalls.c: */
 void do_hypercalls(struct lguest *lg);
diff -puN drivers/lguest/lguest_user.c~lguest-the-host-code-remove-usage-and-export-of-__put_task_struct drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c~lguest-the-host-code-remove-usage-and-export-of-__put_task_struct
+++ a/drivers/lguest/lguest_user.c
@@ -141,7 +141,6 @@ static int initialize(struct file *file,
 	setup_guest_gdt(lg);
 	init_clockdev(lg);
 	lg->tsk = current;
-	get_task_struct(lg->tsk);
 	lg->mm = get_task_mm(lg->tsk);
 	init_waitqueue_head(&lg->break_wq);
 	lg->last_pages = NULL;
@@ -205,7 +204,6 @@ static int close(struct inode *inode, st
 	hrtimer_cancel(&lg->hrt);
 	release_all_dma(lg);
 	free_guest_pagetable(lg);
-	put_task_struct(lg->tsk);
 	mmput(lg->mm);
 	if (!IS_ERR(lg->dead))
 		kfree(lg->dead);
diff -puN kernel/fork.c~lguest-the-host-code-remove-usage-and-export-of-__put_task_struct kernel/fork.c
--- a/kernel/fork.c~lguest-the-host-code-remove-usage-and-export-of-__put_task_struct
+++ a/kernel/fork.c
@@ -127,7 +127,6 @@ void __put_task_struct(struct task_struc
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
-EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init fork_init(unsigned long mempages)
 {
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
readahead-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-min_ra_pages-max_ra_pages-macros.patch
readahead-data-structure-and-routines.patch
readahead-on-demand-readahead-logic.patch
readahead-convert-filemap-invocations.patch
readahead-convert-splice-invocations.patch
readahead-convert-ext3-ext4-invocations.patch
readahead-remove-the-old-algorithm.patch
readahead-move-synchronous-readahead-call-out-of-splice-loop.patch
readahead-pass-real-splice-size.patch
mm-share-pg_readahead-and-pg_reclaim.patch
readahead-split-ondemand-readahead-interface-into-two-functions.patch
readahead-sanify-file_ra_state-names.patch
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-remove-usage-and-export-of-__put_task_struct.patch
lguest-the-host-code-disable-sysenter-for-guests.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
