Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE142C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4BEA613E3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhGIVfq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231225AbhGIVfq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88918613D1;
        Fri,  9 Jul 2021 21:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866381;
        bh=kcaJX1C8ORk+vw60wzFzXJ+Z98Ztr35uIfQx8Url4FM=;
        h=Date:From:To:Subject:From;
        b=hRX0uFsvWYuulxGs+KrcZXdcETtmp+COAwwuh62Ec1Y0YeJhcC8JyL5VadrNEV/Ri
         M3oO9sBiq+BJAXZAqLsg49g231N7maWiv70kvBVLDIlhisZjpj7qQ2o30Ylc/HdENp
         qwBUEsJOg9/lORYz9oHQOpQecO4vnpvbZ9ic2Kuo=
Date:   Fri, 09 Jul 2021 14:33:01 -0700
From:   akpm@linux-foundation.org
To:     ley.foon.tan@intel.com, mm-commits@vger.kernel.org,
        wangkefeng.wang@huawei.com
Subject:  [merged] nios2-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210709213301.VouMND-SH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nios2: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     nios2-convert-to-setup_initial_init_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: nios2: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210608083418.137226-10-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/nios2/kernel/setup.c~nios2-convert-to-setup_initial_init_mm
+++ a/arch/nios2/kernel/setup.c
@@ -156,10 +156,7 @@ void __init setup_arch(char **cmdline_p)
 	memory_start = memblock_start_of_DRAM();
 	memory_end = memblock_end_of_DRAM();
 
-	init_mm.start_code = (unsigned long) _stext;
-	init_mm.end_code = (unsigned long) _etext;
-	init_mm.end_data = (unsigned long) _edata;
-	init_mm.brk = (unsigned long) _end;
+	setup_initial_init_mm(_stext, _etext, _edata, _end);
 	init_task.thread.kregs = &fake_regs;
 
 	/* Keep a copy of command line */
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


