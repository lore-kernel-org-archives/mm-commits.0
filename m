From: akpm@linux-foundation.org
Subject: + git-semaphore-vs-git-x86.patch added to -mm tree
Date: Tue, 08 Apr 2008 11:33:44 -0700
Message-ID: <200804081833.m38IXi7u006035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942AbYDHSeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 14:34:17 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m38IXi4t023531
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 8 Apr 2008 11:33:45 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-semaphore-vs-git-x86
has been added to the -mm tree.  Its filename is
     git-semaphore-vs-git-x86.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-semaphore-vs-git-x86
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/semaphore_32.h |  171 ------------------------------
 include/asm-x86/semaphore_64.h |  176 -------------------------------
 2 files changed, 347 deletions(-)

diff -puN include/asm-x86/semaphore_32.h~git-semaphore-vs-git-x86 /dev/null
--- a/include/asm-x86/semaphore_32.h
+++ /dev/null
@@ -1,171 +0,0 @@
-#ifndef _I386_SEMAPHORE_H
-#define _I386_SEMAPHORE_H
-
-#include <linux/linkage.h>
-
-#ifdef __KERNEL__
-
-/*
- * SMP- and interrupt-safe semaphores..
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- * Modified 1996-12-23 by Dave Grothe <dave@gcom.com> to fix bugs in
- *                     the original code and to make semaphore waits
- *                     interruptible so that processes waiting on
- *                     semaphores can be killed.
- * Modified 1999-02-14 by Andrea Arcangeli, split the sched.c helper
- *		       functions in asm/sempahore-helper.h while fixing a
- *		       potential and subtle race discovered by Ulrich Schmid
- *		       in down_interruptible(). Since I started to play here I
- *		       also implemented the `trylock' semaphore operation.
- *          1999-07-02 Artur Skawina <skawina@geocities.com>
- *                     Optimized "0(ecx)" -> "(ecx)" (the assembler does not
- *                     do this). Changed calling sequences from push/jmp to
- *                     traditional call/ret.
- * Modified 2001-01-01 Andreas Franck <afranck@gmx.de>
- *		       Some hacks to ensure compatibility with recent
- *		       GCC snapshots, to avoid stack corruption when compiling
- *		       with -fomit-frame-pointer. It's not sure if this will
- *		       be fixed in GCC, as our previous implementation was a
- *		       bit dubious.
- *
- * If you would like to see an analysis of this implementation, please
- * ftp to gcom.com and download the file
- * /pub/linux/src/semaphore/semaphore-2.0.24.tar.gz.
- *
- */
-
-#include <asm/system.h>
-#include <asm/atomic.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.sleepers	= 0,						\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name, count)			\
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name, 1)
-
-static inline void sema_init(struct semaphore *sem, int val)
-{
-/*
- *	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
- *
- * i'd rather use the more flexible initialization above, but sadly
- * GCC 2.7.2.3 emits a bogus warning. EGCS doesn't. Oh well.
- */
-	atomic_set(&sem->count, val);
-	sem->sleepers = 0;
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX(struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED(struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-extern asmregparm void __down_failed(atomic_t *count_ptr);
-extern asmregparm int __down_failed_interruptible(atomic_t *count_ptr);
-extern asmregparm int __down_failed_trylock(atomic_t *count_ptr);
-extern asmregparm void __up_wakeup(atomic_t *count_ptr);
-
-/*
- * This is ugly, but we want the default case to fall through.
- * "__down_failed" is a special asm handler that calls the C
- * routine that actually waits. See arch/i386/kernel/semaphore.c
- */
-static inline void down(struct semaphore *sem)
-{
-	might_sleep();
-	asm volatile("# atomic down operation\n\t"
-		     LOCK_PREFIX "decl %0\n\t"     /* --sem->count */
-		     "jns 2f\n"
-		     "\tlea %0,%%eax\n\t"
-		     "call __down_failed\n"
-		     "2:"
-		     : "+m" (sem->count)
-		     :
-		     : "memory", "ax");
-}
-
-/*
- * Interruptible try to acquire a semaphore.  If we obtained
- * it, return zero.  If we were interrupted, returns -EINTR
- */
-static inline int down_interruptible(struct semaphore *sem)
-{
-	int result;
-
-	might_sleep();
-	asm volatile("# atomic interruptible down operation\n\t"
-		     "xorl %0,%0\n\t"
-		     LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
-		     "jns 2f\n\t"
-		     "lea %1,%%eax\n\t"
-		     "call __down_failed_interruptible\n"
-		     "2:"
-		     : "=&a" (result), "+m" (sem->count)
-		     :
-		     : "memory");
-	return result;
-}
-
-/*
- * Non-blockingly attempt to down() a semaphore.
- * Returns zero if we acquired it
- */
-static inline int down_trylock(struct semaphore *sem)
-{
-	int result;
-
-	asm volatile("# atomic interruptible down operation\n\t"
-		     "xorl %0,%0\n\t"
-		     LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
-		     "jns 2f\n\t"
-		     "lea %1,%%eax\n\t"
-		     "call __down_failed_trylock\n\t"
-		     "2:\n"
-		     : "=&a" (result), "+m" (sem->count)
-		     :
-		     : "memory");
-	return result;
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- */
-static inline void up(struct semaphore *sem)
-{
-	asm volatile("# atomic up operation\n\t"
-		     LOCK_PREFIX "incl %0\n\t"     /* ++sem->count */
-		     "jg 1f\n\t"
-		     "lea %0,%%eax\n\t"
-		     "call __up_wakeup\n"
-		     "1:"
-		     : "+m" (sem->count)
-		     :
-		     : "memory", "ax");
-}
-
-#endif
-#endif
diff -puN include/asm-x86/semaphore_64.h~git-semaphore-vs-git-x86 /dev/null
--- a/include/asm-x86/semaphore_64.h
+++ /dev/null
@@ -1,176 +0,0 @@
-#ifndef _X86_64_SEMAPHORE_H
-#define _X86_64_SEMAPHORE_H
-
-#include <linux/linkage.h>
-
-#ifdef __KERNEL__
-
-/*
- * SMP- and interrupt-safe semaphores..
- *
- * (C) Copyright 1996 Linus Torvalds
- *
- * Modified 1996-12-23 by Dave Grothe <dave@gcom.com> to fix bugs in
- *                     the original code and to make semaphore waits
- *                     interruptible so that processes waiting on
- *                     semaphores can be killed.
- * Modified 1999-02-14 by Andrea Arcangeli, split the sched.c helper
- *		       functions in asm/sempahore-helper.h while fixing a
- *		       potential and subtle race discovered by Ulrich Schmid
- *		       in down_interruptible(). Since I started to play here I
- *		       also implemented the `trylock' semaphore operation.
- *          1999-07-02 Artur Skawina <skawina@geocities.com>
- *                     Optimized "0(ecx)" -> "(ecx)" (the assembler does not
- *                     do this). Changed calling sequences from push/jmp to
- *                     traditional call/ret.
- * Modified 2001-01-01 Andreas Franck <afranck@gmx.de>
- *		       Some hacks to ensure compatibility with recent
- *		       GCC snapshots, to avoid stack corruption when compiling
- *		       with -fomit-frame-pointer. It's not sure if this will
- *		       be fixed in GCC, as our previous implementation was a
- *		       bit dubious.
- *
- * If you would like to see an analysis of this implementation, please
- * ftp to gcom.com and download the file
- * /pub/linux/src/semaphore/semaphore-2.0.24.tar.gz.
- *
- */
-
-#include <asm/system.h>
-#include <asm/atomic.h>
-#include <asm/rwlock.h>
-#include <linux/wait.h>
-#include <linux/rwsem.h>
-#include <linux/stringify.h>
-
-struct semaphore {
-	atomic_t count;
-	int sleepers;
-	wait_queue_head_t wait;
-};
-
-#define __SEMAPHORE_INITIALIZER(name, n)				\
-{									\
-	.count		= ATOMIC_INIT(n),				\
-	.sleepers	= 0,						\
-	.wait		= __WAIT_QUEUE_HEAD_INITIALIZER((name).wait)	\
-}
-
-#define __DECLARE_SEMAPHORE_GENERIC(name,count) \
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
-
-#define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name, 1)
-
-static inline void sema_init(struct semaphore *sem, int val)
-{
-/*
- *	*sem = (struct semaphore)__SEMAPHORE_INITIALIZER((*sem),val);
- *
- * i'd rather use the more flexible initialization above, but sadly
- * GCC 2.7.2.3 emits a bogus warning. EGCS doesn't. Oh well.
- */
-	atomic_set(&sem->count, val);
-	sem->sleepers = 0;
-	init_waitqueue_head(&sem->wait);
-}
-
-static inline void init_MUTEX(struct semaphore *sem)
-{
-	sema_init(sem, 1);
-}
-
-static inline void init_MUTEX_LOCKED(struct semaphore *sem)
-{
-	sema_init(sem, 0);
-}
-
-asmlinkage void __down_failed(void /* special register calling convention */);
-asmlinkage int  __down_failed_interruptible(void  /* params in registers */);
-asmlinkage int  __down_failed_trylock(void  /* params in registers */);
-asmlinkage void __up_wakeup(void /* special register calling convention */);
-
-asmlinkage void __down(struct semaphore *sem);
-asmlinkage int  __down_interruptible(struct semaphore *sem);
-asmlinkage int  __down_trylock(struct semaphore *sem);
-asmlinkage void __up(struct semaphore *sem);
-
-/*
- * This is ugly, but we want the default case to fall through.
- * "__down_failed" is a special asm handler that calls the C
- * routine that actually waits. See arch/x86_64/kernel/semaphore.c
- */
-static inline void down(struct semaphore *sem)
-{
-	might_sleep();
-
-	asm volatile("# atomic down operation\n\t"
-		     LOCK_PREFIX "decl %0\n\t"     /* --sem->count */
-		     "jns 1f\n\t"
-		     "call __down_failed\n"
-		     "1:"
-		     : "=m" (sem->count)
-		     : "D" (sem)
-		     : "memory");
-}
-
-/*
- * Interruptible try to acquire a semaphore.  If we obtained
- * it, return zero.  If we were interrupted, returns -EINTR
- */
-static inline int down_interruptible(struct semaphore *sem)
-{
-	int result;
-
-	might_sleep();
-
-	asm volatile("# atomic interruptible down operation\n\t"
-		     "xorl %0,%0\n\t"
-		     LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
-		     "jns 2f\n\t"
-		     "call __down_failed_interruptible\n"
-		     "2:\n"
-		     : "=&a" (result), "=m" (sem->count)
-		     : "D" (sem)
-		     : "memory");
-	return result;
-}
-
-/*
- * Non-blockingly attempt to down() a semaphore.
- * Returns zero if we acquired it
- */
-static inline int down_trylock(struct semaphore *sem)
-{
-	int result;
-
-	asm volatile("# atomic interruptible down operation\n\t"
-		     "xorl %0,%0\n\t"
-		     LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
-		     "jns 2f\n\t"
-		     "call __down_failed_trylock\n\t"
-		     "2:\n"
-		     : "=&a" (result), "=m" (sem->count)
-		     : "D" (sem)
-		     : "memory", "cc");
-	return result;
-}
-
-/*
- * Note! This is subtle. We jump to wake people up only if
- * the semaphore was negative (== somebody was waiting on it).
- * The default case (no contention) will result in NO
- * jumps for both down() and up().
- */
-static inline void up(struct semaphore *sem)
-{
-	asm volatile("# atomic up operation\n\t"
-		     LOCK_PREFIX "incl %0\n\t"     /* ++sem->count */
-		     "jg 1f\n\t"
-		     "call __up_wakeup\n"
-		     "1:"
-		     : "=m" (sem->count)
-		     : "D" (sem)
-		     : "memory");
-}
-#endif /* __KERNEL__ */
-#endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
es1968-fix-sleep-while-holding-lock-bug-checkpatch-fixes.patch
revert-set-relay-file-can-not-be-read-by-pread2.patch
git-acpi.patch
git-acpi-revert-suspend-wakeup-code-in-c.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86.patch
git-kgdb-light.patch
git-alsa-tiwai.patch
es1968-fix-jitter-on-some-maestro-cards-checkpatch-fixes.patch
git-agpgart-export-agp_generic_alloc_pages.patch
git-agpgart-fix-type-confusion.patch
git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
cifs-suppress-warning.patch
git-powerpc.patch
fix-gregkh-driver-kobject-replace-list_for_each-with-list_for_each_entry.patch
pm-remove-destroy_suspended_device.patch
scsi-add-iscsi-ibft-support.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-dlm-vs-git-gfs2-nwm.patch
git-hid.patch
git-hrt.patch
time-close-small-window-for-vsyscall-time-inconsistencies-checkpatch-fixes.patch
arch-ia64-kernel-use-time_-macros.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
maple-add-driver-for-sega-dreamcast-controller.patch
touch-screen-driver-for-the-superh-migor-board-checkpatch-fixes.patch
git-leds.patch
git-libata-all.patch
drivers-ata-sata_fslc-fix-warnings-small-memory-leak.patch
git-async-tx.patch
git-mips.patch
git-net.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
ehea-fix-dlpar-memory-add-support-fix.patch
sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
pci-hotplug-introduce-pci_slot-fix.patch
pci-hotplug-introduce-pci_slot-fix-fix.patch
pci-hotplug-introduce-pci_slot-fix-2.patch
pci-hotplug-introduce-pci_slot-fix-99.patch
pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch
git-s390.patch
git-sched.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-misplaced-hunk.patch
git-cryptodev-fixup.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore-vs-git-x86.patch
git-semaphore-git-rejects.patch
smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
i386-arch-x86-math-emu-reg_ld_strc-fix-warning.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch

