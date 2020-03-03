From: akpm@linux-foundation.org
Subject: +
 mm-compaction-disable-compact_unevictable_allowed-on-rt.patch added to -mm
 tree
Date: Tue, 03 Mar 2020 15:56:53 -0800
Message-ID: <20200303235653.eODkCo-JR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbgCCX45 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Mar 2020 18:56:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bigeasy@linutronix.de, keescook@chromium.org, mcgrof@kernel.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org, tglx@linutronix.de, vbabka@suse.cz, yzaikin@google.com


The patch titled
     Subject: mm/compaction: Disable compact_unevictable_allowed on RT
has been added to the -mm tree.  Its filename is
     mm-compaction-disable-compact_unevictable_allowed-on-rt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-disable-compact_unevictable_allowed-on-rt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-disable-compact_unevictable_allowed-on-rt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/compaction: Disable compact_unevictable_allowed on RT

Since commit 5bbe3547aa3ba ("mm: allow compaction of unevictable pages")
it is allowed to examine mlocked pages and compact them by default.  On
-RT even minor pagefaults are problematic because it may take a few 100us
to resolve them and until then the task is blocked.

Make compact_unevictable_allowed = 0 default and issue a warning on RT if
it is changed.

Link: https://lore.kernel.org/linux-mm/20190710144138.qyn4tuttdq6h7kqx@linutronix.de/
Link: http://lkml.kernel.org/r/20200303202225.nhqc3v5gwlb7x6et@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    3 ++
 kernel/sysctl.c                         |   27 +++++++++++++++++++++-
 mm/compaction.c                         |    4 +++
 3 files changed, 33 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-compaction-disable-compact_unevictable_allowed-on-rt
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -128,6 +128,9 @@ allowed to examine the unevictable lru (
 This should be used on systems where stalls for minor page faults are an
 acceptable trade for large contiguous free memory.  Set to 0 to prevent
 compaction from moving pages that are unevictable.  Default value is 1.
+On CONFIG_PREEMPT_RT the default value is 0 in order to avoid a page fault, due
+to compaction, which would block the task from becomming active until the fault
+is resolved.
 
 
 dirty_background_bytes
--- a/kernel/sysctl.c~mm-compaction-disable-compact_unevictable_allowed-on-rt
+++ a/kernel/sysctl.c
@@ -212,6 +212,11 @@ static int proc_do_cad_pid(struct ctl_ta
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
 static int proc_taint(struct ctl_table *table, int write,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
+#ifdef CONFIG_COMPACTION
+static int proc_dointvec_warn_RT_change(struct ctl_table *table, int write,
+					void __user *buffer, size_t *lenp,
+					loff_t *ppos);
+#endif
 #endif
 
 #ifdef CONFIG_PRINTK
@@ -1484,7 +1489,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_compact_unevictable_allowed,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_warn_RT_change,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
@@ -2572,6 +2577,26 @@ int proc_dointvec(struct ctl_table *tabl
 	return do_proc_dointvec(table, write, buffer, lenp, ppos, NULL, NULL);
 }
 
+#ifdef CONFIG_COMPACTION
+static int proc_dointvec_warn_RT_change(struct ctl_table *table, int write,
+					void __user *buffer, size_t *lenp,
+					loff_t *ppos)
+{
+	int ret, old;
+
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || !write)
+		return proc_dointvec(table, write, buffer, lenp, ppos);
+
+	old = *(int *)table->data;
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
+	WARN_ONCE(old != *(int *)table->data, "sysctl attribute %s changed.",
+		  table->procname);
+	return ret;
+}
+#endif
+
 /**
  * proc_douintvec - read a vector of unsigned integers
  * @table: the sysctl table
--- a/mm/compaction.c~mm-compaction-disable-compact_unevictable_allowed-on-rt
+++ a/mm/compaction.c
@@ -1594,7 +1594,11 @@ typedef enum {
  * Allow userspace to control policy on scanning the unevictable LRU for
  * compactable pages.
  */
+#ifdef CONFIG_PREEMPT_RT
+int sysctl_compact_unevictable_allowed __read_mostly = 0;
+#else
 int sysctl_compact_unevictable_allowed __read_mostly = 1;
+#endif
 
 static inline void
 update_fast_start_pfn(struct compact_control *cc, unsigned long pfn)
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-z3fold-do-not-include-rwlockh-directly.patch
really-limit-compact_unevictable_allowed-to-0-and-1.patch
mm-compaction-disable-compact_unevictable_allowed-on-rt.patch
