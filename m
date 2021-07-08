Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D92C07E9B
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA10361CE3
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhGHBLo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhGHBLm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:11:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D3C661CD6;
        Thu,  8 Jul 2021 01:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706541;
        bh=ASA6qRqYGj1xIUcbx38QmlfwXgtsfPSIOIk2a25V7y4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EYouGAY2d9oUUb8elLT9eBLYxaLpsPCMoc3ksGF3omYNSTWRxnP0LbMjNaEUhTJAm
         g/d6kGfnBlszOJ+MUzsOD9okTALZvrTBlD5/UX4nlHbBH8C22akmOEy8lg7va1lYEa
         X+iuQWoPg8UJtzzWND4dY2N+piPvsUX7lSJpHh60=
Date:   Wed, 07 Jul 2021 18:09:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dalias@libc.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        wangkefeng.wang@huawei.com, ysato@users.sourceforge.jp
Subject:  [patch 29/54] sh: convert to setup_initial_init_mm()
Message-ID: <20210708010900.YBg6LUCjA%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
