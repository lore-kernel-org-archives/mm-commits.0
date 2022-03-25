Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FC6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbiCYWoj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233953AbiCYWoV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20BC20C2CC
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CF0C61502
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716B4C004DD;
        Fri, 25 Mar 2022 22:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248165;
        bh=1YThVbruCxZorxlRxR/trmmjYG25EfnHLwmGVxmsRZk=;
        h=Date:To:From:Subject:From;
        b=KWCewVwmtzstiKjlm3hqOYTOFyKdZL26BWjMR8xQFo3M+Fqtck2L800CsyBGLiuML
         U3Wo0EOGh+HqrA8m+eZOYXmWkx/sLqs+tTsj+Xt10+0FUiDaGbd85kJ9TBGH50V9/7
         mAVgwLSa+d734Q82WcbAwXKwYzdJ3hgnPzwZO/VU=
Date:   Fri, 25 Mar 2022 15:42:44 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-print-basic-stack-frame-info-for-sw_tags.patch removed from -mm tree
Message-Id: <20220325224245.716B4C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: print basic stack frame info for SW_TAGS
has been removed from the -mm tree.  Its filename was
     kasan-print-basic-stack-frame-info-for-sw_tags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: print basic stack frame info for SW_TAGS

Software Tag-Based mode tags stack allocations when CONFIG_KASAN_STACK
is enabled. Print task name and id in reports for stack-related bugs.

[andreyknvl@google.com: include linux/sched/task_stack.h]
  Link: https://lkml.kernel.org/r/d7598f11a34ed96e508f7640fa038662ed2305ec.1647099922.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/029aaa87ceadde0702f3312a34697c9139c9fb53.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h          |    2 +-
 mm/kasan/report_sw_tags.c |   12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/mm/kasan/kasan.h~kasan-print-basic-stack-frame-info-for-sw_tags
+++ a/mm/kasan/kasan.h
@@ -274,7 +274,7 @@ void *kasan_find_first_bad_addr(void *ad
 const char *kasan_get_bug_type(struct kasan_access_info *info);
 void kasan_metadata_fetch_row(char *buffer, void *row);
 
-#if defined(CONFIG_KASAN_GENERIC) && defined(CONFIG_KASAN_STACK)
+#if defined(CONFIG_KASAN_STACK)
 void kasan_print_address_stack_frame(const void *addr);
 #else
 static inline void kasan_print_address_stack_frame(const void *addr) { }
--- a/mm/kasan/report_sw_tags.c~kasan-print-basic-stack-frame-info-for-sw_tags
+++ a/mm/kasan/report_sw_tags.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/printk.h>
 #include <linux/sched.h>
+#include <linux/sched/task_stack.h>
 #include <linux/slab.h>
 #include <linux/stackdepot.h>
 #include <linux/stacktrace.h>
@@ -51,3 +52,14 @@ void kasan_print_tags(u8 addr_tag, const
 
 	pr_err("Pointer tag: [%02x], memory tag: [%02x]\n", addr_tag, *shadow);
 }
+
+#ifdef CONFIG_KASAN_STACK
+void kasan_print_address_stack_frame(const void *addr)
+{
+	if (WARN_ON(!object_is_on_stack(addr)))
+		return;
+
+	pr_err("The buggy address belongs to stack of task %s/%d\n",
+	       current->comm, task_pid_nr(current));
+}
+#endif
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

