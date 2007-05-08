From: akpm@linux-foundation.org
Subject: - uml-dump-core-on-panic.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:19 -0700
Message-ID: <200705080007.l4807JFv009270@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967403AbXEHAHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: dump core on panic
has been removed from the -mm tree.  Its filename was
     uml-dump-core-on-panic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: dump core on panic
From: Jeff Dike <jdike@addtoit.com>

Dump core after a panic.  This will provide better debugging information than
is currently available.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h     |    1 +
 arch/um/kernel/um_arch.c |    2 +-
 arch/um/os-Linux/util.c  |    6 ++++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/um/include/os.h~uml-dump-core-on-panic arch/um/include/os.h
--- a/arch/um/include/os.h~uml-dump-core-on-panic
+++ a/arch/um/include/os.h
@@ -279,6 +279,7 @@ extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
 extern void setup_hostinfo(char *buf, int len);
 extern int setjmp_wrapper(void (*proc)(void *, void *), ...);
+extern void os_dump_core(void);
 
 /* time.c */
 #define BILLION (1000 * 1000 * 1000)
diff -puN arch/um/kernel/um_arch.c~uml-dump-core-on-panic arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-dump-core-on-panic
+++ a/arch/um/kernel/um_arch.c
@@ -474,7 +474,7 @@ static int panic_exit(struct notifier_bl
 	show_regs(&(current->thread.regs));
 	bust_spinlocks(0);
 	uml_exitcode = 1;
-	machine_halt();
+	os_dump_core();
 	return 0;
 }
 
diff -puN arch/um/os-Linux/util.c~uml-dump-core-on-panic arch/um/os-Linux/util.c
--- a/arch/um/os-Linux/util.c~uml-dump-core-on-panic
+++ a/arch/um/os-Linux/util.c
@@ -119,3 +119,9 @@ int setjmp_wrapper(void (*proc)(void *, 
 	va_end(args);
 	return n;
 }
+
+void os_dump_core(void)
+{
+	signal(SIGSEGV, SIG_DFL);
+	abort();
+}
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
