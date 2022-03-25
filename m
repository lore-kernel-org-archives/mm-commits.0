Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9690BC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbiCYWoi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiCYWoV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6381D20C1AC
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CEDF3CE2B8C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A9CC340ED;
        Fri, 25 Mar 2022 22:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248163;
        bh=DPai65msWfwEyW0BNIc7DEw4v4XRv2W50MKN3g3vWKI=;
        h=Date:To:From:Subject:From;
        b=IDIS//8Zxj36cY32L5nJ0sW3uLZmJzz8gfV9FzBMX54S8Nu9vDcf8R0T5GNEP7nXS
         gPagTjWL0uH5tXaFvOe7bH8bh8VeAlNUPWFaiWGnzVMVTKMFB7c6Ym8HmworimsH/y
         Wud+ZRW2cD6j3VfaR2ezlFE4zfiZfrbKcEks5ASI=
Date:   Fri, 25 Mar 2022 15:42:42 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-rearrange-stack-frame-info-in-reports.patch removed from -mm tree
Message-Id: <20220325224243.60A9CC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: rearrange stack frame info in reports
has been removed from the -mm tree.  Its filename was
     kasan-rearrange-stack-frame-info-in-reports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: rearrange stack frame info in reports

- Move printing stack frame info before printing page info.

- Add object_is_on_stack() check to print_address_description()
  and add a corresponding WARNING to kasan_print_address_stack_frame().
  This looks more in line with the rest of the checks in this function
  and also allows to avoid complicating code logic wrt line breaks.

- Clean up comments related to get_address_stack_frame_info().

Link: https://lkml.kernel.org/r/1ee113a4c111df97d168c820b527cda77a3cac40.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c         |   12 +++++++++---
 mm/kasan/report_generic.c |   15 ++++-----------
 2 files changed, 13 insertions(+), 14 deletions(-)

--- a/mm/kasan/report.c~kasan-rearrange-stack-frame-info-in-reports
+++ a/mm/kasan/report.c
@@ -259,6 +259,15 @@ static void print_address_description(vo
 		pr_err("\n");
 	}
 
+	if (object_is_on_stack(addr)) {
+		/*
+		 * Currently, KASAN supports printing frame information only
+		 * for accesses to the task's own stack.
+		 */
+		kasan_print_address_stack_frame(addr);
+		pr_err("\n");
+	}
+
 	if (is_vmalloc_addr(addr)) {
 		struct vm_struct *va = find_vm_area(addr);
 
@@ -278,9 +287,6 @@ static void print_address_description(vo
 		dump_page(page, "kasan: bad access detected");
 		pr_err("\n");
 	}
-
-	kasan_print_address_stack_frame(addr);
-	pr_err("\n");
 }
 
 static bool meta_row_is_guilty(const void *row, const void *addr)
--- a/mm/kasan/report_generic.c~kasan-rearrange-stack-frame-info-in-reports
+++ a/mm/kasan/report_generic.c
@@ -211,6 +211,7 @@ static void print_decoded_frame_descr(co
 	}
 }
 
+/* Returns true only if the address is on the current task's stack. */
 static bool __must_check get_address_stack_frame_info(const void *addr,
 						      unsigned long *offset,
 						      const char **frame_descr,
@@ -224,13 +225,6 @@ static bool __must_check get_address_sta
 
 	BUILD_BUG_ON(IS_ENABLED(CONFIG_STACK_GROWSUP));
 
-	/*
-	 * NOTE: We currently only support printing frame information for
-	 * accesses to the task's own stack.
-	 */
-	if (!object_is_on_stack(addr))
-		return false;
-
 	aligned_addr = round_down((unsigned long)addr, sizeof(long));
 	mem_ptr = round_down(aligned_addr, KASAN_GRANULE_SIZE);
 	shadow_ptr = kasan_mem_to_shadow((void *)aligned_addr);
@@ -269,14 +263,13 @@ void kasan_print_address_stack_frame(con
 	const char *frame_descr;
 	const void *frame_pc;
 
+	if (WARN_ON(!object_is_on_stack(addr)))
+		return;
+
 	if (!get_address_stack_frame_info(addr, &offset, &frame_descr,
 					  &frame_pc))
 		return;
 
-	/*
-	 * get_address_stack_frame_info only returns true if the given addr is
-	 * on the current task's stack.
-	 */
 	pr_err("\n");
 	pr_err("addr %px is located in stack of task %s/%d at offset %lu in frame:\n",
 	       addr, current->comm, task_pid_nr(current), offset);
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

