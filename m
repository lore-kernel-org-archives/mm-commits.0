Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD232C433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9445E64F46
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhBZBVS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:21:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhBZBUW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:20:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAFEB64F22;
        Fri, 26 Feb 2021 01:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302381;
        bh=rpAhG8MI6svXK9zm1R8Ck9QXsd6A4B7lBNj9eF9iqhc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ahk2t4gq2SEmUdfFTlaKi7HBYuaIiub4ev7t4wk7iP7ZRb4UfQxcqWrQqDjZ2cYNv
         b3NDoVu5kumbvXLbsE1gkZptzy/QPILPNBMrnoMsG0e/q+AsjAEK0TH01sPltgJaHM
         x4w60iHqk4kibZVYpDXlg3j5aI4xJmS6dJNtZH3Q=
Date:   Thu, 25 Feb 2021 17:19:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        timur@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 066/118] kfence: report sensitive information
 based on no_hash_pointers
Message-ID: <20210226011940.R4fyY7-Od%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kfence: report sensitive information based on no_hash_pointers

We cannot rely on CONFIG_DEBUG_KERNEL to decide if we're running a "debug
kernel" where we can safely show potentially sensitive information in the
kernel log.

Instead, simply rely on the newly introduced "no_hash_pointers" to print
unhashed kernel pointers, as well as decide if our reports can include
other potentially sensitive information such as registers and corrupted
bytes.

Link: https://lkml.kernel.org/r/20210223082043.1972742-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Timur Tabi <timur@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kfence.rst |    8 ++++----
 mm/kfence/core.c                   |   10 +++-------
 mm/kfence/kfence.h                 |    7 -------
 mm/kfence/kfence_test.c            |    2 +-
 mm/kfence/report.c                 |   18 ++++++++++--------
 5 files changed, 18 insertions(+), 27 deletions(-)

--- a/Documentation/dev-tools/kfence.rst~kfence-report-sensitive-information-based-on-no_hash_pointers
+++ a/Documentation/dev-tools/kfence.rst
@@ -88,8 +88,8 @@ A typical out-of-bounds access looks lik
 
 The header of the report provides a short summary of the function involved in
 the access. It is followed by more detailed information about the access and
-its origin. Note that, real kernel addresses are only shown for
-``CONFIG_DEBUG_KERNEL=y`` builds.
+its origin. Note that, real kernel addresses are only shown when using the
+kernel command line option ``no_hash_pointers``.
 
 Use-after-free accesses are reported as::
 
@@ -184,8 +184,8 @@ invalidly written bytes (offset from the
 representation, '.' denote untouched bytes. In the example above ``0xac`` is
 the value written to the invalid address at offset 0, and the remaining '.'
 denote that no following bytes have been touched. Note that, real values are
-only shown for ``CONFIG_DEBUG_KERNEL=y`` builds; to avoid information
-disclosure for non-debug builds, '!' is used instead to denote invalidly
+only shown if the kernel was booted with ``no_hash_pointers``; to avoid
+information disclosure otherwise, '!' is used instead to denote invalidly
 written bytes.
 
 And finally, KFENCE may also report on invalid accesses to any protected page
--- a/mm/kfence/core.c~kfence-report-sensitive-information-based-on-no_hash_pointers
+++ a/mm/kfence/core.c
@@ -646,13 +646,9 @@ void __init kfence_init(void)
 
 	WRITE_ONCE(kfence_enabled, true);
 	schedule_delayed_work(&kfence_timer, 0);
-	pr_info("initialized - using %lu bytes for %d objects", KFENCE_POOL_SIZE,
-		CONFIG_KFENCE_NUM_OBJECTS);
-	if (IS_ENABLED(CONFIG_DEBUG_KERNEL))
-		pr_cont(" at 0x%px-0x%px\n", (void *)__kfence_pool,
-			(void *)(__kfence_pool + KFENCE_POOL_SIZE));
-	else
-		pr_cont("\n");
+	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
+		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
+		(void *)(__kfence_pool + KFENCE_POOL_SIZE));
 }
 
 void kfence_shutdown_cache(struct kmem_cache *s)
--- a/mm/kfence/kfence.h~kfence-report-sensitive-information-based-on-no_hash_pointers
+++ a/mm/kfence/kfence.h
@@ -16,13 +16,6 @@
 
 #include "../slab.h" /* for struct kmem_cache */
 
