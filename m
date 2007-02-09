From: akpm@linux-foundation.org
Subject: + add-pm_trace-x86_64-support.patch added to -mm tree
Date: Thu, 08 Feb 2007 16:24:51 -0800
Message-ID: <200702090024.l190OpEM031966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46843 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422906AbXBIAZA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 19:25:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nigel@nigel.suspend2.net, ak@suse.de


The patch titled
     Add PM_TRACE x86_64 support
has been added to the -mm tree.  Its filename is
     add-pm_trace-x86_64-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add PM_TRACE x86_64 support
From: Nigel Cunningham <nigel@nigel.suspend2.net>

Add x86_64 support for PM_TRACE, and shift per-arch code to the appropriate
subdirectories.

Symbol exports are added so tracing can be used from drivers built as
modules too.

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/vmlinux.lds.S  |    7 +++++++
 drivers/base/power/trace.c        |    5 ++++-
 include/asm-i386/resume-trace.h   |   21 +++++++++++++++++++++
 include/asm-x86_64/resume-trace.h |   21 +++++++++++++++++++++
 include/linux/resume-trace.h      |   24 ++++++------------------
 kernel/power/Kconfig              |    2 +-
 6 files changed, 60 insertions(+), 20 deletions(-)

diff -puN arch/x86_64/kernel/vmlinux.lds.S~add-pm_trace-x86_64-support arch/x86_64/kernel/vmlinux.lds.S
--- a/arch/x86_64/kernel/vmlinux.lds.S~add-pm_trace-x86_64-support
+++ a/arch/x86_64/kernel/vmlinux.lds.S
@@ -54,6 +54,13 @@ SECTIONS
 
   BUG_TABLE
 
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
diff -puN drivers/base/power/trace.c~add-pm_trace-x86_64-support drivers/base/power/trace.c
--- a/drivers/base/power/trace.c~add-pm_trace-x86_64-support
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
@@ -0,0 +1,21 @@
+#ifndef ARCH_RESUME_TRACE_H
+#define ARCH_RESUME_TRACE_H
+
+#ifdef CONFIG_PM_TRACE
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
+#else
+#define TRACE_RESUME(user) do { } while (0)
+#endif
+#endif
diff -puN /dev/null include/asm-x86_64/resume-trace.h
--- /dev/null
+++ a/include/asm-x86_64/resume-trace.h
@@ -0,0 +1,21 @@
+#ifndef ARCH_RESUME_TRACE_H
+#define ARCH_RESUME_TRACE_H
+
+#ifdef CONFIG_PM_TRACE
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
+#else
+#define TRACE_RESUME(user) do { } while (0)
+#endif
+#endif
diff -puN include/linux/resume-trace.h~add-pm_trace-x86_64-support include/linux/resume-trace.h
--- a/include/linux/resume-trace.h~add-pm_trace-x86_64-support
+++ a/include/linux/resume-trace.h
@@ -1,6 +1,8 @@
 #ifndef RESUME_TRACE_H
 #define RESUME_TRACE_H
 
+#include <asm/resume-trace.h>
+
 #ifdef CONFIG_PM_TRACE
 
 extern int pm_trace_enabled;
@@ -9,26 +11,12 @@ struct device;
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
-
+#define TRACE_DEVICE(dev) do { \
+	if (pm_trace_enabled) \
+		set_trace_device(dev); \
+	} while(0)
 #else
-
 #define TRACE_DEVICE(dev) do { } while (0)
-#define TRACE_RESUME(dev) do { } while (0)
-
 #endif
 
 #endif
diff -puN kernel/power/Kconfig~add-pm_trace-x86_64-support kernel/power/Kconfig
--- a/kernel/power/Kconfig~add-pm_trace-x86_64-support
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

add-pm_trace-x86_64-support.patch
