From: akpm@linux-foundation.org
Subject: + frv-miscellaneous-fixes.patch added to -mm tree
Date: Tue, 08 May 2007 13:25:45 -0700
Message-ID: <200705082025.l48KPjvG000530@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbXEHUZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 16:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     FRV: Miscellaneous fixes
has been added to the -mm tree.  Its filename is
     frv-miscellaneous-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FRV: Miscellaneous fixes
From: David Howells <dhowells@redhat.com>

Miscellaneous fixes to bring FRV up to date:

 (1) Copy the new syscall numbers from i386 to asm-frv/unistd.h and fill out
     the syscall table in entry.S too.

 (2) Mark __frv_uart0 and __frv_uart1 __pminitdata rather than __initdata so
     that determine_clocks() can access them when CONFIG_PM=y.

 (3) Make arch/frv/mm/elf-fdpic.c include asm/mman.h so that MAP_FIXED is
     available (fixes commit 2fd3bebaad9da3b3b99c46a3389099424bf7ee35).

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/entry.S  |   10 ++++++++++
 arch/frv/kernel/setup.c  |    4 ++--
 arch/frv/mm/elf-fdpic.c  |    1 +
 include/asm-frv/unistd.h |   16 +++++++++++++---
 4 files changed, 26 insertions(+), 5 deletions(-)

diff -puN arch/frv/kernel/entry.S~frv-miscellaneous-fixes arch/frv/kernel/entry.S
--- a/arch/frv/kernel/entry.S~frv-miscellaneous-fixes
+++ a/arch/frv/kernel/entry.S
@@ -1482,6 +1482,16 @@ sys_call_table:
 	.long sys_faccessat
 	.long sys_pselect6
 	.long sys_ppoll
+	.long sys_unshare		/* 310 */
+	.long sys_set_robust_list
+	.long sys_get_robust_list
+	.long sys_splice
+	.long sys_sync_file_range
+	.long sys_tee			/* 315 */
+	.long sys_vmsplice
+	.long sys_move_pages
+	.long sys_getcpu
+	.long sys_epoll_pwait
 
 
 syscall_table_size = (. - sys_call_table)
diff -puN arch/frv/kernel/setup.c~frv-miscellaneous-fixes arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~frv-miscellaneous-fixes
+++ a/arch/frv/kernel/setup.c
@@ -191,7 +191,7 @@ static struct clock_cmode __pminitdata c
 static const struct clock_cmode __pminitdata *clock_cmodes;
 static int __pminitdata clock_doubled;
 
-static struct uart_port __initdata __frv_uart0 = {
+static struct uart_port __pminitdata __frv_uart0 = {
 	.uartclk		= 0,
 	.membase		= (char *) UART0_BASE,
 	.irq			= IRQ_CPU_UART0,
@@ -200,7 +200,7 @@ static struct uart_port __initdata __frv
 	.flags			= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,
 };
 
-static struct uart_port __initdata __frv_uart1 = {
+static struct uart_port __pminitdata __frv_uart1 = {
 	.uartclk		= 0,
 	.membase		= (char *) UART1_BASE,
 	.irq			= IRQ_CPU_UART1,
diff -puN arch/frv/mm/elf-fdpic.c~frv-miscellaneous-fixes arch/frv/mm/elf-fdpic.c
--- a/arch/frv/mm/elf-fdpic.c~frv-miscellaneous-fixes
+++ a/arch/frv/mm/elf-fdpic.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/elf-fdpic.h>
+#include <asm/mman.h>
 
 /*****************************************************************************/
 /*
diff -puN include/asm-frv/unistd.h~frv-miscellaneous-fixes include/asm-frv/unistd.h
--- a/include/asm-frv/unistd.h~frv-miscellaneous-fixes
+++ a/include/asm-frv/unistd.h
@@ -186,8 +186,8 @@
 #define __NR_rt_sigtimedwait	177
 #define __NR_rt_sigqueueinfo	178
 #define __NR_rt_sigsuspend	179
-#define __NR_pread		180
-#define __NR_pwrite		181
+#define __NR_pread64		180
+#define __NR_pwrite64		181
 #define __NR_chown		182
 #define __NR_getcwd		183
 #define __NR_capget		184
@@ -316,10 +316,20 @@
 #define __NR_faccessat		307
 #define __NR_pselect6		308
 #define __NR_ppoll		309
+#define __NR_unshare		310
+#define __NR_set_robust_list	311
+#define __NR_get_robust_list	312
+#define __NR_splice		313
+#define __NR_sync_file_range	314
+#define __NR_tee		315
+#define __NR_vmsplice		316
+#define __NR_move_pages		317
+#define __NR_getcpu		318
+#define __NR_epoll_pwait	319
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 310
+#define NR_syscalls 320
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
use-slab_panic-flag-cleanup.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
smaps-only-define-clear_refs-for-config_mmu.patch
frv-miscellaneous-fixes.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
introduce-freezer-flags-rev-2.patch
make-cancel_rearming_delayed_work-reliable.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
frv-gdb-use-__maybe_unused.patch
mutex-subsystem-synchro-test-module.patch
