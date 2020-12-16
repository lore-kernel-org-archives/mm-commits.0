Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F14C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7078023403
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgLPRJk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbgLPRJk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:09:40 -0500
Date:   Wed, 16 Dec 2020 09:08:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138525;
        bh=FjVSElpRYkmLRuUJjUI6EZjyePMsVBe+ohX6+yxjo4k=;
        h=From:To:Subject:From;
        b=eJ07XGFNMXI644fyjO/vkmt75tzAjsdYgnCNc39ucvk3EJAYQuLm4iRHzyyW3XCxo
         TmlMoerI3hKXrxoVTJ8e91odpv36ebg7G38hL2pVzez0GIZWKd1ThF+jQ6DBXZ/GdS
         6ITzr48reEFKQP6NWub7bEygFcYEhzkzgYwfoP9M=
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, mm-commits@vger.kernel.org, rppt@kernel.org,
        willy@infradead.org
Subject:  [merged]
 lib-test_free_pages-add-basic-progress-indicators.patch removed from -mm
 tree
Message-ID: <20201216170845.L2gWIsWz8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_free_pages.c: add basic progress indicators
has been removed from the -mm tree.  Its filename was
     lib-test_free_pages-add-basic-progress-indicators.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: lib/test_free_pages.c: add basic progress indicators

The test module to check that free_pages() does not leak memory does not
provide any feedback whatsoever its state or progress, but may take some
time on slow machines.  Add the printing of messages upon starting each
phase of the test, and upon completion.

Link: https://lkml.kernel.org/r/20201018140445.20972-1-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_free_pages.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/lib/test_free_pages.c~lib-test_free_pages-add-basic-progress-indicators
+++ a/lib/test_free_pages.c
@@ -5,6 +5,8 @@
  * Author: Matthew Wilcox <willy@infradead.org>
  */
 
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/module.h>
@@ -26,8 +28,11 @@ static void test_free_pages(gfp_t gfp)
 
 static int m_in(void)
 {
+	pr_info("Testing with GFP_KERNEL\n");
 	test_free_pages(GFP_KERNEL);
+	pr_info("Testing with GFP_KERNEL | __GFP_COMP\n");
 	test_free_pages(GFP_KERNEL | __GFP_COMP);
+	pr_info("Test completed\n");
 
 	return 0;
 }
_

Patches currently in -mm which might be from geert@linux-m68k.org are


