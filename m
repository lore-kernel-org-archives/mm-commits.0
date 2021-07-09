Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733ECC07E9C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6397A613D1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhGIVfi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbhGIVfi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 896DB613D0;
        Fri,  9 Jul 2021 21:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866374;
        bh=ss5M8p50ZsOoSUlIfNt4lJXwnW7RaI1vDO1yqD6TXxE=;
        h=Date:From:To:Subject:From;
        b=CPHfnWJYf5BnfYHAJQ7NeW/fKZzRnGk1VJ90fPlEwOikoWT5jMKtfydcU7ZKDjREy
         PDaJ4VddHdlzT8c0xmkV10grpIhrI37vVMJyzeBAaBsclnzoL2ihW5iD7VbBdmDaeW
         +ooAA28xetpEBc6VB1j6Qe7oJVlS1g41VaHj0Z1I=
Date:   Fri, 09 Jul 2021 14:32:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vgupta@synopsys.com,
        wangkefeng.wang@huawei.com
Subject:  [merged] arc-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210709213254.RF0a7_bpM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arc: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     arc-convert-to-setup_initial_init_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: arc: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210608083418.137226-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>	arch/arc]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/arc/mm/init.c~arc-convert-to-setup_initial_init_mm
+++ a/arch/arc/mm/init.c
@@ -89,10 +89,7 @@ void __init setup_arch_memory(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
 
-	init_mm.start_code = (unsigned long)_text;
-	init_mm.end_code = (unsigned long)_etext;
-	init_mm.end_data = (unsigned long)_edata;
-	init_mm.brk = (unsigned long)_end;
+	setup_initial_init_mm(_text, _etext, _edata, _end);
 
 	/* first page of system - kernel .vector starts here */
 	min_low_pfn = virt_to_pfn(CONFIG_LINUX_RAM_BASE);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


