Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF752C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354388AbiCYBOL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354593AbiCYBN7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:13:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31655BD2FE
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD008B81DE2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932C7C340EC;
        Fri, 25 Mar 2022 01:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170743;
        bh=vnAUd7nf5uyUi8olJddwm57pCYbDS8/7np9LcQEPrxc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Ct9Ii/FiAGzRWUkNzl9KtFFlzOhvNnguTYRuFUtalu96XtrhXmvXRXgYntfiK0b9q
         I+nDT/mQLn4PQHSYGMaOe+8BQfMw6tQmgx1yaw0eteGaeHEGWCdPG3k4dicXgN/DkR
         uPZIFCnjEglz0zAowOp1VhOzc+ereSJmEA1M+Ms8=
Date:   Thu, 24 Mar 2022 18:12:23 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 076/114] kasan: improve stack frame info in reports
Message-Id: <20220325011223.932C7C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: improve stack frame info in reports

- Print at least task name and id for reports affecting allocas
  (get_address_stack_frame_info() does not support them).

- Capitalize first letter of each sentence.

Link: https://lkml.kernel.org/r/aa613f097c12f7b75efb17f2618ae00480fb4bc3.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report_generic.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/kasan/report_generic.c~kasan-improve-stack-frame-info-in-reports
+++ a/mm/kasan/report_generic.c
@@ -180,7 +180,7 @@ static void print_decoded_frame_descr(co
 		return;
 
 	pr_err("\n");
-	pr_err("this frame has %lu %s:\n", num_objects,
+	pr_err("This frame has %lu %s:\n", num_objects,
 	       num_objects == 1 ? "object" : "objects");
 
 	while (num_objects--) {
@@ -266,13 +266,14 @@ void kasan_print_address_stack_frame(con
 	if (WARN_ON(!object_is_on_stack(addr)))
 		return;
 
+	pr_err("The buggy address belongs to stack of task %s/%d\n",
+	       current->comm, task_pid_nr(current));
+
 	if (!get_address_stack_frame_info(addr, &offset, &frame_descr,
 					  &frame_pc))
 		return;
 
-	pr_err("\n");
-	pr_err("addr %px is located in stack of task %s/%d at offset %lu in frame:\n",
-	       addr, current->comm, task_pid_nr(current), offset);
+	pr_err(" and is located at offset %lu in frame:\n", offset);
 	pr_err(" %pS\n", frame_pc);
 
 	if (!frame_descr)
_
