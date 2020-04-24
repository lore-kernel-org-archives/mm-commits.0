From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Thu, 23 Apr 2020 20:49:12 -0700
Message-ID: <20200424034912.NEyjGtsH3%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgDXDtP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 23:49:15 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |  101 +++++++++++++++++++++++++++++++++------
 1 file changed, 88 insertions(+), 13 deletions(-)

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
+ */
+ #define pr_emerg(fmt, ...) \
+ 	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+/**
+ * pr_alert - Print an alert-level message
+ * @fmt: format string
+ * @...: arguments for the format string
+ *
+ * This macro expands to a printk with KERN_ALERT loglevel. It uses pr_fmt() to
+ * generate the format string.
  */
-#define pr_emerg(fmt, ...) \
-	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
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
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
