Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDEB2C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA16F61D0F
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhF2CnB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2CnB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:43:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5FE961D12;
        Tue, 29 Jun 2021 02:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934434;
        bh=OsWbSZgv/qifFtkYiQZGT1qdUlnvRUXlYb2ULuV/kxc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CskGMS/2xQ6xvGaUKjG3flennR15FkW/1ANOni9Hoov5CaGbfu4+U+dlnCCfkZWkU
         VIVw0QGxJ1FohwU7yWIgCba05VjdrT6kPLjSvU6+dA8yH0nz3G4FP4MUM0A3v2cT12
         13EeXB3BtboyWR5PmyS99fOKoicyovsVG9FIsYS4=
Date:   Mon, 28 Jun 2021 19:40:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bo.he@intel.com, dvyukov@google.com,
        elver@google.com, glider@google.com, linux-mm@kvack.org,
        mingo@kernel.org, mm-commits@vger.kernel.org, pmladek@suse.com,
        psodagud@quicinc.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com,
        senozhatsky@chromium.org, torvalds@linux-foundation.org,
        yanmin_zhang@linux.intel.com
Subject:  [patch 139/192] kasan: use dump_stack_lvl(KERN_ERR) to
 print stacks
Message-ID: <20210629024033.a-hnjH4H1%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexander Potapenko <glider@google.com>
Subject: kasan: use dump_stack_lvl(KERN_ERR) to print stacks

Most of the contents of KASAN reports are printed with pr_err(), so use a
consistent logging level to print the memory access stacks.

Link: https://lkml.kernel.org/r/20210506105405.3535023-2-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Prasad Sodagudi <psodagud@quicinc.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: he, bo <bo.he@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kasan/report.c~kasan-use-dump_stack_lvlkern_err-to-print-stacks
+++ a/mm/kasan/report.c
@@ -230,7 +230,7 @@ static void print_address_description(vo
 {
 	struct page *page = kasan_addr_to_page(addr);
 
-	dump_stack();
+	dump_stack_lvl(KERN_ERR);
 	pr_err("\n");
 
 	if (page && PageSlab(page)) {
@@ -375,7 +375,7 @@ void kasan_report_async(void)
 	pr_err("BUG: KASAN: invalid-access\n");
 	pr_err("Asynchronous mode enabled: no access details available\n");
 	pr_err("\n");
-	dump_stack();
+	dump_stack_lvl(KERN_ERR);
 	end_report(&flags, 0);
 }
 #endif /* CONFIG_KASAN_HW_TAGS */
@@ -420,7 +420,7 @@ static void __kasan_report(unsigned long
 		pr_err("\n");
 		print_memory_metadata(info.first_bad_addr);
 	} else {
-		dump_stack();
+		dump_stack_lvl(KERN_ERR);
 	}
 
 	end_report(&flags, addr);
_
