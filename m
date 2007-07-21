From: akpm@linux-foundation.org
Subject: + whitespace-fixes-panic-handling.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:18:52 -0700
Message-ID: <200707210018.l6L0IqIi023893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55117 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759646AbXGUAUT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:20:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com


The patch titled
     whitespace fixes: panic handling
has been added to the -mm tree.  Its filename is
     whitespace-fixes-panic-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: panic handling
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/panic.c~whitespace-fixes-panic-handling kernel/panic.c
--- a/kernel/panic.c~whitespace-fixes-panic-handling
+++ a/kernel/panic.c
@@ -56,14 +56,14 @@ EXPORT_SYMBOL(panic_blink);
  *
  *	This function never returns.
  */
- 
+
 NORET_TYPE void panic(const char * fmt, ...)
 {
 	long i;
 	static char buf[1024];
 	va_list args;
 #if defined(CONFIG_S390)
-        unsigned long caller = (unsigned long) __builtin_return_address(0);
+	unsigned long caller = (unsigned long) __builtin_return_address(0);
 #endif
 
 	/*
@@ -128,7 +128,7 @@ NORET_TYPE void panic(const char * fmt, 
 	}
 #endif
 #if defined(CONFIG_S390)
-        disabled_wait(caller);
+	disabled_wait(caller);
 #endif
 	local_irq_enable();
 	for (i = 0;;) {
@@ -154,7 +154,7 @@ EXPORT_SYMBOL(panic);
  *
  *	The string is overwritten by the next call to print_taint().
  */
- 
+
 const char *print_tainted(void)
 {
 	static char buf[20];
@@ -164,7 +164,7 @@ const char *print_tainted(void)
 			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
 			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
 			tainted & TAINT_FORCED_RMMOD ? 'R' : ' ',
- 			tainted & TAINT_MACHINE_CHECK ? 'M' : ' ',
+			tainted & TAINT_MACHINE_CHECK ? 'M' : ' ',
 			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
 			tainted & TAINT_USER ? 'U' : ' ',
 			tainted & TAINT_DIE ? 'D' : ' ');
_

Patches currently in -mm which might be from dwalker@mvista.com are

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
