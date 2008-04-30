From: akpm@linux-foundation.org
Subject: - taint-kernel-after-warn_oncondition.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:50 -0700
Message-ID: <200804300538.m3U5coOL028780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753723AbYD3Fja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nurhussein@gmail.com, a.p.zijlstra@chello.nl, arjan@infradead.org, hskinnemoen@atmel.com, kyle@mcmartin.ca, lethal@linux-sh.org, mingo@elte.hu, rdunlap@xenotime.net, schwidefsky@de.ibm


The patch titled
     Taint kernel after WARN_ON(condition)
has been removed from the -mm tree.  Its filename was
     taint-kernel-after-warn_oncondition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Taint kernel after WARN_ON(condition)
From: Nur Hussein <nurhussein@gmail.com>

The kernel is sent to tainted within the warn_on_slowpath() function, and
whenever a warning occurs the new taint flag 'W' is set.  This is useful to
know if a warning occurred before a BUG by preserving the warning as a flag
in the taint state.

This does not work on architectures where WARN_ON has its own definition.
These archs are:
	1. s390
	2. superh
	3. avr32
	4. parisc

The maintainers of these architectures have been added in the Cc: list
in this email to alert them to the situation.

The documentation in oops-tracing.txt has been updated to include the
new flag.

Signed-off-by: Nur Hussein <nurhussein@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/oops-tracing.txt |    4 ++++
 include/linux/kernel.h         |    1 +
 kernel/panic.c                 |    8 ++++++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff -puN Documentation/oops-tracing.txt~taint-kernel-after-warn_oncondition Documentation/oops-tracing.txt
--- a/Documentation/oops-tracing.txt~taint-kernel-after-warn_oncondition
+++ a/Documentation/oops-tracing.txt
@@ -253,6 +253,10 @@ characters, each representing a particul
 
   8: 'D' if the kernel has died recently, i.e. there was an OOPS or BUG.
 
+  9: 'A' if the ACPI table has been overridden.
+
+ 10: 'W' if a warning has previously been issued by the kernel.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
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
@@ -312,6 +315,7 @@ void warn_on_slowpath(const char *file, 
 	print_modules();
 	dump_stack();
 	print_oops_end_marker();
+	add_taint(TAINT_WARN);
 }
 EXPORT_SYMBOL(warn_on_slowpath);
 #endif
_

Patches currently in -mm which might be from nurhussein@gmail.com are

origin.patch

