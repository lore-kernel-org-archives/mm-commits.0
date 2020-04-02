From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 132/155] mm/compaction: Disable
 compact_unevictable_allowed on RT
Date: Wed, 01 Apr 2020 21:10:42 -0700
Message-ID: <20200402041042.AKLelzxfF%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEKo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:44 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bigeasy@linutronix.de, keescook@chromium.org, linux-mm@kvack.org, mcgrof@kernel.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, yzaikin@google.com

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/compaction: Disable compact_unevictable_allowed on RT

Since commit 5bbe3547aa3ba ("mm: allow compaction of unevictable pages")
it is allowed to examine mlocked pages and compact them by default.  On
-RT even minor pagefaults are problematic because it may take a few 100us
to resolve them and until then the task is blocked.

Make compact_unevictable_allowed = 0 default and issue a warning on RT if
it is changed.

[bigeasy@linutronix.de: v5]
  Link: https://lore.kernel.org/linux-mm/20190710144138.qyn4tuttdq6h7kqx@linutronix.de/
  Link: http://lkml.kernel.org/r/20200319165536.ovi75tsr2seared4@linutronix.de
Link: https://lore.kernel.org/linux-mm/20190710144138.qyn4tuttdq6h7kqx@linutronix.de/
Link: http://lkml.kernel.org/r/20200303202225.nhqc3v5gwlb7x6et@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    3 ++
 kernel/sysctl.c                         |   29 +++++++++++++++++++++-
 mm/compaction.c                         |    4 +++
 3 files changed, 35 insertions(+), 1 deletion(-)

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
+static int proc_dointvec_minmax_warn_RT_change(struct ctl_table *table,
+					       int write, void __user *buffer,
+					       size_t *lenp, loff_t *ppos);
+#endif
 #endif
 
 #ifdef CONFIG_PRINTK
@@ -1467,7 +1472,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_compact_unevictable_allowed,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_warn_RT_change,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
@@ -2555,6 +2560,28 @@ int proc_dointvec(struct ctl_table *tabl
 	return do_proc_dointvec(table, write, buffer, lenp, ppos, NULL, NULL);
 }
 
+#ifdef CONFIG_COMPACTION
+static int proc_dointvec_minmax_warn_RT_change(struct ctl_table *table,
+					       int write, void __user *buffer,
+					       size_t *lenp, loff_t *ppos)
+{
+	int ret, old;
+
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || !write)
+		return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	old = *(int *)table->data;
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
+	if (old != *(int *)table->data)
+		pr_warn_once("sysctl attribute %s changed by %s[%d]\n",
+			     table->procname, current->comm,
+			     task_pid_nr(current));
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
