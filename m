Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0090C43470
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3C90613F8
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhD3GC1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhD3GC1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C1D7613AD;
        Fri, 30 Apr 2021 06:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762499;
        bh=eV68x+iRc8udw6njyy41GRVos13JcjrOqf2YbUMnRgk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R+xDLKeKuf3Rqs/Rtw1Tv8uVh9aFP395uPdcLuMJ+V/LEVeQBFD4u8xegCJw0Hrfg
         RsHtHR44iL8DJYJeeWlrL646UgIV3nZLI82AdRARZ2tRYJwikMcwfaXtx/jSDwp1kc
         anY7oBZPP3yBdX2zatvbgYdvukEu3Ao1N7CcZ0vI=
Date:   Thu, 29 Apr 2021 23:01:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zhouchuangao@vivo.com
Subject:  [patch 165/178] mm/page_alloc: duplicate include
 linux/vmalloc.h
Message-ID: <20210430060139.8RKb54hKz%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: zhouchuangao <zhouchuangao@vivo.com>
Subject: mm/page_alloc: duplicate include linux/vmalloc.h

linux/vmalloc.h is repeatedly in the file page_alloc.c

Link: https://lkml.kernel.org/r/1616468751-80656-1-git-send-email-zhouchuangao@vivo.com
Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-duplicate-include-linux-vmalloch
+++ a/mm/page_alloc.c
@@ -72,8 +72,6 @@
 #include <linux/padata.h>
 #include <linux/khugepaged.h>
 #include <linux/buffer_head.h>
-#include <linux/vmalloc.h>
-
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
_
