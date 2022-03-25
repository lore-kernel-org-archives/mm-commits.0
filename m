Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25EDC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbiCYWpF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbiCYWpB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:45:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF94420D529
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7624B82A1E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59684C004DD;
        Fri, 25 Mar 2022 22:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248180;
        bh=gWultpIqxjN+b/8i6aSVneRESSvIQTeeM9TmOtKiacg=;
        h=Date:To:From:Subject:From;
        b=vNDCnFSuEPSZwuRtfQF7uHJhNjdJQGGRY5aIbt2i9PgBR2J0CvOEr8vfgZ/NMmrds
         YoZjF4L4UWXAhKboBM7RZXVgl20YBhuUtuGg6tBvGcJSOVEdpZHWu+PH0PkBnc8/2x
         u/BYNgKxYEZgKVjcgt4KBn+v75uErTO9M2YrZkVw=
Date:   Fri, 25 Mar 2022 15:42:59 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-reorder-reporting-functions.patch removed from -mm tree
Message-Id: <20220325224300.59684C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: reorder reporting functions
has been removed from the -mm tree.  Its filename was
     kasan-reorder-reporting-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: reorder reporting functions

Move print_error_description()'s, report_suppressed()'s, and
report_enabled()'s definitions to improve the logical order of function
definitions in report.c.

No functional changes.

Link: https://lkml.kernel.org/r/82aa926c411e00e76e97e645a551ede9ed0c5e79.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   82 ++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

--- a/mm/kasan/report.c~kasan-reorder-reporting-functions
+++ a/mm/kasan/report.c
@@ -84,24 +84,29 @@ static int __init kasan_set_multi_shot(c
 }
 __setup("kasan_multi_shot", kasan_set_multi_shot);
 
-static void print_error_description(struct kasan_report_info *info)
+/*
+ * Used to suppress reports within kasan_disable/enable_current() critical
+ * sections, which are used for marking accesses to slab metadata.
+ */
+static bool report_suppressed(void)
 {
-	if (info->type == KASAN_REPORT_INVALID_FREE) {
-		pr_err("BUG: KASAN: double-free or invalid-free in %pS\n",
-		       (void *)info->ip);
-		return;
-	}
+#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
+	if (current->kasan_depth)
+		return true;
+#endif
+	return false;
+}
 
-	pr_err("BUG: KASAN: %s in %pS\n",
-		kasan_get_bug_type(info), (void *)info->ip);
-	if (info->access_size)
-		pr_err("%s of size %zu at addr %px by task %s/%d\n",
-			info->is_write ? "Write" : "Read", info->access_size,
-			info->access_addr, current->comm, task_pid_nr(current));
-	else
-		pr_err("%s at addr %px by task %s/%d\n",
-			info->is_write ? "Write" : "Read",
-			info->access_addr, current->comm, task_pid_nr(current));
+/*
+ * Used to avoid reporting more than one KASAN bug unless kasan_multi_shot
+ * is enabled. Note that KASAN tests effectively enable kasan_multi_shot
+ * for their duration.
+ */
+static bool report_enabled(void)
+{
+	if (test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
+		return true;
+	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
@@ -160,6 +165,26 @@ static void end_report(unsigned long *fl
 	kasan_enable_current();
 }
 
+static void print_error_description(struct kasan_report_info *info)
+{
+	if (info->type == KASAN_REPORT_INVALID_FREE) {
+		pr_err("BUG: KASAN: double-free or invalid-free in %pS\n",
+		       (void *)info->ip);
+		return;
+	}
+
+	pr_err("BUG: KASAN: %s in %pS\n",
+		kasan_get_bug_type(info), (void *)info->ip);
+	if (info->access_size)
+		pr_err("%s of size %zu at addr %px by task %s/%d\n",
+			info->is_write ? "Write" : "Read", info->access_size,
+			info->access_addr, current->comm, task_pid_nr(current));
+	else
+		pr_err("%s at addr %px by task %s/%d\n",
+			info->is_write ? "Write" : "Read",
+			info->access_addr, current->comm, task_pid_nr(current));
+}
+
 static void print_track(struct kasan_track *track, const char *prefix)
 {
 	pr_err("%s by task %u:\n", prefix, track->pid);
@@ -381,31 +406,6 @@ static void print_memory_metadata(const
 	}
 }
 
-/*
- * Used to suppress reports within kasan_disable/enable_current() critical
- * sections, which are used for marking accesses to slab metadata.
- */
-static bool report_suppressed(void)
-{
-#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
-	if (current->kasan_depth)
-		return true;
-#endif
-	return false;
-}
-
-/*
- * Used to avoid reporting more than one KASAN bug unless kasan_multi_shot
- * is enabled. Note that KASAN tests effectively enable kasan_multi_shot
- * for their duration.
- */
-static bool report_enabled(void)
-{
-	if (test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
-		return true;
-	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
-}
-
 static void print_report(struct kasan_report_info *info)
 {
 	void *tagged_addr = info->access_addr;
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

