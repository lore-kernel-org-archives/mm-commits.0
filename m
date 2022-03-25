Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166B6C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354316AbiCYBOt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357195AbiCYBOq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:14:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF23F271F
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:13:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90FB4B826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AA8C340EC;
        Fri, 25 Mar 2022 01:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170790;
        bh=h4r6priBT5Kd6mSJOksQhJs4en29aa1lPfNSHb5RK00=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=F7BGOEfA4j1bJxJ4/nKVya8WEchvuO9YjL/YK8irdP/lr2c0ksYpN59HWacQm/Qqb
         fLPiHQMdc027JILu7ohhn2yIwdhJhsmta28p2mvRXyauRToJMO8VPXT2e1A2dXmoZ6
         bIacgZjOfhSZuHAkH1SYXKwd5n7JrbbxPl08Oq8M=
Date:   Thu, 24 Mar 2022 18:13:09 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 092/114] kasan: reorder reporting functions
Message-Id: <20220325011310.36AA8C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