-/* For non-debug builds, avoid leaking kernel pointers into dmesg. */
-#ifdef CONFIG_DEBUG_KERNEL
-#define PTR_FMT "%px"
-#else
-#define PTR_FMT "%p"
-#endif
-
 /*
  * Get the canary byte pattern for @addr. Use a pattern that varies based on the
  * lower 3 bits of the address, to detect memory corruptions with higher
--- a/mm/kfence/kfence_test.c~kfence-report-sensitive-information-based-on-no_hash_pointers
+++ a/mm/kfence/kfence_test.c
@@ -146,7 +146,7 @@ static bool report_matches(const struct
 		break;
 	}
 
-	cur += scnprintf(cur, end - cur, " 0x" PTR_FMT, (void *)r->addr);
+	cur += scnprintf(cur, end - cur, " 0x%p", (void *)r->addr);
 
 	spin_lock_irqsave(&observed.lock, flags);
 	if (!report_available())
--- a/mm/kfence/report.c~kfence-report-sensitive-information-based-on-no_hash_pointers
+++ a/mm/kfence/report.c
@@ -19,6 +19,8 @@
 
 #include "kfence.h"
 
+extern bool no_hash_pointers;
+
 /* Helper function to either print to a seq_file or to console. */
 __printf(2, 3)
 static void seq_con_printf(struct seq_file *seq, const char *fmt, ...)
@@ -118,7 +120,7 @@ void kfence_print_object(struct seq_file
 	}
 
 	seq_con_printf(seq,
-		       "kfence-#%zd [0x" PTR_FMT "-0x" PTR_FMT
+		       "kfence-#%zd [0x%p-0x%p"
 		       ", size=%d, cache=%s] allocated by task %d:\n",
 		       meta - kfence_metadata, (void *)start, (void *)(start + size - 1), size,
 		       (cache && cache->name) ? cache->name : "<destroyed>", meta->alloc_track.pid);
@@ -148,7 +150,7 @@ static void print_diff_canary(unsigned l
 	for (cur = (const u8 *)address; cur < end; cur++) {
 		if (*cur == KFENCE_CANARY_PATTERN(cur))
 			pr_cont(" .");
-		else if (IS_ENABLED(CONFIG_DEBUG_KERNEL))
+		else if (no_hash_pointers)
 			pr_cont(" 0x%02x", *cur);
 		else /* Do not leak kernel memory in non-debug builds. */
 			pr_cont(" !");
@@ -201,7 +203,7 @@ void kfence_report_error(unsigned long a
 
 		pr_err("BUG: KFENCE: out-of-bounds %s in %pS\n\n", get_access_type(is_write),
 		       (void *)stack_entries[skipnr]);
-		pr_err("Out-of-bounds %s at 0x" PTR_FMT " (%luB %s of kfence-#%zd):\n",
+		pr_err("Out-of-bounds %s at 0x%p (%luB %s of kfence-#%zd):\n",
 		       get_access_type(is_write), (void *)address,
 		       left_of_object ? meta->addr - address : address - meta->addr,
 		       left_of_object ? "left" : "right", object_index);
@@ -210,24 +212,24 @@ void kfence_report_error(unsigned long a
 	case KFENCE_ERROR_UAF:
 		pr_err("BUG: KFENCE: use-after-free %s in %pS\n\n", get_access_type(is_write),
 		       (void *)stack_entries[skipnr]);
-		pr_err("Use-after-free %s at 0x" PTR_FMT " (in kfence-#%zd):\n",
+		pr_err("Use-after-free %s at 0x%p (in kfence-#%zd):\n",
 		       get_access_type(is_write), (void *)address, object_index);
 		break;
 	case KFENCE_ERROR_CORRUPTION:
 		pr_err("BUG: KFENCE: memory corruption in %pS\n\n", (void *)stack_entries[skipnr]);
-		pr_err("Corrupted memory at 0x" PTR_FMT " ", (void *)address);
+		pr_err("Corrupted memory at 0x%p ", (void *)address);
 		print_diff_canary(address, 16, meta);
 		pr_cont(" (in kfence-#%zd):\n", object_index);
 		break;
 	case KFENCE_ERROR_INVALID:
 		pr_err("BUG: KFENCE: invalid %s in %pS\n\n", get_access_type(is_write),
 		       (void *)stack_entries[skipnr]);
-		pr_err("Invalid %s at 0x" PTR_FMT ":\n", get_access_type(is_write),
+		pr_err("Invalid %s at 0x%p:\n", get_access_type(is_write),
 		       (void *)address);
 		break;
 	case KFENCE_ERROR_INVALID_FREE:
 		pr_err("BUG: KFENCE: invalid free in %pS\n\n", (void *)stack_entries[skipnr]);
-		pr_err("Invalid free of 0x" PTR_FMT " (in kfence-#%zd):\n", (void *)address,
+		pr_err("Invalid free of 0x%p (in kfence-#%zd):\n", (void *)address,
 		       object_index);
 		break;
 	}
@@ -242,7 +244,7 @@ void kfence_report_error(unsigned long a
 
 	/* Print report footer. */
 	pr_err("\n");
-	if (IS_ENABLED(CONFIG_DEBUG_KERNEL) && regs)
+	if (no_hash_pointers && regs)
 		show_regs(regs);
 	else
 		dump_stack_print_info(KERN_ERR);
_
