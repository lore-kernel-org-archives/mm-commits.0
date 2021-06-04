Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BD4C4743D
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 20:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC9F61406
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 20:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhFDUxm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 16:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229913AbhFDUxm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 16:53:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEB29613FF;
        Fri,  4 Jun 2021 20:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622839903;
        bh=xeDplYxDP6ADzqqH2wDGr2R3TeWQDzvikcHpGgIewKo=;
        h=Date:From:To:Subject:From;
        b=YRbGxFz58SGbD1jX6ZORnNeHlSi/VN1CR4kCOUW9vvB6UlJYk8N3jthI88yLPDf7X
         wYfbaNecQAA+pnBiRUaosWv9fX9Y/OIFMmZ821mqd6/keY9AwkoiFSIJ2UuIWZ8eFB
         DW6Cp6etQ4Fp8X7Ivxw6dZUUAAFl3+zqk3VCLUSE=
Date:   Fri, 04 Jun 2021 13:51:42 -0700
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, gerg@linux-m68k.org,
        mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com
Subject:  + m68k-convert-to-setup_initial_init_mm.patch added to
 -mm tree
Message-ID: <20210604205142.xj68Pq3wj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: convert to setup_initial_init_mm()
has been added to the -mm tree.  Its filename is
     m68k-convert-to-setup_initial_init_mm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/m68k-convert-to-setup_initial_init_mm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/m68k-convert-to-setup_initial_init_mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: m68k: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210604070633.32363-8-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
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

mm-page-writeback-kill-get_writeback_state-comments.patch
mm-add-setup_initial_init_mm-helper.patch
arc-convert-to-setup_initial_init_mm.patch
arm-convert-to-setup_initial_init_mm.patch
arm64-convert-to-setup_initial_init_mm.patch
csky-convert-to-setup_initial_init_mm.patch
h8300-convert-to-setup_initial_init_mm.patch
m68k-convert-to-setup_initial_init_mm.patch
nds32-convert-to-setup_initial_init_mm.patch
nios2-convert-to-setup_initial_init_mm.patch
openrisc-convert-to-setup_initial_init_mm.patch
powerpc-convert-to-setup_initial_init_mm.patch
riscv-convert-to-setup_initial_init_mm.patch
s390-convert-to-setup_initial_init_mm.patch
sh-convert-to-setup_initial_init_mm.patch
x86-convert-to-setup_initial_init_mm.patch
mm-move-holes_in_zone-into-mm.patch
mm-generalize-zone_.patch

