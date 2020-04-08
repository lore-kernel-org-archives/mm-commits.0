From: akpm@linux-foundation.org
Subject: [merged]
 kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch removed from
 -mm tree
Date: Tue, 07 Apr 2020 19:01:10 -0700
Message-ID: <20200408020110.GbKDBKrXv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbgDHCBL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, arnd@arndb.de, aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com, glider@google.com, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, vegard.nossum@oracle.com


The patch titled
     Subject: kasan: stackdepot: move filter_irq_stacks() to stackdepot.c
has been removed from the -mm tree.  Its filename was
     kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kasan: stackdepot: move filter_irq_stacks() to stackdepot.c

filter_irq_stacks() can be used by other tools (e.g.  KMSAN), so it needs
to be moved to a common location.  lib/stackdepot.c seems a good place, as
filter_irq_stacks() is usually applied to the output of
stack_trace_save().

This patch has been previously mailed as part of KMSAN RFC patch series.

[glider@google.co: nds32: linker script: add SOFTIRQENTRY_TEXT\
  Link: http://lkml.kernel.org/r/20200311121002.241430-1-glider@google.com
[glider@google.com: add IRQENTRY_TEXT and SOFTIRQENTRY_TEXT to linker script]
  Link: http://lkml.kernel.org/r/20200311121124.243352-1-glider@google.com
Link: http://lkml.kernel.org/r/20200220141916.55455-3-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/vmlinux.lds.S  |    2 ++
 arch/nds32/kernel/vmlinux.lds.S |    1 +
 include/linux/stackdepot.h      |    2 ++
 lib/stackdepot.c                |   24 ++++++++++++++++++++++++
 mm/kasan/common.c               |   23 -----------------------
 5 files changed, 29 insertions(+), 23 deletions(-)

--- a/arch/ia64/kernel/vmlinux.lds.S~kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -54,6 +54,8 @@ SECTIONS {
 		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
+		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.gnu.linkonce.t*)
 	}
 
--- a/arch/nds32/kernel/vmlinux.lds.S~kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc
+++ a/arch/nds32/kernel/vmlinux.lds.S
@@ -47,6 +47,7 @@ SECTIONS
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.fixup)
 	}
 
--- a/include/linux/stackdepot.h~kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc
+++ a/include/linux/stackdepot.h
@@ -19,4 +19,6 @@ depot_stack_handle_t stack_depot_save(un
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries);
 
+unsigned int filter_irq_stacks(unsigned long *entries, unsigned int nr_entries);
+
 #endif
--- a/lib/stackdepot.c~kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc
+++ a/lib/stackdepot.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/gfp.h>
+#include <linux/interrupt.h>
 #include <linux/jhash.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -316,3 +317,26 @@ fast_exit:
 	return retval;
 }
 EXPORT_SYMBOL_GPL(stack_depot_save);
+
+static inline int in_irqentry_text(unsigned long ptr)
+{
+	return (ptr >= (unsigned long)&__irqentry_text_start &&
+		ptr < (unsigned long)&__irqentry_text_end) ||
+		(ptr >= (unsigned long)&__softirqentry_text_start &&
+		 ptr < (unsigned long)&__softirqentry_text_end);
+}
+
+unsigned int filter_irq_stacks(unsigned long *entries,
+					     unsigned int nr_entries)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr_entries; i++) {
+		if (in_irqentry_text(entries[i])) {
+			/* Include the irqentry function into the stack. */
+			return i + 1;
+		}
+	}
+	return nr_entries;
+}
+EXPORT_SYMBOL_GPL(filter_irq_stacks);
--- a/mm/kasan/common.c~kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc
+++ a/mm/kasan/common.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/export.h>
-#include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
@@ -42,28 +41,6 @@
 #include "kasan.h"
 #include "../slab.h"
 
-static inline int in_irqentry_text(unsigned long ptr)
-{
-	return (ptr >= (unsigned long)&__irqentry_text_start &&
-		ptr < (unsigned long)&__irqentry_text_end) ||
-		(ptr >= (unsigned long)&__softirqentry_text_start &&
-		 ptr < (unsigned long)&__softirqentry_text_end);
-}
-
-static inline unsigned int filter_irq_stacks(unsigned long *entries,
-					     unsigned int nr_entries)
-{
-	unsigned int i;
-
-	for (i = 0; i < nr_entries; i++) {
-		if (in_irqentry_text(entries[i])) {
-			/* Include the irqentry function into the stack. */
-			return i + 1;
-		}
-	}
-	return nr_entries;
-}
