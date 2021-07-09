Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B898AC07E9B
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A23C7613E8
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhGIVfs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231225AbhGIVfr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B636613E1;
        Fri,  9 Jul 2021 21:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866382;
        bh=akXv665VNY1uFV9sH+sCQSG7/TQD1TwLMPE0FMjabdw=;
        h=Date:From:To:Subject:From;
        b=YbsucfZlic0G2j9D+i66FhdvhlURuQG1eJIvf2rhnI2ijGgknZyugCFn5ANgev4pY
         KP6MrneN2+ogATSOD6Tq9OLNDg9fmy4h4NGUEWRAaRoFb4tLBHJYr0P9bmbJ4bptn9
         W+FlP5j4yYYLv44gnLsHvlXu/uK0YHxhxZWJL11Y=
Date:   Fri, 09 Jul 2021 14:33:02 -0700
From:   akpm@linux-foundation.org
To:     jonas@southpole.se, mm-commits@vger.kernel.org, shorne@gmail.com,
        stefan.kristiansson@saunalahti.fi, wangkefeng.wang@huawei.com
Subject:  [merged] openrisc-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210709213302.izLBVaBSm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: openrisc: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     openrisc-convert-to-setup_initial_init_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: openrisc: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210608083418.137226-11-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Stafford Horne <shorne@gmail.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/openrisc/kernel/setup.c~openrisc-convert-to-setup_initial_init_mm
+++ a/arch/openrisc/kernel/setup.c
@@ -293,10 +293,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	/* process 1's initial memory region is the kernel code/data */
-	init_mm.start_code = (unsigned long)_stext;
-	init_mm.end_code = (unsigned long)_etext;
-	init_mm.end_data = (unsigned long)_edata;
-	init_mm.brk = (unsigned long)_end;
+	setup_initial_init_mm(_stext, _etext, _edata, _end);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start == initrd_end) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


