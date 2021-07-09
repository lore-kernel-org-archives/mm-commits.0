Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366EEC07E9E
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22DF8613D6
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhGIVfp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231225AbhGIVfp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 849E1613C8;
        Fri,  9 Jul 2021 21:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866380;
        bh=OQabmvaJWDz72v+Ta8ZLq69b6jijxfGazz/tBcpvPaY=;
        h=Date:From:To:Subject:From;
        b=Lz1WRjzRs4D3UjycTXmC6v90/JECCaDdFZXuDd7ZFXRGgsNH4BEztOLY4BsK3JE7m
         QQdSUci92XFqev49LEC/tRt/iS8OM2SvawiEpfF+n9Mf1dIUkUg9V/IRCXsJua+6Z1
         jKhxFQBliOc/2tWMRo2hHtYhPCZPOxyTFQVS5fdU=
Date:   Fri, 09 Jul 2021 14:33:00 -0700
From:   akpm@linux-foundation.org
To:     green.hu@gmail.com, mm-commits@vger.kernel.org,
        nickhu@andestech.com, wangkefeng.wang@huawei.com
Subject:  [merged] nds32-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210709213300.yMhGL8nvX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nds32: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     nds32-convert-to-setup_initial_init_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


