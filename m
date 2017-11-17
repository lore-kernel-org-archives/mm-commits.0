From: akpm@linux-foundation.org
Subject: [patch 16/94] kernel debug: support resetting WARN_ONCE
 for all architectures
Date: Fri, 17 Nov 2017 15:27:06 -0800
Message-ID: <20171117232706.24JfVndUM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55312 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423248AbdKQX1I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:27:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, torvalds@linux-foundation.org

From: Andi Kleen <ak@linux.intel.com>
Subject: kernel debug: support resetting WARN_ONCE for all architectures

Some architectures store the WARN_ONCE state in the flags field of the
bug_entry.  Clear that one too when resetting once state through
/sys/kernel/debug/clear_warn_once

Pointed out by Michael Ellerman

Improves the earlier patch that add clear_warn_once.

[ak@linux.intel.com: add a missing ifdef CONFIG_MODULES]
  Link: http://lkml.kernel.org/r/20171020170633.9593-1-andi@firstfloor.org
[akpm@linux-foundation.org: fix unused var warning]
[akpm@linux-foundation.org: Use 0200 for clear_warn_once file, per mpe]
[akpm@linux-foundation.org: clear BUGFLAG_DONE in clear_once_table(), per mpe]
Link: http://lkml.kernel.org/r/20171019204642.7404-1-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    5 +++++
 kernel/panic.c      |    3 ++-
 lib/bug.c           |   23 +++++++++++++++++++++++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff -puN include/linux/bug.h~support-resetting-warn_once-for-all-architectures include/linux/bug.h
--- a/include/linux/bug.h~support-resetting-warn_once-for-all-architectures
+++ a/include/linux/bug.h
@@ -43,6 +43,8 @@ enum bug_trap_type report_bug(unsigned l
 /* These are defined by the architecture */
 int is_valid_bugaddr(unsigned long addr);
 
+void generic_bug_clear_once(void);
+
 #else	/* !CONFIG_GENERIC_BUG */
 
 static inline enum bug_trap_type report_bug(unsigned long bug_addr,
@@ -51,6 +53,9 @@ static inline enum bug_trap_type report_
 	return BUG_TRAP_TYPE_BUG;
 }
 
+
+static inline void generic_bug_clear_once(void) {}
+
 #endif	/* CONFIG_GENERIC_BUG */
 
 /*
diff -puN kernel/panic.c~support-resetting-warn_once-for-all-architectures kernel/panic.c
--- a/kernel/panic.c~support-resetting-warn_once-for-all-architectures
+++ a/kernel/panic.c
@@ -595,6 +595,7 @@ EXPORT_SYMBOL(warn_slowpath_null);
 
 static int clear_warn_once_set(void *data, u64 val)
 {
+	generic_bug_clear_once();
 	memset(__start_once, 0, __end_once - __start_once);
 	return 0;
 }
@@ -607,7 +608,7 @@ DEFINE_SIMPLE_ATTRIBUTE(clear_warn_once_
 static __init int register_warn_debugfs(void)
 {
 	/* Don't care about failure */
-	debugfs_create_file("clear_warn_once", 0644, NULL,
+	debugfs_create_file("clear_warn_once", 0200, NULL,
 			    NULL, &clear_warn_once_fops);
 	return 0;
 }
diff -puN lib/bug.c~support-resetting-warn_once-for-all-architectures lib/bug.c
--- a/lib/bug.c~support-resetting-warn_once-for-all-architectures
+++ a/lib/bug.c
@@ -196,3 +196,26 @@ enum bug_trap_type report_bug(unsigned l
 
 	return BUG_TRAP_TYPE_BUG;
 }
+
+static void clear_once_table(struct bug_entry *start, struct bug_entry *end)
+{
+	struct bug_entry *bug;
+
+	for (bug = start; bug < end; bug++)
+		bug->flags &= ~BUGFLAG_DONE;
+}
+
+void generic_bug_clear_once(void)
+{
+#ifdef CONFIG_MODULES
+	struct module *mod;
+
+	rcu_read_lock_sched();
+	list_for_each_entry_rcu(mod, &module_bug_list, bug_list)
+		clear_once_table(mod->bug_table,
+				 mod->bug_table + mod->num_bugs);
+	rcu_read_unlock_sched();
+#endif
+
+	clear_once_table(__start___bug_table, __stop___bug_table);
+}
_
