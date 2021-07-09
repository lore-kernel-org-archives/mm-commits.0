Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC99C07E9B
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7751613E1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhGIVfk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbhGIVfj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82458613C8;
        Fri,  9 Jul 2021 21:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866375;
        bh=fNEX4XIqdB+Uwh3nYKFpd5Wwieqs2pw94eaLuHiKzRc=;
        h=Date:From:To:Subject:From;
        b=hjXFwUNzXcrCbQwCt4bCm++gr54EMlUmjshd6WlTmILPI+3DyRgzxeFgi6wPHb3p3
         wlWQasuHkcy9yGcwEwe4nqe2zDD5JmUx1XcVw0foM8fzd42UwkBPixzs3OVKSsOBW7
         a0o1XOo6K9hCLDabNjkUbAtL6aiSaX9KpXG5LGbk=
Date:   Fri, 09 Jul 2021 14:32:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        wangkefeng.wang@huawei.com
Subject:  [merged] arm-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210709213255.sYXMHIu73%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     arm-convert-to-setup_initial_init_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: arm: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210608083418.137226-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/arm/kernel/setup.c~arm-convert-to-setup_initial_init_mm
+++ a/arch/arm/kernel/setup.c
@@ -1130,10 +1130,7 @@ void __init setup_arch(char **cmdline_p)
 	if (mdesc->reboot_mode != REBOOT_HARD)
 		reboot_mode = mdesc->reboot_mode;
 
-	init_mm.start_code = (unsigned long) _text;
-	init_mm.end_code   = (unsigned long) _etext;
-	init_mm.end_data   = (unsigned long) _edata;
-	init_mm.brk	   = (unsigned long) _end;
+	setup_initial_init_mm(_text, _etext, _edata, _end);
 
 	/* populate cmd_line too for later use, preserving boot_command_line */
 	strlcpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


