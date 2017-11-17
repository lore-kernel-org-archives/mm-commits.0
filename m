From: akpm@linux-foundation.org
Subject: [patch 15/94] kernel debug: support resetting WARN*_ONCE
Date: Fri, 17 Nov 2017 15:27:03 -0800
Message-ID: <20171117232703.Te0SHeBU2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55302 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423248AbdKQX1F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:27:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, torvalds@linux-foundation.org

From: Andi Kleen <ak@linux.intel.com>
Subject: kernel debug: support resetting WARN*_ONCE

I like _ONCE warnings because it's guaranteed that they don't
flood the log.

During testing I find it useful to reset the state of the once warnings,
so that I can rerun tests and see if they trigger again, or can
guarantee that a test run always hits the same warnings.

This patch adds a debugfs interface to reset all the _ONCE
warnings so that they appear again:

echo 1 > /sys/kernel/debug/clear_warn_once

This is implemented by putting all the warning booleans into
a special section, and clearing it.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20171017221455.6740-1-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/clearing-warn-once.txt |    7 ++++++
 include/asm-generic/bug.h            |    6 ++---
 include/asm-generic/sections.h       |    1 
 include/asm-generic/vmlinux.lds.h    |    3 ++
 kernel/panic.c                       |   28 +++++++++++++++++++++++++
 5 files changed, 42 insertions(+), 3 deletions(-)

diff -puN /dev/null Documentation/clearing-warn-once.txt
--- /dev/null
+++ a/Documentation/clearing-warn-once.txt
@@ -0,0 +1,7 @@
+
+WARN_ONCE / WARN_ON_ONCE only print a warning once.
+
+echo 1 > /sys/kernel/debug/clear_warn_once
+
+clears the state and allows the warnings to print once again.
+This can be useful after test suite runs to reproduce problems.
diff -puN include/asm-generic/bug.h~support-resetting-warn_once include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~support-resetting-warn_once
+++ a/include/asm-generic/bug.h
@@ -130,7 +130,7 @@ void __warn(const char *file, int line,
 
 #ifndef WARN_ON_ONCE
 #define WARN_ON_ONCE(condition)	({				\
-	static bool __section(.data.unlikely) __warned;		\
+	static bool __section(.data.once) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once && !__warned)) {		\
@@ -142,7 +142,7 @@ void __warn(const char *file, int line,
 #endif
 
 #define WARN_ONCE(condition, format...)	({			\
-	static bool __section(.data.unlikely) __warned;		\
+	static bool __section(.data.once) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once && !__warned)) {		\
@@ -153,7 +153,7 @@ void __warn(const char *file, int line,
 })
 
 #define WARN_TAINT_ONCE(condition, taint, format...)	({	\
-	static bool __section(.data.unlikely) __warned;		\
+	static bool __section(.data.once) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once && !__warned)) {		\
diff -puN include/asm-generic/sections.h~support-resetting-warn_once include/asm-generic/sections.h
--- a/include/asm-generic/sections.h~support-resetting-warn_once
+++ a/include/asm-generic/sections.h
@@ -44,6 +44,7 @@ extern char __entry_text_start[], __entr
 extern char __start_rodata[], __end_rodata[];
 extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __softirqentry_text_start[], __softirqentry_text_end[];
+extern char __start_once[], __end_once[];
 
 /* Start and end of .ctors section - used for constructor calls. */
 extern char __ctors_start[], __ctors_end[];
diff -puN include/asm-generic/vmlinux.lds.h~support-resetting-warn_once include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~support-resetting-warn_once
+++ a/include/asm-generic/vmlinux.lds.h
@@ -223,6 +223,9 @@
 	MEM_KEEP(init.data)						\
 	MEM_KEEP(exit.data)						\
 	*(.data.unlikely)						\
+	VMLINUX_SYMBOL(__start_once) = .;				\
+	*(.data.once)							\
+	VMLINUX_SYMBOL(__end_once) = .;					\
 	STRUCT_ALIGN();							\
 	*(__tracepoints)						\
 	/* implement dynamic printk debug */				\
diff -puN kernel/panic.c~support-resetting-warn_once kernel/panic.c
--- a/kernel/panic.c~support-resetting-warn_once
+++ a/kernel/panic.c
@@ -27,6 +27,8 @@
 #include <linux/console.h>
 #include <linux/bug.h>
 #include <linux/ratelimit.h>
+#include <linux/debugfs.h>
+#include <asm/sections.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -587,6 +589,32 @@ void warn_slowpath_null(const char *file
 EXPORT_SYMBOL(warn_slowpath_null);
 #endif
 
+#ifdef CONFIG_BUG
+
+/* Support resetting WARN*_ONCE state */
+
+static int clear_warn_once_set(void *data, u64 val)
+{
+	memset(__start_once, 0, __end_once - __start_once);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(clear_warn_once_fops,
+			NULL,
+			clear_warn_once_set,
+			"%lld\n");
+
+static __init int register_warn_debugfs(void)
+{
+	/* Don't care about failure */
+	debugfs_create_file("clear_warn_once", 0644, NULL,
+			    NULL, &clear_warn_once_fops);
+	return 0;
+}
+
+device_initcall(register_warn_debugfs);
+#endif
+
 #ifdef CONFIG_CC_STACKPROTECTOR
 
 /*
_
