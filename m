Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD56C07E9C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57A77613DC
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhGIVfl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231205AbhGIVfl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86B14613D6;
        Fri,  9 Jul 2021 21:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866376;
        bh=W/4/IaexDUrgrn2sgH2sT7QVHln0yunxZzUUfCE00lM=;
        h=Date:From:To:Subject:From;
        b=JJ20tp1o+Lex226NaHZaD27R2zIDR87hbiU7+at4/XIQ9ljNpVgdP9KElNciy01Jg
         OXkgaSf7WOKdqA4lH420YMLnisMWVY8neyj2tnOiKcfQKKEinf4wd5+WF2cnoW7AmY
         7OvItTczHYJ+bkJIvdwDGWy7dFLApe/DxaJMwrNY=
Date:   Fri, 09 Jul 2021 14:32:56 -0700
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, mm-commits@vger.kernel.org,
        wangkefeng.wang@huawei.com, will@kernel.org
Subject:  [merged] arm64-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210709213256.fizAounOp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     arm64-convert-to-setup_initial_init_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: arm64: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210608083418.137226-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/arm64/kernel/setup.c~arm64-convert-to-setup_initial_init_mm
+++ a/arch/arm64/kernel/setup.c
@@ -293,10 +293,7 @@ u64 cpu_logical_map(unsigned int cpu)
 
 void __init __no_sanitize_address setup_arch(char **cmdline_p)
 {
-	init_mm.start_code = (unsigned long) _stext;
-	init_mm.end_code   = (unsigned long) _etext;
-	init_mm.end_data   = (unsigned long) _edata;
-	init_mm.brk	   = (unsigned long) _end;
+	setup_initial_init_mm(_stext, _etext, _edata, _end);
 
 	*cmdline_p = boot_command_line;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


