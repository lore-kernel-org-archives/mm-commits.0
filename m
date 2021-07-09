Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65221C07E9B
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51A38613DC
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhGIVfo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231205AbhGIVfo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83771613E3;
        Fri,  9 Jul 2021 21:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866379;
        bh=mav3zb4kZAdOpvYjng0+skJ3fkWncO8MygVTVsiB62Y=;
        h=Date:From:To:Subject:From;
        b=Q9tV6xplcl1nbf6XPXRsG3g+c3T2uA84paeUq4N6IAoJ7yGjmEw4qkt69fspmuFX1
         lhjOpX8SDq5mcmnnwRRnh2TysJ28TYL0+1zqFRfCXj9hhrigFc2sDSrCC9NEEFLqNC
         6JjVfegwMjXWDKd+6lwk2Aokt+oIiWwIjR4TE/tc=
Date:   Fri, 09 Jul 2021 14:32:59 -0700
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, gerg@linux-m68k.org,
        mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com
Subject:  [merged] m68k-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210709213259.vsjuL7FhA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     m68k-convert-to-setup_initial_init_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: m68k: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210608083418.137226-8-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/setup_mm.c |    5 +----
 arch/m68k/kernel/setup_no.c |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/arch/m68k/kernel/setup_mm.c~m68k-convert-to-setup_initial_init_mm
+++ a/arch/m68k/kernel/setup_mm.c
@@ -258,10 +258,7 @@ void __init setup_arch(char **cmdline_p)
 		}
 	}
 
-	init_mm.start_code = PAGE_OFFSET;
-	init_mm.end_code = (unsigned long)_etext;
-	init_mm.end_data = (unsigned long)_edata;
-	init_mm.brk = (unsigned long)_end;
+	setup_initial_init_mm((void *)PAGE_OFFSET, _etext, _edata, _end);
 
 #if defined(CONFIG_BOOTPARAM)
 	strncpy(m68k_command_line, CONFIG_BOOTPARAM_STRING, CL_SIZE);
--- a/arch/m68k/kernel/setup_no.c~m68k-convert-to-setup_initial_init_mm
+++ a/arch/m68k/kernel/setup_no.c
@@ -87,10 +87,7 @@ void __init setup_arch(char **cmdline_p)
 	memory_start = PAGE_ALIGN(_ramstart);
 	memory_end = _ramend;
 
-	init_mm.start_code = (unsigned long) &_stext;
-	init_mm.end_code = (unsigned long) &_etext;
-	init_mm.end_data = (unsigned long) &_edata;
-	init_mm.brk = (unsigned long) 0;
+	setup_initial_init_mm(_stext, _etext, _edata, NULL);
 
 	config_BSP(&command_line[0], sizeof(command_line));
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


