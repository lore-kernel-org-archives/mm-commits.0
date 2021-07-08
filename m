Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8276C11F68
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A357E61CD8
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhGHBLZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhGHBLY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:11:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A315B61CD6;
        Thu,  8 Jul 2021 01:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706523;
        bh=6tfglENIhPPeB654iz8+zI4grZw0LJbCLG0Z11zYJEw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ic4uEdkHf9sTSa/06w0wECF8iK2GTXREvHXx2ca4eT10e2X0ksxXvj/fg/2nQQ3cI
         E6JVMbcpftcplTpzdM7XGDZ9VJ5ALfXArloZtK6qEIfXPbItYmaSGFE9pwE0YSzanf
         Iuz9BV/83+GV1ZEvUGP0kzQ9kvXKS2BdO3EnZE6A=
Date:   Wed, 07 Jul 2021 18:08:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, green.hu@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        torvalds@linux-foundation.org, wangkefeng.wang@huawei.com
Subject:  [patch 23/54] nds32: convert to setup_initial_init_mm()
Message-ID: <20210708010843.GIaO4lKd9%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: nds32: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210608083418.137226-9-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/nds32/kernel/setup.c~nds32-convert-to-setup_initial_init_mm
+++ a/arch/nds32/kernel/setup.c
@@ -294,10 +294,7 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_cpuinfo();
 
-	init_mm.start_code = (unsigned long)&_stext;
-	init_mm.end_code = (unsigned long)&_etext;
-	init_mm.end_data = (unsigned long)&_edata;
-	init_mm.brk = (unsigned long)&_end;
+	setup_initial_init_mm(_stext, _etext, _edata, _end);
 
 	/* setup bootmem allocator */
 	setup_memory();
_
