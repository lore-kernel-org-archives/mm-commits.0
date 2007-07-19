From: akpm@linux-foundation.org
Subject: - x86_64-pm_trace-support.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:49 -0700
Message-ID: <200707192008.l6JK8nch020489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761463AbXGSUSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:18:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nigel@nigel.suspend2.net, ak@suse.de, pavel@ucw.cz, rdunlap@xenotime.net, rjw@sisk.pl, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     x86_64: PM_TRACE support
has been removed from the -mm tree.  Its filename was
     x86_64-pm_trace-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: PM_TRACE support
From: Nigel Cunningham <nigel@nigel.suspend2.net>

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andi Kleen <ak@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/vmlinux.lds.S  |    7 +++++++
 drivers/base/power/trace.c        |    5 ++++-
 include/asm-i386/resume-trace.h   |   13 +++++++++++++
 include/asm-x86_64/resume-trace.h |   13 +++++++++++++
 include/linux/resume-trace.h      |   19 +++++--------------
 kernel/power/Kconfig              |    2 +-
 6 files changed, 43 insertions(+), 16 deletions(-)

diff -puN arch/x86_64/kernel/vmlinux.lds.S~x86_64-pm_trace-support arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S~x86_64-pm_trace-support
+++ a/arch/x86_64/kernel/vmlinux.lds.S
@@ -54,6 +54,13 @@ SECTIONS
 
   RODATA
 
+  . = ALIGN(4);
+  .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
+  	__tracedata_start = .;
+	*(.tracedata)
+  	__tracedata_end = .;
+  }
+
   . = ALIGN(PAGE_SIZE);        /* Align data segment to page size boundary */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
diff -puN drivers/base/power/trace.c~x86_64-pm_trace-support drivers/base/power/trace.c
--- a/drivers/base/power/trace.c~x86_64-pm_trace-support
+++ a/drivers/base/power/trace.c
@@ -142,6 +142,7 @@ void set_trace_device(struct device *dev
 {
 	dev_hash_value = hash_string(DEVSEED, dev->bus_id, DEVHASH);
 }
+EXPORT_SYMBOL(set_trace_device);
 
 /*
  * We could just take the "tracedata" index into the .tracedata
@@ -162,6 +163,7 @@ void generate_resume_trace(void *traceda
 	file_hash_value = hash_string(lineno, file, FILEHASH);
 	set_magic_time(user_hash_value, file_hash_value, dev_hash_value);
 }
+EXPORT_SYMBOL(generate_resume_trace);
 
 extern char __tracedata_start, __tracedata_end;
 static int show_file_hash(unsigned int value)
@@ -170,7 +172,8 @@ static int show_file_hash(unsigned int v
 	char *tracedata;
 
 	match = 0;
-	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ; tracedata += 6) {
+	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ;
+			tracedata += 2 + sizeof(unsigned long)) {
 		unsigned short lineno = *(unsigned short *)tracedata;
 		const char *file = *(const char **)(tracedata + 2);
 		unsigned int hash = hash_string(lineno, file, FILEHASH);
diff -puN /dev/null include/asm-i386/resume-trace.h
--- /dev/null
+++ a/include/asm-i386/resume-trace.h
@@ -0,0 +1,13 @@
+#define TRACE_RESUME(user) do {					\
+	if (pm_trace_enabled) {					\
+		void *tracedata;				\
+		asm volatile("movl $1f,%0\n"			\
+			".section .tracedata,\"a\"\n"		\
+			"1:\t.word %c1\n"			\
+			"\t.long %c2\n"				\
+			".previous"				\
+			:"=r" (tracedata)			\
+			: "i" (__LINE__), "i" (__FILE__));	\
+		generate_resume_trace(tracedata, user);		\
+	}							\
+} while (0)
diff -puN /dev/null include/asm-x86_64/resume-trace.h
--- /dev/null
+++ a/include/asm-x86_64/resume-trace.h
@@ -0,0 +1,13 @@
+#define TRACE_RESUME(user) do {					\
+	if (pm_trace_enabled) {					\
+		void *tracedata;				\
+		asm volatile("movq $1f,%0\n"			\
+			".section .tracedata,\"a\"\n"		\
+			"1:\t.word %c1\n"			\
+			"\t.quad %c2\n"				\
+			".previous"				\
+			:"=r" (tracedata)			\
+			: "i" (__LINE__), "i" (__FILE__));	\
+		generate_resume_trace(tracedata, user);		\
+	}							\
+} while (0)
diff -puN include/linux/resume-trace.h~x86_64-pm_trace-support include/linux/resume-trace.h
--- a/include/linux/resume-trace.h~x86_64-pm_trace-support
+++ a/include/linux/resume-trace.h
@@ -2,6 +2,7 @@
 #define RESUME_TRACE_H
 
 #ifdef CONFIG_PM_TRACE
+#include <asm/resume-trace.h>
 
 extern int pm_trace_enabled;
 
@@ -9,20 +10,10 @@ struct device;
 extern void set_trace_device(struct device *);
 extern void generate_resume_trace(void *tracedata, unsigned int user);
 
-#define TRACE_DEVICE(dev) set_trace_device(dev)
-#define TRACE_RESUME(user) do {					\
-	if (pm_trace_enabled) {					\
-		void *tracedata;				\
-		asm volatile("movl $1f,%0\n"			\
-			".section .tracedata,\"a\"\n"		\
-			"1:\t.word %c1\n"			\
-			"\t.long %c2\n"				\
-			".previous"				\
-			:"=r" (tracedata)			\
-			: "i" (__LINE__), "i" (__FILE__));	\
-		generate_resume_trace(tracedata, user);		\
-	}							\
-} while (0)
+#define TRACE_DEVICE(dev) do { \
+	if (pm_trace_enabled) \
+		set_trace_device(dev); \
+	} while(0)
 
 #else
 
diff -puN kernel/power/Kconfig~x86_64-pm_trace-support kernel/power/Kconfig
--- a/kernel/power/Kconfig~x86_64-pm_trace-support
+++ a/kernel/power/Kconfig
@@ -50,7 +50,7 @@ config DISABLE_CONSOLE_SUSPEND
 
 config PM_TRACE
 	bool "Suspend/resume event tracing"
-	depends on PM && PM_DEBUG && X86_32 && EXPERIMENTAL
+	depends on PM && PM_DEBUG && X86 && EXPERIMENTAL
 	default n
 	---help---
 	This enables some cheesy code to save the last PM event point in the
_

Patches currently in -mm which might be from nigel@nigel.suspend2.net are

origin.patch
