Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D81C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357208AbiCYBOE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357214AbiCYBNu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:13:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80064BD2EC
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:12:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E4A7B81DE2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC81EC340EE;
        Fri, 25 Mar 2022 01:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170731;
        bh=RPS66mLY40uI7CEhGYfZFqqxIgB4RPI/gfzwyJYAVB8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=VzuZPvGwr82PnQ7KgUnkbt/5DAtiej7C3uoqr5NCSS70ylCvW4Psv0DAR9s/2I1m3
         oqqYyserZmuq27LctMKTO4X5I8aRrHZozobQ74LcsvUcy2FXwP3QYsqhnbiIT5eb2V
         I+6JXukwRq3x8mKN/9AHwWK9kWnopKLNTxeF6oaI=
Date:   Thu, 24 Mar 2022 18:12:11 -0700
To:     ryabinin.a.a@gmail.com, mark.rutland@arm.com, glider@google.com,
        elver@google.com, dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 072/114] kasan: print virtual mapping info in reports
Message-Id: <20220325011211.CC81EC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: print virtual mapping info in reports

Print virtual mapping range and its creator in reports affecting virtual
mappings.

Also get physical page pointer for such mappings, so page information gets
printed as well.

Link: https://lkml.kernel.org/r/6ebb11210ae21253198e264d4bb0752c1fad67d7.1645548178.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/mm/kasan/report.c~kasan-print-virtual-mapping-info-in-reports
+++ a/mm/kasan/report.c
@@ -260,8 +260,21 @@ static void print_address_description(vo
 		pr_err(" %pS\n", addr);
 	}
 
+	if (is_vmalloc_addr(addr)) {
+		struct vm_struct *va = find_vm_area(addr);
+
+		if (va) {
+			pr_err("The buggy address belongs to the virtual mapping at\n"
+			       " [%px, %px) created by:\n"
+			       " %pS\n",
+			       va->addr, va->addr + va->size, va->caller);
+
+			page = vmalloc_to_page(page);
+		}
+	}
+
 	if (page) {
-		pr_err("The buggy address belongs to the page:\n");
+		pr_err("The buggy address belongs to the physical page:\n");
 		dump_page(page, "kasan: bad access detected");
 	}
 
_
