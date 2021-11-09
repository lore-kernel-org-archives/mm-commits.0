Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCAC4C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6C7E60FDA
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbhKICf7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICf6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ED4061207;
        Tue,  9 Nov 2021 02:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425193;
        bh=Kl+Yr4ZpqfIcbsQRzroHHuvY11DtJuYNCE2x8NxuRAo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AOoFU+SlGE2K0nPmrA4gblbj0jUEKEqE1Rgwlg+9+I3SIHw1rmr2EPDYAdbXzSS0G
         +WtyGyZA38Uy+R3NMM9f0lHmOQeXxYo+PK9+Gp9lSjjdOnYIc4yFdn6BCjOxiPG+rd
         /ytf8p/eFzjqXsyouIap9osya0lBHem5VYEQMNdY=
Date:   Mon, 08 Nov 2021 18:33:12 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, akpm@linux-foundation.org, andreyknvl@gmail.com,
        daniel@ffwll.ch, dvyukov@google.com, geert@linux-m68k.org,
        glider@google.com, imran.f.khan@oracle.com, linux-mm@kvack.org,
        maarten.lankhorst@linux.intel.com, mm-commits@vger.kernel.org,
        mripard@kernel.org, ryabinin.a.a@gmail.com,
        torvalds@linux-foundation.org, tzimmermann@suse.de, vbabka@suse.cz
Subject:  [patch 34/87] lib, stackdepot: add helper to print stack
 entries
Message-ID: <20211109023312.3wqnKHnS_%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Imran Khan <imran.f.khan@oracle.com>
Subject: lib, stackdepot: add helper to print stack entries

To print a stack entries, users of stackdepot, first use stack_depot_fetch
to get a list of stack entries and then use stack_trace_print to print
this list.  Provide a helper in stackdepot to print stack entries based on
stackdepot handle.  Also change above mentioned users to use this helper.

Link: https://lkml.kernel.org/r/20210915014806.3206938-3-imran.f.khan@oracle.com
Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    2 ++
 lib/stackdepot.c           |   18 ++++++++++++++++++
 mm/kasan/report.c          |   15 +++------------
 mm/page_owner.c            |   13 ++++---------
 4 files changed, 27 insertions(+), 21 deletions(-)

--- a/include/linux/stackdepot.h~lib-stackdepot-add-helper-to-print-stack-entries
+++ a/include/linux/stackdepot.h
@@ -25,6 +25,8 @@ depot_stack_handle_t stack_depot_save(un
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries);
 
+void stack_depot_print(depot_stack_handle_t stack);
+
 #ifdef CONFIG_STACKDEPOT
 int stack_depot_init(void);
 #else
--- a/lib/stackdepot.c~lib-stackdepot-add-helper-to-print-stack-entries
+++ a/lib/stackdepot.c
@@ -214,6 +214,24 @@ static inline struct stack_record *find_
 }
 
 /**
+ * stack_depot_print - print stack entries from a depot
+ *
+ * @stack:		Stack depot handle which was returned from
+ *			stack_depot_save().
+ *
+ */
+void stack_depot_print(depot_stack_handle_t stack)
+{
+	unsigned long *entries;
+	unsigned int nr_entries;
+
+	nr_entries = stack_depot_fetch(stack, &entries);
+	if (nr_entries > 0)
+		stack_trace_print(entries, nr_entries, 0);
+}
+EXPORT_SYMBOL_GPL(stack_depot_print);
+
+/**
  * stack_depot_fetch - Fetch stack entries from a depot
  *
  * @handle:		Stack depot handle which was returned from
--- a/mm/kasan/report.c~lib-stackdepot-add-helper-to-print-stack-entries
+++ a/mm/kasan/report.c
@@ -132,20 +132,11 @@ static void end_report(unsigned long *fl
 	kasan_enable_current();
 }
 
-static void print_stack(depot_stack_handle_t stack)
-{
-	unsigned long *entries;
-	unsigned int nr_entries;
-
-	nr_entries = stack_depot_fetch(stack, &entries);
-	stack_trace_print(entries, nr_entries, 0);
-}
-
 static void print_track(struct kasan_track *track, const char *prefix)
 {
 	pr_err("%s by task %u:\n", prefix, track->pid);
 	if (track->stack) {
-		print_stack(track->stack);
+		stack_depot_print(track->stack);
 	} else {
 		pr_err("(stack is not available)\n");
 	}
@@ -214,12 +205,12 @@ static void describe_object_stacks(struc
 		return;
 	if (alloc_meta->aux_stack[0]) {
 		pr_err("Last potentially related work creation:\n");
-		print_stack(alloc_meta->aux_stack[0]);
+		stack_depot_print(alloc_meta->aux_stack[0]);
 		pr_err("\n");
 	}
 	if (alloc_meta->aux_stack[1]) {
 		pr_err("Second to last potentially related work creation:\n");
-		print_stack(alloc_meta->aux_stack[1]);
+		stack_depot_print(alloc_meta->aux_stack[1]);
 		pr_err("\n");
 	}
 #endif
--- a/mm/page_owner.c~lib-stackdepot-add-helper-to-print-stack-entries
+++ a/mm/page_owner.c
@@ -394,8 +394,6 @@ void __dump_page_owner(const struct page
 	struct page_ext *page_ext = lookup_page_ext(page);
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
-	unsigned long *entries;
-	unsigned int nr_entries;
 	gfp_t gfp_mask;
 	int mt;
 
@@ -423,20 +421,17 @@ void __dump_page_owner(const struct page
 		 page_owner->pid, page_owner->ts_nsec, page_owner->free_ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
-	if (!handle) {
+	if (!handle)
 		pr_alert("page_owner allocation stack trace missing\n");
-	} else {
-		nr_entries = stack_depot_fetch(handle, &entries);
-		stack_trace_print(entries, nr_entries, 0);
-	}
+	else
+		stack_depot_print(handle);
 
 	handle = READ_ONCE(page_owner->free_handle);
 	if (!handle) {
 		pr_alert("page_owner free stack trace missing\n");
 	} else {
-		nr_entries = stack_depot_fetch(handle, &entries);
 		pr_alert("page last free stack trace:\n");
-		stack_trace_print(entries, nr_entries, 0);
+		stack_depot_print(handle);
 	}
 
 	if (page_owner->last_migrate_reason != -1)
_
