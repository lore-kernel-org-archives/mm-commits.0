From: akpm@linux-foundation.org
Subject: + move-die-notifier-handling-to-common-code-fixes.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:37:02 -0800
Message-ID: <200703250837.l2P8b20A023880@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36330 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933262AbXCYIhR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:37:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, linux-arch@vger.kernel.org, rmk@arm.linux.org.uk


The patch titled
     move-die-notifier-handling-to-common-code fixes
has been added to the -mm tree.  Its filename is
     move-die-notifier-handling-to-common-code-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -92,6 +92,9 @@ void die(const char *msg, struct pt_regs
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
cifs-remove-unneeded-checks.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freevxfs-possible-null-pointer-dereference-fix.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
move-die-notifier-handling-to-common-code.patch
move-die-notifier-handling-to-common-code-fixes.patch
turn-do_sync_file_range-into-do_sync_mapping_range.patch
remove-do_sync_file_range.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
