Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE09DC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD17E61CD7
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhGHBLb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhGHBLb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:11:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67DDC61CBE;
        Thu,  8 Jul 2021 01:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706529;
        bh=s1pdguBVX0lDGoYXjvSAWIzBa8nrHCA4aYolCSYfaKc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gU7x/fKrs3Rd1F5GIkuBrGwDpdkPqgFSHqWTH2QhVAKgyddr3MFOI7/WZkMLDAq1m
         SuDV+mJoy/kU8asHo4Gsh7uXnjrqJ+9Fw3KK8VjD2/qZLJ1d+FMZojpcpX0YaZw70/
         lEkSRDyDjDBIlrfUFxdrFxKBEbsMTNQ+9Nangp3Y=
Date:   Wed, 07 Jul 2021 18:08:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jonas@southpole.se, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, shorne@gmail.com,
        stefan.kristiansson@saunalahti.fi, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com
Subject:  [patch 25/54] openrisc: convert to
 setup_initial_init_mm()
Message-ID: <20210708010849.OBn26dlwG%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
