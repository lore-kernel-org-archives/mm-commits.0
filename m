Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12E6C2BBCF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C31223159
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgLPEoP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:44:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbgLPEoP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:44:15 -0500
Date:   Tue, 15 Dec 2020 20:43:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093781;
        bh=SDHQ4VxXgj7vY8YK66GjM4M3lHyA0v//SqpJpO7g6+w=;
        h=From:To:Subject:In-Reply-To:From;
        b=yKQq11MwwhFjFW/+bEXAPH67SPr9Z7pnGefRqxdhaN/iMSdJ8qX84lvSql3yaa3MM
         sKhE3OAzAGrdx7Qcmsd25+fq2T1rp2jHgN/+AdHDIzVRG7Zl5Xmvi2wjjh7gLG7Y/b
         aW4eSALB8iaFwKwGaxHZFiFzRlwugw3ZiQ+/y1oE=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, geert@linux-m68k.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 13/95] lib/test_free_pages.c: add basic progress
 indicators
Message-ID: <20201216044301.ZYg810UdD%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
