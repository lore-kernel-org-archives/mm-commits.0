From: akpm@linux-foundation.org
Subject: - whitespace-fixes-panic-handling.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:46 -0700
Message-ID: <200710190343.l9J3hk2A013092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38082 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966070AbXJSDzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: panic handling
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-panic-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: panic handling
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
