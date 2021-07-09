Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD17C07E9B
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CDFC613E4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhGIVfm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231205AbhGIVfm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 866A3613D0;
        Fri,  9 Jul 2021 21:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866377;
        bh=kww0zr5Q0MnwSWpOSZMm7VCrxn2i73nobEZc3tXap+o=;
        h=Date:From:To:Subject:From;
        b=oBtnbQd7DtRhKKI1kKlC1g+CBY5+Nw6bP/oW6eJgyyC8JSfVxVo3WrULWuzSnmKxp
         RuJvui9j/X7fLPkw8trcsqd1NoXpyUzVKOu1dMmdNf/Z/EfNVNcodiXl54hVIJpA0R
         Aob09wqxmEQh/B+FIRG7JC6net48xUavRHNOn4y8=
Date:   Fri, 09 Jul 2021 14:32:57 -0700
From:   akpm@linux-foundation.org
To:     guoren@kernel.org, mm-commits@vger.kernel.org,
        wangkefeng.wang@huawei.com
Subject:  [merged] csky-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210709213257.ILPzudHzI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: csky: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     csky-convert-to-setup_initial_init_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: csky: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210608083418.137226-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/csky/kernel/setup.c~csky-convert-to-setup_initial_init_mm
+++ a/arch/csky/kernel/setup.c
@@ -78,10 +78,7 @@ void __init setup_arch(char **cmdline_p)
 	pr_info("Phys. mem: %ldMB\n",
 		(unsigned long) memblock_phys_mem_size()/1024/1024);
 
-	init_mm.start_code = (unsigned long) _stext;
-	init_mm.end_code = (unsigned long) _etext;
-	init_mm.end_data = (unsigned long) _edata;
-	init_mm.brk = (unsigned long) _end;
+	setup_initial_init_mm(_stext, _etext, _edata, _end);
 
 	parse_early_param();
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


