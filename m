From: akpm@linux-foundation.org
Subject: - frv-connect-up-new-syscalls.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:03 -0700
Message-ID: <200707162050.l6GKo3cD001287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58432 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757919AbXGPVTU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:19:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     FRV: Connect up new syscalls
has been removed from the -mm tree.  Its filename was
     frv-connect-up-new-syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
document-page_mkwrite-locking.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
mutex-subsystem-synchro-test-module.patch
