From: akpm@linux-foundation.org
Subject: +
 kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch added to -mm
 tree
Date: Thu, 20 Feb 2020 16:44:11 -0800
Message-ID: <20200221004411.z_lVo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbgBUAoN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 19:44:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vegard.nossum@oracle.com, sergey.senozhatsky@gmail.com, elver@google.com, dvyukov@google.com, aryabinin@virtuozzo.com, arnd@arndb.de, andreyknvl@google.com, glider@google.com


The patch titled
     Subject: kasan: stackdepot: move filter_irq_stacks() to stackdepot.c
has been added to the -mm tree.  Its filename is
     kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kasan: stackdepot: move filter_irq_stacks() to stackdepot.c

filter_irq_stacks() can be used by other tools (e.g.  KMSAN), so it needs
to be moved to a common location.  lib/stackdepot.c seems a good place, as
filter_irq_stacks() is usually applied to the output of
stack_trace_save().

This patch has been previously mailed as part of KMSAN RFC patch series.

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

 include/linux/stackdepot.h |    2 ++
 lib/stackdepot.c           |   24 ++++++++++++++++++++++++
 mm/kasan/common.c          |   23 -----------------------
 3 files changed, 26 insertions(+), 23 deletions(-)

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
@@ -318,3 +319,26 @@ fast_exit:
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
