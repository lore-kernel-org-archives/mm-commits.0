Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D1DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AEE46103C
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbhKKCvA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234404AbhKKCu7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:50:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7DEF6135E;
        Thu, 11 Nov 2021 02:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598890;
        bh=q4dtMhyiJuCsqzglJYMyFW1Kxm8xEZQJxdJLWTcM+uM=;
        h=Date:From:To:Subject:From;
        b=vnuMBNMVB3GrclXcOUqHqAUYd5MscIqziiiUmHLkEl0/h4iOZSIzoTW/aVy3dT3IQ
         kPeBnmJdXLPK0TvRkN5s8mKOgTGaPt8xppE0w3ei0dyT4E18DhlmibDiBF0WGsDFq/
         VaG955mcPvmMAxfUEb14hxkKzH7cuw74Kw1xpayM=
Date:   Wed, 10 Nov 2021 18:48:10 -0800
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, mm-commits@vger.kernel.org, nogikh@google.com,
        tarasmadan@google.com
Subject:  [merged]
 stacktrace-move-filter_irq_stacks-to-kernel-stacktracec.patch removed from
 -mm tree
Message-ID: <20211111024810.hTI9tRquH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: stacktrace: move filter_irq_stacks() to kernel/stacktrace.c
has been removed from the -mm tree.  Its filename was
     stacktrace-move-filter_irq_stacks-to-kernel-stacktracec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: stacktrace: move filter_irq_stacks() to kernel/stacktrace.c

filter_irq_stacks() has little to do with the stackdepot implementation,
except that it is usually used by users (such as KASAN) of stackdepot to
reduce the stack trace.

However, filter_irq_stacks() itself is not useful without a stack trace as
obtained by stack_trace_save() and friends.

Therefore, move filter_irq_stacks() to kernel/stacktrace.c, so that new
users of filter_irq_stacks() do not have to start depending on STACKDEPOT
only for filter_irq_stacks().

Link: https://lkml.kernel.org/r/20210923104803.2620285-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    2 --
 include/linux/stacktrace.h |    1 +
 kernel/stacktrace.c        |   30 ++++++++++++++++++++++++++++++
 lib/stackdepot.c           |   24 ------------------------
 4 files changed, 31 insertions(+), 26 deletions(-)

--- a/include/linux/stackdepot.h~stacktrace-move-filter_irq_stacks-to-kernel-stacktracec
+++ a/include/linux/stackdepot.h
@@ -25,8 +25,6 @@ depot_stack_handle_t stack_depot_save(un
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries);
 
-unsigned int filter_irq_stacks(unsigned long *entries, unsigned int nr_entries);
-
 #ifdef CONFIG_STACKDEPOT
 int stack_depot_init(void);
 #else
--- a/include/linux/stacktrace.h~stacktrace-move-filter_irq_stacks-to-kernel-stacktracec
+++ a/include/linux/stacktrace.h
@@ -21,6 +21,7 @@ unsigned int stack_trace_save_tsk(struct
 unsigned int stack_trace_save_regs(struct pt_regs *regs, unsigned long *store,
 				   unsigned int size, unsigned int skipnr);
 unsigned int stack_trace_save_user(unsigned long *store, unsigned int size);
+unsigned int filter_irq_stacks(unsigned long *entries, unsigned int nr_entries);
 
 /* Internal interfaces. Do not use in generic code */
 #ifdef CONFIG_ARCH_STACKWALK
--- a/kernel/stacktrace.c~stacktrace-move-filter_irq_stacks-to-kernel-stacktracec
+++ a/kernel/stacktrace.c
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/kallsyms.h>
 #include <linux/stacktrace.h>
+#include <linux/interrupt.h>
 
 /**
  * stack_trace_print - Print the entries in the stack trace
@@ -373,3 +374,32 @@ unsigned int stack_trace_save_user(unsig
 #endif /* CONFIG_USER_STACKTRACE_SUPPORT */
 
 #endif /* !CONFIG_ARCH_STACKWALK */
+
+static inline bool in_irqentry_text(unsigned long ptr)
+{
+	return (ptr >= (unsigned long)&__irqentry_text_start &&
+		ptr < (unsigned long)&__irqentry_text_end) ||
+		(ptr >= (unsigned long)&__softirqentry_text_start &&
+		 ptr < (unsigned long)&__softirqentry_text_end);
+}
+
+/**
+ * filter_irq_stacks - Find first IRQ stack entry in trace
+ * @entries:	Pointer to stack trace array
+ * @nr_entries:	Number of entries in the storage array
+ *
+ * Return: Number of trace entries until IRQ stack starts.
+ */
+unsigned int filter_irq_stacks(unsigned long *entries, unsigned int nr_entries)
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
--- a/lib/stackdepot.c~stacktrace-move-filter_irq_stacks-to-kernel-stacktracec
+++ a/lib/stackdepot.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/gfp.h>
-#include <linux/interrupt.h>
 #include <linux/jhash.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -371,26 +370,3 @@ depot_stack_handle_t stack_depot_save(un
 	return __stack_depot_save(entries, nr_entries, alloc_flags, true);
 }
 EXPORT_SYMBOL_GPL(stack_depot_save);
-
-static inline int in_irqentry_text(unsigned long ptr)
-{
-	return (ptr >= (unsigned long)&__irqentry_text_start &&
-		ptr < (unsigned long)&__irqentry_text_end) ||
-		(ptr >= (unsigned long)&__softirqentry_text_start &&
-		 ptr < (unsigned long)&__softirqentry_text_end);
-}
-
-unsigned int filter_irq_stacks(unsigned long *entries,
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
-EXPORT_SYMBOL_GPL(filter_irq_stacks);
_

Patches currently in -mm which might be from elver@google.com are


