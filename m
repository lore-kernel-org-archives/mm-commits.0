From: akpm@linux-foundation.org
Subject: - mutex_lock_interruptible-add-__must_check-must-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 01:51:11 -0700
Message-ID: <200705090851.l498pBxd018452@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753805AbXEIIvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 04:51:13 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l498pBm9004238
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 9 May 2007 01:51:12 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     mutex_lock_interruptible-add-__must_check-must-fix
has been removed from the -mm tree.  Its filename was
     mutex_lock_interruptible-add-__must_check-must-fix.patch

This patch was dropped because it was folded into mutex_lock_interruptible-add-__must_check.patch

------------------------------------------------------
Subject: mutex_lock_interruptible-add-__must_check-must-fix
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mutex.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/mutex.h~mutex_lock_interruptible-add-__must_check-must-fix include/linux/mutex.h
--- a/include/linux/mutex.h~mutex_lock_interruptible-add-__must_check-must-fix
+++ a/include/linux/mutex.h
@@ -121,11 +121,10 @@ static inline int fastcall mutex_is_lock
  * Also see Documentation/mutex-design.txt.
  */
 extern void fastcall mutex_lock(struct mutex *lock);
-extern int fastcall mutex_lock_interruptible(struct mutex *lock);
+extern int __must_check fastcall mutex_lock_interruptible(struct mutex *lock);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern void __must_check mutex_lock_nested(struct mutex *lock,
-					unsigned int subclass);
+extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
 #else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
mutex_lock_interruptible-add-__must_check.patch
mutex_lock_interruptible-add-__must_check-must-fix.patch
afs-implement-basic-file-write-support-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
make-vm-statistics-update-interval-configurable-fix.patch
rename-thread_info-to-stack-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
