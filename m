Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B46C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357227AbiCYBOK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354887AbiCYBOA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:14:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920B2BD2E3
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26AEF6185F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF6BC340EC;
        Fri, 25 Mar 2022 01:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170746;
        bh=4JjK8Jx3YlJUCJPuPZYeO4AyX6YNEqchKKAO5jD9YQg=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=jbe/7fBKTa2aJ0C8pb/Ir168YsaA/oyQRjKn59UIbLYiLwrQHxzZ14hbfhdSQv7pk
         53jnJvLb3r4dFBKulfb+ytc0gVWy3eSZNx4jAcOnyGFtpkorgIjwF6tGHE0SUjX0yR
         aypu2CIsn2Pp5MVEXXSPwrTOclt6QBXTtc0M912M=
Date:   Thu, 24 Mar 2022 18:12:25 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 077/114] kasan: print basic stack frame info for SW_TAGS
Message-Id: <20220325011226.7EF6BC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
