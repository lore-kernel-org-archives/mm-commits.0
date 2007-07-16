From: akpm@linux-foundation.org
Subject: - frv-be-self-consistent-and-use-config_gdb_console-everywhere.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:05 -0700
Message-ID: <200707162050.l6GKo5Ra001290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51474 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987AbXGPV0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:26:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     FRV: Be (self-)consistent and use CONFIG_GDB_CONSOLE everywhere
has been removed from the -mm tree.  Its filename was
     frv-be-self-consistent-and-use-config_gdb_console-everywhere.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FRV: Be (self-)consistent and use CONFIG_GDB_CONSOLE everywhere
From: David Howells <dhowells@redhat.com>

Be (self-)consistent and use CONFIG_GDB_CONSOLE everywhere rather than using
CONFIG_GDBSTUB_CONSOLE in some places and not others.  This is also then
consistent with other archs.

Also remove the gdbstub console device() op which doesn't seem to be necessary
now (especially as it doesn't compile).

[Found by Robert P. J. Day <rpjday@mindspring.com>]

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/kernel/gdb-stub.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN arch/frv/kernel/gdb-stub.c~frv-be-self-consistent-and-use-config_gdb_console-everywhere arch/frv/kernel/gdb-stub.c
--- a/arch/frv/kernel/gdb-stub.c~frv-be-self-consistent-and-use-config_gdb_console-everywhere
+++ a/arch/frv/kernel/gdb-stub.c
@@ -647,17 +647,11 @@ void debug_to_serial(const char *p, int 
 }
 #endif
 
-#ifdef CONFIG_GDBSTUB_CONSOLE
-
-static kdev_t gdbstub_console_dev(struct console *con)
-{
-	return MKDEV(1,3); /* /dev/null */
-}
+#ifdef CONFIG_GDB_CONSOLE
 
 static struct console gdbstub_console = {
 	.name	= "gdb",
 	.write	= gdbstub_console_write,	/* in break.S */
-	.device	= gdbstub_console_dev,
 	.flags	= CON_PRINTBUFFER,
 	.index	= -1,
 };
@@ -2021,7 +2015,7 @@ void __init gdbstub_init(void)
 	ptr = mem2hex(gdbstub_banner, ptr, sizeof(gdbstub_banner) - 1, 0);
 	gdbstub_send_packet(output_buffer);
 #endif
-#if defined(CONFIG_GDBSTUB_CONSOLE) && defined(CONFIG_GDBSTUB_IMMEDIATE)
+#if defined(CONFIG_GDB_CONSOLE) && defined(CONFIG_GDBSTUB_IMMEDIATE)
 	register_console(&gdbstub_console);
 #endif
 
@@ -2031,7 +2025,7 @@ void __init gdbstub_init(void)
 /*
  * register the console at a more appropriate time
  */
-#if defined (CONFIG_GDBSTUB_CONSOLE) && !defined(CONFIG_GDBSTUB_IMMEDIATE)
+#if defined (CONFIG_GDB_CONSOLE) && !defined(CONFIG_GDBSTUB_IMMEDIATE)
 static int __init gdbstub_postinit(void)
 {
 	printk("registering console\n");
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
