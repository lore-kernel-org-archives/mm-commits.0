Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB6DC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 837DC2222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633357;
	bh=hoJ7sASIXH94oPe/Mbsuuv8izvHmRzQaUw8Ej0t2/zs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=KckMHIDQByGbWf7oC7qAhHWNzXH8TGI6auua1od7xoWaV68zmeipQouqMjOFUb+Lp
	 ef6V2SOMPKco7fs1qXjE1zGgA0U7zIYvqGV2vKsdXTC+j76fihuMODgQL6ysaCubPH
	 g+yhaYNVfOkc64U7qUEx71eQMnfgR/Dxi0KW9XC4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388574AbgJMXz5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXz5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 379B52222E;
        Tue, 13 Oct 2020 23:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633355;
        bh=hoJ7sASIXH94oPe/Mbsuuv8izvHmRzQaUw8Ej0t2/zs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Jld3q7qGDS3GvGkGdzWmnjGvQTnxok1OdkOJTXsPjYNX56zAH0mjAnytjGgARWwRf
         krIvxSeskJ2G4twEMydn8k/TC5VYQuN08qaKyq1IhJpU5KB/kMQeG7kCA/CpUdyOAy
         QMVs/mPGmc1cUp9fiRp6azQsZo5gmyGvBiZj9Rpg=
Date:   Tue, 13 Oct 2020 16:55:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yanfei.xu@windriver.com
Subject:  [patch 136/181] mm/page_alloc.c: __perform_reclaim should
 return 'unsigned long'
Message-ID: <20201013235554.mZlvetQKb%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/page_alloc.c: __perform_reclaim should return 'unsigned long'

__perform_reclaim()'s single caller expects it to return 'unsigned long',
hence change its return value and a local variable to 'unsigned long'.

Link: https://lkml.kernel.org/r/20200916022138.16740-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-__perform_reclaim-should-return-unsigned-long
+++ a/mm/page_alloc.c
@@ -4253,13 +4253,12 @@ EXPORT_SYMBOL_GPL(fs_reclaim_release);
 #endif
 
 /* Perform direct synchronous page reclaim */
-static int
+static unsigned long
 __perform_reclaim(gfp_t gfp_mask, unsigned int order,
 					const struct alloc_context *ac)
 {
-	int progress;
 	unsigned int noreclaim_flag;
-	unsigned long pflags;
+	unsigned long pflags, progress;
 
 	cond_resched();
 
_
