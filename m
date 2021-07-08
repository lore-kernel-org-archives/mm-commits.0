Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E85C07E9C
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ACD561CD9
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhGHBLH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhGHBLH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:11:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 969A561CD3;
        Thu,  8 Jul 2021 01:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706506;
        bh=zihMgvq5Nn+3+jYg0Mb3YLXUsinJdGkiPGdgtQ2gBvQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s0V6J1Gy+41R2FUYTnToaZdrLhusZDCoePXbUbNCBlYvdcAAsBu/qHC04knNkn3g9
         2+sSkmHkHdMMNJmsGg1uTKQzcQ8YSx7ZiwQJ3zGagQD/hTghvhNM23FQo3YAkySRNE
         m1o6xrcp1vpBn6gT97ZLqgCkcBw4ALEVXKuO4JwA=
Date:   Wed, 07 Jul 2021 18:08:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vgupta@synopsys.com, wangkefeng.wang@huawei.com
Subject:  [patch 17/54] arc: convert to setup_initial_init_mm()
Message-ID: <20210708010826.wfyHgpdQh%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
