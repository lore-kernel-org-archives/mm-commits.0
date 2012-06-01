From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 01 Jun 2012 12:39:53 -0700
Message-ID: <20120601193953.88E63A026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:39811 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759017Ab2FATjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:39:54 -0400
Received: by ghbz15 with SMTP id z15so245593ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:39:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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

 arch/avr32/kernel/entry-avr32b.S |    4 ----
 arch/parisc/kernel/entry.S       |    4 ----
 arch/x86/syscalls/syscall_32.tbl |    7 ++-----
 arch/x86/syscalls/syscall_64.tbl |    8 ++------
 fs/btrfs/ulist.c                 |    9 ---------
 fs/btrfs/ulist.h                 |    4 ----
 fs/ext4/namei.c                  |    4 ----
 kernel/fork.c                    |    3 ---
 kernel/irq/manage.c              |    4 ----
 security/security.c              |    3 ---
 10 files changed, 4 insertions(+), 46 deletions(-)

diff -puN arch/avr32/kernel/entry-avr32b.S~linux-next-git-rejects arch/avr32/kernel/entry-avr32b.S
--- a/arch/avr32/kernel/entry-avr32b.S~linux-next-git-rejects
+++ a/arch/avr32/kernel/entry-avr32b.S
@@ -587,11 +587,7 @@ fault_exit_work:
 	ld.w	r1, r0[TI_flags]
 	rjmp	fault_exit_work
 
-<<<<<<< HEAD
-1:	mov	r2, _TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NOTIFY_RESUME
-=======
 1:	mov	r2, _TIF_SIGPENDING | _TIF_NOTIFY_RESUME
->>>>>>> linux-next/akpm-base
 	tst	r1, r2
 	breq	2f
 	unmask_interrupts
diff -puN arch/parisc/kernel/entry.S~linux-next-git-rejects arch/parisc/kernel/entry.S
--- a/arch/parisc/kernel/entry.S~linux-next-git-rejects
+++ a/arch/parisc/kernel/entry.S
@@ -2032,11 +2032,7 @@ syscall_check_resched:
 	.import do_signal,code
 syscall_check_sig:
 	LDREG	TI_FLAGS-THREAD_SZ_ALGN-FRAME_SIZE(%r30),%r19
-<<<<<<< HEAD
-	ldi	(_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK|_TIF_NOTIFY_RESUME), %r26
-=======
 	ldi	(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME), %r26
->>>>>>> linux-next/akpm-base
 	and,COND(<>)	%r19, %r26, %r0
 	b,n	syscall_restore	/* skip past if we've nothing to do */
 
diff -puN arch/x86/syscalls/syscall_32.tbl~linux-next-git-rejects arch/x86/syscalls/syscall_32.tbl
--- a/arch/x86/syscalls/syscall_32.tbl~linux-next-git-rejects
+++ a/arch/x86/syscalls/syscall_32.tbl
@@ -355,9 +355,6 @@
 346	i386	setns			sys_setns
 347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
-<<<<<<< HEAD
 349	i386	kcmp			sys_kcmp
-=======
-349	i386	numa_mbind		sys_numa_mbind			compat_sys_numa_mbind
-350	i386	numa_tbind		sys_numa_tbind			compat_sys_numa_tbind
->>>>>>> linux-next/akpm-base
+350	i386	numa_mbind		sys_numa_mbind			compat_sys_numa_mbind
+351	i386	numa_tbind		sys_numa_tbind			compat_sys_numa_tbind
diff -puN arch/x86/syscalls/syscall_64.tbl~linux-next-git-rejects arch/x86/syscalls/syscall_64.tbl
--- a/arch/x86/syscalls/syscall_64.tbl~linux-next-git-rejects
+++ a/arch/x86/syscalls/syscall_64.tbl
@@ -318,13 +318,9 @@
 309	common	getcpu			sys_getcpu
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
-<<<<<<< HEAD
 312	64	kcmp			sys_kcmp
-
-=======
-312	64	numa_mbind		sys_numa_mbind
-313	64	numa_tbind		sys_numa_tbind
->>>>>>> linux-next/akpm-base
+313	64	numa_mbind		sys_numa_mbind
+314	64	numa_tbind		sys_numa_tbind
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
 # for native 64-bit operation.
