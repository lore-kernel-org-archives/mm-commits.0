Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48147C47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F1C76127A
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhFHA3H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230503AbhFHA3H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:29:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E5FE6124C;
        Tue,  8 Jun 2021 00:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623112018;
        bh=fu0Q4mTJS3T1iEYUuP60yGD7LNW/b56qt9yeMD0Lw8w=;
        h=Date:From:To:Subject:From;
        b=jOcvB357ScmI/XQD3JSfMDsP9xQ7zwZZYzvkPzOCnxI9yrjCAMi8o/mrIxDI4DzKw
         E70E62M9u62oM+VXKq84X1QwWcxH2Y6vOqqMjMaP1ymPqyycqfj/WDbLm5hDDUqOWC
         HDWQfiTJdsr3shpU9RSoa5QP1NjUpfVDW1p4BlSA=
Date:   Mon, 07 Jun 2021 17:26:58 -0700
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, gerg@linux-m68k.org,
        mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com
Subject:  [failures] m68k-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210608002658.6MzkEP8ir%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     m68k-convert-to-setup_initial_init_mm.patch

This patch was dropped because it had testing failures

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

