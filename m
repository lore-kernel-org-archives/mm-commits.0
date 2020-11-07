Return-Path: <SRS0=9IPz=EN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C17C2D0A3
	for <mm-commits@archiver.kernel.org>; Sat,  7 Nov 2020 00:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D7DB20867
	for <mm-commits@archiver.kernel.org>; Sat,  7 Nov 2020 00:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604707509;
	bh=EsGrp/3pEfX5xyPXnbDuIqcvqsGGfAKFGMR/NCb/wYs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BQDJO9lFxQidK+kGHAByCEZPa6ev1D5wKEvAgWz6mcVO6AXG4Yw5hHUqKb222ONnI
	 iIbMf8G9dajZrWMqtk9qI0Wibs7hKGGvAf54Qv5edsrOuXT8SFEoDg2auLqdZfT09i
	 WBTi/vFtBgjBM1lGUsyE9/70S7C3jEV+Ld2XuapQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgKGAFI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Nov 2020 19:05:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgKGAFG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Nov 2020 19:05:06 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2BC6206C0;
        Sat,  7 Nov 2020 00:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604707505;
        bh=EsGrp/3pEfX5xyPXnbDuIqcvqsGGfAKFGMR/NCb/wYs=;
        h=Date:From:To:Subject:From;
        b=s/w6OuuGkCPPsg2T3SJxifCVFndDPMXoRr5dp45MjsfhfNOeFlXFFdDAUNe3RFGXN
         w/phBaRByKsQlGRfc/1znYGAqjWVbSDlK+f2ytRZYwysJLmg1VZR9/G+J6R9coNVXQ
         wXG7s42+JD9ERLeE5KuJHtw24MrflVaXCoC3zeWE=
Date:   Fri, 06 Nov 2020 16:05:04 -0800
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, mark.rutland@arm.com, mm-commits@vger.kernel.org
Subject:  +
 kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch added to -mm
 tree
Message-ID: <20201107000504.srOKc8njo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: use pt_regs to generate stack trace on faults
has been added to the -mm tree.  Its filename is
     kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: use pt_regs to generate stack trace on faults

Instead of removing the fault handling portion of the stack trace based on
the fault handler's name, just use struct pt_regs directly.

Change kfence_handle_page_fault() to take a struct pt_regs, and plumb it
through to kfence_report_error() for out-of-bounds, use-after-free, or
invalid access errors, where pt_regs is used to generate the stack trace.

If the kernel is a DEBUG_KERNEL, also show registers for more information.

Link: https://lkml.kernel.org/r/20201105092133.2075331-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/kfence.h |    2 
 arch/arm64/mm/fault.c           |    2 
 arch/x86/include/asm/kfence.h   |    6 --
 arch/x86/mm/fault.c             |    2 
 include/linux/kfence.h          |    5 +-
 mm/kfence/core.c                |   10 ++--
 mm/kfence/kfence.h              |    4 -
 mm/kfence/report.c              |   63 +++++++++++++++++-------------
 8 files changed, 48 insertions(+), 46 deletions(-)

--- a/arch/arm64/include/asm/kfence.h~kfence-use-pt_regs-to-generate-stack-trace-on-faults
+++ a/arch/arm64/include/asm/kfence.h
@@ -5,8 +5,6 @@
 
 #include <asm/cacheflush.h>
 
-#define KFENCE_SKIP_ARCH_FAULT_HANDLER "el1_sync"
-
 static inline bool arch_kfence_init_pool(void) { return true; }
 
 static inline bool kfence_protect_page(unsigned long addr, bool protect)
