Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54D6C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbiCYWoq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbiCYWoY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8C120C1BE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6AE7B82A33
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76507C004DD;
        Fri, 25 Mar 2022 22:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248166;
        bh=bZPvYNsodN/zgqDU6iAMZ+u7XMlWqNCFV3PEu9v5eJc=;
        h=Date:To:From:Subject:From;
        b=PmSwbCwnqNSzbU1zUnKHMKJvGUziUQS5ZjQDEb0Hj8Qw0eQxJXZBnDSh0C43hB36v
         bzgnWOCKOGPO5yJ0AA3fOFQZ3a3ix4B5Keceoh1zpYLGhb58zB26CunhCxOSpwVamL
         nOeCM/7v47h8uSdxQaPZEsz3IIXbvYz0iqUDwMJQ=
Date:   Fri, 25 Mar 2022 15:42:45 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-simplify-async-check-in-end_report.patch removed from -mm tree
Message-Id: <20220325224246.76507C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: simplify async check in end_report()
has been removed from the -mm tree.  Its filename was
     kasan-simplify-async-check-in-end_report.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: simplify async check in end_report()

Currently, end_report() does not call trace_error_report_end() for bugs
detected in either async or asymm mode (when kasan_async_fault_possible()
returns true), as the address of the bad access might be unknown.

However, for asymm mode, the address is known for faults triggered by read
operations.

Instead of using kasan_async_fault_possible(), simply check that the addr
is not NULL when calling trace_error_report_end().

Link: https://lkml.kernel.org/r/1c8ce43f97300300e62c941181afa2eb738965c5.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/report.c~kasan-simplify-async-check-in-end_report
+++ a/mm/kasan/report.c
@@ -112,7 +112,7 @@ static void start_report(unsigned long *
 
 static void end_report(unsigned long *flags, unsigned long addr)
 {
-	if (!kasan_async_fault_possible())
+	if (addr)
 		trace_error_report_end(ERROR_DETECTOR_KASAN, addr);
 	pr_err("==================================================================\n");
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

