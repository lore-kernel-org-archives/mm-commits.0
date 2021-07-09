Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5544BC07E9C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40233613E6
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhGIVft (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231241AbhGIVft (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80DA1613D6;
        Fri,  9 Jul 2021 21:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866384;
        bh=R517JCLG4c1fkD9V9SouJZxE3/1sVG3DReg+qTZzBHk=;
        h=Date:From:To:Subject:From;
        b=HCaF+P4ukKXvE0BbiSwJAIbhrOIbR/3Ex+r92osIdWtWZz/aoAq3lYxaa0zvD3Bhh
         xOZs7E/128BwVl9MmgW6wd+fFKXGlKhbXdkUEhlJIVJP8ag7kFcIYscoaOmIkaYTqY
         ERn8+r+8SfcI+gxSYme3AEil8v/xMLA+f+1podHQ=
Date:   Fri, 09 Jul 2021 14:33:04 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, palmerdabbelt@google.com,
        paul.walmsley@sifive.com, wangkefeng.wang@huawei.com
Subject:  [merged] riscv-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210709213304.CIjP6Gpmi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     riscv-convert-to-setup_initial_init_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


