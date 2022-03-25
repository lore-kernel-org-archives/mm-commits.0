Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3D9C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbiCYWpD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234024AbiCYWof (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C09020C2F8
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02C15615A2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A89EC004DD;
        Fri, 25 Mar 2022 22:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248179;
        bh=dt3vZ+nZquR23qfbSiN0XkXwDKwt1GKG1OyDs1wZrwQ=;
        h=Date:To:From:Subject:From;
        b=Wan7yUW8K8QVt/NLtJttFkDsHxnPiktj70tZRQnVYQCx/UWVkDtBotbE4Uhk7eXUK
         cVszlHEkReWOgSKOYH63Bv7RvFW8i+Wfcq5mpg8CQ0vBktK6HMnJqcqO5xZNb781Uh
         btNg8REmOp4TxqVi8ya78r82ipuU7v+sky0UgmbA=
Date:   Fri, 25 Mar 2022 15:42:58 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-respect-kasan_bit_reported-in-all-reporting-routines.patch removed from -mm tree
Message-Id: <20220325224259.5A89EC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: respect KASAN_BIT_REPORTED in all reporting routines
has been removed from the -mm tree.  Its filename was
     kasan-respect-kasan_bit_reported-in-all-reporting-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: respect KASAN_BIT_REPORTED in all reporting routines

Currently, only kasan_report() checks the KASAN_BIT_REPORTED and
KASAN_BIT_MULTI_SHOT flags.

Make other reporting routines check these flags as well.

Also add explanatory comments.

Note that the current->kasan_depth check is split out into
report_suppressed() and only called for kasan_report().

Link: https://lkml.kernel.org/r/715e346b10b398e29ba1b425299dcd79e29d58ce.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

--- a/mm/kasan/report.c~kasan-respect-kasan_bit_reported-in-all-reporting-routines
+++ a/mm/kasan/report.c
@@ -381,12 +381,26 @@ static void print_memory_metadata(const
 	}
 }
 
-static bool report_enabled(void)
+/*
+ * Used to suppress reports within kasan_disable/enable_current() critical
+ * sections, which are used for marking accesses to slab metadata.
+ */
+static bool report_suppressed(void)
 {
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 	if (current->kasan_depth)
-		return false;
+		return true;
 #endif
+	return false;
+}
+
+/*
+ * Used to avoid reporting more than one KASAN bug unless kasan_multi_shot
+ * is enabled. Note that KASAN tests effectively enable kasan_multi_shot
+ * for their duration.
+ */
+static bool report_enabled(void)
+{
 	if (test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
 		return true;
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
@@ -416,6 +430,14 @@ void kasan_report_invalid_free(void *ptr
 	unsigned long flags;
 	struct kasan_report_info info;
 
+	/*
+	 * Do not check report_suppressed(), as an invalid-free cannot be
+	 * caused by accessing slab metadata and thus should not be
+	 * suppressed by kasan_disable/enable_current() critical sections.
+	 */
+	if (unlikely(!report_enabled()))
+		return;
+
 	start_report(&flags, true);
 
 	info.type = KASAN_REPORT_INVALID_FREE;
@@ -444,7 +466,7 @@ bool kasan_report(unsigned long addr, si
 	unsigned long irq_flags;
 	struct kasan_report_info info;
 
-	if (unlikely(!report_enabled())) {
+	if (unlikely(report_suppressed()) || unlikely(!report_enabled())) {
 		ret = false;
 		goto out;
 	}
@@ -473,6 +495,13 @@ void kasan_report_async(void)
 {
 	unsigned long flags;
 
+	/*
+	 * Do not check report_suppressed(), as kasan_disable/enable_current()
+	 * critical sections do not affect Hardware Tag-Based KASAN.
+	 */
+	if (unlikely(!report_enabled()))
+		return;
+
 	start_report(&flags, false);
 	pr_err("BUG: KASAN: invalid-access\n");
 	pr_err("Asynchronous fault: no details available\n");
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

