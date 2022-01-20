Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2332C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377801AbiATVW7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:22:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56056 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377807AbiATVW6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:22:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1614EB81E6B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A219EC340E0;
        Thu, 20 Jan 2022 21:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713775;
        bh=jl9bcRJP6IvURCsejIbtugDRoDRqygCbds4Pp2MKRTo=;
        h=Date:From:To:Subject:From;
        b=crg3CEH16R1OsfZi7C0lTza3JvVQTBD5CpVgzGjwXIpgfIUoDfuRxJWGyB774t7sV
         oHdQ9Kh8isOHoC1IV0/SvPM8tlW643iNCLzHKi+b8Hm52Hete3ZnXIndln1IXoTgoZ
         KtMCHgVaviV4GqBRGhlH3X/vNl+42gfGCR8XwFVQ=
Date:   Thu, 20 Jan 2022 13:22:55 -0800
From:   akpm@linux-foundation.org
To:     davidcomponentone@gmail.com, mm-commits@vger.kernel.org,
        yang.guang5@zte.com.cn, zealci@zte.com.cn
Subject:  [merged] ia64-module-use-swap-to-make-code-cleaner.patch
 removed from -mm tree
Message-ID: <20220120212255.FCPZRQjZx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: module: use swap() to make code cleaner
has been removed from the -mm tree.  Its filename was
     ia64-module-use-swap-to-make-code-cleaner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Guang <yang.guang5@zte.com.cn>
Subject: ia64: module: use swap() to make code cleaner

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Link: https://lkml.kernel.org/r/20211104062642.1506539-1-yang.guang5@zte.com.cn
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: David Yang <davidcomponentone@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/module.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/ia64/kernel/module.c~ia64-module-use-swap-to-make-code-cleaner
+++ a/arch/ia64/kernel/module.c
@@ -848,7 +848,7 @@ register_unwind_table (struct module *mo
 {
 	struct unw_table_entry *start = (void *) mod->arch.unwind->sh_addr;
 	struct unw_table_entry *end = start + mod->arch.unwind->sh_size / sizeof (*start);
-	struct unw_table_entry tmp, *e1, *e2, *core, *init;
+	struct unw_table_entry *e1, *e2, *core, *init;
 	unsigned long num_init = 0, num_core = 0;
 
 	/* First, count how many init and core unwind-table entries there are.  */
@@ -865,9 +865,7 @@ register_unwind_table (struct module *mo
 	for (e1 = start; e1 < end; ++e1) {
 		for (e2 = e1 + 1; e2 < end; ++e2) {
 			if (e2->start_offset < e1->start_offset) {
-				tmp = *e1;
-				*e1 = *e2;
-				*e2 = tmp;
+				swap(*e1, *e2);
 			}
 		}
 	}
_

Patches currently in -mm which might be from yang.guang5@zte.com.cn are


