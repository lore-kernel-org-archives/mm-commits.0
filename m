Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66135C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346581AbiCYBOI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354578AbiCYBN7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:13:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E26BD2F8
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 124EAB81DE2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98D3C340EC;
        Fri, 25 Mar 2022 01:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170740;
        bh=xQSfJIuSU52DubWv2LUm5w2eFU4+5HQyYynBzRelMTQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=CKa7zkx4QfK6ssZu8owkNkg2oLecNFrvR8POUZbpY7+SEL365ufFh/L7Z9r05Uiwp
         jA9TVtp6xrj2zDnxtaSCddsV3/tmpYChhjQ8MATsY9bLnGT51aCcMtLzOUiD6k/Kq8
         qgjEL2xpwaA8mToDZ5xelAMSdei0dTNqa53YeLU0=
Date:   Thu, 24 Mar 2022 18:12:20 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 075/114] kasan: rearrange stack frame info in reports
Message-Id: <20220325011220.A98D3C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
