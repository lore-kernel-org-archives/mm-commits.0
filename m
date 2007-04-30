From: akpm@linux-foundation.org
Subject: - move-die-notifier-handling-to-common-code-fixes.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:48:15 -0700
Message-ID: <200704301948.l3UJmGBI013340@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031579AbXD3Txz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:53:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, linux-arch@vger.kernel.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     move-die-notifier-handling-to-common-code fixes
has been removed from the -mm tree.  Its filename was
     move-die-notifier-handling-to-common-code-fixes.patch

This patch was dropped because it was folded into move-die-notifier-handling-to-common-code.patch

------------------------------------------------------
Subject: move-die-notifier-handling-to-common-code fixes
From: Christoph Hellwig <hch@lst.de>

Here's an updated version of that patch that fixes arm, tested with a
netwinder config.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: <linux-arch@vger.kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/traps.c  |    2 +-
 arch/arm/mm/fault.c      |    2 +-
 include/asm-arm/system.h |    3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/arm/kernel/traps.c~move-die-notifier-handling-to-common-code-fixes arch/arm/kernel/traps.c
--- a/arch/arm/kernel/traps.c~move-die-notifier-handling-to-common-code-fixes
+++ a/arch/arm/kernel/traps.c
@@ -245,7 +245,7 @@ NORET_TYPE void die(const char *str, str
 	do_exit(SIGSEGV);
 }
 
-static void arm_notify_die(const char *str, struct pt_regs *regs,
+void arm_notify_die(const char *str, struct pt_regs *regs,
 		struct siginfo *info, unsigned long err, unsigned long trap)
 {
 	if (user_mode(regs)) {
diff -puN arch/arm/mm/fault.c~move-die-notifier-handling-to-common-code-fixes arch/arm/mm/fault.c
--- a/arch/arm/mm/fault.c~move-die-notifier-handling-to-common-code-fixes
+++ a/arch/arm/mm/fault.c
@@ -453,7 +453,7 @@ do_DataAbort(unsigned long addr, unsigne
 	info.si_errno = 0;
 	info.si_code  = inf->code;
 	info.si_addr  = (void __user *)addr;
-	notify_die("", regs, &info, fsr, 0);
+	arm_notify_die("", regs, &info, fsr, 0);
 }
 
 asmlinkage void __exception
diff -puN include/asm-arm/system.h~move-die-notifier-handling-to-common-code-fixes include/asm-arm/system.h
--- a/include/asm-arm/system.h~move-die-notifier-handling-to-common-code-fixes
+++ a/include/asm-arm/system.h
@@ -93,6 +93,9 @@ void die(const char *msg, struct pt_regs
 		__attribute__((noreturn));
 
 struct siginfo;
+void arm_notify_die(const char *str, struct pt_regs *regs, struct siginfo *info,
+		unsigned long err, unsigned long trap);
+
 void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
 				       struct pt_regs *),
 		     int sig, const char *name);
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-cifs.patch
git-powerpc.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freevxfs-possible-null-pointer-dereference-fix.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
move-die-notifier-handling-to-common-code.patch
move-die-notifier-handling-to-common-code-fixes.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
move-die-notifier-handling-to-common-code-fix.patch
remove-do_sync_file_range.patch
remove-artificial-software-max_loop-limit.patch
merge-compat_ioctlh-into-compat_ioctlc.patch
cleanup-compat-ioctl-handling.patch
make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop.patch
check-privileges-before-setting-mount-propagation.patch
jbd-check-for-error-returned-by-kthread_create-on-creating-journal-thread.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits-comments.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
kprobes-use-hlist_for_each_entry.patch
kprobes-codingstyle-cleanups.patch
kprobes-kretprobes-simplifcations.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
