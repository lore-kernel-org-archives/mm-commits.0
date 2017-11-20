From: akpm@linux-foundation.org
Subject: [merged]
 bug-define-the-cut-here-string-in-a-single-place.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:23:32 -0800
Message-ID: <20171120212332.aYgZZchPu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40116 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753046AbdKTVXd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:23:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, fengguang.wu@intel.com, jpoimboe@redhat.com, keescook@chromium.org, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org


The patch titled
     Subject: bug: define the "cut here" string in a single place
has been removed from the -mm tree.  Its filename was
     bug-define-the-cut-here-string-in-a-single-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: bug: define the "cut here" string in a single place

The "cut here" string is used in a few paths.  Define it in a single
place.

Link: http://lkml.kernel.org/r/1510100869-73751-3-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/mm/fault.c   |    2 +-
 include/asm-generic/bug.h |    2 ++
 kernel/panic.c            |    2 +-
 lib/bug.c                 |    2 +-
 4 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/mn10300/mm/fault.c~bug-define-the-cut-here-string-in-a-single-place arch/mn10300/mm/fault.c
--- a/arch/mn10300/mm/fault.c~bug-define-the-cut-here-string-in-a-single-place
+++ a/arch/mn10300/mm/fault.c
@@ -60,7 +60,7 @@ void bust_spinlocks(int yes)
 void do_BUG(const char *file, int line)
 {
 	bust_spinlocks(1);
-	printk(KERN_EMERG "------------[ cut here ]------------\n");
+	printk(KERN_EMERG CUT_HERE);
 	printk(KERN_EMERG "kernel BUG at %s:%d!\n", file, line);
 }
 
diff -puN include/asm-generic/bug.h~bug-define-the-cut-here-string-in-a-single-place include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~bug-define-the-cut-here-string-in-a-single-place
+++ a/include/asm-generic/bug.h
@@ -4,6 +4,8 @@
 
 #include <linux/compiler.h>
 
+#define CUT_HERE		"------------[ cut here ]------------\n"
+
 #ifdef CONFIG_GENERIC_BUG
 #define BUGFLAG_WARNING		(1 << 0)
 #define BUGFLAG_ONCE		(1 << 1)
diff -puN kernel/panic.c~bug-define-the-cut-here-string-in-a-single-place kernel/panic.c
--- a/kernel/panic.c~bug-define-the-cut-here-string-in-a-single-place
+++ a/kernel/panic.c
@@ -520,7 +520,7 @@ void __warn(const char *file, int line,
 {
 	disable_trace_on_warning();
 
-	pr_warn("------------[ cut here ]------------\n");
+	pr_warn(CUT_HERE);
 
 	if (file)
 		pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS\n",
diff -puN lib/bug.c~bug-define-the-cut-here-string-in-a-single-place lib/bug.c
--- a/lib/bug.c~bug-define-the-cut-here-string-in-a-single-place
+++ a/lib/bug.c
@@ -186,7 +186,7 @@ enum bug_trap_type report_bug(unsigned l
 		return BUG_TRAP_TYPE_WARN;
 	}
 
-	printk(KERN_DEFAULT "------------[ cut here ]------------\n");
+	printk(KERN_DEFAULT CUT_HERE);
 
 	if (file)
 		pr_crit("kernel BUG at %s:%u!\n", file, line);
_

Patches currently in -mm which might be from keescook@chromium.org are