--- a/arch/arm64/mm/fault.c~kfence-use-pt_regs-to-generate-stack-trace-on-faults
+++ a/arch/arm64/mm/fault.c
@@ -323,7 +323,7 @@ static void __do_kernel_fault(unsigned l
 	} else if (addr < PAGE_SIZE) {
 		msg = "NULL pointer dereference";
 	} else {
-		if (kfence_handle_page_fault(addr))
+		if (kfence_handle_page_fault(addr, regs))
 			return;
 
 		msg = "paging request";
--- a/arch/x86/include/asm/kfence.h~kfence-use-pt_regs-to-generate-stack-trace-on-faults
+++ a/arch/x86/include/asm/kfence.h
@@ -11,12 +11,6 @@
 #include <asm/set_memory.h>
 #include <asm/tlbflush.h>
 
-/*
- * The page fault handler entry function, up to which the stack trace is
- * truncated in reports.
- */
-#define KFENCE_SKIP_ARCH_FAULT_HANDLER "asm_exc_page_fault"
-
 /* Force 4K pages for __kfence_pool. */
 static inline bool arch_kfence_init_pool(void)
 {
--- a/arch/x86/mm/fault.c~kfence-use-pt_regs-to-generate-stack-trace-on-faults
+++ a/arch/x86/mm/fault.c
@@ -727,7 +727,7 @@ no_context(struct pt_regs *regs, unsigne
 		efi_recover_from_page_fault(address);
 
 	/* Only not-present faults should be handled by KFENCE. */
-	if (!(error_code & X86_PF_PROT) && kfence_handle_page_fault(address))
+	if (!(error_code & X86_PF_PROT) && kfence_handle_page_fault(address, regs))
 		return;
 
 oops:
--- a/include/linux/kfence.h~kfence-use-pt_regs-to-generate-stack-trace-on-faults
+++ a/include/linux/kfence.h
@@ -171,6 +171,7 @@ static __always_inline __must_check bool
 /**
  * kfence_handle_page_fault() - perform page fault handling for KFENCE pages
  * @addr: faulting address
+ * @regs: current struct pt_regs (can be NULL, but shows full stack trace)
  *
  * Return:
  * * false - address outside KFENCE pool,
@@ -181,7 +182,7 @@ static __always_inline __must_check bool
  * cases KFENCE prints an error message and marks the offending page as
  * present, so that the kernel can proceed.
  */
-bool __must_check kfence_handle_page_fault(unsigned long addr);
+bool __must_check kfence_handle_page_fault(unsigned long addr, struct pt_regs *regs);
 
 #else /* CONFIG_KFENCE */
 
@@ -194,7 +195,7 @@ static inline size_t kfence_ksize(const
 static inline void *kfence_object_start(const void *addr) { return NULL; }
 static inline void __kfence_free(void *addr) { }
 static inline bool __must_check kfence_free(void *addr) { return false; }
-static inline bool __must_check kfence_handle_page_fault(unsigned long addr) { return false; }
+static inline bool __must_check kfence_handle_page_fault(unsigned long addr, struct pt_regs *regs) { return false; }
 
 #endif
 
--- a/mm/kfence/core.c~kfence-use-pt_regs-to-generate-stack-trace-on-faults
+++ a/mm/kfence/core.c
@@ -212,7 +212,7 @@ static inline bool check_canary_byte(u8
 		return true;
 
 	atomic_long_inc(&counters[KFENCE_COUNTER_BUGS]);
-	kfence_report_error((unsigned long)addr, addr_to_metadata((unsigned long)addr),
+	kfence_report_error((unsigned long)addr, NULL, addr_to_metadata((unsigned long)addr),
 			    KFENCE_ERROR_CORRUPTION);
 	return false;
 }
@@ -347,7 +347,7 @@ static void kfence_guarded_free(void *ad
 	if (meta->state != KFENCE_OBJECT_ALLOCATED || meta->addr != (unsigned long)addr) {
 		/* Invalid or double-free, bail out. */
 		atomic_long_inc(&counters[KFENCE_COUNTER_BUGS]);
-		kfence_report_error((unsigned long)addr, meta, KFENCE_ERROR_INVALID_FREE);
+		kfence_report_error((unsigned long)addr, NULL, meta, KFENCE_ERROR_INVALID_FREE);
 		raw_spin_unlock_irqrestore(&meta->lock, flags);
 		return;
 	}
@@ -748,7 +748,7 @@ void __kfence_free(void *addr)
 		kfence_guarded_free(addr, meta, false);
 }
 
-bool kfence_handle_page_fault(unsigned long addr)
+bool kfence_handle_page_fault(unsigned long addr, struct pt_regs *regs)
 {
 	const int page_index = (addr - (unsigned long)__kfence_pool) / PAGE_SIZE;
 	struct kfence_metadata *to_report = NULL;
@@ -811,11 +811,11 @@ bool kfence_handle_page_fault(unsigned l
 
 out:
 	if (to_report) {
-		kfence_report_error(addr, to_report, error_type);
+		kfence_report_error(addr, regs, to_report, error_type);
 		raw_spin_unlock_irqrestore(&to_report->lock, flags);
 	} else {
 		/* This may be a UAF or OOB access, but we can't be sure. */
-		kfence_report_error(addr, NULL, KFENCE_ERROR_INVALID);
+		kfence_report_error(addr, regs, NULL, KFENCE_ERROR_INVALID);
 	}
 
 	return kfence_unprotect(addr); /* Unprotect and let access proceed. */
--- a/mm/kfence/kfence.h~kfence-use-pt_regs-to-generate-stack-trace-on-faults
+++ a/mm/kfence/kfence.h
@@ -99,8 +99,8 @@ enum kfence_error_type {
 	KFENCE_ERROR_INVALID_FREE,	/* Invalid free. */
 };
 
-void kfence_report_error(unsigned long address, const struct kfence_metadata *meta,
-			 enum kfence_error_type type);
+void kfence_report_error(unsigned long address, struct pt_regs *regs,
+			 const struct kfence_metadata *meta, enum kfence_error_type type);
 
 void kfence_print_object(struct seq_file *seq, const struct kfence_metadata *meta);
 
--- a/mm/kfence/report.c~kfence-use-pt_regs-to-generate-stack-trace-on-faults
+++ a/mm/kfence/report.c
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/lockdep.h>
 #include <linux/printk.h>
+#include <linux/sched/debug.h>
 #include <linux/seq_file.h>
 #include <linux/stacktrace.h>
 #include <linux/string.h>
@@ -36,7 +37,6 @@ static int get_stack_skipnr(const unsign
 {
 	char buf[64];
 	int skipnr, fallback = 0;
-	bool is_access_fault = false;
 
 	if (type) {
 		/* Depending on error type, find different stack entries. */
@@ -44,8 +44,12 @@ static int get_stack_skipnr(const unsign
 		case KFENCE_ERROR_UAF:
 		case KFENCE_ERROR_OOB:
 		case KFENCE_ERROR_INVALID:
-			is_access_fault = true;
-			break;
+			/*
+			 * kfence_handle_page_fault() may be called with pt_regs
+			 * set to NULL; in that case we'll simply show the full
+			 * stack trace.
+			 */
+			return 0;
 		case KFENCE_ERROR_CORRUPTION:
 		case KFENCE_ERROR_INVALID_FREE:
 			break;
@@ -55,26 +59,21 @@ static int get_stack_skipnr(const unsign
 	for (skipnr = 0; skipnr < num_entries; skipnr++) {
 		int len = scnprintf(buf, sizeof(buf), "%ps", (void *)stack_entries[skipnr]);
 
-		if (is_access_fault) {
-			if (!strncmp(buf, KFENCE_SKIP_ARCH_FAULT_HANDLER, len))
-				goto found;
-		} else {
-			if (str_has_prefix(buf, "kfence_") || str_has_prefix(buf, "__kfence_") ||
-			    !strncmp(buf, "__slab_free", len)) {
-				/*
-				 * In case of tail calls from any of the below
-				 * to any of the above.
-				 */
-				fallback = skipnr + 1;
-			}
-
-			/* Also the *_bulk() variants by only checking prefixes. */
-			if (str_has_prefix(buf, "kfree") ||
-			    str_has_prefix(buf, "kmem_cache_free") ||
-			    str_has_prefix(buf, "__kmalloc") ||
-			    str_has_prefix(buf, "kmem_cache_alloc"))
-				goto found;
+		if (str_has_prefix(buf, "kfence_") || str_has_prefix(buf, "__kfence_") ||
+		    !strncmp(buf, "__slab_free", len)) {
+			/*
+			 * In case of tail calls from any of the below
+			 * to any of the above.
+			 */
+			fallback = skipnr + 1;
 		}
+
+		/* Also the *_bulk() variants by only checking prefixes. */
+		if (str_has_prefix(buf, "kfree") ||
+		    str_has_prefix(buf, "kmem_cache_free") ||
+		    str_has_prefix(buf, "__kmalloc") ||
+		    str_has_prefix(buf, "kmem_cache_alloc"))
+			goto found;
 	}
 	if (fallback < num_entries)
 		return fallback;
@@ -152,13 +151,20 @@ static void print_diff_canary(unsigned l
 	pr_cont(" ]");
 }
 
-void kfence_report_error(unsigned long address, const struct kfence_metadata *meta,
-			 enum kfence_error_type type)
+void kfence_report_error(unsigned long address, struct pt_regs *regs,
+			 const struct kfence_metadata *meta, enum kfence_error_type type)
 {
 	unsigned long stack_entries[KFENCE_STACK_DEPTH] = { 0 };
-	int num_stack_entries = stack_trace_save(stack_entries, KFENCE_STACK_DEPTH, 1);
-	int skipnr = get_stack_skipnr(stack_entries, num_stack_entries, &type);
 	const ptrdiff_t object_index = meta ? meta - kfence_metadata : -1;
+	int num_stack_entries;
+	int skipnr = 0;
+
+	if (regs) {
+		num_stack_entries = stack_trace_save_regs(regs, stack_entries, KFENCE_STACK_DEPTH, 0);
+	} else {
+		num_stack_entries = stack_trace_save(stack_entries, KFENCE_STACK_DEPTH, 1);
+		skipnr = get_stack_skipnr(stack_entries, num_stack_entries, &type);
+	}
 
 	/* Require non-NULL meta, except if KFENCE_ERROR_INVALID. */
 	if (WARN_ON(type != KFENCE_ERROR_INVALID && !meta))
@@ -222,7 +228,10 @@ void kfence_report_error(unsigned long a
 
 	/* Print report footer. */
 	pr_err("\n");
-	dump_stack_print_info(KERN_ERR);
+	if (IS_ENABLED(CONFIG_DEBUG_KERNEL) && regs)
+		show_regs(regs);
+	else
+		dump_stack_print_info(KERN_ERR);
 	pr_err("==================================================================\n");
 
 	lockdep_on();
_

Patches currently in -mm which might be from elver@google.com are

mm-add-kernel-electric-fence-infrastructure-fix.patch
arm64-kfence-enable-kfence-for-arm64.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
maintainers-add-entry-for-kfence.patch

