Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8AEC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbiCYWpD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbiCYWoe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE4620C1BE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F68FB82A1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5806EC004DD;
        Fri, 25 Mar 2022 22:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248177;
        bh=fgGCwhRwqdqWFpwzZb2Za3nUUhFuZDV+KP7RCIYQFoI=;
        h=Date:To:From:Subject:From;
        b=xvqQNGKqVC7PbAZBkt+p4mJ2a8Byf4Jhu8MxNmmdx+qmkzWE4g8TwgsCZGbxf4lAa
         DxfRIV8CKYxkerDxM5qUyuUTjYapbjn0EIio6EZ3UxviHzKa4Clk9k4qgOnF3HPIE1
         Sabghz66s362VPVd5XTOZofx+gvNwGCVfhi9avRk=
Date:   Fri, 25 Mar 2022 15:42:56 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-rename-kasan_access_info-to-kasan_report_info.patch removed from -mm tree
Message-Id: <20220325224257.5806EC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rename kasan_access_info to kasan_report_info
has been removed from the -mm tree.  Its filename was
     kasan-rename-kasan_access_info-to-kasan_report_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: rename kasan_access_info to kasan_report_info

Rename kasan_access_info to kasan_report_info, as the latter name better
reflects the struct's purpose.

Link: https://lkml.kernel.org/r/158a4219a5d356901d017352558c989533a0782c.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h          |    4 ++--
 mm/kasan/report.c         |    8 ++++----
 mm/kasan/report_generic.c |    6 +++---
 mm/kasan/report_tags.c    |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/mm/kasan/kasan.h~kasan-rename-kasan_access_info-to-kasan_report_info
+++ a/mm/kasan/kasan.h
@@ -132,7 +132,7 @@ enum kasan_report_type {
 	KASAN_REPORT_INVALID_FREE,
 };
 
-struct kasan_access_info {
+struct kasan_report_info {
 	enum kasan_report_type type;
 	void *access_addr;
 	void *first_bad_addr;
@@ -276,7 +276,7 @@ static inline void kasan_print_tags(u8 a
 #endif
 
 void *kasan_find_first_bad_addr(void *addr, size_t size);
-const char *kasan_get_bug_type(struct kasan_access_info *info);
+const char *kasan_get_bug_type(struct kasan_report_info *info);
 void kasan_metadata_fetch_row(char *buffer, void *row);
 
 #if defined(CONFIG_KASAN_STACK)
--- a/mm/kasan/report.c~kasan-rename-kasan_access_info-to-kasan_report_info
+++ a/mm/kasan/report.c
@@ -84,7 +84,7 @@ static int __init kasan_set_multi_shot(c
 }
 __setup("kasan_multi_shot", kasan_set_multi_shot);
 
-static void print_error_description(struct kasan_access_info *info)
+static void print_error_description(struct kasan_report_info *info)
 {
 	if (info->type == KASAN_REPORT_INVALID_FREE) {
 		pr_err("BUG: KASAN: double-free or invalid-free in %pS\n",
@@ -392,7 +392,7 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-static void print_report(struct kasan_access_info *info)
+static void print_report(struct kasan_report_info *info)
 {
 	void *tagged_addr = info->access_addr;
 	void *untagged_addr = kasan_reset_tag(tagged_addr);
@@ -414,7 +414,7 @@ static void print_report(struct kasan_ac
 void kasan_report_invalid_free(void *ptr, unsigned long ip)
 {
 	unsigned long flags;
-	struct kasan_access_info info;
+	struct kasan_report_info info;
 
 	start_report(&flags, true);
 
@@ -437,7 +437,7 @@ bool kasan_report(unsigned long addr, si
 	void *ptr = (void *)addr;
 	unsigned long ua_flags = user_access_save();
 	unsigned long irq_flags;
-	struct kasan_access_info info;
+	struct kasan_report_info info;
 
 	if (unlikely(!report_enabled())) {
 		ret = false;
--- a/mm/kasan/report_generic.c~kasan-rename-kasan_access_info-to-kasan_report_info
+++ a/mm/kasan/report_generic.c
@@ -43,7 +43,7 @@ void *kasan_find_first_bad_addr(void *ad
 	return p;
 }
 
-static const char *get_shadow_bug_type(struct kasan_access_info *info)
+static const char *get_shadow_bug_type(struct kasan_report_info *info)
 {
 	const char *bug_type = "unknown-crash";
 	u8 *shadow_addr;
@@ -95,7 +95,7 @@ static const char *get_shadow_bug_type(s
 	return bug_type;
 }
 
-static const char *get_wild_bug_type(struct kasan_access_info *info)
+static const char *get_wild_bug_type(struct kasan_report_info *info)
 {
 	const char *bug_type = "unknown-crash";
 
@@ -109,7 +109,7 @@ static const char *get_wild_bug_type(str
 	return bug_type;
 }
 
-const char *kasan_get_bug_type(struct kasan_access_info *info)
+const char *kasan_get_bug_type(struct kasan_report_info *info)
 {
 	/*
 	 * If access_size is a negative number, then it has reason to be
--- a/mm/kasan/report_tags.c~kasan-rename-kasan_access_info-to-kasan_report_info
+++ a/mm/kasan/report_tags.c
@@ -7,7 +7,7 @@
 #include "kasan.h"
 #include "../slab.h"
 
-const char *kasan_get_bug_type(struct kasan_access_info *info)
+const char *kasan_get_bug_type(struct kasan_report_info *info)
 {
 #ifdef CONFIG_KASAN_TAGS_IDENTIFY
 	struct kasan_alloc_meta *alloc_meta;
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

