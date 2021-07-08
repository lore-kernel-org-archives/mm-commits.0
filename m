Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7922C07E9B
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF49E61CD9
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhGHBLe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhGHBLe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ACBB61CD3;
        Thu,  8 Jul 2021 01:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706532;
        bh=uKWWoA3nRbhSfqbwBw6QR79fTaF/sulh1yVGe8V40+w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sIU5M2IjVH7YS3bpofEz78ISEDaIgbxpUAxifD8f41/0M5H2iDXKh+LGGrnXoVvVs
         BzLsueqMa9sBQ2q4qjyZGcPYIGwQIADb4onTJqDu4gb4URXzF/srH5q2UJu4CIgXm4
         UqgM3zdpLotNyKp7n/OtJwt6Qg0F49yjuXmP+jLA=
Date:   Wed, 07 Jul 2021 18:08:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        christophe.leroy@csgroup.eu, jrdr.linux@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org, wangkefeng.wang@huawei.com
Subject:  [patch 26/54] powerpc: convert to setup_initial_init_mm()
Message-ID: <20210708010851.Nu7rJ1_vQ%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: powerpc: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Note klimit is (unsigned long) _end, with new helper, will use _end
directly.

Link: https://lkml.kernel.org/r/20210608083418.137226-12-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/setup-common.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/powerpc/kernel/setup-common.c~powerpc-convert-to-setup_initial_init_mm
+++ a/arch/powerpc/kernel/setup-common.c
@@ -926,10 +926,7 @@ void __init setup_arch(char **cmdline_p)
 
 	klp_init_thread_info(&init_task);
 
-	init_mm.start_code = (unsigned long)_stext;
-	init_mm.end_code = (unsigned long) _etext;
-	init_mm.end_data = (unsigned long) _edata;
-	init_mm.brk = (unsigned long)_end;
+	setup_initial_init_mm(_stext, _etext, _edata, _end);
 
 	mm_iommu_init(&init_mm);
 	irqstack_early_init();
_
