Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D56FC07E9E
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6080561CD8
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhGHBLU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhGHBLT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:11:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDE1A61CBE;
        Thu,  8 Jul 2021 01:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706518;
        bh=72UnW7ZGBE54cRajQCrbJS6NQg4AYno3T+9eIOZRH3o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lhoTI6hxrOQxNNstmPeiaKAdQ5yBT3kM/VVIoKw4bEJnVTFYRFV9r5ICB/R78nZ3T
         3fVQG1/NSiFeNtIf2rxFuAyx1y5q8geixeNUFFfbDwnvAreS+dxnTKDSBsAkuMALSr
         Jg06DzsyIuOd3lAleWauiff9fl/szLRp/8zUs9Ps=
Date:   Wed, 07 Jul 2021 18:08:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com, ysato@users.sourceforge.jp
Subject:  [patch 21/54] h8300: convert to setup_initial_init_mm()
Message-ID: <20210708010837.WODl2wpG9%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
