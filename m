Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0905C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353678AbiCYBOH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346581AbiCYBNx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:13:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78513BD2D7
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25C33B81DE2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAFBC340EC;
        Fri, 25 Mar 2022 01:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170737;
        bh=3qvwsQTjMidRCLTYP6z768o2hxVRhUmxnEZJGnCFHmA=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=NKYd3rM//YmT3JOOVIB2QTUd9nOldmo+9sIev4/6KBZstm2Co7Q/TRWBzaUBX+txU
         ueCDN5pIPIN309IV5QZtENFGORJIDK0zDMODiRnfofVLmbRR27gpU63+zZ5o1orwTe
         zUc2hTJGesUweTrXn2ifHaaeMGPJy+s3MeQK/DFU=
Date:   Thu, 24 Mar 2022 18:12:17 -0700
To:     ryabinin.a.a@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 074/114] kasan: more line breaks in reports
Message-Id: <20220325011217.BBAFBC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
