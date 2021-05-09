Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8FAC433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 348DF61426
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhEIAyi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 20:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEIAyi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 20:54:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00455613D9;
        Sun,  9 May 2021 00:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620521615;
        bh=TODuTMiNLsmeZYdmsj4aQ4+N66h++j8ZDmYkM/OJ53s=;
        h=Date:From:To:Subject:From;
        b=pVZCcc4SSf+LwbC25iBRkwcx4/W1Lt27yILwilTkyztaLCXYvCucYla2+CTDnSUM3
         3+67+ltcZ+tsHoudoBwfN/k7xIdzMhhfDRgs7romqOn8AnSZw2P2YdQi93TTq84BfT
         vpA3axgmdp4lk37AhSa4YY+JAd89MlZgS8La2620=
Date:   Sat, 08 May 2021 17:53:34 -0700
From:   akpm@linux-foundation.org
To:     bo.he@intel.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mingo@kernel.org, mm-commits@vger.kernel.org,
        pmladek@suse.com, psodagud@quicinc.com, rostedt@goodmis.org,
        ryabinin.a.a@gmail.com, senozhatsky@chromium.org,
        yanmin_zhang@linux.intel.com
Subject:  + kasan-use-dump_stack_lvlkern_err-to-print-stacks.patch
 added to -mm tree
Message-ID: <20210509005334.A4HAIZNpq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use dump_stack_lvl(KERN_ERR) to print stacks
has been added to the -mm tree.  Its filename is
     kasan-use-dump_stack_lvlkern_err-to-print-stacks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-use-dump_stack_lvlkern_err-to-print-stacks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-use-dump_stack_lvlkern_err-to-print-stacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from glider@google.com are

printk-introduce-dump_stack_lvl.patch
kasan-use-dump_stack_lvlkern_err-to-print-stacks.patch

