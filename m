Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D61C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbiCYWoi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiCYWoV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A36A20C1BE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14A8A611CF
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B28EC004DD;
        Fri, 25 Mar 2022 22:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248164;
        bh=BIWTm9t6zs1oDfPKwJqlOdH7vaooOPwRrhVs+McL0YY=;
        h=Date:To:From:Subject:From;
        b=vrsmi/HpPYUNYD+776cQz4HrXmrz2FEcnhBBtKsts6gNsO3VUzu3LfnqItHTZ8m8k
         9ZcySmJfWDzHNUZvqIkl86xB5GZHFOrB5sAChVWg26MfIt7GmWipxX1dgiTkeXLKXr
         RWh7bN/+RJfelvNU3TKD+TO4bDXhuUc+VcFjMKEg=
Date:   Fri, 25 Mar 2022 15:42:43 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-improve-stack-frame-info-in-reports.patch removed from -mm tree
Message-Id: <20220325224244.6B28EC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: improve stack frame info in reports
has been removed from the -mm tree.  Its filename was
     kasan-improve-stack-frame-info-in-reports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

