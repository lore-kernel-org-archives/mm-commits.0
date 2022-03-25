Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62195C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbiCYWpC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbiCYWod (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763FC20C2FC
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04F7B61502
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEB1C340ED;
        Fri, 25 Mar 2022 22:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248176;
        bh=O+gHN37FICAizauSc1Fve2PgE+8TG1hD0TJC3gA4Re4=;
        h=Date:To:From:Subject:From;
        b=ViDIcPiokC+WJ34om2K4Cchs0/2sOKt1fDIoy0yDijDVSTpXyQbs5sIcU4cSo6Z0p
         +XBO1oRb7CPNaYKnt7PUyJz88IOfZicGR3880Q61S/14Rccm+NNq94IHoGjHv5jVKm
         nFCUrPOp5y1oajMrgGmkDSrNPD3ZlDFkX899SkRk=
Date:   Fri, 25 Mar 2022 15:42:55 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-move-and-simplify-kasan_report_async.patch removed from -mm tree
Message-Id: <20220325224256.5BEB1C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: move and simplify kasan_report_async
has been removed from the -mm tree.  Its filename was
     kasan-move-and-simplify-kasan_report_async.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: move and simplify kasan_report_async

Place kasan_report_async() next to the other main reporting routines. 
Also simplify printed information.

Link: https://lkml.kernel.org/r/52d942ef3ffd29bdfa225bbe8e327bc5bda7ab09.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/kasan/report.c~kasan-move-and-simplify-kasan_report_async
+++ a/mm/kasan/report.c
@@ -392,20 +392,6 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-#ifdef CONFIG_KASAN_HW_TAGS
-void kasan_report_async(void)
-{
-	unsigned long flags;
-
-	start_report(&flags, false);
-	pr_err("BUG: KASAN: invalid-access\n");
-	pr_err("Asynchronous mode enabled: no access details available\n");
-	pr_err("\n");
-	dump_stack_lvl(KERN_ERR);
-	end_report(&flags, NULL);
-}
-#endif /* CONFIG_KASAN_HW_TAGS */
-
 static void print_report(struct kasan_access_info *info)
 {
 	void *tagged_addr = info->access_addr;
@@ -477,6 +463,20 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_KASAN_HW_TAGS
+void kasan_report_async(void)
+{
+	unsigned long flags;
+
+	start_report(&flags, false);
+	pr_err("BUG: KASAN: invalid-access\n");
+	pr_err("Asynchronous fault: no details available\n");
+	pr_err("\n");
+	dump_stack_lvl(KERN_ERR);
+	end_report(&flags, NULL);
+}
+#endif /* CONFIG_KASAN_HW_TAGS */
+
 #ifdef CONFIG_KASAN_INLINE
 /*
  * With CONFIG_KASAN_INLINE, accesses to bogus pointers (outside the high
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

