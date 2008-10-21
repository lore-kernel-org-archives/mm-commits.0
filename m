From: akpm@linux-foundation.org
Subject: + freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch added to -mm tree
Date: Tue, 21 Oct 2008 13:58:28 -0700
Message-ID: <200810212058.m9LKwSbn018420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbYJUVAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 17:00:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clg@fr.ibm.com, lizf@cn.fujitsu.com


The patch titled
     freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
has been added to the -mm tree.  Its filename is
     freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |    5 -----
 kernel/freezer.c        |   20 ++++++++++----------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff -puN include/linux/freezer.h~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix include/linux/freezer.h
--- a/include/linux/freezer.h~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
+++ a/include/linux/freezer.h
@@ -44,11 +44,6 @@ static inline bool should_send_signal(st
 	return !(p->flags & PF_FREEZER_NOSIG);
 }
 
-/*
- * Wake up a frozen process
- */
-extern int __thaw_process(struct task_struct *p);
-
 /* Takes and releases task alloc lock using task_lock() */
 extern int thaw_process(struct task_struct *p);
 
diff -puN kernel/freezer.c~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix kernel/freezer.c
--- a/kernel/freezer.c~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
+++ a/kernel/freezer.c
@@ -121,16 +121,7 @@ void cancel_freezing(struct task_struct 
 	}
 }
 
-/*
- * Wake up a frozen process
- *
- * task_lock() is needed to prevent the race with refrigerator() which may
- * occur if the freezing of tasks fails.  Namely, without the lock, if the
- * freezing of tasks failed, thaw_tasks() might have run before a task in
- * refrigerator() could call frozen_process(), in which case the task would be
- * frozen and no one would thaw it.
- */
-int __thaw_process(struct task_struct *p)
+static int __thaw_process(struct task_struct *p)
 {
 	if (frozen(p)) {
 		p->flags &= ~PF_FROZEN;
@@ -140,6 +131,15 @@ int __thaw_process(struct task_struct *p
 	return 0;
 }
 
+/*
+ * Wake up a frozen process
+ *
+ * task_lock() is needed to prevent the race with refrigerator() which may
+ * occur if the freezing of tasks fails.  Namely, without the lock, if the
+ * freezing of tasks failed, thaw_tasks() might have run before a task in
+ * refrigerator() could call frozen_process(), in which case the task would be
+ * frozen and no one would thaw it.
+ */
 int thaw_process(struct task_struct *p)
 {
 	task_lock(p);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
git-tests-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