diff -puN fs/btrfs/ulist.c~linux-next-git-rejects fs/btrfs/ulist.c
--- a/fs/btrfs/ulist.c~linux-next-git-rejects
+++ a/fs/btrfs/ulist.c
@@ -145,15 +145,6 @@ EXPORT_SYMBOL(ulist_free);
  */
 int ulist_add(struct ulist *ulist, u64 val, unsigned long aux,
 	      gfp_t gfp_mask)
-<<<<<<< HEAD
-{
-	return ulist_add_merge(ulist, val, aux, NULL, gfp_mask);
-}
-
-int ulist_add_merge(struct ulist *ulist, u64 val, unsigned long aux,
-		    unsigned long *old_aux, gfp_t gfp_mask)
-=======
->>>>>>> linux-next/akpm-base
 {
 	int i;
 
diff -puN fs/btrfs/ulist.h~linux-next-git-rejects fs/btrfs/ulist.h
--- a/fs/btrfs/ulist.h~linux-next-git-rejects
+++ a/fs/btrfs/ulist.h
@@ -67,14 +67,10 @@ struct ulist *ulist_alloc(gfp_t gfp_mask
 void ulist_free(struct ulist *ulist);
 int ulist_add(struct ulist *ulist, u64 val, unsigned long aux,
 	      gfp_t gfp_mask);
-<<<<<<< HEAD
-int ulist_add_merge(struct ulist *ulist, u64 val, unsigned long aux,
-		    unsigned long *old_aux, gfp_t gfp_mask);
 struct ulist_node *ulist_next(struct ulist *ulist,
 			      struct ulist_iterator *uiter);
 
 #define ULIST_ITER_INIT(uiter) ((uiter)->i = 0)
-=======
 struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_node *prev);
 >>>>>>> linux-next/akpm-base
 
diff -puN fs/ext4/namei.c~linux-next-git-rejects fs/ext4/namei.c
--- a/fs/ext4/namei.c~linux-next-git-rejects
+++ a/fs/ext4/namei.c
@@ -1330,11 +1330,7 @@ static struct dentry *ext4_lookup(struct
 			EXT4_ERROR_INODE(dir, "bad inode number: %u", ino);
 			return ERR_PTR(-EIO);
 		}
-<<<<<<< HEAD
-		if (unlikely(ino == dir->i_ino)) {
-=======
 		if (ino == dir->i_ino) {
->>>>>>> linux-next/akpm-base
 			EXT4_ERROR_INODE(dir, "'%.*s' linked to parent dir",
 					 dentry->d_name.len,
 					 dentry->d_name.name);
diff -puN kernel/fork.c~linux-next-git-rejects kernel/fork.c
--- a/kernel/fork.c~linux-next-git-rejects
+++ a/kernel/fork.c
@@ -1415,10 +1415,7 @@ static struct task_struct *copy_process(
 	 * We dont wake it up yet.
 	 */
 	p->group_leader = p;
-<<<<<<< HEAD
 	INIT_LIST_HEAD(&p->thread_group);
-=======
->>>>>>> linux-next/akpm-base
 	INIT_HLIST_HEAD(&p->task_works);
 
 	/* Now that the task is set up, run cgroup callbacks if
diff -puN kernel/irq/manage.c~linux-next-git-rejects kernel/irq/manage.c
--- a/kernel/irq/manage.c~linux-next-git-rejects
+++ a/kernel/irq/manage.c
@@ -792,11 +792,7 @@ static void irq_thread_dtor(struct task_
 
 	action = kthread_data(tsk);
 
-<<<<<<< HEAD
-	pr_err("exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
-=======
 	pr_err("genirq: exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
->>>>>>> linux-next/akpm-base
 	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
 
 
diff -puN security/security.c~linux-next-git-rejects security/security.c
--- a/security/security.c~linux-next-git-rejects
+++ a/security/security.c
@@ -22,10 +22,7 @@
 #include <linux/fsnotify.h>
 #include <linux/mman.h>
 #include <linux/mount.h>
-<<<<<<< HEAD
 #include <linux/personality.h>
-=======
->>>>>>> linux-next/akpm-base
 #include <net/flow.h>
 
 #define MAX_LSM_EVM_XATTR	2
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
tmpfs-implement-numa-node-interleaving-fix.patch
tmpfs-implement-numa-node-interleaving-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

