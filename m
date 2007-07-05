From: akpm@linux-foundation.org
Subject: + frv-connect-up-new-syscalls.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:42:45 -0700
Message-ID: <200707052142.l65Lgjt6021322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760809AbXGEVnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     FRV: Connect up new syscalls
has been added to the -mm tree.  Its filename is
     frv-connect-up-new-syscalls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FRV: Connect up new syscalls
From: David Howells <dhowells@redhat.com>

Connect up new system calls.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/entry.S  |    4 ++++
 include/asm-frv/unistd.h |    6 +++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN arch/frv/kernel/entry.S~frv-connect-up-new-syscalls arch/frv/kernel/entry.S
--- a/arch/frv/kernel/entry.S~frv-connect-up-new-syscalls
+++ a/arch/frv/kernel/entry.S
@@ -1492,6 +1492,10 @@ sys_call_table:
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_utimensat		/* 320 */
+	.long sys_signalfd
+	.long sys_timerfd
+	.long sys_eventfd
 
 
 syscall_table_size = (. - sys_call_table)
diff -puN include/asm-frv/unistd.h~frv-connect-up-new-syscalls include/asm-frv/unistd.h
--- a/include/asm-frv/unistd.h~frv-connect-up-new-syscalls
+++ a/include/asm-frv/unistd.h
@@ -326,10 +326,14 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_utimensat		320
+#define __NR_signalfd		321
+#define __NR_timerfd		322
+#define __NR_eventfd		323
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 324
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */
_

Patches currently in -mm which might be from dhowells@redhat.com are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
document-page_mkwrite-locking.patch
frv-connect-up-new-syscalls.patch
frv-be-self-consistent-and-use-config_gdb_console-everywhere.patch
frv-remove-some-dead-code.patch
nommu-stub-expand_stack-for-nommu-case.patch
afs-implement-file-locking.patch
afs-drop-explicit-extern.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags-fix.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
mutex-subsystem-synchro-test-module.patch
