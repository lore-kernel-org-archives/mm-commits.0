Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF97FC47094
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D865B60FDA
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhFHA3L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230514AbhFHA3J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:29:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 895D3611BD;
        Tue,  8 Jun 2021 00:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623112026;
        bh=6SIzFMps9sLwiwFpvqY6NrFRydL51yHhD4nlL6TfaDg=;
        h=Date:From:To:Subject:From;
        b=vV4GvFNaU9s3c9syAbqyN7eGapa485yDFikgTZBC3czAp4Ksovq4Rg3Ifdez+2sbG
         RkmdcVX/4nTSFZSq8pDfT7NWRUXWmQsWDkjreuZu1GmbaQxUciZFqc1kPaHuZcXRT3
         PL1nAjPXKPs7Kx7e1n9AHo5bdZMwdfUs2oOdd+ZY=
Date:   Mon, 07 Jun 2021 17:27:06 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, wangkefeng.wang@huawei.com
Subject:  [failures] powerpc-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210608002706.OxfNGjnHP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     powerpc-convert-to-setup_initial_init_mm.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: powerpc: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Note klimit is (unsigned long) _end, with new helper, will use _end
directly.

Link: https://lkml.kernel.org/r/20210604070633.32363-12-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup-common.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/powerpc/kernel/setup-common.c~powerpc-convert-to-setup_initial_init_mm
+++ a/arch/powerpc/kernel/setup-common.c
@@ -927,10 +927,7 @@ void __init setup_arch(char **cmdline_p)
 
 	klp_init_thread_info(&init_task);
 
-	init_mm.start_code = (unsigned long)_stext;
-	init_mm.end_code = (unsigned long) _etext;
-	init_mm.end_data = (unsigned long) _edata;
-	init_mm.brk = klimit;
+	setup_initial_init_mm(_stext, _etext, _edata, _end);
 
 	mm_iommu_init(&init_mm);
 	irqstack_early_init();
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page-writeback-kill-get_writeback_state-comments.patch
riscv-convert-to-setup_initial_init_mm.patch
s390-convert-to-setup_initial_init_mm.patch
sh-convert-to-setup_initial_init_mm.patch
x86-convert-to-setup_initial_init_mm.patch
mm-move-holes_in_zone-into-mm.patch
mm-generalize-zone_.patch

