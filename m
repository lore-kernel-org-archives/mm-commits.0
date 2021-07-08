Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F2BC07E9E
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD32B61CD9
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhGHBLh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhGHBLh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 456C661CD8;
        Thu,  8 Jul 2021 01:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706535;
        bh=83NTYCuDoYH1tAJIIRLHwxTLMXhROzf2TGl0jh222HU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=stuCfkGSBSR7/iRjs0ggncHOG7y/Iuym4E7MPSNxAN8xjx5k7LlElmNg1w0FlZTzR
         WWxmpWasjh0xQKeDzKxqwsQKBT1Q7U0Us3+/ky8waQxZV5rwc0F1CvTPrQlKwIc99s
         VjkCS9VMJiLXwNZdto3sE0PqFgcXq4OBtc+mRdgU=
Date:   Wed, 07 Jul 2021 18:08:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, palmerdabbelt@google.com,
        paul.walmsley@sifive.com, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com
Subject:  [patch 27/54] riscv: convert to setup_initial_init_mm()
Message-ID: <20210708010854.tejN8VeeE%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: riscv: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210608083418.137226-13-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/riscv/kernel/setup.c~riscv-convert-to-setup_initial_init_mm
+++ a/arch/riscv/kernel/setup.c
@@ -264,10 +264,7 @@ static void __init parse_dtb(void)
 void __init setup_arch(char **cmdline_p)
 {
 	parse_dtb();
-	init_mm.start_code = (unsigned long) _stext;
-	init_mm.end_code   = (unsigned long) _etext;
-	init_mm.end_data   = (unsigned long) _edata;
-	init_mm.brk        = (unsigned long) _end;
+	setup_initial_init_mm(_stext, _etext, _edata, _end);
 
 	*cmdline_p = boot_command_line;
 
_
