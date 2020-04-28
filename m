From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Tue, 28 Apr 2020 14:27:39 -0700
Message-ID: <20200428212739.Kfeb9I7Xh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbgD1V1l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Apr 2020 17:27:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig     |    2 
 include/linux/printk.h |   97 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 88 insertions(+), 11 deletions(-)

--- a/arch/riscv/Kconfig~linux-next-rejects
+++ a/arch/riscv/Kconfig
@@ -30,6 +30,8 @@ config RISCV
 	select GENERIC_IOREMAP
 	select GENERIC_PTDUMP if MMU
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_KGDB_QXFER_PKT
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ASM_MODVERSIONS
 	select HAVE_DMA_CONTIGUOUS if MMU
--- a/include/linux/printk.h~linux-next-rejects
+++ a/include/linux/printk.h
@@ -279,40 +279,115 @@ static inline void printk_safe_flush_on_
 
 extern int kptr_restrict;
 
+/**
+ * pr_fmt - used by the pr_*() macros to generate the printk format string
+ * @fmt: format string passed from a pr_*() macro
+ *
+ * This macro can be used to generate a unified format string for pr_*()
+ * macros. A common use is to prefix all pr_*() messages in a file with a common
+ * string. For example, defining this at the top of a source file:
+ *
+ *        #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ *
+ * would prefix all pr_info, pr_emerg... messages in the file with the module
+ * name.
+ */
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
 #endif
 
-/*
- * These can be used to print at the various log levels.
- * All of these will print unconditionally, although note that pr_debug()
- * and other debug macros are compiled out unless either DEBUG is defined,
- * CONFIG_DYNAMIC_DEBUG is set, or CONFIG_DYNAMIC_DEBUG_CORE is set when
- * DYNAMIC_DEBUG_MODULE being defined for any modules.
+/**
+ * pr_emerg - Print an emergency-level message
+ * @fmt: format string
+ * @...: arguments for the format string
+ *
+ * This macro expands to a printk with KERN_EMERG loglevel. It uses pr_fmt() to
+ * generate the format string.
  */
 #define pr_emerg(fmt, ...) \
 	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+/**
+ * pr_alert - Print an alert-level message
+ * @fmt: format string
+ * @...: arguments for the format string
+ *
+ * This macro expands to a printk with KERN_ALERT loglevel. It uses pr_fmt() to
+ * generate the format string.
+ */
 #define pr_alert(fmt, ...) \
 	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+/**
+ * pr_crit - Print a critical-level message
+ * @fmt: format string
+ * @...: arguments for the format string
+ *
+ * This macro expands to a printk with KERN_CRIT loglevel. It uses pr_fmt() to
+ * generate the format string.
+ */
 #define pr_crit(fmt, ...) \
 	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+/**
+ * pr_err - Print an error-level message
+ * @fmt: format string
+ * @...: arguments for the format string
+ *
+ * This macro expands to a printk with KERN_ERR loglevel. It uses pr_fmt() to
+ * generate the format string.
+ */
 #define pr_err(fmt, ...) \
 	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+/**
+ * pr_warn - Print a warning-level message
+ * @fmt: format string
+ * @...: arguments for the format string
+ *
+ * This macro expands to a printk with KERN_WARNING loglevel. It uses pr_fmt()
+ * to generate the format string.
+ */
 #define pr_warn(fmt, ...) \
 	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+/**
+ * pr_notice - Print a notice-level message
+ * @fmt: format string
+ * @...: arguments for the format string
+ *
+ * This macro expands to a printk with KERN_NOTICE loglevel. It uses pr_fmt() to
+ * generate the format string.
+ */
 #define pr_notice(fmt, ...) \
 	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+/**
+ * pr_info - Print an info-level message
+ * @fmt: format string
+ * @...: arguments for the format string
+ *
+ * This macro expands to a printk with KERN_INFO loglevel. It uses pr_fmt() to
+ * generate the format string.
+ */
 #define pr_info(fmt, ...) \
 	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-/*
- * Like KERN_CONT, pr_cont() should only be used when continuing
- * a line with no newline ('\n') enclosed. Otherwise it defaults
- * back to KERN_DEFAULT.
+/**
+ * pr_cont - Continues a previous log message in the same line.
+ * @fmt: format string
+ * @...: arguments for the format string
+ *
+ * This macro expands to a printk with KERN_CONT loglevel. It should only be
+ * used when continuing a log message with no newline ('\n') enclosed. Otherwise
+ * it defaults back to KERN_DEFAULT loglevel.
  */
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
-/* pr_devel() should produce zero code unless DEBUG is defined */
+/**
+ * pr_devel - Print a debug-level message conditionally
+ * @fmt: format string
+ * @...: arguments for the format string
+ *
+ * This macro expands to a printk with KERN_DEBUG loglevel if DEBUG is
+ * defined. Otherwise it does nothing.
+ *
+ * It uses pr_fmt() to generate the format string.
+ */
 #ifdef DEBUG
 #define pr_devel(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-git-rejects.patch
linux-next-git-rejects-fix.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
