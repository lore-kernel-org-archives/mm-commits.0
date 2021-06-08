Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02803C47095
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E152C6124C
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhFHA3J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230514AbhFHA3I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:29:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 862326101A;
        Tue,  8 Jun 2021 00:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623112020;
        bh=p78TFtDigdf8g1PPAax5PzAm92pa2WTQ72icvyW/YC0=;
        h=Date:From:To:Subject:From;
        b=upc86mANZICL5UBLc59y6jtmx/YsoL2ONobtuLaQMXQV32erO1+cuYxaaPgvkxSnZ
         LnvGJKHoQxG1YwHul6NOcrd/VOyTDaD+RnEAvVl3vWSbSsmwhOcAxSqwIEZlMTof9j
         qICdX2hEZ1WDhCchYMSklSsVQ+wOrvaC0V1TQjR8=
Date:   Mon, 07 Jun 2021 17:27:00 -0700
From:   akpm@linux-foundation.org
To:     green.hu@gmail.com, mm-commits@vger.kernel.org,
        nickhu@andestech.com, wangkefeng.wang@huawei.com
Subject:  [failures] nds32-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210608002700.WV4aXnXZo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nds32: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     nds32-convert-to-setup_initial_init_mm.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: nds32: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210604070633.32363-9-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Greentime Hu <green.hu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/nds32/kernel/setup.c~nds32-convert-to-setup_initial_init_mm
+++ a/arch/nds32/kernel/setup.c
@@ -294,10 +294,7 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_cpuinfo();
 
-	init_mm.start_code = (unsigned long)&_stext;
-	init_mm.end_code = (unsigned long)&_etext;
-	init_mm.end_data = (unsigned long)&_edata;
-	init_mm.brk = (unsigned long)&_end;
+	setup_initial_init_mm(_stext, _etext, _edata, _end);
 
 	/* setup bootmem allocator */
 	setup_memory();
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page-writeback-kill-get_writeback_state-comments.patch
nios2-convert-to-setup_initial_init_mm.patch
openrisc-convert-to-setup_initial_init_mm.patch
powerpc-convert-to-setup_initial_init_mm.patch
riscv-convert-to-setup_initial_init_mm.patch
s390-convert-to-setup_initial_init_mm.patch
sh-convert-to-setup_initial_init_mm.patch
x86-convert-to-setup_initial_init_mm.patch
mm-move-holes_in_zone-into-mm.patch
mm-generalize-zone_.patch

