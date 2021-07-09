Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57306C07E9C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46AA1613E1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhGIVfn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231205AbhGIVfn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84EE1613D1;
        Fri,  9 Jul 2021 21:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866378;
        bh=RP0mQhclsltsT9HrMsTCWjZTslNhwZmqdzPcKYEnNv0=;
        h=Date:From:To:Subject:From;
        b=Q/TZIIIgtYvYtqcjs4qQMojhY/KakStKmLM42YUXlp38x6Od4Zk+c1KPS/qyeFcny
         KBd7Xn6QMVpQZid8N6JTKbC/fcxoCaM1HkOfLkZT5bDm94dPB0Flpp9ajQqs3fLI2b
         WwBBm8RNEHDwikb7x4gRQCOgiU65F4kQ6XSUbeUc=
Date:   Fri, 09 Jul 2021 14:32:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        ysato@users.sourceforge.jp
Subject:  [merged] h8300-convert-to-setup_initial_init_mm.patch
 removed from -mm tree
Message-ID: <20210709213258.5TbzWzVsl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: convert to setup_initial_init_mm()
has been removed from the -mm tree.  Its filename was
     h8300-convert-to-setup_initial_init_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: h8300: convert to setup_initial_init_mm()

Use setup_initial_init_mm() helper to simplify code.

Link: https://lkml.kernel.org/r/20210608083418.137226-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/h8300/kernel/setup.c~h8300-convert-to-setup_initial_init_mm
+++ a/arch/h8300/kernel/setup.c
@@ -95,10 +95,7 @@ void __init setup_arch(char **cmdline_p)
 {
 	unflatten_and_copy_device_tree();
 
-	init_mm.start_code = (unsigned long) _stext;
-	init_mm.end_code = (unsigned long) _etext;
-	init_mm.end_data = (unsigned long) _edata;
-	init_mm.brk = (unsigned long) 0;
+	setup_initial_init_mm(_stext, _etext, _edata, NULL);
 
 	pr_notice("\r\n\nuClinux " CPU "\n");
 	pr_notice("Flat model support (C) 1998,1999 Kenneth Albanowski, D. Jeff Dionne\n");
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


