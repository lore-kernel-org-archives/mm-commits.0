From: akpm@linux-foundation.org
Subject: [patch 21/94] bug: fix "cut here" location for
 __WARN_TAINT architectures
Date: Fri, 17 Nov 2017 15:27:24 -0800
Message-ID: <20171117232724.rC1qiEbsa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55370 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423259AbdKQX10 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:27:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, fengguang.wu@intel.com, jpoimboe@redhat.com, keescook@chromium.org, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org

From: Kees Cook <keescook@chromium.org>
Subject: bug: fix "cut here" location for __WARN_TAINT architectures

Prior to v4.11, x86 used warn_slowpath_fmt() for handling WARN()s.  After
WARN() was moved to using UD0 on x86, the warning text started appearing
_before_ the "cut here" line.  This appears to have been a long-standing
bug on architectures that used __WARN_TAINT, but it didn't get fixed.

v4.11 and earlier on x86:

[    7.944142] ------------[ cut here ]------------
[    7.945631] WARNING: CPU: 0 PID: 2956 at drivers/misc/lkdtm_bugs.c:65 lkdtm_WARNING+0x21/0x30
[    7.947453] This is a warning message
[    7.948357] Modules linked in:

v4.12 and later on x86:

[    8.973063] This is a warning message
[    8.973885] ------------[ cut here ]------------
[    8.974867] WARNING: CPU: 1 PID: 2982 at drivers/misc/lkdtm_bugs.c:68 lkdtm_WARNING+0x15/0x20
[    8.976563] Modules linked in:

With this fix:

[    9.157133] ------------[ cut here ]------------
[    9.158143] This is a warning message
[    9.159099] WARNING: CPU: 3 PID: 3009 at drivers/misc/lkdtm_bugs.c:67 lkdtm_WARNING+0x15/0x20

Since the __FILE__ reporting happens as part of the UD0 handler, it isn't
trivial to move the message to after the WARNING line, but at least we can
fix the position of the "cut here" line so all the various logging tools
will start including the actual runtime warning message again, when they
follow the instruction and "cut here".

Link: http://lkml.kernel.org/r/1510100869-73751-4-git-send-email-keescook@chromium.org
Fixes: 9a93848fe787 ("x86/debug: Implement __WARN() using UD0")
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    5 +++--
 kernel/panic.c            |   16 +++++++++++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff -puN include/asm-generic/bug.h~bug-fix-cut-here-location-for-__warn_taint-architectures include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~bug-fix-cut-here-location-for-__warn_taint-architectures
+++ a/include/asm-generic/bug.h
@@ -92,10 +92,11 @@ extern void warn_slowpath_null(const cha
 #define __WARN_printf_taint(taint, arg...)				\
 	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
 #else
+extern __printf(1, 2) void __warn_printk(const char *fmt, ...);
 #define __WARN()		__WARN_TAINT(TAINT_WARN)
-#define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
+#define __WARN_printf(arg...)	do { __warn_printk(arg); __WARN(); } while (0)
 #define __WARN_printf_taint(taint, arg...)				\
-	do { printk(arg); __WARN_TAINT(taint); } while (0)
+	do { __warn_printk(arg); __WARN_TAINT(taint); } while (0)
 #endif
 
 /* used internally by panic.c */
diff -puN kernel/panic.c~bug-fix-cut-here-location-for-__warn_taint-architectures kernel/panic.c
--- a/kernel/panic.c~bug-fix-cut-here-location-for-__warn_taint-architectures
+++ a/kernel/panic.c
@@ -520,7 +520,8 @@ void __warn(const char *file, int line,
 {
 	disable_trace_on_warning();
 
-	pr_warn(CUT_HERE);
+	if (args)
+		pr_warn(CUT_HERE);
 
 	if (file)
 		pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS\n",
@@ -584,9 +585,22 @@ EXPORT_SYMBOL(warn_slowpath_fmt_taint);
 
 void warn_slowpath_null(const char *file, int line)
 {
+	pr_warn(CUT_HERE);
 	__warn(file, line, __builtin_return_address(0), TAINT_WARN, NULL, NULL);
 }
 EXPORT_SYMBOL(warn_slowpath_null);
+#else
+void __warn_printk(const char *fmt, ...)
+{
+	va_list args;
+
+	pr_warn(CUT_HERE);
+
+	va_start(args, fmt);
+	vprintk(fmt, args);
+	va_end(args);
+}
+EXPORT_SYMBOL(__warn_printk);
 #endif
 
 #ifdef CONFIG_BUG
_
