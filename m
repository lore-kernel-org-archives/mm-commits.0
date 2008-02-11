From: akpm@linux-foundation.org
Subject: - taint-kernel-after-warn_oncondition.patch removed from -mm tree
Date: Mon, 11 Feb 2008 12:57:14 -0800
Message-ID: <200802112057.m1BKvEmb032526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51510 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471AbYBKVGm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 16:06:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nurhussein@gmail.com, a.p.zijlstra@chello.nl, arjan@infradead.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Taint kernel after WARN_ON(condition)
has been removed from the -mm tree.  Its filename was
     taint-kernel-after-warn_oncondition.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Taint kernel after WARN_ON(condition)
From: Nur Hussein <nurhussein@gmail.com>

Taint the kernel with a new flag, 'W', whenever a warning is issued with
WARN_ON(condition).  Whenever a warning occurs, it is helpful to record
this within the kernel state as a taint.  When a BUG happens, it'd be
useful to know if it was also preceded by a WARN.

Signed-off-by: Nur Hussein (nurhussein@gmail.com)
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    6 +++++-
 include/linux/kernel.h    |    1 +
 kernel/panic.c            |    7 +++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff -puN include/asm-generic/bug.h~taint-kernel-after-warn_oncondition include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~taint-kernel-after-warn_oncondition
+++ a/include/asm-generic/bug.h
@@ -42,8 +42,10 @@ extern void warn_on_slowpath(const char 
 #ifndef WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on))					\
+	if (unlikely(__ret_warn_on)) {					\
 		__WARN();						\
+		add_taint(TAINT_WARN);					\
+	}								\
 	unlikely(__ret_warn_on);					\
 })
 #endif
@@ -60,6 +62,8 @@ extern void warn_on_slowpath(const char 
 #ifndef HAVE_ARCH_WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on)) 					\
+		add_taint(TAINT_WARN);					\
 	unlikely(__ret_warn_on);					\
 })
 #endif
diff -puN include/linux/kernel.h~taint-kernel-after-warn_oncondition include/linux/kernel.h
--- a/include/linux/kernel.h~taint-kernel-after-warn_oncondition
+++ a/include/linux/kernel.h
@@ -255,6 +255,7 @@ extern enum system_states {
 #define TAINT_USER			(1<<6)
 #define TAINT_DIE			(1<<7)
 #define TAINT_OVERRIDDEN_ACPI_TABLE	(1<<8)
+#define TAINT_WARN			(1<<9)
 
 extern void dump_stack(void) __cold;
 
diff -puN kernel/panic.c~taint-kernel-after-warn_oncondition kernel/panic.c
--- a/kernel/panic.c~taint-kernel-after-warn_oncondition
+++ a/kernel/panic.c
@@ -153,6 +153,8 @@ EXPORT_SYMBOL(panic);
  *  'M' - System experienced a machine check exception.
  *  'B' - System has hit bad_page.
  *  'U' - Userspace-defined naughtiness.
+ *  'A' - ACPI table overridden.
+ *  'W' - Taint on warning.
  *
  *	The string is overwritten by the next call to print_taint().
  */
@@ -161,7 +163,7 @@ const char *print_tainted(void)
 {
 	static char buf[20];
 	if (tainted) {
-		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c",
+		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c%c",
 			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
 			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
 			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
@@ -170,7 +172,8 @@ const char *print_tainted(void)
 			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
 			tainted & TAINT_USER ? 'U' : ' ',
 			tainted & TAINT_DIE ? 'D' : ' ',
-			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ');
+			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ',
+			tainted & TAINT_WARN ? 'W' : ' ');
 	}
 	else
 		snprintf(buf, sizeof(buf), "Not tainted");
_

Patches currently in -mm which might be from nurhussein@gmail.com are

taint-kernel-after-warn_oncondition.patch
