From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 01 Feb 2016 16:55:36 -0800
Message-ID: <56affe88.BqTKri2jhM7XEtVv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbcBBAzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 19:55:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/tty_io.c    |   60 --------------------------------------
 drivers/tty/tty_mutex.c |    4 --
 include/linux/tty.h     |    8 -----
 3 files changed, 72 deletions(-)

diff -puN drivers/tty/tty_io.c~linux-next-git-rejects drivers/tty/tty_io.c
--- a/drivers/tty/tty_io.c~linux-next-git-rejects
+++ a/drivers/tty/tty_io.c
@@ -2110,59 +2110,14 @@ retry_open:
 		return -ENOMEM;
 
 	tty = tty_open_current_tty(device, filp);
-<<<<<<< HEAD
-	if (!tty) {
-		mutex_lock(&tty_mutex);
-		driver = tty_lookup_driver(device, filp, &noctty, &index);
-		if (IS_ERR(driver)) {
-			retval = PTR_ERR(driver);
-			goto err_unlock;
-		}
-
-		/* check whether we're reopening an existing tty */
-		tty = tty_driver_lookup_tty(driver, inode, index);
-		if (IS_ERR(tty)) {
-			retval = PTR_ERR(tty);
-			goto err_unlock;
-		}
-
-		if (tty) {
-			mutex_unlock(&tty_mutex);
-			retval = tty_lock_interruptible(tty);
-			if (retval) {
-				if (retval == -EINTR)
-					retval = -ERESTARTSYS;
-				goto err_unref;
-			}
-			/* safe to drop the kref from tty_driver_lookup_tty() */
-			tty_kref_put(tty);
-			retval = tty_reopen(tty);
-			if (retval < 0) {
-				tty_unlock(tty);
-				tty = ERR_PTR(retval);
-			}
-		} else { /* Returns with the tty_lock held for now */
-			tty = tty_init_dev(driver, index);
-			mutex_unlock(&tty_mutex);
-		}
-
-		tty_driver_kref_put(driver);
-	}
-=======
 	if (!tty)
 		tty = tty_open_by_driver(device, inode, filp);
->>>>>>> linux-next/akpm-base
 
 	if (IS_ERR(tty)) {
 		tty_free_file(filp);
 		retval = PTR_ERR(tty);
 		if (retval != -EAGAIN || signal_pending(current))
-<<<<<<< HEAD
-			goto err_file;
-		tty_free_file(filp);
-=======
 			return retval;
->>>>>>> linux-next/akpm-base
 		schedule();
 		goto retry_open;
 	}
@@ -2233,18 +2188,6 @@ retry_open:
 	read_unlock(&tasklist_lock);
 	tty_unlock(tty);
 	return 0;
-<<<<<<< HEAD
-err_unlock:
-	mutex_unlock(&tty_mutex);
-err_unref:
-	/* after locks to avoid deadlock */
-	if (!IS_ERR_OR_NULL(driver))
-		tty_driver_kref_put(driver);
-err_file:
-	tty_free_file(filp);
-	return retval;
-=======
->>>>>>> linux-next/akpm-base
 }
 
 
@@ -2749,11 +2692,8 @@ static int tiocgetd(struct tty_struct *t
 	int ret;
 
 	ld = tty_ldisc_ref_wait(tty);
-<<<<<<< HEAD
-=======
 	if (!ld)
 		return -EIO;
->>>>>>> linux-next/akpm-base
 	ret = put_user(ld->ops->num, p);
 	tty_ldisc_deref(ld);
 	return ret;
diff -puN drivers/tty/tty_mutex.c~linux-next-git-rejects drivers/tty/tty_mutex.c
--- a/drivers/tty/tty_mutex.c~linux-next-git-rejects
+++ a/drivers/tty/tty_mutex.c
@@ -27,11 +27,7 @@ int tty_lock_interruptible(struct tty_st
 	return mutex_lock_interruptible(&tty->legacy_mutex);
 }
 
-<<<<<<< HEAD
-void __lockfunc tty_unlock(struct tty_struct *tty)
-=======
 void tty_unlock(struct tty_struct *tty)
->>>>>>> linux-next/akpm-base
 {
 	if (WARN(tty->magic != TTY_MAGIC, "U Bad %p\n", tty))
 		return;
diff -puN include/linux/tty.h~linux-next-git-rejects include/linux/tty.h
--- a/include/linux/tty.h~linux-next-git-rejects
+++ a/include/linux/tty.h
@@ -622,19 +622,11 @@ extern long vt_compat_ioctl(struct tty_s
 
 /* tty_mutex.c */
 /* functions for preparation of BKL removal */
-<<<<<<< HEAD
-extern void __lockfunc tty_lock(struct tty_struct *tty);
-extern int  tty_lock_interruptible(struct tty_struct *tty);
-extern void __lockfunc tty_unlock(struct tty_struct *tty);
-extern void __lockfunc tty_lock_slave(struct tty_struct *tty);
-extern void __lockfunc tty_unlock_slave(struct tty_struct *tty);
-=======
 extern void tty_lock(struct tty_struct *tty);
 extern int  tty_lock_interruptible(struct tty_struct *tty);
 extern void tty_unlock(struct tty_struct *tty);
 extern void tty_lock_slave(struct tty_struct *tty);
 extern void tty_unlock_slave(struct tty_struct *tty);
->>>>>>> linux-next/akpm-base
 extern void tty_set_lock_subclass(struct tty_struct *tty);
 
 #ifdef CONFIG_PROC_FS
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
arm-arch-arm-include-asm-pageh-needs-personalityh-fix.patch
mm-warn-about-vmdata-over-rlimit_data-fix.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

