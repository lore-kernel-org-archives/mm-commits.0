Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF87C4743E
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 20:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D01160C40
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 20:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhFDUxT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 16:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231320AbhFDUxT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 16:53:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3AAA61404;
        Fri,  4 Jun 2021 20:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622839892;
        bh=KUNzs+qtJ3CmthBoC4/iNmkYq7q2BhlAA/lfPzi/vaI=;
        h=Date:From:To:Subject:From;
        b=OuNZYETv/TLymPVmRlKDE+59seKPLvud59O53k+81zqWak6etK+gL6f7caz68GVmL
         /9nZAkOMnTiyiYZSPUnwtScYkCKcA/sbZbzs5YyacBdUjzkSKuIg3wmFftMP9sVX6r
         JHsIOZQkDR16tnX7kzk5+1lmggVGQ1NC2MUXAFF8=
Date:   Fri, 04 Jun 2021 13:51:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vgupta@synopsys.com,
        wangkefeng.wang@huawei.com
Subject:  + arc-convert-to-setup_initial_init_mm.patch added to -mm
 tree
Message-ID: <20210604205132.43T3nmBWP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arc: convert to setup_initial_init_mm()
has been added to the -mm tree.  Its filename is
     arc-convert-to-setup_initial_init_mm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arc-convert-to-setup_initial_init_mm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arc-convert-to-setup_initial_init_mm.patch

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
Subject: arc: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210604070633.32363-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/arc/mm/init.c~arc-convert-to-setup_initial_init_mm
+++ a/arch/arc/mm/init.c
@@ -94,10 +94,7 @@ void __init setup_arch_memory(void)
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

