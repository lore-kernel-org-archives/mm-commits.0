Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C495FC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbiCYWoh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbiCYWoU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE0C20C1A2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D115FB82A32
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D446C340F0;
        Fri, 25 Mar 2022 22:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248162;
        bh=xGxdXnt4KBR1RPvdzUIf52yGV5A79Zn11KOE4qJPCEY=;
        h=Date:To:From:Subject:From;
        b=VFibslcX+kNvuCw6OjHjnbY9Xzd99+bhKKX30iB3/1EbxkxN4y1dUZyS/GIBDawK0
         XP/Ni+S2oS961TizWrlpJmM739vbPJBd/EgNrZs/KXLBCvlbOgAutyWV7BoFFEBW5o
         I9FLb5oqNWN7asYJ4U4Bgz+daH1r1tOfX9SjJsho=
Date:   Fri, 25 Mar 2022 15:42:41 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-more-line-breaks-in-reports.patch removed from -mm tree
Message-Id: <20220325224242.5D446C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: more line breaks in reports
has been removed from the -mm tree.  Its filename was
     kasan-more-line-breaks-in-reports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: more line breaks in reports

Add a line break after each part that describes the buggy address. 
Improves readability of reports.

Link: https://lkml.kernel.org/r/8682c4558e533cd0f99bdb964ce2fe741f2a9212.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/kasan/report.c~kasan-more-line-breaks-in-reports
+++ a/mm/kasan/report.c
@@ -250,11 +250,13 @@ static void print_address_description(vo
 		void *object = nearest_obj(cache, slab,	addr);
 
 		describe_object(cache, object, addr, tag);
+		pr_err("\n");
 	}
 
 	if (kernel_or_module_addr(addr) && !init_task_stack_addr(addr)) {
 		pr_err("The buggy address belongs to the variable:\n");
 		pr_err(" %pS\n", addr);
+		pr_err("\n");
 	}
 
 	if (is_vmalloc_addr(addr)) {
@@ -265,6 +267,7 @@ static void print_address_description(vo
 			       " [%px, %px) created by:\n"
 			       " %pS\n",
 			       va->addr, va->addr + va->size, va->caller);
+			pr_err("\n");
 
 			page = vmalloc_to_page(page);
 		}
@@ -273,9 +276,11 @@ static void print_address_description(vo
 	if (page) {
 		pr_err("The buggy address belongs to the physical page:\n");
 		dump_page(page, "kasan: bad access detected");
+		pr_err("\n");
 	}
 
 	kasan_print_address_stack_frame(addr);
+	pr_err("\n");
 }
 
 static bool meta_row_is_guilty(const void *row, const void *addr)
@@ -382,7 +387,6 @@ void kasan_report_invalid_free(void *obj
 	kasan_print_tags(tag, object);
 	pr_err("\n");
 	print_address_description(object, tag);
-	pr_err("\n");
 	print_memory_metadata(object);
 	end_report(&flags, (unsigned long)object);
 }
@@ -443,7 +447,6 @@ static void __kasan_report(unsigned long
 
 	if (addr_has_metadata(untagged_addr)) {
 		print_address_description(untagged_addr, get_tag(tagged_addr));
-		pr_err("\n");
 		print_memory_metadata(info.first_bad_addr);
 	} else {
 		dump_stack_lvl(KERN_ERR);
_

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

