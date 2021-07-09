Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D5AC11F69
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A6DF613D3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhGIVfu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231244AbhGIVfu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 713E6613E4;
        Fri,  9 Jul 2021 21:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866386;
        bh=gdxnvSjIBAa0KtuZR89iakMSmEM54IxKitEykJfbV4k=;
        h=Date:From:To:Subject:From;
        b=DVL2xm7J/YGSEvfWTmorZCmGTbrLBn5ozSiutfDaJlGrAeHv9zIjWNrynpwifKQ1i
         ZRWjdjWj9ImDQij9dsrTuAhKtNladtyhxEuEWkkZJJLsFfN3lYurwKikMiianyYCso
         Q5NF8w68FpzP7x1CXgR9Wx2vFE7XNf+nvq2+xBBw=
Date:   Fri, 09 Jul 2021 14:33:06 -0700
From:   akpm@linux-foundation.org
To:     dalias@libc.org, mm-commits@vger.kernel.org,
        wangkefeng.wang@huawei.com, ysato@users.sourceforge.jp
Subject:  [merged] sh-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210709213306.s_zHvE-8M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     sh-convert-to-setup_initial_init_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: sh: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210608083418.137226-15-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/sh/kernel/setup.c~sh-convert-to-setup_initial_init_mm
+++ a/arch/sh/kernel/setup.c
@@ -294,10 +294,7 @@ void __init setup_arch(char **cmdline_p)
 
 	if (!MOUNT_ROOT_RDONLY)
 		root_mountflags &= ~MS_RDONLY;
-	init_mm.start_code = (unsigned long) _text;
-	init_mm.end_code = (unsigned long) _etext;
-	init_mm.end_data = (unsigned long) _edata;
-	init_mm.brk = (unsigned long) _end;
+	setup_initial_init_mm(_text, _etext, _edata, _end);
 
 	code_resource.start = virt_to_phys(_text);
 	code_resource.end = virt_to_phys(_etext)-1;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


