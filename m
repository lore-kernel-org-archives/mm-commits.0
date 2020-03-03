From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-compaction-disable-compact_unevictable_allowed-on-rt.patch removed from
 -mm tree
Date: Tue, 03 Mar 2020 15:53:13 -0800
Message-ID: <20200303235313.zSzMvsMdd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727762AbgCCXxP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Mar 2020 18:53:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, keescook@chromium.org, mcgrof@kernel.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org, tglx@linutronix.de, yzaikin@google.com


The patch titled
     Subject: mm/compaction: disable compact_unevictable_allowed on RT
has been removed from the -mm tree.  Its filename was
     mm-compaction-disable-compact_unevictable_allowed-on-rt.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/compaction: disable compact_unevictable_allowed on RT

Since commit 5bbe3547aa3ba ("mm: allow compaction of unevictable pages")
it is allowed to examine mlocked pages and compact them by default.  On
-RT even minor pagefaults are problematic because it may take a few 100us
to resolve them and until then the task is blocked.

Make compact_unevictable_allowed = 0 default and RO on RT.

Link: https://lore.kernel.org/linux-mm/20190710144138.qyn4tuttdq6h7kqx@linutronix.de/
Link: http://lkml.kernel.org/r/20200302173516.iysuejilava37psk@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    1 +
 kernel/sysctl.c                         |    4 ++++
 mm/compaction.c                         |    4 ++++
 3 files changed, 9 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~mm-compaction-disable-compact_unevictable_allowed-on-rt
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -128,6 +128,7 @@ allowed to examine the unevictable lru (
 This should be used on systems where stalls for minor page faults are an
 acceptable trade for large contiguous free memory.  Set to 0 to prevent
 compaction from moving pages that are unevictable.  Default value is 1.
+On CONFIG_PREEMPT_RT the default value is 0.
 
 
 dirty_background_bytes
--- a/kernel/sysctl.c~mm-compaction-disable-compact_unevictable_allowed-on-rt
+++ a/kernel/sysctl.c
@@ -1483,7 +1483,11 @@ static struct ctl_table vm_table[] = {
 		.procname	= "compact_unevictable_allowed",
 		.data		= &sysctl_compact_unevictable_allowed,
 		.maxlen		= sizeof(int),
+#ifdef CONFIG_PREEMPT_RT
+		.mode		= 0444,
+#else
 		.mode		= 0644,
+#endif
 		.proc_handler	= proc_dointvec,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
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
