Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E6E5C4743D
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 20:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 266E661407
	for <mm-commits@archiver.kernel.org>; Fri,  4 Jun 2021 20:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhFDUxh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Jun 2021 16:53:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229913AbhFDUxh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Jun 2021 16:53:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFF7261403;
        Fri,  4 Jun 2021 20:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622839911;
        bh=Zg6P8XtHXRjZc7uysy7KpYcIqavZKWNTAH6WBi8DXUg=;
        h=Date:From:To:Subject:From;
        b=UVa7lLttkbpbfsxeDYLEEVP7/4CM84KmHY7D+zdP16ELlq9YkSdVITxP8j2hJ00hK
         juhAWGBQpQ/r0oU1sagpEfFmBqID6dLQop7ayd57aWe4+kauTSAYyun7hFlSUmb1wY
         Vdw2HIJ28piwr0vToKrUqNi0mFRoChibNPRIcecA=
Date:   Fri, 04 Jun 2021 13:51:50 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, wangkefeng.wang@huawei.com
Subject:  + powerpc-convert-to-setup_initial_init_mm.patch added to
 -mm tree
Message-ID: <20210604205150.0j1MpsVgQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: convert to setup_initial_init_mm()
has been added to the -mm tree.  Its filename is
     powerpc-convert-to-setup_initial_init_mm.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-convert-to-setup_initial_init_mm.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-convert-to-setup_initial_init_mm.patch

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

