Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349FAC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiCYWof (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbiCYWoS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:44:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A5E20C193
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:42:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B910CB82A34
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E20CC004DD;
        Fri, 25 Mar 2022 22:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248160;
        bh=XWLO4rxwdEf7HgA54NwkEr4P97hnv3pHVmepiV1guZQ=;
        h=Date:To:From:Subject:From;
        b=nMxwLE8BtQX6ysxJtbM1uR9JTyYCZCxMkNAsgUJQ6D4UDJ55xjVvPd2yxA4IzY4j2
         E7CRfDPw3OtNGSTb95cKudXMcfiF+Ty+DGimU0A4NYlqCGbuHcoSFztiEpVHVLTHxu
         BY9k/bOpqIrOwPT8WkP5qinCNSzuH7YR3MKp+t48=
Date:   Fri, 25 Mar 2022 15:42:39 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        mark.rutland@arm.com, glider@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kasan-print-virtual-mapping-info-in-reports.patch removed from -mm tree
Message-Id: <20220325224240.5E20CC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: print virtual mapping info in reports
has been removed from the -mm tree.  Its filename was
     kasan-print-virtual-mapping-info-in-reports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andreyknvl@google.com are

stacktrace-add-interface-based-on-shadow-call-stack.patch
arm64-scs-save-scs_sp-values-per-cpu-when-switching-stacks.patch
arm64-implement-stack_trace_save_shadow.patch
kasan-use-stack_trace_save_shadow.patch

